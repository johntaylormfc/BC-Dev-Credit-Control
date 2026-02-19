table 50100 "Credit Controller"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Credit Controller List";
    LookupPageId = "Credit Controller List";

    fields
    {
        field(1; "User ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Email; Text[80])
        {
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = EMail;
        }
        field(4; Active; Boolean)
        {
            InitValue = true;
            DataClassification = ToBeClassified;
        }
        field(5; "Default Action Days"; Integer)
        {
            InitValue = 7;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }

    procedure IsCreditController(): Boolean
    var
        User: Record User;
    begin
        if User.Get(UpperCase(Format(UserSecurityId()))) then
            exit(Get(User."User ID"));
        exit(false);
    end;

    procedure Get(UserID: Code[50]): Boolean
    begin
        Reset();
        SetCurrentKey("User ID");
        SetRange("User ID", UserID);
        SetRange(Active, true);
        exit(FindFirst());
    end;
}
