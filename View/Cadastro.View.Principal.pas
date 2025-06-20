unit Cadastro.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Vcl.StdCtrls, Cadastro.View.CadastroPessoas, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Buttons;
type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    btnCadastroPessoas: TSpeedButton;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCadastroPessoasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses Cadastro.Controller;

procedure TfrmPrincipal.btnCadastroPessoasClick(Sender: TObject);
begin
  frmCadastroPessoas := TfrmCadastroPessoas.Create(nil);
  frmCadastroPessoas.ShowModal;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmPrincipal := nil;
  TCadastroController.GetInstance.Destroy;
  Action := caFree;
end;

end.
