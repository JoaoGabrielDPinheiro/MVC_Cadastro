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
    id_pessoa: integer;
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
  cep := TUtilsFuncoes.New.RemoveMask(edtCEP);
  TCadastroController.GetInstance.EnderecoDAO.GetEnderecoAPI(cep);

  with TCadastroController.GetInstance.Endereco do
  begin
    edtEndereco.Text := nome_endereco;
    edtCidade.Text   := cidade;
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
end;

procedure TfrmCadastroPessoas.edtCEPExit(Sender: TObject);
begin
  AlimentaCamposEndereco;
end;

procedure TfrmCadastroPessoas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmCadastroPessoas := nil;
end;

procedure TfrmCadastroPessoas.FormShow(Sender: TObject);
begin
  bEdicao := false;
end;

procedure TfrmCadastroPessoas.Salvar;
begin
  with TCadastroController.GetInstance.Pessoa  do
  begin
    Nome := Trim(edtNome.Text);
    cpf  := Trim(edtCpf.Text);
    data_nascimento := dtpDataNascimento.Date;
    telefone := Trim(edtTelefone.Text);
  end;

  TUtilsFuncoes.New.ValidateFields(TCadastroController.GetInstance.Pessoa);

  with TCadastroController.GetInstance.Endereco do
  begin
    nome_endereco := Trim(edtEndereco.Text);
    cidade := Trim(edtCidade.Text);
    estado := Trim(edtEstado.Text);
    cep    := Trim(edtCep.text);
  end;

  TUtilsFuncoes.New.ValidateFields(TCadastroController.GetInstance.Endereco);

  if bEdicao then
    TCadastroController.GetInstance.PessoaDAO.PutPessoa(TCadastroController.GetInstance.Pessoa,  TCadastroController.GetInstance.Endereco)
  else
    TCadastroController.GetInstance.PessoaDAO.PostPessoa(TCadastroController.GetInstance.Pessoa,  TCadastroController.GetInstance.Endereco);
end;

end.
