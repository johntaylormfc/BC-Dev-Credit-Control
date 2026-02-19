codeunit 50104 "Payment Terms Recommendation"
{
    SingleInstance = true;

    /// <summary>
    /// Analyze customer payment history and recommend payment terms
    /// </summary>
    procedure RecommendPaymentTerms(CustomerNo: Code[20]): Text
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PaymentHistory: List of [Integer];
        AvgDaysLate: Integer;
        OnTimeCount: Integer;
        LateCount: Integer;
    begin
        // Get payment history
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, false);
        CustLedgerEntry.SetFilter("Due Date", '<>%1', 0D);
        
        if CustLedgerEntry.FindSet() then
            repeat
                if CustLedgerEntry."Pmt. Discount Date" <> 0D then begin
                    // Has payment terms - check if paid on time
                    if CustLedgerEntry."Pmt. Discount Date" >= CustLedgerEntry."Posting Date" then
                        OnTimeCount += 1
                    else
                        LateCount += 1;
                end;
            until CustLedgerEntry.Next() = 0;
        
        // Calculate recommendation
        if (OnTimeCount + LateCount) = 0 then
            exit('NET30'); // Default
        
        if LateCount > OnTimeCount then
            exit('NET15') // Stricter terms for late payers
        else
            exit('NET30'); // Standard terms
        
        exit('NET30');
    end;

    /// <summary>
    /// Calculate average days to pay
    /// </summary>
    procedure GetAverageDaysToPay(CustomerNo: Code[20]): Integer
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotalDays: Integer;
        Count: Integer;
    begin
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, false);
        
        if CustLedgerEntry.FindSet() then
            repeat
                if (CustLedgerEntry."Due Date" <> 0D) and (CustLedgerEntry."Posting Date" <> 0D) then begin
                    TotalDays += CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
                    Count += 1;
                end;
            until CustLedgerEntry.Next() = 0;
        
        if Count = 0 then
            exit(30);
        
        exit(TotalDays div Count);
    end;

    /// <summary>
    /// Get payment behavior score (0-100)
    /// </summary>
    procedure GetPaymentBehaviorScore(CustomerNo: Code[20]): Integer
    var
        AvgDays: Integer;
    begin
        AvgDays := GetAverageDaysToPay(CustomerNo);
        
        // Convert days to score (0 = very late, 100 = always early)
        if AvgDays <= 0 then
            exit(100);
        if AvgDays <= 7 then
            exit(90);
        if AvgDays <= 14 then
            exit(75);
        if AvgDays <= 30 then
            exit(60);
        if AvgDays <= 45 then
            exit(40);
        if AvgDays <= 60 then
            exit(20);
        exit(0);
    end;
}
