codeunit 50013 MyCodeunit
{
    trigger OnRun()
    begin
        
    end;
    
    local procedure CreateEDIShipmentFile()
    var
        InbSalesDocumentLine: Record "EDI Inb. Sales Document Line";
        ShipmentConfirmation: File;
        Ch: Char;
        ChNew: Char;
        Tab: Text[1];
        LineCount: Integer;
        FileName: Text;
        Instream1: InStream;
        OutStream1: OutStream;
        CRLF: Text[2];
        TempBLOB: Codeunit "Temp Blob";
    begin

        Ch := 9;
        chnew := 13;
        Tab := Format(Ch);
        CRLF[1] := 13;
        CRLF[2] := 10;
        //   ShipmentConfirmation.TextMode := true;
        FileName := ('RCONFIRM_NT_I_N_' + InbSalesDocHeader."Customer Order No." + '_' +
           DelChr(Format(Today, 0, '<Year4><Month,2><Day,2>'), '=', '') + Format(Time, 0, '<Hours24,2><Minutes,2><Seconds,2>') + '.txt');
        // HEADER
        FileName := DelChr(FileName, '=', ' ');
        FileName := DelChr(FileName, '=', '');

        TempBLOB.CreateOutStream(OutStream1, TextEncoding::MSDos);
        OutStream1.WriteTexT(InbSalesDocHeader."KB Line Identifier" + Tab + InbSalesDocHeader."KB File Identifier" + Tab + InbSalesDocHeader."KB Purchase Order Number" + Tab +
           InbSalesDocHeader."KB Vendor Number" + Tab + InbSalesDocHeader."KB Vendor Name" + Tab + InbSalesDocHeader."KB Location Code" + Tab + InbSalesDocHeader."KB Expected Receipt Date"
            + Tab + InbSalesDocHeader."KB Customer Number" + Tab + InbSalesDocHeader."KB Customer Name" + Tab + InbSalesDocHeader."KB Customer Ordered Date" + Tab +
              InbSalesDocHeader."KB Comment");
        //CSA.GS 06/08/2018 write blank line between segments>>
        // OutStream1.WriteText(ChNew);
        //  OutStream1.WriteText(ChNew);//dss
        OutStream1.WriteText(CRLF);//dss
        OutStream1.WriteText(CRLF);//dss
                                   //  OutStream1.WriteText(CRLF);
                                   //   OutStream1.WriteTexT('');
                                   // OutStream1.WriteTexT('');
                                   //<<
        InbSalesDocumentLine.SetRange("Inbound Document No.", InbSalesDocHeader."Inbound Document No.");
        if InbSalesDocumentLine.FindFirst then
            repeat
                // LINES
                OutStream1.WriteTexT(InbSalesDocumentLine."KB Line Identifier" + Tab + InbSalesDocumentLine."KB Line No." + Tab + InbSalesDocumentLine."KB Navision Item No." + Tab +
                 InbSalesDocumentLine."KB GTIN" + Tab + InbSalesDocumentLine."KB Description" + Tab + InbSalesDocumentLine."KB Unit Of Measure" + Tab +
                 Format(InbSalesDocumentLine."KB Quantity Ordered") + Tab + Format(InbSalesDocumentLine."KB Quantity Received") + Tab + Format(InbSalesDocumentLine."KB Weight Received") + Tab +
                 InbSalesDocumentLine."KB Item Status" + Tab + InbSalesDocumentLine."KB Lot No." + Tab + InbSalesDocumentLine."KB Used By Date");
                //   Outstream1.WriteText('');//DSSTESTING
                OutStream1.WriteText(CRLF);
                //  OutStream1.WriteText(ChNew);//DSSTESTING
                LineCount := LineCount + 1;
            until InbSalesDocumentLine.Next = 0;

        //CSA.GS 06/08/2018>>
          OutStream1.WriteText(CRLF);//DSS
        //  OutStream1.WriteText(CRLF);
        // OutStream1.WriteTexT('');
        //<<


        // FOOTER
        OutStream1.WriteTexT('F' + Tab + Format(LineCount + 2));   //060920

        TempBLOB.CreateInStream(Instream1);

        UploadOnlineDriveFiles(FileName, Instream1, EDIPartner."Folder Out");
    end;

    
    var
        myInt: Integer;
}