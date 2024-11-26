unit UVendaPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Grids, DBGrids, Mask, Buttons, DB,
  DBClient;

type
  TTfrmVendaPesqView = class(TForm)
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    edtCodigo: TEdit;
    lblCodCliente: TLabel;
    btnFiltrar: TBitBtn;
    lblDataInicio: TLabel;
    edtData: TMaskEdit;
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    dbgVenda: TDBGrid;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    dtsVenda: TDataSource;
    cdsVenda: TClientDataSet;
    cdsVendaID: TIntegerField;
    cdsVendaNomeCliente: TStringField;
    cdsVendaData: TIntegerField;
    cdsVendaValor: TFloatField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;
  public
    { Public declarations }
    mVendaID : Integer;
  end;

var
//    frmVendaPesqView : TfrmVendaPesqView;


implementation

uses UVendaPesqView;

{$R *.dfm}

procedure TTfrmVendaPesqView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NEXTDLGCTL, 0, 0);
      end;

      VK_ESCAPE:
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina? ') then
            Close;
      end;

      VK_UP:
      begin
         vKey := VK_CLEAR;

         if (ActiveControl = dbgCliente) then
         exit;

         Perform(WM_NEXTDLGCTL, 1, 0);
      end;
end;
end;

procedure TTfrmVendaPesqView.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred (ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsCliente.IsEmpty) then
      cdsCliente.EmptyDataSet;

   if (edtNome.CanFocus) then
      edtNome.SetFocus;
end;

procedure TTfrmVendaPesqView.ProcessaConfirmacao;
begin
   if (not cdsVenda.IsEmpty) then
   begin
      mVendaID         := cdsClienteID.Value;
      Self.ModalResult := mrOk;
      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma Venda encontrada. ');

      if edtCodigo.CanFocus then
         edtCodigo.SetFocus;
   end;
end;

procedure TTfrmVendaPesqView.ProcessaPesquisa;
begin

end;

end.
