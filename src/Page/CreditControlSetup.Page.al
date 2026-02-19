page 50110 "Credit Control Setup"
{
    ApplicationArea = All;
    Caption = 'Credit Control Setup';
    PageType = Card;
    SourceTable = "Credit Control Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Default Action Days"; Rec."Default Action Days")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Default number of days for next action.';
                }
                field("Auto-Escalate Days"; Rec."Auto-Escalate Days")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Days after which overdue items are escalated.';
                }
                field("Enable Notifications"; Rec."Enable Notifications")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Default Credit Limit"; Rec."Default Credit Limit")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Default credit limit for new customers.';
                }
            }
            group(Email)
            {
                Caption = 'Email Settings';
                
                field("From Email"; Rec."From Email")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                }
                field("From Name"; Rec."From Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Reminder Template"; Rec."Reminder Template")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Scoring)
            {
                Caption = 'Collection Scoring';
                
                field("High Score Threshold"; Rec."High Score Threshold")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Score above which customer is considered high priority.';
                }
                field("Low Score Threshold"; Rec."Low Score Threshold")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Score below which customer is flagged for review.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Credit Controllers")
            {
                ApplicationArea = Basic, Suite;
                RunObject = page "Credit Controller List";
                Image = User;
            }
            action("Customer Assignments")
            {
                ApplicationArea = Basic, Suite;
                RunObject = page "Customer Credit Controller List";
                Image = Customer;
            }
            action("Action Log")
            {
                ApplicationArea = Basic, Suite;
                RunObject = page "Credit Action Log";
                Image = Log;
            }
        }
    }
}

table 50110 "Credit Control Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Default Action Days"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 7;
        }
        field(3; "Auto-Escalate Days"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 14;
        }
        field(4; "Enable Notifications"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(5; "Default Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "From Email"; Text[80])
        {
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = EMail;
        }
        field(7; "From Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Reminder Template"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "High Score Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 70;
            MinValue = 0;
            MaxValue = 100;
        }
        field(10; "Low Score Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 30;
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'DEFAULT';
    end;

    var
        CreditControlSetup: Record "Credit Control Setup";

    procedure GetSetup(): Record "Credit Control Setup"
    begin
        if not CreditControlSetup.Get('DEFAULT') then begin
            CreditControlSetup.Init();
            CreditControlSetup."Primary Key" := 'DEFAULT';
            CreditControlSetup.Insert();
        end;
        exit(CreditControlSetup);
    end;
}
