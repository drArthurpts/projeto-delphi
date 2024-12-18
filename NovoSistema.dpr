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
  UPessoaController in 'Controller\UPessoaController.pas',
  UUnidadeProduto in 'Model\UUnidadeProduto.pas',
  UUnidadeProdController in 'Controller\UUnidadeProdController.pas',
  UUnidadeProdutoDAO in 'Model\UUnidadeProdutoDAO.pas',
  Consts in 'Model\Util\Consts.pas',
  UEnumerationUtil in 'Model\Util\UEnumerationUtil.pas',
  UPessoa in 'Model\UPessoa.pas',
  UPessoaDAO in 'Model\UPessoaDAO.pas',
  UCliente in 'Model\UCliente.pas',
  UEndereco in 'Model\UEndereco.pas',
  UEnderecoDAO in 'Model\UEnderecoDAO.pas',
  UClientePesqView in 'View\UClientePesqView.pas' {frmClientesPesq},
  UUnidadeProdView in 'View\UUnidadeProdView.pas' {frmUnidadeProd},
  UUnidadePesqView in 'View\UUnidadePesqView.pas' {frmUnidadePesq},
  UProduto in 'Model\UProduto.pas',
  UProdutoView in 'View\UProdutoView.pas' {Form2},
  UProdutoController in 'Controller\UProdutoController.pas',
  UProdutoDAO in 'Model\UProdutoDAO.pas',
  UProdutoPesqView in 'View\UProdutoPesqView.pas' {frmProdutoPesqView},
  UVendaView in 'View\UVendaView.pas' {frmVenda},
  UVenda in 'Model\UVenda.pas',
  UVendaController in 'Controller\UVendaController.pas',
  UVendaDAO in 'Model\UVendaDAO.pas',
  UVendaItem in 'Model\UVendaItem.pas',
  UVendaItemDAO in 'Model\UVendaItemDAO.pas',
  UVendaItemController in 'Controller\UVendaItemController.pas',
  UVendaPesqView in 'View\UVendaPesqView.pas' {TfrmVendaPesqView};

//  UVendaItemController in 'Controller\UVendaItemController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
