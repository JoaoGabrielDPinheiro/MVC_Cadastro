unit Cadastro.Controller;

interface

uses Cadastro.DAO.Connection, SysUtils, Cadastro.DAO.APIService,
  Cadastro.DAO.ClassDAO.Pessoa, Cadastro.Models.Endereco, Cadastro.Models.Pessoa,
  Cadastro.DAO.ClassDAO.Endereco;

  type TCadastroController = class
    private
      FConnection: TConnection;
      FAPIService: TAPIService;
      FPessoa: TPessoa;
      FPessoaDAO: TPessoaDAO;
      FEndereco: TEndereco;
      FEnderecoDAO: TEnderecoDAO;
      class var FInstance: TCadastroController;
    public
      constructor Create;
      destructor Destroy; override;

      class function GetInstance: TCadastroController;

      property Connection: TConnection read FConnection write FConnection;
      property APIService: TAPIService read FAPIService write FAPIService;
      property Pessoa: TPessoa read FPessoa write FPessoa;
      property PessoaDAO: TPessoaDAO read FPessoaDAO write FPessoaDAO;
      property Endereco: TEndereco read FEndereco write FEndereco;
      property EnderecoDAO: TEnderecoDAO read FEnderecoDAO write FEnderecoDAO;
  end;

implementation

{ TCadastroController }

constructor TCadastroController.Create;
begin
  FConnection := TConnection.Create;
  FAPIService := TAPIService.Create;
  FPessoa     := TPessoa.Create;
  FPessoaDAO  := TPessoaDAO.Create;
  FEndereco   := TEndereco.Create;
  FEnderecoDAO:= TEnderecoDAO.Create;
end;

destructor TCadastroController.Destroy;
begin
  FreeAndNil(FConnection);
  FreeAndNil(FAPIService);
  FreeAndNil(FPessoa);
  FreeAndNil(FPessoaDAO);
  FreeAndNil(FEndereco);
  FreeAndNil(FEnderecoDAO);
  inherited;
end;

class function TCadastroController.GetInstance: TCadastroController;
begin
  if not Assigned(Self.FInstance) then
    Self.FInstance := TCadastroController.Create;

  Result := Self.FInstance;
end;

end.
