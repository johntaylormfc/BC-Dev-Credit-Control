table 50103 "Credit Controller Note"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Credit Controller Notes";
    LookupPageId = "Credit Controller Notes";

    fields
    {
        field(1; ID; Guid)
        {
            DataClassification = SystemMetadata;
            DefaultLayout = Equation;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cust. Ledger Entry";
        }
        field(5; "Note Date"; DateTime)
        {
            DataClassification = SystemMetadata;
            InitValue = CurrentDateTime;
        }
        field(6; "User ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; Note; Text[2000])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Note Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","General","Phone","Email","Meeting","Promise To Pay","Dispute";
            OptionCaptionML = ENU = " ,General,Phone,Email,Meeting,Promise To Pay,Dispute";
        }
        field(9; Private; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(Key1; "Customer No.", "Note Date")
        {
        }
        key(Key2; "Entry No.", "Note Date")
        {
        }
    }

    procedure AddNote(CustomerNo: Code[20]; DocumentNo: Code[20]; EntryNo: Integer; NoteText: Text[2000]; NoteType: Option; IsPrivate: Boolean)
    begin
        Init();
        ID := CreateGuid();
        "Customer No." := CustomerNo;
        "Document No." := DocumentNo;
        "Entry No." := EntryNo;
        "Note Date" := CurrentDateTime;
        "User ID" := CopyStr(UserId(), 1, 50);
        Note := CopyStr(NoteText, 1, 2000);
        "Note Type" := NoteType;
        Private := IsPrivate;
        Insert(true);
    end;
}
