table 50101 Student
{
    DataClassification = ToBeClassified;
    LookupPageId = "Student List";
    DrillDownPageId = "Student List";

    fields
    {
        field(1; "Roll No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "Roll No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Roll No.", Name)
        {
        }
        fieldgroup(Brick; "Roll No.", Name)
        {
        }
    }

}


page 50110 "Student List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;

    SourceTable = Student;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Roll No."; "Roll No.")
                {
                    ApplicationArea = All;

                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}