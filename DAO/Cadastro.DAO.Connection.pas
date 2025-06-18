unit Cadastro.DAO.Connection;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, Forms,
  FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.DApt, FireDAC.Phys.PGDef, FireDAC.Phys.PG;


  type TConnection = class
    private
    FConnection: TFDConnection;
    FDriverLink: TFDPhysPgDriverLink;

    procedure ConfigureConnection;
    public
    function CreateQuery: TFDQuery;
    function GetConnection: TFDConnection;

    constructor Create;
    destructor Destroy;  override;

    const Lib: string = 'libpq.dll';
  end;

implementation

{ TConnection }

procedure TConnection.ConfigureConnection;
begin
  with FConnection do
  begin
    Params.DriverID := 'PG';
    Params.Database := 'Cadastro';
    Params.UserName := 'postgres';
    Params.Password := '1234';
    Params.Add('Server=localhost');
    Params.Add('Port=5432');
    LoginPrompt := False;
    Connected := True;
  end;
end;

constructor TConnection.Create;
begin
  FConnection := TFDConnection.Create(nil);
  FDriverLink := TFDPhysPgDriverLink.Create(nil);
  FDriverLink.VendorLib := ExtractFilePath(Application.ExeName) + Lib;
  Self.ConfigureConnection;
end;

function TConnection.CreateQuery: TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := TFDQuery.Create(nil);
  VQuery.Connection := FConnection;

  Result := VQuery;
end;

destructor TConnection.Destroy;
begin
  FreeAndNil(FConnection);
  FreeAndNil(FDriverLink);
  inherited;
end;

function TConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
