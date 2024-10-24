unit UProdutoPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB, DBClient, Grids,
  DBGrids;

type
  TfrmProdutoPesqView = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlResultado: TPanel;
    grbFiltrar: TGroupBox;
    lblInfo: TLabel;
    lblProduto: TLabel;
    edtNome: TEdit;
    btnFiltrar: TBitBtn;
    grbGrid: TGroupBox;
    DBGrid1: TDBGrid;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoID: TIntegerField;
    cdsProdutoDescricao: TStringField;
    cdsProdutoQuantidade: TIntegerField;
    cdsProdutoPreco: TFloatField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutoPesqView: TfrmProdutoPesqView;

implementation

{$R *.dfm}

end.
