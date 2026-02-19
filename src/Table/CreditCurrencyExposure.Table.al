table 50108 "Credit Currency Exposure"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(2; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(3; "Outstanding Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Outstanding Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Credit Limit (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Last Updated"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Currency Code")
        {
            Clustered = true;
        }
    }

    procedure UpdateExposure(CustomerNo: Code[20]; CurrencyCode: Code[10]; Amount: Decimal; CreditLimitLCY: Decimal)
    begin
        if Get(CustomerNo, CurrencyCode) then begin
            "Outstanding Amount" := Amount;
            "Outstanding Amount (LCY)" := Amount; // Would convert using exchange rate
            "Credit Limit (LCY)" := CreditLimitLCY;
            "Last Updated" := CurrentDateTime;
            Modify(true);
        end else begin
            Init();
            "Customer No." := CustomerNo;
            "Currency Code" := CurrencyCode;
            "Outstanding Amount" := Amount;
            "Outstanding Amount (LCY)" := Amount;
            "Credit Limit (LCY)" := CreditLimitLCY;
            "Last Updated" := CurrentDateTime;
            Insert(true);
        end;
    end;

    procedure GetTotalExposureLCY(CustomerNo: Code[20]): Decimal
    var
        CreditCurrencyExposure: Record "Credit Currency Exposure";
    begin
        CreditCurrencyExposure.SetRange("Customer No.", CustomerNo);
        CreditCurrencyExposure.CalcSums("Outstanding Amount (LCY)");
        exit(CreditCurrencyExposure."Outstanding Amount (LCY)");
    end;
}
