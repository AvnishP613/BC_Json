table 50110 Course
{
    DataClassification = ToBeClassified;
    LookupPageId = "Courses List";
    DrillDownPageId = "Courses List";
    fields
    {
        field(1; CourseId; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; CourseName; Text[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; CourseId)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; CourseId, CourseName)
        {
        }
        fieldgroup(Brick; CourseId, CourseName)
        {
        }
    }

}


page 50111 "Courses List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;

    SourceTable = Course;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CourseId; CourseId)
                {
                    ApplicationArea = All;

                }
                field(CourseName; CourseName)
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