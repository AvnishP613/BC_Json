codeunit 50120 MyCodeunit2
{
    trigger OnRun()
    begin

    end;

    procedure AutheticationRun()
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        HttpsContent: HttpContent;
        RequestHeader: HttpHeaders;
    begin




        CRLF[1] := 13;
        CRLF[2] := 10;
        //AuthText2 := NewDocText;
        //InputText := AuthLabel + '&' + 'code = ' + AuthText2 + '&' + Label5;

        //  Message('Authentication Text %1', AuthText2);
        URL := StrSubstNo('https://xecdapi.xe.com/v1/currencies.json/?obsolete=true');//+ InputText;
                                                                                      //  InputText := AuthLabel + CRLF + 'code = ' + AuthText2 + CRLF + Label5;

        //   Message(InputText);
        Message(URL);
        //        HttpsContent.WriteFrom(InputText);
        HttpsContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');
        HttpClient.DefaultRequestHeaders().Remove('Authorization');
        RequestHeader.Add('Content-Type', 'application/json');
        AuthText := StrSubstNo('%1:%2', ApplicationID, ClientSercret);
        //  TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
        Convert.ToBase64(AuthText);
        HttpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Basic %1', Convert.ToBase64(AuthText)));
        HttpClient.SetBaseAddress(URL);
        //  IF not HttpClient.Post(URL, HttpsContent, ResponseMessage) THEN BEGIN
 
        if not HttpClient.Get(url, ResponseMessage) then begin
            Message('Fail %1', format(ResponseMessage.HttpStatusCode));
        end
        else begin
            if ResponseMessage.IsSuccessStatusCode() then begin
                ResponseMessage.Content().ReadAs(InputText);
                Message('Success %1', InputText);
            end;
            if not ResponseMessage.IsSuccessStatusCode then
                ResponseMessage.Content.ReadAs(InputText);
            Message('The web service returned an error message:\\' +
                  'Status code: %1\' +
                  'Description: %2\' + 'Reason %3',
                  ResponseMessage.HttpStatusCode,

        ResponseMessage.ReasonPhrase, InputText);
            Message(InputText);


        end;


    end;

    var


        ResponseText: Text;
        InputText: Text;
        AuthText: Text;
        AutheticationToken: Text;

        CRLF: Text[2];
        AuthText2: Text;
        Convert: Codeunit "Base64 Convert";

        Conv1: Codeunit StringConversionManagement;

        URL: Text;
        ItemJson: Text;
        i: Integer;
        Iteration: Integer;

        AuthLabel: Label 'grant_type=authorization_code';
        //AthLabel1: Label
        Lable1: Label 'client_id=biocgvilghpyl4rxsmmuiizmpxgiypfc';
        Lable2: Label 'response_type=code';
        Label3: Label 'access_type=offline';
        ApplicationID: Label 'direction517229811';

        ClientSercret: Label 'vt52ja4jp4v6eiq9buc6hpbmt6';
        Label4: Label 'scope=orders inventory';
        Label5: Label 'redirect_uri=https://www.navapplication.com/oauth2/callback';


        Jtoken: JsonToken;
        JValue: JsonValue;

        TempBlob: Codeunit "Temp Blob";

        DocText: Text;
        DateInput: Date;

        NewDocText: Text;
        NewDateInput: Date;
        RightWeight: Decimal;
        ImageArray: JsonArray;
        JobjectImages: JsonObject;
        JTokenImage: JsonToken;
        ClientImage: HttpClient;
        ResponseImage: HttpResponseMessage;
        InStrImage: InStream;

        LineNo: Integer;
        ImageUrl: Text;
}