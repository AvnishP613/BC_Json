table 60001 "My Line"
{
    fields
    {
        field(1; "Header No."; Code[20])
        {
            TableRelation = "My Header"."No.";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Header Id"; Guid)
        {
            TableRelation = "My Header".SystemId;
        }
        field(4; Description; Text[50]) { }
    }

    keys
    {
        key(PK; "Header No.", "Line No.") { }
    }
}