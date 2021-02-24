page 60000 "My Header API"
{
    PageType = API;
    SourceTable = "My Header";
    APIPublisher = 'ajk';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntitySetName = 'headers';
    EntityName = 'header';
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    ApplicationArea = all;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            field(id; SystemId) { }
            field(headerNo; "No.") { }
            field(description; Description) { }
            part(lines; MyAPILines)
            {
                EntitySetName = 'lines';
                EntityName = 'line';
                SubPageLink = "Header Id" = field(SystemId);
            }
        }
    }
}