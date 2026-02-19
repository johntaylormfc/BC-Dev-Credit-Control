page 50122 "Credit Control Part"
{
    ApplicationArea = All;
    Caption = 'Credit Control Part';
    PageType = ListPart;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Next Action Date"; Rec."Next Action Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Promise To Pay Date"; Rec."Promise To Pay Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Credit Controller"; Rec."Credit Controller")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetFilters();
    end;

    local procedure SetFilters()
    begin
        // Show entries that need attention
        Reset();
        SetCurrentKey("Next Action Date");
        SetFilter("Next Action Date", '>=%1|=%1', Today, 0D);
        SetRange(Open, true);
        SetFilter("Remaining Amount", '>%1', 0);
    end;
}
