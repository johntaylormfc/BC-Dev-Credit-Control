page 50103 "Credit Controller Notes"
{
    ApplicationArea = All;
    Caption = 'Credit Controller Notes';
    PageType = List;
    SourceTable = "Credit Controller Note";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Note Date"; Rec."Note Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Note Type"; Rec."Note Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Private; Rec.Private)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = Basic, Suite;
                    MultiLine = true;
                }
            }
        }
        area(Factboxes)
        {
            systempart(Control1900380207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767506; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Customer Ledger Entry")
            {
                ApplicationArea = Basic, Suite;
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Customer Ledger Entry";
                RunPageLink = "Entry No." = field("Entry No.");
            }
        }
    }
}
