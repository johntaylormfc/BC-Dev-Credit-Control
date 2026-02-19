page 50120 "Credit Controller Role Center"
{
    ApplicationArea = All;
    Caption = 'Credit Controller';
    PageType = RoleCenter;

    layout
    {
        area(Header)
        {
            systempart(Control1905762007; Links)
            {
            }
            systempart(Control1905762006; Notes)
            {
            }
        }
        area(RoleCenterHeadline)
        {
            part(Headline; "Credit Control Headline")
            {
            }
        }
        area(Content)
        {
            group(Control18)
            {
                Caption = 'Tasks';
                Visible = true;
                
                part(PageContainer; "Credit Control Part")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(Section1)
        {
            group(MyTasks)
            {
                Caption = 'My Tasks';
                
                action("Customers Requiring Action")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers Requiring Action';
                    RunObject = page "Customer List";
                    Image = Customer;
                }
                action("Overdue Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Overdue Entries';
                    RunObject = page "Customer Ledger Entries";
                    Image = LedgerEntries;
                }
                action("Promises Due")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Promises to Pay Due';
                    Image = Payment;
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                
                action("Aged Debt by Controller")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aged Debt by Credit Controller';
                    RunObject = report "Aged Debt by Credit Controller";
                    Image = Report;
                }
                action("Collection Metrics")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Collection Metrics';
                    RunObject = report "Collection Metrics";
                    Image = Report;
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                
                action("Credit Control Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Setup';
                    RunObject = page "Credit Control Setup";
                    Image = Setup;
                }
                action("Credit Controllers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Credit Controllers';
                    RunObject = page "Credit Controller List";
                    Image = User;
                }
                action("Action Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Action Log';
                    RunObject = page "Credit Action Log";
                    Image = Log;
                }
            }
        }
    }
}

part("Credit Control Headline"; "Credit Control Headline")
{
    ApplicationArea = Basic, Suite;
}

part("Credit Control Part"; "Credit Control Part")
{
    ApplicationArea = Basic, Suite;
}
