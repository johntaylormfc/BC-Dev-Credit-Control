table 50102 "Credit Action Log"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Credit Action Log";
    LookupPageId = "Credit Action Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Action Date"; DateTime)
        {
            DataClassification = SystemMetadata;
            InitValue = CurrentDateTime;
        }
        field(6; "User ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Action Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Note Added","Action Created","Action Completed","Promise To Pay","Dispute Raised","Dispute Resolved","Credit Status Changed","Credit Limit Changed","Customer Assigned","Escalated";
            OptionCaptionML = ENU = " ,Note Added,Action Created,Action Completed,Promise To Pay,Dispute Raised,Dispute Resolved,Credit Status Changed,Credit Limit Changed,Customer Assigned,Escalated";
        }
        field(8; Description; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Credit Controller"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Credit Controller";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Customer No.", "Action Date")
        {
        }
        key(Key2; "Document No.", "Action Date")
        {
        }
        key(Key3; "User ID", "Action Date")
        {
        }
    }

    procedure LogAction(CustomerNo: Code[20]; DocumentNo: Code[20]; ActionType: Option; Description: Text[500]; Amount: Decimal; CreditController: Code[50])
    begin
        Init();
        "Customer No." := CustomerNo;
        "Document No." := DocumentNo;
        "Posting Date" := Today;
        "Action Date" := CurrentDateTime;
        "User ID" := CopyStr(UserId(), 1, 50);
        "Action Type" := ActionType;
        Description := CopyStr(Description, 1, 500);
        Amount := Amount;
        "Credit Controller" := CreditController;
        Insert(true);
    end;
}
