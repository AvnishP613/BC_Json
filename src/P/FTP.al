codeunit 50230 "Security Token"
{
    trigger OnRun()
    begin

    end;

    procedure SecurityToken(): Text
    var
        //  CC: Codeunit 50229;
        G: Guid;
        HttpClient: HttpClient;
        SecurityHttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        ResponseText: Text;
        SecurityHttpResponse: HttpResponseMessage;
        SecurityResponseText: Text;
        URL: Text;
        HttpRequest: HttpRequestMessage;
        SubFolder: Text[100];
        OrderNo: Code[20];
        HttpsContent: HttpContent;
        SecurityHttpsContent: HttpContent;
        HttpsHeader: HttpHeaders;
        ReturnValue: ARRAY[20] OF Text[1000];
        jObj: JsonObject;
        json: Text;
        SalesnRec: Record "Sales & Receivables Setup";
        RequestHeader: HttpHeaders;
        SecurityRequestHeader: HttpHeaders;
    BEGIN
        SalesnRec.get;

        HttpsContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');

        URL := StrSubstNo(SalesnRec."Security Token API");//'https://order.ewizpower.com/home/token/zkT5UFfRnTdWbtL9/2qa9WuE4E5cQYEDn');

        HttpClient.SetBaseAddress(URL);

        IF HttpClient.Get(URL, HttpResponse) THEN BEGIN
            HttpResponse.Content.ReadAs(ResponseText);
            //Message(ResponseText);
            exit(ResponseText);
        END;
    END;


    var
        myInt: Integer;
}


procedure SendImageToFTP(ArtID: Code[100]; SalesOrderNo: Code[20]; SubFolderName: Text; ImageText: Text)
    var
        HttpClient: HttpClient;
        URL: Text;
        HttpResponse: HttpResponseMessage;
        ResponseText: Text;
        HttpsContent: HttpContent;
        HttpRequest: HttpRequestMessage;
        json: Text;
        RequestHeader: HttpHeaders;

        SecurityTokenCodeunit: codeunit "Security Token";
        AuthString: Text;
        SecurityResponseText: Text;
        DevSetup: Record "Developers Setup";
    BEGIN
        salesnRec.Get();
        Clear(SecurityResponseText);
        Clear(AuthString);
        SecurityResponseText := SecurityTokenCodeunit.SecurityToken();


        clear(json);
        json := '{"FileName" :' + '"' + FORMAT(ArtID) + '"' + ',"UploadPath" :' + '"' + FORMAT(SalesOrderNo) + '/' + SubFolderName + '"' + ',"description" :' + '"' + 'Upload Image' + '"' + ',"ImageContent" :' + '"' + ImageText + '"' + '}';

        IF DevSetup.Get(1) THEN
            IF DevSetup."Proof Json Display" THEN
                Message(json);

        HttpsContent.WriteFrom(json);
        HttpsContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/json');

        AuthString := STRSUBSTNO('Bearer %1', SecurityResponseText);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);

        //RequestHeader.Add('WebsiteGuid', '59391C60-78D1-4D17-8567-871209299A66');

        //HttpClient.DefaultRequestHeaders.Add('Content-Type', 'application/json');
        URL := salesnRec."Art Image Creation API";//'https://orderbeta.ewizsaas.com/api/order/UploadFileAtFTP';
        HttpClient.SetBaseAddress(URL);
        HttpClient.DefaultRequestHeaders.Add('WebsiteGuid', salesnRec."Website-GUID For Art");//'59391C60-78D1-4D17-8567-871209299A66');
                                                                                              //HttpsContent.Clear();



        //HttpRequest.Content.GetHeaders(RequestHeader);



        //Message(ImageText);
        //HttpsContent.GetHeaders(RequestHeader);
        // Message(json);
        //URL := StrSubstNo('http://orderbeta.ewizsaas.com/api/order/CreateFolderAtFTP/' + VarOrderNo + '/' + SubFolder);
        IF HttpClient.Post(URL, HttpsContent, HttpResponse) THEN BEGIN
            HttpResponse.Content.ReadAs(ResponseText);
            //Message(ResponseText);
        END;
    END;


    EmailSplits('abc@gmail.com;xyz@gmail.com');

SmtpMail: Codeunit "SMTP Mail";
SmtpConf: Record "SMTP Mail Setup";
EmailBody: text;

SmtpMail.CreateMessage('Checking multiple Emails', SmtpConf."User ID", 
                        Receipt, 'Emails ', EmailBody, true);
        
    local procedure EmailSplits(EmaifieldValue: Text[250])
    var
        PosBgn: Integer;
        ValueLength: integer;
        PosEnd: Integer;
        SplitValue: Text;
    begin
        PosBgn := 1;
        ValueLength := STRLEN(EmaifieldValue);
        REPEAT
            IF STRPOS(EmaifieldValue, ';') = 0 THEN
                PosEnd := ValueLength
            ELSE
                PosEnd := (STRPOS(EmaifieldValue, ';') - 1);
            SplitValue := COPYSTR(EmaifieldValue, PosBgn, PosEnd);
            EmaifieldValue := DELSTR(EmaifieldValue, 1, PosEnd + 1);
            Receipt.Add(SplitValue);
        UNTIL EmaifieldValue = '';
    end;
