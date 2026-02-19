codeunit 50105 "Interest Calculator"
{
    SingleInstance = true;

    /// <summary>
    /// Calculate late payment interest for overdue amount
    /// </summary>
    procedure CalculateInterest(OverdueAmount: Decimal; OverdueDays: Integer; InterestRate: Decimal): Decimal
    var
        DailyRate: Decimal;
    begin
        if OverdueAmount <= 0 then
            exit(0);
        if OverdueDays <= 0 then
            exit(0);
        
        // Annual rate / 365 = daily rate
        DailyRate := InterestRate / 365;
        
        // Interest = Amount * Days * Daily Rate
        exit(Round(OverdueAmount * OverdueDays * DailyRate, 0.01));
    end;

    /// <summary>
    /// Calculate total with interest
    /// </summary>
    procedure CalculateTotalWithInterest(OverdueAmount: Decimal; OverdueDays: Integer; InterestRate: Decimal): Decimal
    var
        Interest: Decimal;
    begin
        Interest := CalculateInterest(OverdueAmount, OverdueDays, InterestRate);
        exit(OverdueAmount + Interest);
    end;

    /// <summary>
    /// Generate interest invoice lines
    /// </summary>
    procedure CreateInterestInvoice(CustomerNo: Code[20]; var SalesHeader: Record "Sales Header"): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InterestAmount: Decimal;
        TotalOverdue: Decimal;
        OverdueDays: Integer;
    begin
        // Get overdue entries
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetFilter("Due Date", '<%1', Today);
        
        if CustLedgerEntry.IsEmpty() then
            exit(false);
        
        CustLedgerEntry.CalcSums("Remaining Amount");
        TotalOverdue := CustLedgerEntry."Remaining Amount";
        
        // Assume 8% interest rate (UK statutory)
        InterestAmount := CalculateInterest(TotalOverdue, 30, 8.0); // Default 30 days overdue
        
        if InterestAmount > 0 then begin
            // Would create sales header and lines for interest invoice
            // SalesHeader.Init();
            // SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            // SalesHeader."Sell-to Customer No." := CustomerNo;
            // SalesHeader.Insert(true);
            exit(true);
        end;
        
        exit(false);
    end;

    /// <summary>
    /// Calculate recommended interest rate based on customer history
    /// </summary>
    procedure GetRecommendedInterestRate(CustomerNo: Code[20]): Decimal
    var
        PaymentTermsRecommendation: Codeunit "Payment Terms Recommendation";
        Score: Integer;
    begin
        Score := PaymentTermsRecommendation.GetPaymentBehaviorScore(CustomerNo);
        
        // Higher risk = higher interest rate
        if Score >= 80 then
            exit(0); // No interest for good payers
        if Score >= 60 then
            exit(4);
        if Score >= 40 then
            exit(6);
        if Score >= 20 then
            exit(8);
        
        exit(12); // High interest for poor payers
    end;
}
