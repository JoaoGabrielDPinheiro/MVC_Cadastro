unit Cadastro.Models.Pessoa;

interface

  type TPessoa = class
    private
    Fid_pessoa: integer;
    Fcpf: string;
    Fdata_nascimento: TDate;
    Fnome: string;
    Ftelefone: string;
    procedure Setcpf(const Value: string);
    procedure Setdata_nascimento(const Value: TDate);
    procedure Setid_pessoa(const Value: integer);
    procedure Setnome(const Value: string);
    procedure Settelefone(const Value: string);
    public
    property id_pessoa: integer read Fid_pessoa write Setid_pessoa;
    property nome: string read Fnome write Setnome;
    property cpf: string read Fcpf write Setcpf;
    property telefone: string read Ftelefone write Settelefone;
    property data_nascimento: TDate read Fdata_nascimento write Setdata_nascimento;
  end;

implementation

{ TPessoa }

procedure TPessoa.Setcpf(const Value: string);
begin
  Fcpf := Value;
end;

procedure TPessoa.Setdata_nascimento(const Value: TDate);
begin
  Fdata_nascimento := Value;
end;

procedure TPessoa.Setid_pessoa(const Value: integer);
begin
  Fid_pessoa := Value;
end;

procedure TPessoa.Setnome(const Value: string);
begin
  Fnome := Value;
end;

procedure TPessoa.Settelefone(const Value: string);
begin
  Ftelefone := Value;
end;

end.
