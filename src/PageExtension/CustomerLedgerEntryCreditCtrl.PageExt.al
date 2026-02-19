pageextension 50100 "Customer Ledger Entry Credit Ctrl" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field("Credit Controller"; Rec."Credit Controller")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Assigned credit controller.';
            }
            field("Collection Score"; Rec."Collection Score")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Collection priority score (0-100).';
            }
        }
        addafter("Due Date")
        {
            field("Next Action Date"; Rec."Next Action Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Next action date for this entry.';
            }
            field("Promise To Pay Date"; Rec."Promise To Pay Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Promise to pay date.';
            }
        }
    }

    actions
    {
        addafter("&Customer")
        {
            group(CreditControl)
            {
                Caption = 'Credit Control';
                Image = Finance;

                action("Set Next Action")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set Next Action';
                    Image = ActionLog;
                    ToolTip = 'Set next action for this entry.';

                    trigger OnAction()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                        CreditActionEntry: Page "Credit Action Entry";
                    begin
                        CustLedgerEntry := Rec;
                        CreditActionEntry.SetRecord(CustLedgerEntry);
                        CreditActionEntry.Run();
                    end;
                }
                action("Add Note")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Add Note';
                    Image = Note;
                    ToolTip = 'Add a note to this entry.';

                    trigger OnAction()
                    var
                        CreditNote: Record "Credit Controller Note";
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        CustLedgerEntry := Rec;
                        CreditNote.Init();
                        CreditNote.ID := CreateGuid();
                        CreditNote."Customer No." := CustLedgerEntry."Customer No.";
                        CreditNote."Document No." := CustLedgerEntry."Document No.";
                        CreditNote."Entry No." := CustLedgerEntry."Entry No.";
                        CreditNote."Note Date" := CurrentDateTime;
                        CreditNote."User ID" := CopyStr(UserId(), 1, 50);
                        CreditNote.Insert(true);
                        Message('Note added. Please edit in Credit Controller Notes.');
                    end;
                }
                action("Set Promise to Pay")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Promise to Pay';
                    Image = Payment;
                    ToolTip = 'Record promised payment date.';

                    trigger OnAction()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                        CreditActionEntry: Page "Credit Action Entry";
                    begin
                        CustLedgerEntry := Rec;
                        CreditActionEntry.SetRecord(CustLedgerEntry);
                        CreditActionEntry.Run();
                    end;
                }
                action("View Action Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'View Action Log';
                    Image = Log;
                    ToolTip = 'View audit trail for this entry.';

                    trigger OnAction()
                    var
                        CreditActionLog: Record "Credit Action Log";
                    begin
                        CreditActionLog.SetRange("Document No.", Rec."Document No.");
                        CreditActionLog.SetRange("Customer No.", Rec."Customer No.");
                        if CreditActionLog.FindSet() then
                            Page.Run(Page::"Credit Action Log", CreditActionLog);
                    end;
                }
            }
        }
    }
}
