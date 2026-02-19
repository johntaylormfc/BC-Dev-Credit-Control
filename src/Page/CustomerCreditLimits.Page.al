page 50130 "Customer Credit Limits"
{
    ApplicationArea = All;
    Caption = 'Customer Credit Limits';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Orders (LCY)"; Rec."Outstanding Orders (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(AvailableCredit; AvailableCredit)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Available Credit';
                }
                field(CreditUtilization; CreditUtilization)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Utilization %';
                }
                field("Blocked"; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(SetCreditLimit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Credit Limit';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Would open a page to set credit limit
                    Message('Use the Customer Credit Controller page to set credit limits.');
                end;
            }
            action(PutOnHold)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Put On Credit Hold';
                Image = Block;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Would put customer on credit hold
                    Message('Customer put on credit hold.');
                end;
            }
            action(RemoveHold)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Remove Credit Hold';
                Image = Unblock;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Would remove credit hold
                    Message('Credit hold removed.');
                end;
            }
            action(ViewHistory)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View Credit Limit History';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Message('Opening credit limit history...');
                end;
            }
        }
    }

    var
        AvailableCredit: Decimal;
        CreditUtilization: Integer;

    trigger OnAfterGetRecord()
    begin
        CalculateCreditFields();
    end;

    local procedure CalculateCreditFields()
    var
        CreditLimitCheck: Codeunit "Credit Limit Check";
    begin
        AvailableCredit := CreditLimitCheck.GetAvailableCredit(Rec."No.");
        CreditUtilization := CreditLimitCheck.GetCreditUtilization(Rec."No.");
    end;
}
