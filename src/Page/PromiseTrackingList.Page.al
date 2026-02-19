page 50123 "Promise Tracking List"
{
    ApplicationArea = All;
    Caption = 'Promise to Pay Tracking';
    PageType = List;
    SourceTable = "Promise To Pay Tracking";
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
                field("Promise Date"; Rec."Promise Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Promise Amount"; Rec."Promise Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Actual Payment Date"; Rec."Actual Payment Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Broken Reason"; Rec."Broken Reason")
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
            action(MarkKept)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mark as Kept';
                Image = Check;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Kept;
                    Rec."Actual Payment Date" := Today;
                    Rec."Actual Amount" := Rec."Promise Amount";
                    Rec.Modify(true);
                end;
            }
            action(MarkBroken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mark as Broken';
                Image = Cancel;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Broken;
                    Rec.Modify(true);
                end;
            }
        }
    }
}
