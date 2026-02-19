codeunit 50100 "Credit Control Management"
{
    SingleInstance = true;

    procedure LogAction(CustomerNo: Code[20]; DocumentNo: Code[20]; ActionType: Option; Description: Text[500])
    var
        CreditActionLog: Record "Credit Action Log";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustomerCreditController: Record "Customer Credit Controller";
        CreditController: Code[50];
    begin
        // Get credit controller for customer
        CreditController := CustomerCreditController.GetCreditControllerForCustomer(CustomerNo);

        // Get amount if document specified
        CustLedgerEntry.SetCurrentKey("Document No.", "Customer No.");
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        if CustLedgerEntry.FindFirst() then
            CreditActionLog.LogAction(
                CustomerNo,
                DocumentNo,
                ActionType,
                Description,
                CustLedgerEntry.Amount,
                CreditController)
        else
            CreditActionLog.LogAction(
                CustomerNo,
                DocumentNo,
                ActionType,
                Description,
                0,
                CreditController);
    end;

    procedure AddNote(CustomerNo: Code[20]; DocumentNo: Code[20]; EntryNo: Integer; NoteText: Text[2000]; NoteType: Option)
    var
        CreditControllerNote: Record "Credit Controller Note";
    begin
        CreditControllerNote.AddNote(CustomerNo, DocumentNo, EntryNo, NoteText, NoteType, false);
        LogAction(CustomerNo, DocumentNo, CreditControllerNote."Note Type"::"Note Added"::"Note Added", CopyStr(NoteText, 1, 100));
    end;

    procedure SetPromiseToPay(CustomerNo: Code[20]; DocumentNo: Code[20]; PromiseDate: Date; PromiseAmount: Decimal)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetCurrentKey("Document No.", "Customer No.");
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        if CustLedgerEntry.FindFirst() then begin
            CustLedgerEntry."Promise To Pay Date" := PromiseDate;
            CustLedgerEntry."Promise To Pay Amount" := PromiseAmount;
            CustLedgerEntry.Modify(true);
            LogAction(CustomerNo, DocumentNo, 5, StrSubstNo('Promise to pay: %1 on %2', PromiseAmount, PromiseDate));
        end;
    end;

    procedure SetNextAction(CustomerNo: Code[20]; DocumentNo: Code[20]; NextActionDate: Date; NextAction: Text[250])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetCurrentKey("Document No.", "Customer No.");
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        if CustLedgerEntry.FindFirst() then begin
            CustLedgerEntry."Next Action Date" := NextActionDate;
            CustLedgerEntry."Next Action" := NextAction;
            CustLedgerEntry."Last Action Date" := Today;
            CustLedgerEntry.Modify(true);
            LogAction(CustomerNo, DocumentNo, 2, CopyStr(NextAction, 1, 100));
        end;
    end;

    procedure AssignCustomerToCreditController(CustomerNo: Code[20]; CreditController: Code[50])
    var
        CustomerCreditController: Record "Customer Credit Controller";
    begin
        CustomerCreditController.SetCreditController(CustomerNo, CreditController);
        LogAction(CustomerNo, '', 9, StrSubstData('Assigned to credit controller: %1', CreditController));
    end;

    procedure GetMyAssignedCustomers(var Customer: Record Customer)
    var
        CreditController: Record "Credit Controller";
        CustomerCreditController: Record "Customer Credit Controller";
    begin
        if not CreditController.IsCreditController() then
            exit;

        CustomerCreditController.SetRange("Credit Controller", CreditController."User ID");
        if CustomerCreditController.FindSet() then begin
            Customer.SetFilter("No.", '');
            repeat
                if Customer.Get(CustomerCreditController."Customer No.") then begin
                    // Add to filter
                end;
            until CustomerCreditController.Next() = 0;
        end;
    end;
}
