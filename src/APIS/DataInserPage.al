
page 60004 "My Header API List"
{
    PageType = List;
    SourceTable = "My Header";

    DelayedInsert = true;
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(headerNo; "No.")
                {
                    ApplicationArea = all;
                }
                field(description; Description)
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

