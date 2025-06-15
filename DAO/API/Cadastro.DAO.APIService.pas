unit Cadastro.DAO.APIService;

interface

uses
  SysUtils,
  REST.Types,
  REST.Client,
  REST.Authenticator.Basic;

  type TAPIService = class
    private
      FRESTClient: TRESTClient;
      FRESTRequest: TRESTRequest;
      FRESTResponse: TRESTResponse;
    public
      constructor Create;
      destructor Destroy; override;

      function ExecuteAPIOperation(Url, Token: string;  HTTPMethod: TRESTRequestMethod): string;
  end;

implementation

{ TAPIService }

constructor TAPIService.Create;
begin
  FRESTClient     := TRESTClient.Create(nil);
  FRESTRequest    := TRESTRequest.Create(nil);
  FRESTResponse   := TRESTResponse.Create(nil);
end;

destructor TAPIService.Destroy;
begin
  FreeAndNil(FRESTClient);
  FreeAndNil(FRESTRequest);
  FreeAndNil(FRESTResponse);

  inherited;
end;

function TAPIService.ExecuteAPIOperation(Url, Token: string; HTTPMethod: TRESTRequestMethod): string;
begin
  Result := '';
  try
    FRESTRequest.Client := FRESTClient;
    FRESTRequest.Response := FRESTResponse;

    FRESTClient.BaseURL := Url;
    FRESTRequest.Method := HTTPMethod;

    if not Token.IsEmpty then
      FRESTRequest.Params.AddHeader('Authorization', 'Bearer ' + Token);

    FRESTRequest.Execute;
    if Assigned(FRESTResponse) then
    begin
      case FRESTResponse.StatusCode of
        200: Result := FRESTResponse.Content;
        400: raise Exception.Create('Bad Request');
        401: raise Exception.Create('Unauthorized');
        403: raise Exception.Create('Forbidden');
        404: raise Exception.Create('Not Found');
        500: raise Exception.Create('Internal Server Error');
        else
          raise Exception.Create('Unexpected Error: ' + IntToStr(FRESTResponse.StatusCode));
      end;
    end
    else
    begin
      raise Exception.Create('No response received.');
    end;
  except
    on E: Exception do
    begin
      Result := 'Error: ' + E.Message;
    end;
  end;
end;


end.
