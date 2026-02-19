report 50100 "Aged Debt by Credit Controller"
{
    ApplicationArea = All;
    Caption = 'Aged Debt by Credit Controller';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Credit Controller";

            column(Customer_No_; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Credit_Controller; "Credit Controller")
            {
            }
            column(Balance; Balance)
            {
            }
            column(Outstanding_Orders; "Outstanding Orders")
            {
            }
            column(Total_Exposure; "Total Exposure")
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
                    field(BusinessUnitCode; BusinessUnitCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Business Unit Code';
                        TableRelation = "Business Unit";
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if EndingDate = 0D then
            EndingDate := Today;
    end;

    var
        BusinessUnitCode: Code[10];
        EndingDate: Date;
}
