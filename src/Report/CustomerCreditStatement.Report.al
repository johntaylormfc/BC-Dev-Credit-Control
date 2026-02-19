report 50102 "Customer Credit Statement"
{
    ApplicationArea = All;
    Caption = 'Customer Credit Statement';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");

            column(CompanyName; CompanyName)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(StatementDate; StatementDate)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer_Address; Address)
            {
            }
            column(Customer_City; City)
            {
            }
            column(Customer_Post_Code; "Post Code")
            {
            }
            column(Balance; Balance)
            {
            }
            column(CreditLimit; "Credit Limit (LCY)")
            {
            }
            column(AvailableCredit; AvailableCredit)
            {
            }
        }
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemLinkReference = Customer;
            DataItemLink = "Customer No." = field("No.");
            DataItemTableView = sorting("Posting Date");

            column(Document_No_; "Document No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Due_Date; "Due Date")
            {
            }
            column(Description; Description)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Remaining_Amount; "Remaining Amount")
            {
            }
            column(DaysOverdue; DaysOverdue)
            {
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer No.';
                        TableRelation = Customer;
                    }
                    field(StatementDate; StatementDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statement Date';
                    }
                    field(ShowAged; ShowAged)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Aged Summary';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if StatementDate = 0D then
            StatementDate := Today;
        
        CompanyName := CompanyInformation.Name;
        CompanyAddress := CompanyInformation.Address + ' ' + CompanyInformation.City + ' ' + CompanyInformation."Post Code";
    end;

    var
        CompanyInformation: Record "Company Information";
        CustomerNo: Code[20];
        StatementDate: Date;
        ShowAged: Boolean;
        CompanyName: Text[100];
        CompanyAddress: Text[200];
        AvailableCredit: Decimal;
        DaysOverdue: Integer;

    procedure SetCustomer(No: Code[20])
    begin
        CustomerNo := No;
    end;
}
