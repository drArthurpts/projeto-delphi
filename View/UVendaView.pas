unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, NumEdit,UEnumerationUtil,
  UVendaController, DB, DBClient, Grids, DBGrids, Mask ,UVenda;

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
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);



  private
    { Private declarations }
    vKey : Word;

    vEstadoTela  : TEstadoTela;
    vObjVenda    : TVenda;
    vObjColVenda : TColVenda;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure CarregaDadosTela;
    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao    : Boolean;
    function ProcessaConsulta    : Boolean;


  public
    { Public declarations }
  end;

var
  frmVenda  : TfrmVenda;
  vObjVenda : TVenda;

implementation

uses
   uMessageUtil, Types, UVendaDAO;
{$R *.dfm}




procedure TfrmVenda.BitBtn2Click(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVenda.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;


      if (Components[i] is TComboBox) then
         (Components[i] as TComboBox).Enabled := pOpcao;

   end;

end;


procedure TfrmVenda.CarregaDadosTela;
var
   xObjVenda : TVenda;
   vObjVenda := TVenda.Create;
begin
   if (vObjVenda = nil) then
      exit;

   edtNumVenda.Text               := IntToStr(vObjVenda.ID);
   edtData.Text                   := vObjVenda.Data;
   edtCodigo.Text                 := IntToStr(vObjVenda.IDCliente);


   try
      if vObjVenda.ID <> 0 then
      begin
         xObjVenda := nil;
         xObjVenda := TVenda.create;
         cmbUnidade.Text := xObjVenda.;
         edtDescricaoUnidade.Text := xObjVenda.;

         if  xObjVenda <> nil then
             edtDescricaoUnidade.Text :=  xObjVenda.Descricao;
      end;
   finally
      if xObjVenda <> nil then
         FreeAndNil(xObjVenda);
   end;

   btnCancelar.Enabled := True;
   btnAlterar.Enabled  := True;
   btnExcluir.Enabled  := True;

   if  vEstadoTela = etAlterar then
   begin
      edtDescricaoProd.Enabled     := true;
      edtQuantidade.Enabled        := true;
      edtPreco.Enabled             := true;
   end;
end;

procedure TfrmVenda.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Text := EmptyStr;

      if (Components[i] is TComboBox) then
         begin
         (Components[i] as TComboBox).Clear;
         (Components[i] as TComboBox).ItemIndex := -1;
         end;

   end;
   if (vObjVenda <> nil) then
   FreeAndNil(vObjVenda);

end;

function TfrmVenda.ProcessaConfirmacao: Boolean;
begin
   Result := False;

  try
    case vEstadoTela of
      etIncluir:
        Result := ProcessaInclusao;
      etConsultar:
        Result := ProcessaConsulta;

    end;
    if not Result then
      Exit;
  except
    on E: Exception do
      TMessageUtil.Alerta(E.Message);
  end;

  Result := True;
end;

function TfrmVenda.ProcessaConsulta: Boolean;
begin
   try
    Result := False;

    if (edtNumVenda.Text = EmptyStr) then
    begin
      TMessageUtil.Alerta('Número da venda não pode ficar em branco.');

      if (edtNumVenda.CanFocus) then
          edtNumVenda.SetFocus;

      Exit;
    end;

    vObjVenda := TVenda(TVendaController.getInstancia.
    BuscaVenda(StrToIntDef(edtNumVenda.Text, 0)));

    if (vObjVenda <> nil) then
       CarregaDadosTela
    else
    begin
      TMessageUtil.Alerta('Nenhum Produto encontrado');
      LimpaTela;

      if (edtNumVenda.CanFocus) then
          edtNumVenda.SetFocus;

      exit;
    end;

    DefineEstadoTela;
    Result := True;
  
   except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao consultar os dados do Produto [View].' + #13 + e.Message);

    end;
   end;
end;

function TfrmVenda.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaVenda then
      begin
         TMessageUtil.Informacao('Venda realizada com sucesso! ' + #13 +
                                 'Código da venda: ' + IntToStr(vObjVenda.Id));
         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
       on E : Exception do
       begin
          Raise Exception.Create(
          'Falha ao incluir os dados da venda [View]: '#13 +
          e.Message);
       end;
   end;
end;

end.
