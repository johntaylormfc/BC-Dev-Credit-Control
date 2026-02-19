codeunit 50101 "Credit Control Notifications"
{
    SingleInstance = true;

    procedure SendPaymentReminder(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        EmailBody: Text;
        EmailSubject: Text;
    begin
        if not Customer.Get(CustomerNo) then
            exit;

        // Get overdue entries
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Due Date", '<%1', Today);
        
        if CustLedgEntry.IsEmpty() then
            exit;

        CustLedgEntry.CalcSums("Remaining Amount");
        
        // Build email
        EmailSubject := StrSubstData('Payment Reminder - %1', Customer.Name);
        EmailBody := BuildReminderEmail(Customer, CustLedgEntry."Remaining Amount");
        
        // In production, this would send an email
        // SendEmail(Customer."E-Mail", EmailSubject, EmailBody);
        
        // Log the action
        LogAction(CustomerNo, '', 1, 'Payment reminder sent');
    end;

    procedure SendPromiseReminder(PromiseDate: Date)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetRange("Promise To Pay Date", PromiseDate);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Promise To Pay Date", '<=%1', Today);
        
        if CustLedgEntry.FindSet() then
            repeat
                SendPaymentReminder(CustLedgEntry."Customer No.");
            until CustLedgEntry.Next() = 0;
    end;

    procedure SendEscalationAlert(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        CreditController: Record "Credit Controller";
    begin
        if not Customer.Get(CustomerNo) then
            exit;

        // Find credit controller
        CreditController.SetRange("User ID", Customer."Credit Controller");
        if not CreditController.FindFirst() then
            exit;

        // Get overdue amount
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Due Date", '<%1', Today - 30);
        CustLedgEntry.CalcSums("Remaining Amount");
        
        if CustLedgEntry."Remaining Amount" > 0 then
            LogAction(CustomerNo, '', 10, StrSubstData('Escalated: %1 overdue > 30 days', CustLedgEntry."Remaining Amount"));
    end;

    local procedure BuildReminderEmail(Customer: Record Customer; OverdueAmount: Decimal): Text
    var
        Body: Text;
    begin
        Body := 'Dear ' + Customer.Contact + ',' + '\n\n';
        Body += 'This is a friendly reminder that your account has an overdue balance.' + '\n\n';
        Body += 'Overdue Amount: ' + Format(OverdueAmount, 0, '<Currency>') + '\n';
        Body += 'Please contact us to discuss payment options.' + '\n\n';
        Body += 'Best regards,' + '\n';
        Body += 'Credit Control Team';
        
        exit(Body);
    end;

    local procedure LogAction(CustomerNo: Code[20]; DocumentNo: Code[20]; ActionType: Option; Description: Text[500])
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
