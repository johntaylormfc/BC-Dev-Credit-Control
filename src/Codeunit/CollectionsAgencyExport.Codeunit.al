codeunit 50106 "Collections Agency Export"
{
    SingleInstance = true;

    /// <summary>
    /// Export overdue customers to collections agency format
    /// </summary>
    procedure ExportToCollectionsAgency(AgencyCode: Code[20]): Text
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CollectionsEntry: Record "Collections Agency Entry";
        Customer: Record Customer;
        ExportText: Text;
        LineNo: Integer;
    begin
        ExportText := '';
        LineNo := 0;
        
        // Find overdue customers
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetFilter("Due Date", '<%1', Today - 60); // 60+ days overdue
        
        if CustLedgerEntry.FindSet() then
            repeat
                if Customer.Get(CustLedgerEntry."Customer No.") then begin
                    LineNo += 1;
                    ExportText += StrSubstData(
                        '%1|%2|%3|%4|%5|%6|%7|' + '\r\n',
                        LineNo,
                        Customer."No.",
                        Customer.Name,
                        Customer.Address,
                        Customer."Post Code",
                        Customer."E-Mail",
                        CustLedgerEntry."Remaining Amount"
                    );
                end;
            until CustLedgerEntry.Next() = 0;
        
        exit(ExportText);
    end;

    /// <summary>
    /// Send to collections agency
    /// </summary>
    procedure SendToCollections(CustomerNo: Code[20]; Amount: Decimal; AgencyCode: Code[20])
    var
        Customer: Record Customer;
        CollectionsEntry: Record "Collections Agency Entry";
        AgencyRecord: Record "Collections Agency";
    begin
        if not Customer.Get(CustomerNo) then
            exit;
        
        // Get agency details
        if AgencyRecord.Get(AgencyCode) then;
        
        // Create entry
        CollectionsEntry.SendToAgency(
            CustomerNo,
            Customer.Name,
            Amount,
            AgencyCode,
            AgencyRecord.Name,
            AgencyRecord."Commission %"
        );
    end;

    /// <summary>
    /// Get total sent to collections
    /// </summary>
    procedure GetTotalSentToCollections(CustomerNo: Code[20]): Decimal
    var
        CollectionsEntry: Record "Collections Agency Entry";
    begin
        CollectionsEntry.SetRange("Customer No.", CustomerNo);
        CollectionsEntry.SetFilter(Status, '%1|%2', CollectionsEntry.Status::Sent, CollectionsEntry.Status::"Partial Recovery");
        CollectionsEntry.CalcSums("Outstanding Amount");
        exit(CollectionsEntry."Outstanding Amount");
    end;
}

table 50107 "Collections Agency"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Contact; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Email"; Text[80])
        {
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = EMail;
        }
        field(5; "Commission %"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 15;
        }
        field(6; "File Format"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "CSV","XML","Fixed Width";
        }
        field(7; Active; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
