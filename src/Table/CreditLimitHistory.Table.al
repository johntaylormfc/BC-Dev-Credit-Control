table 50105 "Credit Limit History"
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
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Quote","Order","Invoice","Credit Memo";
        }
        field(5; "Original Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "New Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Change Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Changed By"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9; "Reason"; Text[250])
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
        key(Key1; "Customer No.", "Change Date")
        {
        }
    }

    procedure RecordChange(CustomerNo: Code[20]; DocNo: Code[20]; DocType: Option; OldLimit: Decimal; NewLimit: Decimal; Reason: Text[250])
    begin
        Init();
        ID := CreateGuid();
        "Customer No." := CustomerNo;
        "Document No." := DocNo;
        "Document Type" := DocType;
        "Original Credit Limit" := OldLimit;
        "New Credit Limit" := NewLimit;
        "Change Date" := Today;
        "Changed By" := CopyStr(UserId(), 1, 50);
        "Reason" := CopyStr(Reason, 1, 250);
        Insert(true);
    end;
}
