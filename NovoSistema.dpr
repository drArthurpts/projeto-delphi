program NovoSistema;

{%File '..\..\Downloads\RESULTH\RESULTH.FB'}

uses
  Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {frmPrincipal},
  UConexao in 'Model\BD\UConexao.pas',
  UCriptografiaUtil in 'Model\Util\UCriptografiaUtil.pas',
  UClassFuncoes in 'Model\Util\UClassFuncoes.pas',
  UClientesView in 'View\UClientesView.pas' {frmClientes},
  uMessageUtil in 'Model\Util\uMessageUtil.pas',
  Consts in 'Model\Util\Consts.pas',
  UEnumerationUtil in 'Model\Util\UEnumerationUtil.pas',
  UPessoa in 'Model\UPessoa.pas',
  UPessoaDAO in 'Model\UPessoaDAO.pas',
  UCliente in 'Model\UCliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
