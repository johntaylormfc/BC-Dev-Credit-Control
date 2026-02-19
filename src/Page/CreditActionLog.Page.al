page 50102 "Credit Action Log"
{
    ApplicationArea = All;
    Caption = 'Credit Action Log';
    Editable = false;
    PageType = List;
    SourceTable = "Credit Action Log";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry number.';
                }
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
                field("Action Date"; Rec."Action Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount"; Rec.Amount)
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

    actions
    {
        area(Navigation)
        {
            action("Customer Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                RunObject = page "Customer Ledger Entries";
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }
}
