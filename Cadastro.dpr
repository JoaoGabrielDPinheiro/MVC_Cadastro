program Cadastro;

uses
  Vcl.Forms,
  Cadastro.View.Principal in 'View\Cadastro.View.Principal.pas' {frmPrincipal},
  Cadastro.View.CadastroPessoas in 'View\Cadastro.View.CadastroPessoas.pas' {frmCadastroPessoas},
  Cadastro.Controller in 'Controller\Cadastro.Controller.pas',
  Cadastro.DAO.Connection in 'DAO\Cadastro.DAO.Connection.pas',
  Cadastro.DAO.APIService in 'DAO\API\Cadastro.DAO.APIService.pas',
  Cadastro.Models.Utils.Funcoes in 'Models\Utils\Cadastro.Models.Utils.Funcoes.pas',
  Cadastro.View.VisulizarPessoas in 'View\Cadastro.View.VisulizarPessoas.pas' {frmVisualizarPessoas},
  Cadastro.DAO.ClassDAO.Pessoa in 'DAO\ClassDAO\Cadastro.DAO.ClassDAO.Pessoa.pas',
  Cadastro.Models.Pessoa in 'Models\Cadastro.Models.Pessoa.pas',
  Cadastro.Models.Endereco in 'Models\Cadastro.Models.Endereco.pas',
  Cadastro.DAO.ClassDAO.Endereco in 'DAO\ClassDAO\Cadastro.DAO.ClassDAO.Endereco.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
