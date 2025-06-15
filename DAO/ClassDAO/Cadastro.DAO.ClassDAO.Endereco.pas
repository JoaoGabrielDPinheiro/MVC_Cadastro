unit Cadastro.DAO.ClassDAO.Endereco;

interface

uses Cadastro.Models.Endereco,   REST.Types,
  REST.Client, JSON, SysUtils,
  REST.Authenticator.Basic;
  type
    TEnderecoDAO = class
      private
      public
      function GetEnderecoAPI(cep: string): TEndereco;
    end;

implementation


{ TEnderecoDAO }

uses Cadastro.Controller;

function TEnderecoDAO.GetEnderecoAPI(cep: string): TEndereco;
var
  url, Response: string;
  JSON: TJSONObject;
begin
  try
    url := 'https://viacep.com.br/ws/'+cep+'/json/';
    Response := TCadastroController.GetInstance.APIService.ExecuteAPIOperation(url, '', rmGET);

    JSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;

    with TCadastroController.GetInstance.Endereco do
    begin
      estado := JSON.GetValue<string>('estado');
      cidade := JSON.GetValue<string>('localidade');
      nome_endereco := JSON.GetValue<string>('logradouro');     //Por enquanto só estes implementados.
    end;

    Result := TCadastroController.GetInstance.Endereco;
  finally
    FreeAndNil(JSON);
  end;
end;

end.
