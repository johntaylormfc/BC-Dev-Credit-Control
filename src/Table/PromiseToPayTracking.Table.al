table 50104 "Promise To Pay Tracking"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Promise Tracking List";
    LookupPageId = "Promise Tracking List";

    fields
    {
        field(1; ID; Guid)
        {
            DataClassification = SystemMetadata;
            DefaultLayout = Equation;
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
        field(4; "Promise Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Promise Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Actual Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Actual Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Pending","Kept","Broken","Partial";
        }
        field(9; "Created Date"; DateTime)
        {
            DataClassification = SystemMetadata;
            InitValue = CurrentDateTime;
        }
        field(10; "Created By"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; "Broken Reason"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(Key1; "Customer No.", "Promise Date")
        {
        }
        key(Key2; Status, "Promise Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, 50);
        if "Created Date" = 0DT then
            "Created Date" := CurrentDateTime;
    end;

    procedure CreatePromise(CustomerNo: Code[20]; DocumentNo: Code[20]; PromiseDate: Date; PromiseAmount: Decimal)
    begin
        Init();
        ID := CreateGuid();
        "Customer No." := CustomerNo;
        "Document No." := DocumentNo;
        "Promise Date" := PromiseDate;
        "Promise Amount" := PromiseAmount;
        Status := Status::Pending;
        Insert(true);
    end;

    procedure RecordPayment(ActualPaymentDate: Date; ActualAmount: Decimal)
    begin
        "Actual Payment Date" := ActualPaymentDate;
        "Actual Amount" := ActualAmount;
        
        if ActualAmount >= "Promise Amount" then
            Status := Status::Kept
        else if ActualAmount > 0 then
            Status := Status::Partial
        else
            Status := Status::Broken;
            
        Modify(true);
    end;
}
