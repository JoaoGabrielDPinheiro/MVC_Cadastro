unit Cadastro.Models.Endereco;

interface

uses Cadastro.Models.Pessoa;
  type
    TEndereco = class
      private
        Fnome_endereco: string;
        Fcep: string;
        Fid_endereco: integer;
        Fcidade: string;
        Festado: string;
        procedure Setcep(const Value: string);
        procedure Setcidade(const Value: string);
        procedure Setestado(const Value: string);
        procedure Setid_endereco(const Value: integer);
        procedure Setnome_endereco(const Value: string);
      public
        property id_enderecos: integer read Fid_endereco write Setid_endereco;
        property nome_endereco: string read Fnome_endereco write Setnome_endereco;
        property cep: string read Fcep write Setcep;
        property cidade: string read Fcidade write Setcidade;
        property estado: string read Festado write Setestado;
    end;

implementation

{ Endereco }

procedure TEndereco.Setcep(const Value: string);
begin
  Fcep := Value;
end;

procedure TEndereco.Setcidade(const Value: string);
begin
  Fcidade := Value;
end;

procedure TEndereco.Setestado(const Value: string);
begin
  Festado := Value;
end;

procedure TEndereco.Setid_endereco(const Value: integer);
begin
  Fid_endereco := Value;
end;

procedure TEndereco.Setnome_endereco(const Value: string);
begin
  Fnome_endereco := Value;
end;

end.
