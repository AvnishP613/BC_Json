table 50007 "Variation Order"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Blanket Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE ("Document Type" = FILTER ("Blanket Order"));
        }
        field(2; "VO No."; Code[20])
        {
            Caption = 'Vo No.';
            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
                PPSetup: Record "Purchases & Payables Setup";
            begin
                IF "VO No." <> xRec."VO No." THEN BEGIN
                    PPSetup.GET;
                    NoSeriesMgt.TestManual(PPSetup."VO Nos.");
                    "No. Series" := '';
                END;
            end;

        }
        field(3; "VO Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "VO Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                BlanketPO1: Record "Purchase Header";
            begin
                // BlanketPO1.Reset;
                // BlanketPO1.SetRange("Document Type", BlanketPO1."Document Type"::"Blanket Order");
                // BlanketPO1.SetRange("No.", "Blanket Order No.");
                // IF BlanketPO1.FindFirst then begin
                //     BlanketPO1.CalcFields(BlanketPO1."Approved Variations");
                //     IF (BlanketPO1."Original Contract Price" - (Abs(BlanketPO1."Approved Variations") + Abs("VO Amount"))) < 0 then
                //         Error('Variation Amount %1 exceeded the contract value %2', (Abs(BlanketPO1."Approved Variations") + Abs("VO Amount")), BlanketPO1."Original Contract Price");
                // end;
            end;
        }
        field(5; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Creation date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Approved By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Approved date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Currency Code"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;
        }
        field(10; "Project Code"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(11; "Certified Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Certified Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "VO Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
            OptionCaption = 'Open, Released, "Pending Approval", "Pending Prepayment"';
        }
        field(15; "VO Status"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "VO Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "PC No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(PK; "Blanket Order No.", "VO No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record "Purchases & Payables Setup";

    trigger OnInsert()
    begin
        IF "VO No." = '' THEN BEGIN
            PPSetup.GET;
            PPSetup.TESTFIELD("VO Nos.");
            NoSeriesMgt.InitSeries(PPSetup."VO Nos.", xRec."No. Series", 0D, "VO No.", "No. Series");
        END;

        "Created By" := UserId;
        "Creation date" := WorkDate;

    end;

    trigger OnModify()
    begin
        TestField(Status, Status::Open);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}