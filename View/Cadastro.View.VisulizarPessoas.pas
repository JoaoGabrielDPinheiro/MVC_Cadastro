unit Cadastro.View.VisulizarPessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmVisualizarPessoas = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    dbgPessoas: TDBGrid;
    edtNome: TEdit;
    btnPesquisar: TSpeedButton;
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgPessoasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    MemTable: TFDMemTable;
    DataSource: TDataSource;
    procedure Pesquisar;
    procedure Deletar;
    procedure Editar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVisualizarPessoas: TfrmVisualizarPessoas;

implementation

{$R *.dfm}

uses Cadastro.Controller, Cadastro.View.CadastroPessoas;

{ TfrmVisualizarPessoas }

procedure TfrmVisualizarPessoas.btnPesquisarClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmVisualizarPessoas.dbgPessoasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    Deletar;

  if Key = VK_RETURN then
    Editar;
end;

procedure TfrmVisualizarPessoas.Deletar;
begin
  if not MemTable.IsEmpty then
  begin
    if MessageDlg('Deseja realmente excluir esta pessoa '+dbgPessoas.DataSource.DataSet.FieldByName('NOME').AsString+' ? ', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      TCadastroController.GetInstance.PessoaDAO.DeletePessoa(dbgPessoas.DataSource.DataSet.FieldByName('ID').AsInteger, dbgPessoas.DataSource.DataSet.FieldByName('ID_ENDE').AsInteger);
      Pesquisar;
    end;
  end;
end;

procedure TfrmVisualizarPessoas.Editar;
begin
  if not MemTable.IsEmpty then
  begin
    with frmCadastroPessoas do
    begin
      edtNome.Text := dbgPessoas.DataSource.DataSet.FieldByName('nome').AsString;
      edtCPF.Text  := dbgPessoas.DataSource.DataSet.FieldByName('cpf').AsString;
      dtpDataNascimento.Date := dbgPessoas.DataSource.DataSet.FieldByName('data_nascimento').AsDateTime;
      edtTelefone.Text := dbgPessoas.DataSource.DataSet.FieldByName('telefone').AsString;
      edtEndereco.Text := dbgPessoas.DataSource.DataSet.FieldByName('nome_endereco').AsString;
      edtCidade.Text :=  dbgPessoas.DataSource.DataSet.FieldByName('cidade').AsString;
      edtEstado.Text :=  dbgPessoas.DataSource.DataSet.FieldByName('estado').AsString;
      id_pessoa  := dbgPessoas.DataSource.DataSet.FieldByName('id').AsInteger;
      bEdicao := true;
    end;

    Close;
  end;
end;

procedure TfrmVisualizarPessoas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(MemTable);
  FreeAndNil(DataSource);
  frmVisualizarPessoas := nil;
end;

procedure TfrmVisualizarPessoas.FormCreate(Sender: TObject);
begin
  MemTable := TFDMemTable.Create(nil);
  DataSource := TDataSource.Create(nil);
end;

procedure TfrmVisualizarPessoas.FormShow(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmVisualizarPessoas.Pesquisar;
var
  VQuery: TFDQuery;
begin
  VQuery := TCadastroController.GetInstance.PessoaDAO.GetPessoa(Trim(edtNome.Text));
  try
    MemTable.CopyDataSet(VQuery, [coStructure, coRestart, coAppend]);
    DataSource.DataSet := MemTable;
    dbgPessoas.DataSource := DataSource;
  finally
    VQuery.Free;
  end;
end;

end.
