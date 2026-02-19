page 50111 "Credit Action Entry"
{
    ApplicationArea = All;
    Caption = 'Credit Action Entry';
    PageType = Card;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(Content)
        {
            group(Entry)
            {
                FieldCaption("Document No."): "Document No.";
                FieldCaption("Customer No."): "Customer No.";
                FieldCaption("Posting Date"): "Posting Date";
                FieldCaption("Due Date"): "Due Date";
                FieldCaption(Amount): Amount;
                FieldCaption("Remaining Amount"): "Remaining Amount";
            }
            group(Action)
            {
                Caption = 'Next Action';
                
                field("Next Action Date"; NextActionDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Action Date';
                }
                field("Next Action"; NextAction)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Action Description';
                    MultiLine = true;
                }
            }
            group(Promise)
            {
                Caption = 'Promise To Pay';
                
                field("Promise Date"; PromiseDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Promise Date';
                }
                field("Promise Amount"; PromiseAmount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Promise Amount';
                }
            }
            group(Dispute)
            {
                Caption = 'Dispute';
                
                field("Disputed Amount"; DisputedAmt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Disputed Amount';
                }
                field("Dispute Reason"; DisputeReason)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reason';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Save)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Save';
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SaveAction();
                end;
            }
        }
    }

    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CreditActionLog: Record "Credit Action Log";
        NextActionDate: Date;
        NextAction: Text[250];
        PromiseDate: Date;
        PromiseAmount: Decimal;
        DisputedAmt: Decimal;
        DisputeReason: Text[250];

    trigger OnOpenPage()
    begin
        CustLedgerEntry := Rec;
        NextActionDate := CustLedgerEntry."Next Action Date";
        NextAction := CustLedgerEntry."Next Action";
        PromiseDate := CustLedgerEntry."Promise To Pay Date";
        PromiseAmount := CustLedgerEntry."Promise To Pay Amount";
        DisputedAmt := CustLedgerEntry."Disputed Amount";
        DisputeReason := CustLedgerEntry."Dispute Reason";
    end;

    local procedure SaveAction()
    begin
        CustLedgerEntry."Next Action Date" := NextActionDate;
        CustLedgerEntry."Next Action" := NextAction;
        CustLedgerEntry."Promise To Pay Date" := PromiseDate;
        CustLedgerEntry."Promise To Pay Amount" := PromiseAmount;
        CustLedgerEntry."Disputed Amount" := DisputedAmt;
        CustLedgerEntry."Dispute Reason" := DisputeReason;
        CustLedgerEntry."Last Action Date" := Today;
        CustLedgerEntry.Modify(true);

        // Log the action
        CreditActionLog.Init();
        CreditActionLog."Customer No." := CustLedgerEntry."Customer No.";
        CreditActionLog."Document No." := CustLedgerEntry."Document No.";
        CreditActionLog."Posting Date" := CustLedgerEntry."Posting Date";
        CreditActionLog."User ID" := CopyStr(UserId(), 1, 50);
        CreditActionLog."Action Type" := CreditActionLog."Action Type"::"Action Created";
        CreditActionLog.Description := CopyStr(NextAction, 1, 500);
        CreditActionLog.Amount := CustLedgerEntry.Amount;
        CreditActionLog.Insert(true);

        Message('Credit action saved successfully.');
    end;
}
