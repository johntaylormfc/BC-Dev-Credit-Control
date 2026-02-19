table 50106 "Collections Agency Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(3; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Outstanding Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Sent Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Agency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Agency Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Pending","Sent","Withdrawn","Recovered","Partial Recovery";
        }
        field(9; "Recovery Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Recovery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Commission %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Notes; Text[500])
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
        key(Key1; "Customer No.", "Sent Date")
        {
        }
    }

    procedure SendToAgency(CustomerNo: Code[20]; CustomerName: Text[100]; Amount: Decimal; AgencyCode: Code[20]; AgencyName: Text[100]; CommissionPct: Decimal)
    begin
        Init();
        ID := CreateGuid();
        "Customer No." := CustomerNo;
        "Customer Name" := CustomerName;
        "Outstanding Amount" := Amount;
        "Sent Date" := Today;
        "Agency Code" := AgencyCode;
        "Agency Name" := AgencyName;
        "Commission %" := CommissionPct;
        Status := Status::Sent;
        Insert(true);
    end;

    procedure MarkRecovered(RecoveryAmt: Decimal)
    begin
        if RecoveryAmt >= "Outstanding Amount" then
            Status := Status::Recovered
        else
            Status := Status::"Partial Recovery";
        
        "Recovery Amount" := RecoveryAmt;
        "Recovery Date" := Today;
        Modify(true);
    end;

    procedure Withdraw()
    begin
        Status := Status::Withdrawn;
        Modify(true);
    end;
}
