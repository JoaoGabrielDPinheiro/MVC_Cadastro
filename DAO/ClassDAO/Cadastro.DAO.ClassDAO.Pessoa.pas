unit Cadastro.DAO.ClassDAO.Pessoa;

interface

uses Cadastro.Models.Pessoa, Cadastro.Models.Endereco, Data.DB, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Comp.Client, FireDAC.DApt,
  Vcl.Dialogs;

  type TPessoaDAO = class
    private
    public
      {Métodos CRUD para Pessoa.}
      function GetPessoa(nome: string): TFDQuery;
      procedure PostPessoa(Pessoa: TPessoa; Endereco: TEndereco);
      procedure DeletePessoa(id_pessoa, id_endereco: integer);
      procedure PutPessoa(Pessoa: TPessoa; Endereco: TEndereco);
  end;

implementation

{ TPessoaDAO }

uses Cadastro.Controller;

procedure TPessoaDAO.DeletePessoa(id_pessoa, id_endereco: integer);
var
  VQuery: TFDQuery;
begin
  VQuery := TCadastroController.GetInstance.Connection.CreateQuery;
  try
    try
      if not VQuery.Connection.InTransaction then
        VQuery.Connection.StartTransaction;

      VQuery.Close;
      VQuery.SQL.Text := 'DELETE FROM PESSOA WHERE ID = :ID';
      VQuery.ParamByName('ID').AsInteger := id_pessoa;
      VQuery.ExecSQL;

      VQuery.Close;
      VQuery.SQL.Text := 'DELETE FROM ENDERECO WHERE ID = :ID';
      VQuery.ParamByName('ID').AsInteger := id_endereco;
      VQuery.ExecSQL;

      VQuery.Connection.Commit;
    except on E: Exception do
      VQuery.Connection.Rollback;
    end;
  finally
    VQuery.Free;
  end;
end;

procedure TPessoaDAO.PutPessoa(Pessoa: TPessoa; Endereco: TEndereco);
var
  VQuery: TFDQuery;
begin
  VQuery := TCadastroController.GetInstance.Connection.CreateQuery;
  try
    try
      if not VQuery.Connection.InTransaction then
        VQuery.Connection.StartTransaction;

      VQuery.Close;
      VQuery.SQL.Text :=
      'UPDATE pessoa                            '+
      'SET nome = :nome,                        '+
      '    data_nascimento = :data_nascimento,  '+
      '    cpf = :cpf,                          '+
      '    telefone = :telefone                 '+
      ' WHERE id = :id;                          ';
      VQuery.ParamByName('nome').AsString := Pessoa.nome;
      VQuery.ParamByName('data_nascimento').AsDate := Pessoa.data_nascimento;
      VQuery.ParamByName('cpf').AsString := Pessoa.cpf;
      VQuery.ParamByName('telefone').AsString := Pessoa.telefone;
      VQuery.ParamByName('id').AsInteger := Pessoa.id_pessoa;
      VQuery.ExecSQL;

      VQuery.Close;
      VQuery.SQL.Text :=
        'UPDATE endereco ' +
        'SET nome_endereco = :nome_endereco, ' +
        '    cep = :cep, ' +
        '    cidade = :cidade, ' +
        '    estado = :estado ' +
        'WHERE id = :id';

      VQuery.ParamByName('nome_endereco').AsString := Endereco.nome_endereco;
      VQuery.ParamByName('cep').AsString := Endereco.cep;
      VQuery.ParamByName('cidade').AsString := Endereco.cidade;
      VQuery.ParamByName('estado').AsString := Endereco.estado;
      VQuery.ParamByName('id').AsInteger := Endereco.id_enderecos;
      VQuery.ExecSQL;


      VQuery.Connection.Commit;
    except on E: Exception do
      VQuery.Connection.Rollback;
    end;
  finally
    VQuery.Free;
  end;
end;

function TPessoaDAO.GetPessoa(nome: string): TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := TCadastroController.GetInstance.Connection.CreateQuery;
  VQuery.Close;
  VQuery.SQL.Text :=
  'SELECT P.ID, P.NOME, P.DATA_NASCIMENTO, P.CPF, P.TELEFONE, E.NOME_ENDERECO, '+
  'E.CEP, E.CIDADE, E.ESTADO, E.ID AS ID_ENDE                                  '+
  'FROM PESSOA P                                                               '+
  'JOIN ENDERECO E ON E.ID = P.ID_ENDERECO                                     ';

  if not NOME.IsEmpty then
    VQuery.SQL.Text := VQuery.SQL.Text + ' WHERE P.NOME LIKE ''%' + NOME + '%''';

  VQuery.Open;
  VQuery.FetchAll;

  Result := VQuery;
end;

procedure TPessoaDAO.PostPessoa(Pessoa: TPessoa; Endereco: TEndereco);
var
  VQuery: TFDQuery;
begin
  VQuery := TCadastroController.GetInstance.Connection.CreateQuery;
  try
    try
      if not VQuery.Connection.InTransaction then
        VQuery.Connection.StartTransaction;

      VQuery.Close;
      VQuery.SQL.Text :=
        'INSERT INTO endereco (nome_endereco, cep, cidade, estado) ' +
        'VALUES (:nome_endereco, :cep, :cidade, :estado) ' +
        'RETURNING id';

      VQuery.ParamByName('nome_endereco').AsString := Endereco.nome_endereco;
      VQuery.ParamByName('cep').AsString := Endereco.cep;
      VQuery.ParamByName('cidade').AsString := Endereco.cidade;
      VQuery.ParamByName('estado').AsString := Endereco.estado;

      VQuery.Open;
      Endereco.id_enderecos := VQuery.FieldByName('id').AsInteger;

      VQuery.Close;
      VQuery.SQL.Text :=
        'INSERT INTO pessoa (nome, data_nascimento, id_endereco, cpf, telefone) ' +
        'VALUES (:nome, :data_nascimento, :id_endereco, :cpf, :telefone)';

      VQuery.ParamByName('nome').AsString := Pessoa.nome;
      VQuery.ParamByName('data_nascimento').AsDate := Pessoa.data_nascimento;
      VQuery.ParamByName('id_endereco').AsInteger := Endereco.id_enderecos;
      VQuery.ParamByName('cpf').AsString := Pessoa.cpf;
      VQuery.ParamByName('telefone').AsString := Pessoa.telefone;
      VQuery.ExecSQL;

      VQuery.Connection.Commit;
    except on E: Exception do
      VQuery.Connection.Rollback;
    end;
  finally
    VQuery.Free;
  end;
end;

end.
