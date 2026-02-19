table 50101 "Customer Credit Controller"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Customer Credit Controller List";
    LookupPageId = "Customer Credit Controller List";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Customer;
        }
        field(2; "Credit Controller"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Credit Controller";
        }
        field(3; "Assigned Date"; Date)
        {
            DataClassification = ToBeClassified;
            InitValue = Today;
        }
        field(4; "Last Review Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Credit Status"; Enum "Credit Status")
        {
            DataClassification = ToBeClassified;
        }
        field(7; Notes; Blob)
        {
            SubType = Memo;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
    }

    procedure GetCreditControllerForCustomer(CustomerNo: Code[20]): Code[50]
    begin
        Reset();
        SetCurrentKey("Customer No.");
        SetRange("Customer No.", CustomerNo);
        if FindFirst() then
            exit("Credit Controller");
        exit('');
    end;

    procedure SetCreditController(CustomerNo: Code[50]; CreditController: Code[50])
    begin
        Reset();
        if Get(CustomerNo) then begin
            "Credit Controller" := CreditController;
            "Last Review Date" := Today;
            Modify(true);
        end else begin
            Init();
            "Customer No." := CustomerNo;
            "Credit Controller" := CreditController;
            "Assigned Date" := Today;
            "Last Review Date" := Today;
            Insert(true);
        end;
    end;
}
