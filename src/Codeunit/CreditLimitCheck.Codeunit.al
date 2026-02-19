codeunit 50102 "Credit Limit Check"
{
    SingleInstance = true;

    /// <summary>
    /// Check if customer is over credit limit and should be put on hold
    /// </summary>
    procedure CheckCreditLimit(CustomerNo: Code[20]; Amount: Decimal): Boolean
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustomerCreditController: Record "Customer Credit Controller";
        CreditLimit: Decimal;
        TotalOutstanding: Decimal;
    begin
        if not Customer.Get(CustomerNo) then
            exit(false);

        // Get credit limit from mapping or customer
        CreditLimit := GetCreditLimit(CustomerNo, Customer."Credit Limit (LCY)");

        if CreditLimit = 0 then
            exit(false); // No limit set

        // Get total outstanding
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.CalcSums("Remaining Amount");
        TotalOutstanding := CustLedgerEntry."Remaining Amount";

        // Check if this order would exceed limit
        if (TotalOutstanding + Amount) > CreditLimit then
            exit(true); // Over limit

        exit(false); // Under limit
    end;

    /// <summary>
    /// Get effective credit limit for customer
    /// </summary>
    procedure GetCreditLimit(CustomerNo: Code[20]; DefaultLimit: Decimal): Decimal
    var
        CustomerCreditController: Record "Customer Credit Controller";
    begin
        // Check if custom limit is set
        if CustomerCreditController.Get(CustomerNo) then
            if CustomerCreditController."Credit Limit" > 0 then
                exit(CustomerCreditController."Credit Limit");

        // Use customer default
        exit(DefaultLimit);
    end;

    /// <summary>
    /// Calculate available credit
    /// </summary>
    procedure GetAvailableCredit(CustomerNo: Code[20]): Decimal
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CreditLimit: Decimal;
    begin
        if not Customer.Get(CustomerNo) then
            exit(0);

        CreditLimit := GetCreditLimit(CustomerNo, Customer."Credit Limit (LCY)");

        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.CalcSums("Remaining Amount");

        exit(CreditLimit - CustLedgerEntry."Remaining Amount");
    end;

    /// <summary>
    /// Get credit utilization percentage
    /// </summary>
    procedure GetCreditUtilization(CustomerNo: Code[20]): Integer
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CreditLimit: Decimal;
        TotalOutstanding: Decimal;
    begin
        if not Customer.Get(CustomerNo) then
            exit(0);

        CreditLimit := GetCreditLimit(CustomerNo, Customer."Credit Limit (LCY)");

        if CreditLimit = 0 then
            exit(0);

        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.CalcSums("Remaining Amount");
        TotalOutstanding := CustLedgerEntry."Remaining Amount";

        exit(Round((TotalOutstanding / CreditLimit) * 100, 1));
    end;

    /// <summary>
    /// Put customer on credit hold
    /// </summary>
    procedure SetCreditHold(CustomerNo: Code[20]; OnHold: Boolean; Reason: Text[250])
    var
        Customer: Record Customer;
        CustomerCreditController: Record "Customer Credit Controller";
    begin
        if not Customer.Get(CustomerNo) then
            exit;

        // Update customer
        Customer."Credit Limit (LCY)" := Customer."Credit Limit (LCY)"; // Trigger validation
        Customer.Blocked := OnHold::Customer;
        Customer.Modify(true);

        // Update credit controller mapping
        if CustomerCreditController.Get(CustomerNo) then begin
            if OnHold then
                CustomerCreditController."Credit Status" := CustomerCreditController."Credit Status"::"On Hold"
            else
                CustomerCreditController."Credit Status" := CustomerCreditController."Credit Status"::Approved;
            CustomerCreditController.Modify(true);
        end;

        // Log action
        LogAction(CustomerNo, '', 7, Reason);
    end;

    local procedure LogAction(CustomerNo: Code[20]; DocumentNo: Code[: Option; Description: Text[50020]; ActionType])
    var
        CreditActionLog: Record "Credit Action Log";
    begin
        CreditActionLog.Init();
        CreditActionLog."Customer No." := CustomerNo;
        CreditActionLog."Document No." := DocumentNo;
        CreditActionLog."Posting Date" := Today;
        CreditActionLog."Action Date" := CurrentDateTime;
        CreditActionLog."User ID" := CopyStr(UserId(), 1, 50);
        CreditActionLog."Action Type" := ActionType;
        CreditActionLog.Description := CopyStr(Description, 1, 500);
        CreditActionLog.Insert(true);
    end;
}
