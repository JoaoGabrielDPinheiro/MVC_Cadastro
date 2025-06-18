unit Cadastro.Models.Utils.Funcoes;

interface

uses
  RTTI, SysUtils, Vcl.Dialogs, Vcl.Forms, Vcl.StdCtrls, Vcl.Mask;

type
  IUtilsFuncoes = interface
    ['{876E27E4-A201-46BC-8B31-0E8FBA744799}']
    function ValidateFields(FieldsObject: TObject): Boolean;
    function FormatValue(str: string): string;
    procedure ClearFields(Form: TForm);
    function RemoveMask(Mask: TMaskEdit): string;
  end;

  TUtilsFuncoes = class(TInterfacedObject, IUtilsFuncoes)
  public
    class function New: IUtilsFuncoes;

    function ValidateFields(FieldsObject: TObject): Boolean;
    function FormatValue(str: string): string;
    procedure ClearFields(Form: TForm);
    function RemoveMask(Mask: TMaskEdit): string;
  end;

implementation

{ TUtilsFuncoes }

procedure TUtilsFuncoes.ClearFields(Form: TForm);
var
  i: Integer;
begin
  //Coloque os tipos dos componentes que vão ser limpos.
  for i := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[i] is TEdit then
      TEdit(Form.Components[i]).Text := '';

    if Form.Components[i] is TComboBox then
      TComboBox(Form.Components[i]).ItemIndex := 0;

    if Form.Components[i] is TMaskEdit then
      TMaskEdit(Form.Components[i]).Clear;
  end;
end;

function TUtilsFuncoes.FormatValue(str: string): string;
begin
  if str = '' then
    str := '0';

  try
    Result := FormatFloat('#,##0.00', StrToFloat(str) / 100);
  except
    Result := FormatFloat('#,##0.00', 0);
  end;
end;

class function TUtilsFuncoes.New: IUtilsFuncoes;
begin
  Result := Self.Create;
end;

function TUtilsFuncoes.RemoveMask(Mask: TMaskEdit): string;
begin
  Mask.EditMask := '';
  Result := Mask.Text;
end;

function TUtilsFuncoes.ValidateFields(FieldsObject: TObject): Boolean;
var
  Context: TRttiContext;
  RttiType: TRttiType;
  Prop: TRttiProperty;
  Value: TValue;
begin
  Result := False;
  Context := TRttiContext.Create;
  try
    RttiType := Context.GetType(FieldsObject.ClassType);

    for Prop in RttiType.GetProperties do
    begin
      Value := Prop.GetValue(FieldsObject);

      if (Prop.PropertyType.TypeKind = tkUString) and (Value.AsString = '') then
      begin
        ShowMessage('Erro: O campo ' + Prop.Name + ' está vazio.');
        Exit(False);
      end;

    end;

    Result := True;
  finally
    Context.Free;
  end;
end;

end.
