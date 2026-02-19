enum 50100 "Credit Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Approved)
    {
        Caption = 'Approved';
    }
    value(2; "On Hold")
    {
        Caption = 'On Hold';
    }
    value(3; "Review Required")
    {
        Caption = 'Review Required';
    }
    value(4; Rejected)
    {
        Caption = 'Rejected';
    }
    value(5; "Credit Limit Exceeded")
    {
        Caption = 'Credit Limit Exceeded';
    }
    value(6; "Payment Plan")
    {
        Caption = 'Payment Plan';
    }
    value(7; "Disputed")
    {
        Caption = 'Disputed';
    }
    value(8; "Closed")
    {
        Caption = 'Closed';
    }
}
