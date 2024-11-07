unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, NumEdit,UEnumerationUtil,
  UVendaController, DB, DBClient, Grids, DBGrids, Mask ,UVenda,UPessoaController,
  UClientesView,UPessoa, UClientePesqView, UProdutoPesqView, UProduto,
  UProdutoController,UProdutoView,UConexao;

type
  TfrmVenda = class(TForm)
    pnlBotoes: TPanel;
    StbBarraStatus: TStatusBar;
    pnlValores: TPanel;
    grbPedido: TGroupBox;
    grbProdutos: TGroupBox;
    dbgProduto: TDBGrid;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoCodigo: TIntegerField;
    cdsProdutoDesc: TStringField;
    cdsProdutoPreoUni: TFloatField;
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
    lblValor: TLabel;
    edtDesconto: TNumEdit;
    Label1: TLabel;
    btnIncluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnFaturar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    edtTotal: TNumEdit;
    cdsProdutoUnidadedeSada: TStringField;
    edtValorComDesconto: TNumEdit;
    Label2: TLabel;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure dbgProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edtDescontoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsProdutoAfterPost(DataSet: TDataSet);
    procedure cdsProdutoAfterDelete(DataSet: TDataSet);
    procedure edtDescontoChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);






  private
    { Private declarations }
    vKey : Word;

    vEstadoTela  : TEstadoTela;
    vObjVenda    : TVenda;
    vObjColVenda : TColVenda;
    vObjPessoa   : TPessoa;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    procedure AtualizarValorTotal;
    procedure CalculaTotalVenda;
    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao    : Boolean;
    function ProcessaConsulta    : Boolean;
    function ProcessaVenda       : Boolean;
    function ProcessaVendaItem   : Boolean;
    function ValidaCampos        : Boolean;


  public
    { Public declarations }
  end;

var
  frmVenda   : TfrmVenda;
  frmProduto : TfrmProduto;
  vObjVenda  : TVenda;

implementation

uses
   uMessageUtil, Types, UVendaDAO;
{$R *.dfm}




procedure TfrmVenda.btnConfirmarClick(Sender: TObject);
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

procedure TfrmVenda.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnabled(False);
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

         if (frmVenda <> nil) and
         (frmVenda.Active) and
         (frmVenda.CanFocus) then
         btnIncluir.SetFocus;

         Application.ProcessMessages;
      end;
      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';

         CamposEnabled(True);

         edtNumVenda.Enabled := False;

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

         edtData.Clear;
         edtData.Text := FormatDateTime('dd/mm/yyyy',Now);

         
      end;

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

//function TfrmVenda.ProcessaConsulta: Boolean;
//begin
//   try
//    Result := False;
//
//    if (edtNumVenda.Text = EmptyStr) then
//    begin
//      TMessageUtil.Alerta('Número da venda não pode ficar em branco.');
//
//      if (edtNumVenda.CanFocus) then
//          edtNumVenda.SetFocus;
//
//      Exit;
//    end;
//
//    vObjVenda := TVenda(TVendaController.getInstancia.
//    BuscaVenda(StrToIntDef(edtNumVenda.Text, 0)));
//
//    if (vObjVenda <> nil) then
//       CarregaDadosTela
//    else
//    begin
//      TMessageUtil.Alerta('Nenhum Produto encontrado');
//      LimpaTela;
//
//      if (edtNumVenda.CanFocus) then
//          edtNumVenda.SetFocus;
//
//      exit;
//    end;
//
//    DefineEstadoTela;
//    Result := True;
//
//   except
//    on E: Exception do
//    begin
//      raise Exception.Create('Falha ao consultar os dados do Produto [View].' + #13 + e.Message);
//
//    end;
//   end;
//end;

function TfrmVenda.ProcessaConsulta: Boolean;
begin

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



function TfrmVenda.ProcessaVenda: Boolean;
begin
   try
      Result := False;

     if (ValidaCampos) then
       begin
         TVendaController.getInstancia.GravaVenda(
         vObjVenda);
         Result := True;
       end;
     except
       on E : Exception do
       begin
          Raise  Exception.Create(
         'Falha ao gavar os dados da venda [View]: '#13 +
         e.Message);
       end;
     end;
   end;

function TfrmVenda.ValidaCampos: Boolean;
begin
   try
      Result := False;

//      if not ValidaVenda then
//         exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjVenda  = nil then
            vObjVenda := TVenda.Create
      end
      else if vEstadoTela = etAlterar then
      begin
         if vObjVenda = nil then
            exit;
      end;

      if vObjVenda = nil then
         exit;

//      vObjVenda.ID          := StrToInt(edtNumVenda.Text);
      vObjVenda.ID_Cliente     := StrToInt(edtCodigo.Text);
      vObjVenda.TotalAcrescimo := edtDesconto.Value;
      vObjVenda.TotalVenda     := edtTotal.Value;
      vObjVenda.TotalDesconto := edtDesconto.Value;
      vObjVenda.DataVenda      := StrToDate(edtData.Text);


      Result := True
   except
       on E : Exception do
       begin

          Raise Exception.Create(
          'Falha ao processar os dados da Venda [View]: ' + #13 + e.Message);
       end
   end;
end;


procedure TfrmVenda.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmVenda.edtCodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  xCodigo  : Integer;
  NomeCliente : string;
  xCliente : TPessoa;
begin
   if Key = VK_RETURN then
   begin
      if TryStrToInt(edtCodigo.Text, xCodigo) then
      begin
            xCliente := TPessoa.Create;
            try
            xCliente := TPessoaController.getInstancia
                     .BuscaPessoa(StrToInt(edtCodigo.Text));

             if xCliente.Nome <> '' then
             begin
                edtNome.Text := xCliente.Nome;
                edtNome.Enabled := False;
             end
             else
               TMessageUtil.Informacao('Cliente não encontrado!');
             finally
                frmClientes.Free;
             end;
             dbgProduto.SelectedIndex := 0;
             dbgProduto.SetFocus;
      end;
      if (edtCodigo.Text = EmptyStr) then
      begin
         if frmClientesPesq  = nil then
         begin
            frmClientesPesq  := TfrmClientesPesq.Create(Application);
         end;
            frmClientesPesq.Show;
      end;
   end;
end;


procedure TfrmVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action   := caFree;
   frmVenda := nil;
end;

procedure TfrmVenda.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if (TMessageUtil.Pergunta('Deseja realmente abortar essa operação?')) then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;


procedure TfrmVenda.dbgProdutoKeyPress(Sender: TObject; var Key: Char);
var
   xProdutoID  : Integer;
   xProduto    : TProduto;
begin

  if (Key = #13) then
  begin
    xProdutoID := dbgProduto.DataSource.DataSet.FieldByName('Código').AsInteger;

    xProduto := TProdutoController.getInstancia.BuscaProduto(xProdutoID);

    if (xProduto = nil) then
        cdsProdutoCodigo.ReadOnly := False;

    if xProduto <> nil then
    begin
      dbgProduto.DataSource.DataSet.Edit;
      dbgProduto.DataSource.DataSet.FieldByName('Descrição').AsString := xProduto.Descricao;
      dbgProduto.DataSource.DataSet.FieldByName('Preço Uni.').AsFloat := xProduto.PrecoVenda;
      dbgProduto.DataSource.DataSet.FieldByName('Unidade de Saída').AsString := xProduto.UnidadeSaida;
      dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat := xProduto.QuantidadeEstoque;
      dbgProduto.DataSource.DataSet.FieldByName('Preço Total').AsFloat := xProduto.PrecoVenda;
      dbgProduto.DataSource.DataSet.Post;
      cdsProdutoCodigo.ReadOnly := True;

    end
  end;

end;

procedure TfrmVenda.FormCreate(Sender: TObject);
begin
   cmbPagamento.Items.Add('Pix');
   cmbPagamento.Items.Add('Cartão de Débito');
   cmbPagamento.Items.Add('Cartão de Crédito');
end;

procedure TfrmVenda.AtualizarValorTotal;
var
  xPrecoTotal  : Double;
  xDesconto    : Double;
  xValorTotal  : Double;
begin
   if dbgProduto.DataSource.DataSet.FieldByName('Preço Total').AsFloat <> 0 then
      xPrecoTotal := dbgProduto.DataSource.DataSet.FieldByName('Preço Total').AsFloat
   else
      xPrecoTotal := 0;

   xDesconto := xPrecoTotal * (edtDesconto.Value / 100);
   xValorTotal := xDesconto;

   edtValorComDesconto.Text := FormatFloat('#,##0.00', xValorTotal);
end;



procedure TfrmVenda.edtDescontoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
   begin
      AtualizarValorTotal;
      Key := 0;
   end;
end;

procedure TfrmVenda.dbgProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
  begin
    if dbgProduto.DataSource.DataSet.RecNo = dbgProduto.DataSource.DataSet.RecordCount then
    begin
      dbgProduto.DataSource.DataSet.Append;
    end;

    Key := 0;
  end;
end;

procedure TfrmVenda.cdsProdutoAfterPost(DataSet: TDataSet);
begin
   CalculaTotalVenda;

end;

procedure TfrmVenda.cdsProdutoAfterDelete(DataSet: TDataSet);
begin
   CalculaTotalVenda;
end;

procedure TfrmVenda.CalculaTotalVenda;
var
   xTotalVenda, xPrecoTotal, xDesconto: Double;
begin
    dbgProduto.DataSource.DataSet.DisableControls; // Desabilita o controle visual para evitar piscadas
  try
    dbgProduto.DataSource.DataSet.First;
    while not dbgProduto.DataSource.DataSet.Eof do
    begin
      xPrecoTotal := dbgProduto.DataSource.DataSet.FieldByName('Preço Total').AsFloat;
      xTotalVenda := xTotalVenda + xPrecoTotal;
      dbgProduto.DataSource.DataSet.Next;
    end;
  finally
    dbgProduto.DataSource.DataSet.EnableControls;
  end;


  xDesconto := xTotalVenda * (edtDesconto.Value / 100);


  xTotalVenda := xTotalVenda - xDesconto;


  edtTotal.Text := FormatFloat('#,##0.00', xTotalVenda);
end;

procedure TfrmVenda.edtDescontoChange(Sender: TObject);
begin
   CalculaTotalVenda;
end;

procedure TfrmVenda.FormKeyDown(Sender: TObject; var Key: Word;
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
         if (vEstadoTela <> etPadrao) then
         begin
         if (TMessageUtil.Pergunta(
         'Deseja realmente abortar essa operação?')) then
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            end;
         end
         else
         begin
           if (TMessageUtil.Pergunta(
           'Deseja sair da rotina? ')) then
              Close;
              end;
         end;
      end;
end;

end.
