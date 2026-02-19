page 50121 "Credit Control Headline"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Credit Control Headline';
    PageType = HeadlinePart;

    layout
    {
        area(Content)
        {
            field("Overdue Total"; OverdueTotal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Overdue Total';
                
                trigger OnDrilldown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetFilter("Due Date", '<%1', Today);
                    Page.Run(Page::"Customer Ledger Entries", CustLedgEntry);
                end;
            }
            field("Customers Requiring Action"; CustomersAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers Requiring Action';
                
                trigger OnDrilldown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SetCurrentKey("Next Action Date");
                    CustLedgEntry.SetFilter("Next Action Date", '>=%1', Today);
                    CustLedgEntry.SetRange(Open, true);
                    Page.Run(Page::"Customer Ledger Entries", CustLedgEntry);
                end;
            }
            field("Promises Due This Week"; PromisesDue)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Promises Due This Week';
                
                trigger OnDrilldown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SetRange("Promise To Pay Date", Today, Today + 7);
                    CustLedgEntry.SetRange(Open, true);
                    Page.Run(Page::"Customer Ledger Entries", CustLedgEntry);
                end;
            }
            field("Total Outstanding"; TotalOutstanding)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Total Outstanding';
                
                trigger OnDrilldown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SetRange(Open, true);
                    Page.Run(Page::"Customer Ledger Entries", CustLedgEntry);
                end;
            }
        }
    }

    var
        OverdueTotal: Decimal;
        CustomersAction: Integer;
        PromisesDue: Integer;
        TotalOutstanding: Decimal;

    trigger OnOpenPage()
    begin
        SetHeadlineData();
    end;

    local procedure SetHeadlineData()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        // Overdue Total
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Due Date", '<%1', Today);
        CustLedgEntry.CalcSums("Remaining Amount");
        OverdueTotal := CustLedgEntry."Remaining Amount";

        // Customers Requiring Action
        CustLedgEntry.Reset();
        CustLedgEntry.SetCurrentKey("Next Action Date");
        CustLedgEntry.SetFilter("Next Action Date", '>=%1', Today);
        CustLedgEntry.SetRange(Open, true);
        CustomersAction := CustLedgEntry.Count();

        // Promises Due This Week
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Promise To Pay Date", Today, Today + 7);
        CustLedgEntry.SetRange(Open, true);
        PromisesDue := CustLedgEntry.Count();

        // Total Outstanding
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.CalcSums("Remaining Amount");
        TotalOutstanding := CustLedgEntry."Remaining Amount";
    end;
}
