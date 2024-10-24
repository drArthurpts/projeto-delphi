unit UProdutoPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  TfrmProdutoPesqView = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlResultado: TPanel;
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
