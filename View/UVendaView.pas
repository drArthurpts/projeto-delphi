unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, NumEdit, Mask, DB,
  DBClient, Grids, DBGrids;

type
  TfrmVenda = class(TForm)
    pnlBotoes: TPanel;
    StatusBar1: TStatusBar;
    pnlValores: TPanel;
    grbPedido: TGroupBox;
    grbProdutos: TGroupBox;
    DBGrid1: TDBGrid;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoCdigo: TIntegerField;
    cdsProdutoDescrio: TStringField;
    cdsProdutoPreoUni: TFloatField;
    cdsProdutoUnidadedeSada: TIntegerField;
    cdsProdutoQuant: TIntegerField;
    cdsProdutoPreoTotal: TFloatField;
    edtNumVenda: TEdit;
    lblNumVenda: TLabel;
    btnSpeed: TSpeedButton;
    lblData: TLabel;
    edtData: TMaskEdit;
    edtCodigo: TEdit;
    lblCodigo: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblPagamento: TLabel;
    cmbPagamento: TComboBox;
    lblDesconto: TLabel;
    lblValor: TLabel;
    edtValor: TNumEdit;
    edtDesconto: TNumEdit;
    edtTotal: TMaskEdit;
    Label1: TLabel;
    btnIncluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    BitBtn1: TBitBtn;


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVenda : TfrmVenda;

implementation

{$R *.dfm}





end.
