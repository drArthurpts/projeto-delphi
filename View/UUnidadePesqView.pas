unit UUnidadePesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfrmUnidadePesq = class(TForm)
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
  frmUnidadePesq: TfrmUnidadePesq;

implementation

{$R *.dfm}

end.
