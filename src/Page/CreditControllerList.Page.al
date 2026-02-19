page 50100 "Credit Controller List"
{
    ApplicationArea = All;
    Caption = 'Credit Controllers';
    PageType = List;
    SourceTable = "Credit Controller";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the user ID.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the email address.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Default Action Days"; Rec."Default Action Days")
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
            action("Customer Assignments")
            {
                ApplicationArea = Basic, Suite;
                RunObject = page "Customer Credit Controller List";
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Optionally filter to show only active
        // Rec.SetFilter(Active, '=true');
    end;
}
