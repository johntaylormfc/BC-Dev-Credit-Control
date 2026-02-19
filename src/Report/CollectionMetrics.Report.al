report 50101 "Collection Metrics"
{
    ApplicationArea = All;
    Caption = 'Collection Metrics';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");

            column(Customer_No_; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Balance; Balance)
            {
            }
            column(Credit_Controller; "Credit Controller")
            {
            }
            column(Aged_Debt_0_30; AgedDebt[1])
            {
            }
            column(Aged_Debt_31_60; AgedDebt[2])
            {
            }
            column(Aged_Debt_61_90; AgedDebt[3])
            {
            }
            column(Aged_Debt_Over_90; AgedDebt[4])
            {
            }
            column(Total_Outstanding; TotalOutstanding)
            {
            }
            column(DSO; DSO)
            {
            }
            column(Promise_Kept_Rate; PromiseKeptRate)
            {
            }
            column(Collection_Score; "Collection Score")
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
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                    field(CreditControllerFilter; CreditControllerFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Credit Controller Filter';
                        TableRelation = "Credit Controller";
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if EndingDate = 0D then
            EndingDate := Today;
        CalculateMetrics();
    end;

    var
        EndingDate: Date;
        CreditControllerFilter: Code[50];
        AgedDebt: array[4] of Decimal;
        TotalOutstanding: Decimal;
        DSO: Decimal;
        PromiseKeptRate: Decimal;

    local procedure CalculateMetrics()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        PromiseTracking: Record "Promise To Pay Tracking";
        DaysOverdue: Integer;
    begin
        // Calculate metrics for each customer
    end;
}
