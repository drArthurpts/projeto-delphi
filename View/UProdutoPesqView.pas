unit UProdutoPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB, DBClient, Grids,
  DBGrids, uMessageUtil, UProdutoController, UProduto;

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
    dbgProduto: TGroupBox;
    DBGrid1: TDBGrid;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoID: TIntegerField;
    cdsProdutoDescricao: TStringField;
    cdsProdutoPreco: TFloatField;
    cdsProdutoQuantidade: TFloatField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsProdutoBeforeDelete(DataSet: TDataSet);
    procedure dbgProdutoDblClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);


  private
    { Private declarations }
    vKey : Word;
    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;
  public
    { Public declarations }
    mProdutoID        : Integer;
    mProdutoDescricao : String;
  end;

var
  frmProdutoPesqView: TfrmProdutoPesqView;


implementation

uses Math, StrUtils, UVendaView;

{$R *.dfm}

procedure TfrmProdutoPesqView.FormKeyDown(Sender: TObject; var Key: Word;
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
         vKey := 0;
      end;

      VK_UP:
      begin
         vKey := VK_CLEAR;

         if (ActiveControl = dbgProduto) then
         exit; 

         Perform(WM_NEXTDLGCTL, 1, 0);
      end;
      end;
end;

procedure TfrmProdutoPesqView.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred (ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsProduto.IsEmpty) then
      cdsProduto.EmptyDataSet;

   if (edtNome.CanFocus) then
       edtNome.SetFocus;

   mProdutoID   := 0;
   mProdutoDescricao := EmptyStr;
end;

procedure TfrmProdutoPesqView.ProcessaPesquisa;
var
   xListaProduto : TColProduto;
   xAux          : Integer;
begin
   try
      try
         xListaProduto := TColProduto.Create;

         xListaProduto :=
            TProdutoController.getInstancia.PesquisaProduto(Trim(edtNome.Text));

         cdsProduto.EmptyDataSet;

         if xListaProduto <> nil then
         begin
            for xAux := 0 to pred(xListaProduto.Count) do
            begin
            cdsProduto.Append;
            cdsProdutoID.Value         := xListaProduto.Retorna(xAux).ID;
            cdsProdutoDescricao.Value  := xListaProduto.Retorna(xAux).Descricao;
            cdsProdutoQuantidade.Value := xListaProduto.Retorna(xAux).QuantidadeEstoque;
            cdsProdutoPreco.Value      := xListaProduto.Retorna(xAux).PrecoVenda;
            cdsProduto.Post;
            end;
         end;

         if (cdsProduto.RecordCount = 0) then
         begin
            TMessageUtil.Alerta('Nenhum Produto encontrada para esse filtro.');
            if edtNome.CanFocus then
               edtNome.SetFocus;
         end
         else
         begin
            cdsProduto.First;
            if dbgProduto.CanFocus then
               dbgProduto.SetFocus;
         end;

      finally
         if (xListaProduto <> nil) then
            FreeAndNil(xListaProduto);
      end;

   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao pesquisar os dados do produto [View] : ' + #13 +
            e.Message);
      end;
   end;
end;


procedure TfrmProdutoPesqView.btnFiltrarClick(Sender: TObject);
begin
   mProdutoID   := 0;
   mProdutoDescricao := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmProdutoPesqView.btnLimparClick(Sender: TObject);
begin
   mProdutoID   := 0;
   mProdutoDescricao := EmptyStr;
   LimparTela;
end;

procedure TfrmProdutoPesqView.btnSairClick(Sender: TObject);
begin
   LimparTela;
   Close;
end;

procedure TfrmProdutoPesqView.cdsProdutoBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmProdutoPesqView.dbgProdutoDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutoPesqView.ProcessaConfirmacao;
begin
   if (not cdsProduto.IsEmpty) then
   begin
      mProdutoID        := cdsProdutoID.Value;
      mProdutoDescricao := cdsProdutoDescricao.Value;
      Self.ModalResult  := mrOk;
//      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma Unidade encontrada.');

      if edtNome.CanFocus then
         edtNome.SetFocus;
   end;
end;

procedure TfrmProdutoPesqView.DBGrid1DblClick(Sender: TObject);
begin
   mProdutoID := DBGrid1.DataSource.DataSet.FieldByName('ID').AsInteger;
   ModalResult := mrOk;
end;

procedure TfrmProdutoPesqView.FormShow(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmProdutoPesqView.btnConfirmarClick(Sender: TObject);
begin
  ProcessaConfirmacao;
end;

procedure TfrmProdutoPesqView.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := 0;
end;

end.
