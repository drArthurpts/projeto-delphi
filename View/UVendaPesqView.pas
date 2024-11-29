unit UVendaPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Grids, DBGrids, Mask, Buttons, DB,
  DBClient, uMessageUtil, UVenda, UClassFuncoes, UVendaController, UPessoaController;

type
  TTfrmVendaPesqView = class(TForm)
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    edtCodigo: TEdit;
    lblCodCliente: TLabel;
    btnFiltrar: TBitBtn;
    lblDataInicio: TLabel;
    edtDataInicio: TMaskEdit;
    Label1: TLabel;
    edtDataFim: TMaskEdit;
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
    cdsVendaValor: TFloatField;
    cdsVendaData: TDateField;
    cdsVendaDesconto: TFloatField;
    cdsVendaNomeCliente: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dbgVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgVendaDblClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;
  public
    { Public declarations }
    mVendaID     : Integer;
    mNomeCliente : string;
    vKey         : Word;
  end;

var
    frmVendaPesqView : TTfrmVendaPesqView;


implementation


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

         if (ActiveControl = dbgVenda) then
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

   if (not cdsVenda.IsEmpty) then
      cdsVenda.EmptyDataSet;

   if (edtCodigo.CanFocus) then
      edtCodigo.SetFocus;
end;

procedure TTfrmVendaPesqView.ProcessaConfirmacao;
begin
   if (not cdsVenda.IsEmpty) then
   begin
      mVendaID         := cdsVendaID.Value;
      mNomeCliente     := cdsVendaNomeCliente.EditMask;
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
var
   xListaVenda : TColVenda;
   xID_Venda   : Integer;
   xAux        : Integer;
begin
   try
      try
         xID_Venda := 0;
         xListaVenda := TColVenda.Create;

         if (edtCodigo.Text <> EmptyStr) then
            xID_Venda := StrToInt(edtCodigo.Text);

         if (TFuncoes.SoNumero(edtDataInicio.Text) = EmptyStr) then
            edtDataInicio.Text := '01/01/1999';

         if (TFuncoes.SoNumero(edtDataFim.Text) = EmptyStr) then
            edtDataFim.Text := '01/01/2999';

         xListaVenda :=
               TVendaController.getInstancia.PesquisaVenda(xID_Venda, edtDataInicio.Text, edtDataFim.Text);

         cdsVenda.EmptyDataSet;

         if xListaVenda <> nil then
         begin
            for xAux := 0 to pred(xListaVenda.Count) do
            begin
               if xListaVenda.Retorna(xAux).ID <> 0 then
               begin
               cdsVenda.Append;
               cdsVendaID.Value             := xListaVenda.Retorna(xAux).ID;
               cdsVendaNomeCliente.Text     := TPessoaController.getInstancia.BuscaPessoa(xListaVenda.Retorna(xAux).ID_Cliente).Nome;
//               ShowMessage('NomeCliente: ' + xListaVenda.Retorna(xAux).NomeCliente);
//               cdsVendaNomeCliente.Text     := xListaVenda.Retorna(xAux).NomeCliente;
               cdsVendaData.Value           := xListaVenda.Retorna(xAux).DataVenda;
               cdsVendaDesconto.Value       := xListaVenda.Retorna(xAux).TotalAcrescimo;
               cdsVendaValor.Value          := xListaVenda.Retorna(xAux).TotalVenda;
               cdsVenda.Post;
               end;
            end;
         end;
         if (cdsVenda.RecordCount = 0) then
         begin
            if edtDataInicio.CanFocus then
               edtDataInicio.SetFocus;

            TMessageUtil.Alerta(
               'Nenhuma venda encontrada para este filtro.');
         end
         else
         begin
            cdsVenda.First;
            if dbgVenda.CanFocus then
               dbgVenda.SetFocus;
         end;
      finally
         if (xListaVenda <> nil) then
            FreeAndNil(xListaVenda);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao pesquisar dados da venda '#13 +
            e.Message);
      end;
   end;
end;

procedure TTfrmVendaPesqView.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TTfrmVendaPesqView.btnLimparClick(Sender: TObject);
begin
   mVendaID := 0;
   mNomeCliente := EmptyStr;
   LimparTela;
end;

procedure TTfrmVendaPesqView.btnSairClick(Sender: TObject);
begin
   LimparTela;
   Close;
end;

procedure TTfrmVendaPesqView.dbgVendaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
       btnConfirmar.SetFocus;
end;

procedure TTfrmVendaPesqView.dbgVendaDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TTfrmVendaPesqView.btnFiltrarClick(Sender: TObject);
begin
   mVendaID := 0;
   mNomeCliente := EmptyStr;
   ProcessaPesquisa;
end;
end.
