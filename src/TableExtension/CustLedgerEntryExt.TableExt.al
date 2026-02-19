tableextension 50100 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50100; "Credit Controller"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Credit Controller";
            CalcFormula = lookup("Customer Credit Controller"."Credit Controller" where("Customer No." = field("Customer No.")));
            Editable = false;
        }
        field(50101; "Next Action Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Next Action"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Promise To Pay Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Promise To Pay Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Disputed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Dispute Reason"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Last Action Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50108; "Collection Score"; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
    }
}
