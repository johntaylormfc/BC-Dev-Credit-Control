page 50101 "Customer Credit Controller List"
{
    ApplicationArea = All;
    Caption = 'Customer Credit Controllers';
    PageType = List;
    SourceTable = "Customer Credit Controller";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Credit Controller"; Rec."Credit Controller")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the assigned credit controller.';
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Review Date"; Rec."Last Review Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Credit Status"; Rec."Credit Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Credit Limit"; Rec."Credit Limit")
                {
                    ApplicationArea = Basic, Suite;
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
            action("Open Customer")
            {
                ApplicationArea = Basic, Suite;
                RunObject = page "Customer List";
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }
}
