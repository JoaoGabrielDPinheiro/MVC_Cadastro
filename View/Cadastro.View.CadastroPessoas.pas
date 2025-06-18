unit Cadastro.View.CadastroPessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Buttons,
  Cadastro.Models.Utils.Funcoes, Vcl.WinXPickers, Cadastro.View.VisulizarPessoas;

type
  TfrmCadastroPessoas = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    lbl: TLabel;
    Label7: TLabel;
    edtNome: TEdit;
    edtTelefone: TMaskEdit;
    edtEndereco: TEdit;
    edtEstado: TEdit;
    edtCPF: TMaskEdit;
    edtCidade: TEdit;
    btnSalvar: TSpeedButton;
    ImageList1: TImageList;
    btnCancelar: TSpeedButton;
    btnVisualizarPessoas: TSpeedButton;
    Label2: TLabel;
    dtpDataNascimento: TDatePicker;
    edtCEP: TMaskEdit;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure btnVisualizarPessoasClick(Sender: TObject);
  private
    procedure Salvar;
    procedure Cancelar;
    procedure AlimentaCamposEndereco;
    { Private declarations }
  public
    bEdicao: boolean;
    id_pessoas, id_endereco: integer;
    { Public declarations }
  end;

var
  frmCadastroPessoas: TfrmCadastroPessoas;

implementation

{$R *.dfm}

uses Cadastro.Controller;

{ TfrmCadastroPessoas }

procedure TfrmCadastroPessoas.AlimentaCamposEndereco;
var
 cep: string;
begin
  cep := TUtilsFuncoes.New.LimparTexto(edtCEP.Text);
  TCadastroController.GetInstance.EnderecoDAO.GetEnderecoAPI(cep);

  with TCadastroController.GetInstance.Endereco do
  begin
    if Trim(edtEndereco.Text) = '' then
      edtEndereco.Text := nome_endereco;

    if Trim(edtCidade.Text) = '' then
      edtCidade.Text   := cidade;

    if Trim(edtEstado.Text) = '' then
      edtEstado.Text   := estado;
  end;
end;

procedure TfrmCadastroPessoas.btnCancelarClick(Sender: TObject);
begin
  Cancelar;
end;

procedure TfrmCadastroPessoas.btnSalvarClick(Sender: TObject);
begin
  Salvar;
end;

procedure TfrmCadastroPessoas.btnVisualizarPessoasClick(Sender: TObject);
begin
  frmVisualizarPessoas := TfrmVisualizarPessoas.Create(nil);
  frmVisualizarPessoas.ShowModal;
end;

procedure TfrmCadastroPessoas.Cancelar;
begin
  bEdicao := False;
  TUtilsFuncoes.New.ClearFields(Self);
  dtpDataNascimento.Date := Now;
end;

procedure TfrmCadastroPessoas.edtCEPExit(Sender: TObject);
begin
  AlimentaCamposEndereco;
end;

procedure TfrmCadastroPessoas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmCadastroPessoas := nil;
end;

procedure TfrmCadastroPessoas.FormShow(Sender: TObject);
begin
  bEdicao     := false;
  id_endereco := 0;
  id_pessoas   := 0;
end;

procedure TfrmCadastroPessoas.Salvar;
begin
  with TCadastroController.GetInstance.Pessoa do
  begin
    Nome := Trim(edtNome.Text);
    cpf  := Trim(edtCpf.Text);
    data_nascimento := dtpDataNascimento.Date;
    telefone := Trim(edtTelefone.Text);
    id_pessoa := id_pessoas;

    if (TUtilsFuncoes.New.ValorExiste('pessoa', 'cpf', cpf, TCadastroController.GetInstance.Connection.GetConnection)) and (not bEdicao) then
    begin
      ShowMessage('Este CPF já está registrado no sistema.');
      exit;
    end;
  end;

  if not TUtilsFuncoes.New.ValidateFields(TCadastroController.GetInstance.Pessoa) then
    exit;

  with TCadastroController.GetInstance.Endereco do
  begin
    nome_endereco := Trim(edtEndereco.Text);
    cidade := Trim(edtCidade.Text);
    estado := Trim(edtEstado.Text);
    cep    := Trim(edtCep.text);
    id_enderecos := id_endereco;
  end;

  if not TUtilsFuncoes.New.ValidateFields(TCadastroController.GetInstance.Endereco) then
    exit;

  if bEdicao then
    TCadastroController.GetInstance.PessoaDAO.PutPessoa(TCadastroController.GetInstance.Pessoa,  TCadastroController.GetInstance.Endereco)
  else
    TCadastroController.GetInstance.PessoaDAO.PostPessoa(TCadastroController.GetInstance.Pessoa,  TCadastroController.GetInstance.Endereco);

  Cancelar;
end;

end.
