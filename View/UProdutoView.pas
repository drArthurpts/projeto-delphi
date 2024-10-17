unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
    TfrmProduto = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    edtDescricao: TEdit;
    lblUnidade: TLabel;
    edtCodigo: TEdit;
    edtUnidade: TEdit;
    Label1: TLabel;
    lblCodigo: TLabel;
    edtQuantidade: TEdit;
    lblQuantidade: TLabel;
    edtVenda: TEdit;
    lblPreco: TLabel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    Edit1: TEdit;
    btnSpeed: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProduto: TfrmProduto;

implementation

{$R *.dfm}

end.
