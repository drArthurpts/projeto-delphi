unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, UClassFuncoes, ExtCtrls, StdCtrls, Buttons, NumEdit,
  UEnumerationUtil, UVendaController, DB, DBClient, Grids, DBGrids, Mask, UVenda,
  UPessoaController, UClientesView, UPessoa, UVendaItem, UClientePesqView,
  UProdutoPesqView, UProduto, UProdutoController, UProdutoView, UConexao,
  UVendaItemController;

type
  TfrmVenda = class(TForm)
    pnlBotoes: TPanel;
    StbBarraStatus: TStatusBar;
    pnlValores: TPanel;
    grbPedido: TGroupBox;
    grbProdutos: TGroupBox;
    dbgProduto: TDBGrid;
    dtsProdutoVenda: TDataSource;
    cdsProdutos: TClientDataSet;
    cdsProdutosCodigo: TIntegerField;
    cdsProdutosDesc: TStringField;
    cdsProdutosPreoUni: TFloatField;
    cdsProdutosQuant: TIntegerField;
    cdsProdutosPreoTotal: TFloatField;
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
    cdsProdutosUnidadedeSada: TStringField;
    edtValorComDesconto: TNumEdit;
    Label2: TLabel;
    btnSpeed: TSpeedButton;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtDescontoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cdsProdutosAfterPost(DataSet: TDataSet);
    procedure cdsProdutosAfterDelete(DataSet: TDataSet);
    procedure edtDescontoChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cdsProdutosQuantChange(Sender: TField);
    procedure edtCodigoChange(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure dbgProdutoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure dbgProdutoExit(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cmbPagamentoKeyPress(Sender: TObject; var Key: Char);
    procedure cdsProdutosAfterOpen(DataSet: TDataSet);
    procedure edtNumVendaChange(Sender: TObject);
    procedure edtNumVendaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure cdsProdutosQuantValidate(Sender: TField);
    procedure edtDescontoExit(Sender: TObject);
    procedure edtValorComDescontoExit(Sender: TObject);
    procedure edtNumVendaExit(Sender: TObject);
    procedure cdsProdutosCodigoSetText(Sender: TField; const Text: String);
    procedure dbgProdutoColEnter(Sender: TObject);
    procedure btnSpeedClick(Sender: TObject);

  private
    { Private declarations }
    vKey: Word;
    vGridEditavel: Boolean;
    vEstadoTela: TEstadoTela;
    vObjVenda: TVenda;
    vObjColVenda: TColVenda;
    vObjPessoa: TPessoa;
    vObjVendaItem: TVendaItem;
    vObjColVendaItem: TColVendaItem;

    procedure CamposEnabled(pOpcao: Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    procedure CarregaDadosProduto;
    procedure AtualizarValorTotal;
    procedure CalculaTotalVenda;
    procedure ProcessaProduto;
    function ProcessaConfirmacao: Boolean;
    function ProcessaInclusao: Boolean;
    function PesquisaProduto(pIDproduto: Integer): Boolean;
    function ProcessaConsulta: Boolean;
    function ProcessaVenda: Boolean;
    function ProcessaVendaItem: Boolean;
    function ValidaCampos: Boolean;
    function ValidaCamposItem: Boolean;
    function CarregaCliente: Boolean;
    function ClienteValido: Boolean;

  public
    { Public declarations }
  end;

var
  frmVenda: TfrmVenda;
  frmProduto: TfrmProduto;
  vObjVenda: TVenda;
  vCriouRegistro: Boolean;

implementation

uses
  uMessageUtil, Types, UVendaDAO, UVendaPesqView;
{$R *.dfm}

procedure TfrmVenda.btnConfirmarClick(Sender: TObject);
begin
  ProcessaConfirmacao;
end;

procedure TfrmVenda.CamposEnabled(pOpcao: Boolean);
var
  i: Integer;
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
  btnIncluir.Enabled := (vEstadoTela in [etPadrao]);

  btnConfirmar.Enabled := vEstadoTela in [etIncluir, etConsultar];
  btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
  btnCancelar.Enabled := vEstadoTela in [etIncluir, etConsultar];
  btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

  case vEstadoTela of
    etPadrao:
      begin
        dbgProduto.Options := dbgProduto.Options - [dgEditing];
        CamposEnabled(False);
        cmbPagamento.Enabled := False;
        edtDesconto.Enabled := False;
        edtValorComDesconto.Enabled := False;
        LimpaTela;
        stbBarraStatus.Panels[0].Text := EmptyStr;
        stbBarraStatus.Panels[1].Text := EmptyStr;
        if (frmVenda <> nil) and (frmVenda.Active) and (frmVenda.CanFocus) then
          btnIncluir.SetFocus;
        cmbPagamento.Items.Clear;
        cmbPagamento.Items.Add('Cart�o de cr�dito');
        cmbPagamento.Items.Add('Cart�o de D�bito');
        cmbPagamento.Items.Add('Dinheiro');
        cmbPagamento.Items.Add('Pix');
      end;

    etIncluir:
      begin
        stbBarraStatus.Panels[0].Text := 'Inclus�o';

        CamposEnabled(True);
        edtNumVenda.Enabled := False;
        dbgProduto.Options := dbgProduto.Options + [dgEditing];
        if edtCodigo.CanFocus then
          edtCodigo.SetFocus;
        edtData.Clear;
        edtData.Text := FormatDateTime('dd/mm/yyyy', Now);
        edtData.Enabled := False;
        edtNome.Enabled := False;
        edtDesconto.Enabled := True;
        edtValorComDesconto.Enabled := True;
        edtTotal.Enabled := True;
      end;

    etConsultar:
      begin
        stbBarraStatus.Panels[0].Text := 'Consulta';

        CamposEnabled(False);
        btnLimpar.Enabled := True;

        if (edtNumVenda.Text <> EmptyStr) then
        begin
          edtNumVenda.Enabled := False;
          btnConfirmar.Enabled := False;

          if (btnConfirmar.CanFocus) then
            btnConfirmar.SetFocus;
        end
        else
        begin
          lblNumVenda.Enabled := True;
          edtNumVenda.Enabled := True;

          if edtNumVenda.CanFocus then
            edtNumVenda.SetFocus;
        end;
      end;
    etPesquisar:
      begin
        stbBarraStatus.Panels[0].Text := 'Pesquisar';
        if (frmVendaPesqView = nil) then
          frmVendaPesqView := TTfrmVendaPesqView.Create(Application);
        try
          frmVendaPesqView.ShowModal;
          if (frmVendaPesqView.mVendaID <> 0) then
          begin
            edtNumVenda.Text := IntToStr(frmVendaPesqView.mVendaID);
            vEstadoTela := etConsultar;
            ProcessaConsulta;
          end
          else
          begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            LimpaTela;
          end;
        finally
          FreeAndNil(frmVendaPesqView);
        end;
      end;
  end;
end;

procedure TfrmVenda.LimpaTela;
var
  i: Integer;
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
    if (Components[i] is TNumEdit) then
      (Components[i] as TNumEdit).Text := EmptyStr;

    cdsProdutos.EmptyDataSet;
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
      TMessageUtil.Alerta('N�mero da venda n�o pode ficar em branco.');

      if (edtNumVenda.CanFocus) then
        edtNumVenda.SetFocus;

      exit;
    end;

    vObjVenda := TVendaController.getInstancia.BuscaVenda(StrToIntDef(edtNumVenda.Text, 0));

    vObjColVendaItem := TVendaItemController.getInstancia.BuscaVenda(StrToIntDef(edtNumVenda.Text, 0));

    if (vObjVenda <> nil) then
    begin
      CarregaDadosTela;
      CarregaCliente;
    end
    else
    begin
      TMessageUtil.Alerta('Nenhum dado de venda encontrado.');

      edtNumVenda.Clear;

      if (edtNumVenda.CanFocus) then
        edtNumVenda.SetFocus;
      exit;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha na consulta da venda [View]: '#13 + e.Message);
    end;
  end;
end;

function TfrmVenda.ProcessaInclusao: Boolean;
var
  vClienteID: Integer;
  vPessoa: TPessoa;
begin
  Result := False;
  try
    try

      vClienteID := StrToIntDef(edtCodigo.Text, 0);

      if vClienteID = 0 then
      begin
        TMessageUtil.Alerta('Informe o c�digo do cliente antes de salvar a venda.');
        Exit;
      end;

      vPessoa := TPessoaController.Create.BuscaPessoa(vClienteID);
      if vPessoa = nil then
      begin
        TMessageUtil.Alerta('O cliente informado n�o existe. Verifique o c�digo do cliente.');
        edtCodigo.Clear;
        edtNome.Clear;
        if edtCodigo.CanFocus then
           edtCodigo.SetFocus;
        Exit;
      end;

      if (ProcessaVenda) and (ProcessaVendaItem) then
      begin
        TMessageUtil.Informacao('Venda cadastrada com sucesso!'#13 + 'C�digo cadastrado: ' + IntToStr(vObjVenda.ID));

        vEstadoTela := etPadrao;
        DefineEstadoTela;

        Result := True;
      end;

    except
      on E: Exception do
      begin
        raise Exception.Create('Falha ao incluir os dados da venda [View]: '#13 + e.Message);
      end;
    end;
  finally
    if vObjVenda <> nil then
      FreeAndNil(vObjVenda);
  end;
end;


function TfrmVenda.ProcessaVenda: Boolean;
begin
  try
    Result := False;

    if not ValidaCampos then
      exit;

    if vEstadoTela = etIncluir then
    begin
      if vObjVenda = nil then
        vObjVenda := TVenda.Create;
    end;

    if (vObjVenda = nil) then
      exit;

    vObjVenda.ID_Cliente := StrToInt(edtCodigo.Text);
    vObjVenda.TotalDesconto := edtDesconto.Value;
    vObjVenda.DataVenda := Now;
    vObjVenda.TotalVenda := edtTotal.Value;
    vObjVenda.FormaPagamento := cmbPagamento.Text;
    vObjVenda.ValorSemDesconto := edtValorComDesconto.Value;
    TVendaController.getInstancia.GravaVenda(vObjVenda);

    Result := True;

  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao processar os dados da venda[View]'#13 + e.Message);
    end;
  end;
end;

function TfrmVenda.ValidaCampos: Boolean;
begin
  Result := False;

  if (edtCodigo.Text = EmptyStr) then
  begin
    TMessageUtil.Alerta('O c�digo do cliente n�o pode ficar em branco.  ');

    if (edtCodigo.CanFocus) then
      edtCodigo.SetFocus;
    exit;
  end;

  if (edtNome.Text = EmptyStr) then
  begin
    TMessageUtil.Alerta('O nome do cliente n�o pode ficar em branco.  ');

    if (edtNome.CanFocus) then
      edtNome.SetFocus;
    exit;
  end;

  if (cmbPagamento.Text = EmptyStr) then
  begin
    TMessageUtil.Alerta('A forma de pagamento da venda n�o pode ficar em branco.  ');

    if (cmbPagamento.CanFocus) then
      cmbPagamento.SetFocus;
    exit;
  end;

  if (dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsInteger = 0) then
  begin
    TMessageUtil.Alerta('O c�digo do produto a ser vendido n�o pode ficar em branco.  ');

    dbgProduto.SetFocus;
    dbgProduto.SelectedIndex := 0;
    exit;
  end;

  Result := True;
end;

procedure TfrmVenda.btnIncluirClick(Sender: TObject);
begin
  vEstadoTela := etIncluir;
  DefineEstadoTela;
end;

procedure TfrmVenda.edtCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if Trim(edtCodigo.Text) = '' then
    begin
      Screen.Cursor := crHourGlass;
      try
        if frmClientesPesq = nil then
          frmClientesPesq := TfrmClientesPesq.Create(Application);

        frmClientesPesq.ShowModal;

        if (frmClientesPesq.mClienteID <> 0) then
        begin
          edtCodigo.Text := IntToStr(frmClientesPesq.mClienteID);
          CarregaCliente;
          edtNome.Enabled := False;
          if dbgProduto.CanFocus then
          begin
            dbgProduto.SetFocus;
            dbgProduto.SelectedIndex := 0;
          end;
        end
        else
        begin
//              TMessageUtil.Alerta('Nenhum cliente encontrado para o c�digo informado.');
//              edtNome.Clear;
//              edtCodigo.Clear;
//              if edtCodigo.CanFocus then
//                 edtCodigo.SetFocus;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end
    else
    begin
      CarregaCliente;
      if ClienteValido then
      begin
        edtNome.Enabled := False;
        if dbgProduto.CanFocus then
        begin
          dbgProduto.SetFocus;
          dbgProduto.SelectedIndex := 0;
        end;
      end
      else
      begin
        TMessageUtil.Alerta('Nenhum cliente encontrado para o c�digo informado.');
        edtNome.Clear;
        edtCodigo.Clear;
        if edtCodigo.CanFocus then
          edtCodigo.SetFocus;
      end;
    end;
  end;

  Key := VK_CLEAR;
end;

procedure TfrmVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmVenda := nil;
end;

procedure TfrmVenda.btnSairClick(Sender: TObject);
begin
  if (vEstadoTela <> etPadrao) then
  begin
    if (TMessageUtil.Pergunta('Deseja realmente abortar essa opera��o?')) then
    begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
    end;
  end
  else
    Close;
end;

procedure TfrmVenda.FormCreate(Sender: TObject);
begin
  vEstadoTela := etPadrao;
end;

procedure TfrmVenda.AtualizarValorTotal;
var
  i: Integer;
  xPrecoTotal: Double;
  xDesconto: Double;
  xValorItem: Double;
  xQuantidade: Integer;
  xValorTotal: Double;
begin
  xValorTotal := 0;
  vCriouRegistro := false;

  for i := 0 to dbgProduto.DataSource.DataSet.RecordCount - 1 do
  begin
    dbgProduto.DataSource.DataSet.RecNo := i + 1;
    xValorItem := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat;
    xQuantidade := dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsInteger;
    xValorTotal := xValorTotal + (xValorItem * xQuantidade);
    edtValorComDesconto.Text := FormatFloat('0.00', xValorTotal);
  end;

  if TryStrToFloat(edtDesconto.Text, xValorItem) then
    xValorTotal := xValorTotal - (xValorTotal * (xValorItem / 100));
  xDesconto := (edtDesconto.Value / 100) * xValorItem;
  edtTotal.Text := FormatFloat('0.00', xValorTotal);
end;

procedure TfrmVenda.edtDescontoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    AtualizarValorTotal;
    Key := 0;
  end;
end;

procedure TfrmVenda.dbgProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  vKey := Key;
  if vKey = VK_DELETE then
  begin
    if (TMessageUtil.Pergunta('Deseja mesmo excluir este produto?')) then
    begin
      if not (dbgProduto.DataSource.DataSet.IsEmpty) then
        dbgProduto.DataSource.DataSet.Delete;
    end;
    vKey := VK_CLEAR;
  end;
end;

procedure TfrmVenda.cdsProdutosAfterPost(DataSet: TDataSet);
begin
  CalculaTotalVenda;
end;

procedure TfrmVenda.cdsProdutosAfterDelete(DataSet: TDataSet);
begin
  CalculaTotalVenda;
end;

procedure TfrmVenda.CalculaTotalVenda;
var
  xTotalVenda, xPrecoTotal, xDesconto: Double;
begin
  dbgProduto.DataSource.DataSet.DisableControls;
  try
    dbgProduto.DataSource.DataSet.First;
    while not dbgProduto.DataSource.DataSet.Eof do
    begin
      xPrecoTotal := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat;
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
  if edtDesconto.Value > 100 then
    edtDesconto.Value := 100;
end;

procedure TfrmVenda.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
          if (TMessageUtil.Pergunta('Deseja realmente abortar essa opera��o?')) then
          begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
          end;
        end
        else
        begin
          if (TMessageUtil.Pergunta('Deseja sair da rotina? ')) then
            Close;
        end;
      end;
  end;
end;

function TfrmVenda.ProcessaVendaItem: Boolean;
var
  xVendaItem: TVendaItem;
begin
  try
    try
      Result := False;
      xVendaItem := nil;
      vObjColVendaItem := nil;

      if not ValidaCampos then
        exit;

      if vEstadoTela = etIncluir then
      begin
        if (xVendaItem = nil) then
          xVendaItem := TVendaItem.Create;

        if vObjColVendaItem = nil then
          vObjColVendaItem := TColVendaItem.Create;
      end;

      if (xVendaItem = nil) then
        exit;

      cdsProdutos.First;
      while not cdsProdutos.Eof do
      begin
        xVendaItem := TVendaItem.Create;

        xVendaItem.ID_Venda := vObjVenda.ID;
        xVendaItem.ID_Produto := dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsInteger;
        xVendaItem.Quantidade := dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsInteger;
        xVendaItem.UnidadeSaida := dbgProduto.DataSource.DataSet.FieldByName('Unidade de Sa�da').AsString;
        xVendaItem.Descricao_Produto := dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString;
        xVendaItem.ValorDesconto := edtValorComDesconto.Value;
        xVendaItem.ValorUnitario := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat;
        xVendaItem.TotalItem := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat;

        vObjColVendaItem.Adiciona(xVendaItem);
        cdsProdutos.Next;
      end;
      TVendaItemController.getInstancia.GravaVenda(vObjColVendaItem);

      Result := True;
    finally
      if (xVendaItem <> nil) then
        FreeAndNil(xVendaItem);

      if (vObjColVendaItem <> nil) then
        FreeAndNil(vObjColVendaItem);
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao processar os dados do produto vendido. [View]'#13 + e.Message);
    end;
  end;
end;

function TfrmVenda.ValidaCamposItem: Boolean;
begin
  try
    Result := False;

    if vEstadoTela = etIncluir then
    begin
      if vObjVendaItem = nil then
        vObjVendaItem := TVendaItem.Create
    end
    else if vEstadoTela = etAlterar then
    begin
      if vObjVendaItem = nil then
        exit;
    end;

    if vObjVendaItem = nil then
      exit;

    vObjVendaItem.ID_Produto := StrToInt(cdsProdutosCodigo.Text);
    vObjVendaItem.Quantidade := cdsProdutosQuant.Value;
    vObjVendaItem.UnidadeSaida := cdsProdutosUnidadedeSada.Text;
    vObjVendaItem.ValorDesconto := edtDesconto.Value;
    vObjVendaItem.ValorUnitario := cdsProdutosPreoUni.Value;
    vObjVendaItem.TotalItem := cdsProdutosPreoTotal.Value;
    Result := True
  except
    on E: Exception do
    begin

      raise Exception.Create('Falha ao processar os dados do Item Venda [View]: ' + #13 + e.Message);
    end
  end;
end;

procedure TfrmVenda.cdsProdutosQuantChange(Sender: TField);
var
  xPrecoUnitario, xPrecoTotal: Double;
  xQuantidade: Integer;
  DataSet: TDataSet;
begin
  if dbgProduto.SelectedField.FieldName = 'Quant.' then
  begin
    xQuantidade := dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsInteger;
    xPrecoUnitario := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat;
    xPrecoTotal := xQuantidade * xPrecoUnitario;
    dbgProduto.DataSource.DataSet.Edit;
    dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := xPrecoTotal;
  end;
end;

procedure TfrmVenda.edtCodigoChange(Sender: TObject);
var
  xCodigoReplace: string;
begin
  xCodigoReplace := TFuncoes.SoNumero(edtCodigo.Text);
  edtCodigo.Text := xCodigoReplace;
end;

procedure TfrmVenda.btnConsultarClick(Sender: TObject);
begin
  vEstadoTela := etConsultar;
  DefineEstadoTela;
end;

procedure TfrmVenda.CarregaDadosTela;
var
  xAux: Integer;
begin
  if (vObjVenda = nil) and (frmClientesPesq.mClienteID <> 0) then
    CarregaCliente
  else
  begin
    edtNumVenda.Text := IntToStr(vObjVenda.ID);
    edtCodigo.Text := IntToStr(vObjVenda.ID_Cliente);
    edtData.Text := DateToStr(vObjVenda.DataVenda);
    edtDesconto.Value := vObjVenda.TotalDesconto;
    edtTotal.Value := vObjVenda.TotalVenda;
    cmbPagamento.Text := vObjVenda.FormaPagamento;
    edtValorComDesconto.Value := vObjVenda.ValorSemDesconto;
    cmbPagamento.ItemIndex := cmbPagamento.Items.IndexOf(vObjVenda.FormaPagamento);
    edtTotal.Enabled := False;
    edtValorComDesconto.Enabled := False;
    edtDesconto.Enabled := False;
    btnCancelar.Enabled := True;
  end;

  if (vObjColVendaItem = nil) then
    exit
  else
  begin
    for xAux := 0 to pred(vObjColVendaItem.Count) do
    begin
      cdsProdutos.Append;
      cdsProdutosCodigo.Value := vObjColVendaItem.Retorna(xAux).ID_Produto;
      cdsProdutosDesc.Value := vObjColVendaItem.Retorna(xAux).Descricao_Produto;
      cdsProdutosPreoUni.Value := vObjColVendaItem.Retorna(xAux).ValorUnitario;
      cdsProdutosUnidadedeSada.Value := vObjColVendaItem.Retorna(xAux).UnidadeSaida;
      cdsProdutosQuant.Value := vObjColVendaItem.Retorna(xAux).Quantidade;
      cdsProdutosPreoTotal.Value := vObjColVendaItem.Retorna(xAux).TotalItem;
      cdsProdutos.Post;
      dbgProduto.Options := dbgProduto.Options - [dgEditing];
    end;
  end;
end;

function TfrmVenda.CarregaCliente: Boolean;
var
  xPessoa: TPessoa;
begin
  try
    Result := False;
    xPessoa := TPessoa.Create;

    xPessoa := TPessoa(TPessoaController.getInstancia.BuscaPessoa(StrToIntDef(edtCodigo.Text, 0)));

    if (xPessoa <> nil) then
      edtNome.Text := xPessoa.Nome
    else
    begin
      edtNome.Clear;
      edtCodigo.Clear;
      if (edtCodigo.CanFocus) then
        edtCodigo.SetFocus;
      exit;
    end;
    DefineEstadoTela;
  finally
    if (xPessoa <> nil) then
      FreeAndNil(xPessoa);
  end;
end;

procedure TfrmVenda.FormShow(Sender: TObject);
begin
  DefineEstadoTela;
  cmbPagamento.Items.Clear;
  cmbPagamento.Items.Add('Cart�o de cr�dito');
  cmbPagamento.Items.Add('Cart�o de D�bito');
  cmbPagamento.Items.Add('Dinheiro');
  cmbPagamento.Items.Add('Pix');
  cdsProdutos.Open;
end;

procedure TfrmVenda.btnCancelarClick(Sender: TObject);
begin
  vEstadoTela := etPadrao;
  DefineEstadoTela;
end;

procedure TfrmVenda.dbgProdutoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Key := 0;
end;

procedure TfrmVenda.btnPesquisarClick(Sender: TObject);
begin
  vEstadoTela := etPesquisar;
  DefineEstadoTela;
end;

procedure TfrmVenda.dbgProdutoExit(Sender: TObject);
begin
  cdsProdutos.Last;
  if (cdsProdutosDesc.Value = EmptyStr) and (cdsProdutos.RecordCount <> 0) then
    dbgProduto.DataSource.DataSet.Delete;
    AtualizarValorTotal;
end;

procedure TfrmVenda.btnLimparClick(Sender: TObject);
begin
  LimpaTela;
  vEstadoTela := etPadrao;
  DefineestadoTela;
end;

procedure TfrmVenda.cmbPagamentoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TfrmVenda.cdsProdutosAfterOpen(DataSet: TDataSet);
begin
  (dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.') as TFloatField).DisplayFormat := 'R$ ##,##0.00';
  (dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total') as TFloatField).DisplayFormat := 'R$ ##,##0.00';
end;

procedure TfrmVenda.edtNumVendaChange(Sender: TObject);
begin
  edtNumVenda.Text := TFuncoes.removeCaracterEspecial(edtNumVenda.Text, true);
  edtNumVenda.Text := TFuncoes.SoNumero(edtNumVenda.Text);
end;

procedure TfrmVenda.edtNumVendaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ProcessaConsulta;
  end;
  Key := VK_CLEAR;
end;

procedure TfrmVenda.dbgProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if (vKey = VK_RETURN) then
  begin
    if (dbgProduto.SelectedIndex = 0) then
    begin
      ProcessaProduto;
      if dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString = '' then
      begin
        dbgProduto.DataSource.DataSet.Edit;
        dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsString := '';
        exit
      end;
      dbgProduto.SelectedIndex := 4;

      exit;
    end;

    if (dbgProduto.SelectedIndex = 4) then
    begin
      dbgProduto.DataSource.DataSet.Edit;
      dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat * dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat;
      dbgProduto.DataSource.DataSet.Post;
    end;

    if (dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString <> EmptyStr) and (dbgProduto.SelectedIndex = 4) then
    begin
      dbgProduto.DataSource.DataSet.Append;
      dbgProduto.SelectedIndex := 0;
    end;
  end;

  vKey := VK_CLEAR;
end;

procedure TfrmVenda.ProcessaProduto;
var
  xIDProduto: Integer;
  xProduto: TProduto;
begin
  try
    try
      xIDProduto := 0;
      xProduto := nil;
      xProduto := TProduto.Create;

      xIDProduto := dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsInteger;

      if xIDProduto = 0 then
      begin
        PesquisaProduto(xIDProduto);
        exit;
      end;

      xProduto := TProdutoController.getInstancia.BuscaProduto(xIDProduto);

      if xProduto = nil then
      begin
        TMessageUtil.Alerta('Nenhum Produto encontrado.');
        exit;
      end;

      dbgProduto.DataSource.DataSet.First;

      while not dbgProduto.DataSource.DataSet.Eof do
      begin
        if (dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsInteger = xIDProduto) and (dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString <> EmptyStr) then
        begin
          dbgProduto.DataSource.DataSet.Edit;
          dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat + 1;
          dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat * dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat;
          dbgProduto.DataSource.DataSet.Post;
          exit;
        end;
        dbgProduto.DataSource.DataSet.Next;
      end;
      if (xProduto <> nil) then
      begin
        dbgProduto.DataSource.DataSet.Edit;
        dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString := xProduto.Descricao;
        dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat := xProduto.PrecoVenda;
        dbgProduto.DataSource.DataSet.FieldByName('Unidade de Sa�da').AsString := xProduto.UnidadeSaida;
        dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat := 1;
        dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat * dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat;
        dbgProduto.DataSource.DataSet.Post;
        exit;
      end;

    finally
      if (xProduto <> nil) then
        FreeAndNil(xProduto);
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao processar dados da venda do item. [View]' + #13 + e.Message);
    end;
  end;
end;

function TfrmVenda.PesquisaProduto(pIDproduto: Integer): Boolean;
begin
  if (vKey = VK_RETURN) then
  begin
    if (dbgProduto.SelectedIndex = 0) then
    begin
      dbgProduto.DataSource.DataSet.Edit;
      dbgProduto.DataSource.DataSet.FieldByName('C�digo').Clear;
      dbgProduto.DataSource.DataSet.FieldByName('Descri��o').Clear;
      dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').Clear;
      dbgProduto.DataSource.DataSet.FieldByName('Quant.').Clear;
      dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').Clear;
      dbgProduto.DataSource.DataSet.Post;
      Screen.Cursor := crHourGlass;

      if (frmProdutoPesqView = nil) then
        frmProdutoPesqView := TfrmProdutoPesqView.Create(Application);

      frmProdutoPesqView.ShowModal;

      if (frmProdutoPesqView.mProdutoID <> 0) then
        CarregaDadosProduto;

      Screen.Cursor := crDefault;
      exit;
    end;

    if (dbgProduto.SelectedIndex = 4) then
    begin
      dbgProduto.DataSource.DataSet.Edit;
      dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat * dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat;
      dbgProduto.DataSource.DataSet.Post;
    end;

    if (dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString <> EmptyStr) and (dbgProduto.SelectedIndex = 4) then
    begin
      dbgProduto.DataSource.DataSet.Append;
      dbgProduto.SelectedIndex := 0;
    end;
  end;
  vKey := VK_CLEAR;
end;

procedure TfrmVenda.CarregaDadosProduto;
var
  xProduto: TProduto;
  xIDProduto: Integer;
begin
  try
    xProduto := nil;
    xProduto := TProduto.Create;

    xIDProduto := frmProdutoPesqView.mProdutoID;

    xProduto := TProdutoController.getInstancia.BuscaProduto(xIDProduto);

    if xProduto = nil then
    begin
      TMessageUtil.Alerta('Nenhum produto encontrado. ');
      exit;
    end;

    dbgProduto.DataSource.DataSet.First;
    while not dbgProduto.DataSource.DataSet.Eof do
    begin
      if (dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsInteger = xIDProduto) and (dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString <> EmptyStr) then
      begin
        dbgProduto.DataSource.DataSet.Edit;
        dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat + 1;
        dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat * dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat;
        dbgProduto.DataSource.DataSet.Post;

        if (dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString <> EmptyStr) and (dbgProduto.SelectedIndex = 4) then
        begin
          dbgProduto.DataSource.DataSet.Append;
          dbgProduto.SelectedIndex := 0;
        end;
        exit;
      end;
      dbgProduto.DataSource.DataSet.Next;
    end;

    if (dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString <> EmptyStr) and (dbgProduto.SelectedIndex = 0) then
    begin
      dbgProduto.DataSource.DataSet.Append;
    end;

    if (xProduto <> nil) then
    begin
      dbgProduto.DataSource.DataSet.Edit;
      dbgProduto.DataSource.DataSet.FieldByName('C�digo').AsInteger := xProduto.ID;
      dbgProduto.DataSource.DataSet.FieldByName('Descri��o').AsString := xProduto.Descricao;
      dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat := xProduto.PrecoVenda;
      dbgProduto.DataSource.DataSet.FieldByName('Unidade de Sa�da').AsString := xProduto.UnidadeSaida;
      dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat := 1;
      dbgProduto.DataSource.DataSet.FieldByName('Pre�o Total').AsFloat := dbgProduto.DataSource.DataSet.FieldByName('Pre�o Uni.').AsFloat * dbgProduto.DataSource.DataSet.FieldByName('Quant.').AsFloat;
      dbgProduto.DataSource.DataSet.Post;
      exit;
    end;
  finally
    if (xProduto <> nil) then
      FreeAndNil(xProduto);
  end;
end;

procedure TfrmVenda.cdsProdutosQuantValidate(Sender: TField);
begin
  if Sender.AsInteger > 10000 then
  begin
    TMessageUtil.Alerta('Quantidade m�xima permitida � 10.000!');
    Sender.Clear;
    Abort;
  end;
end;

function TfrmVenda.ClienteValido: Boolean;
begin
  Result := (Trim(edtNome.Text) <> '');
end;

procedure TfrmVenda.edtDescontoExit(Sender: TObject);
begin
    if edtDesconto.Value < 0 then
      edtDesconto.Value := 0;
end;

procedure TfrmVenda.edtValorComDescontoExit(Sender: TObject);
begin
    if edtValorComDesconto.Value < 0 then
       edtValorComDesconto.Value := 0;
end;

procedure TfrmVenda.edtNumVendaExit(Sender: TObject);
var
  xValor: Integer;
begin
  if TryStrToInt(edtNumVenda.Text, xValor) then
  begin
    if xValor > 10000 then
      edtNumVenda.Text := '';
  end
  else
  begin
    edtNumVenda.Text := '0';
  end;
end;

procedure TfrmVenda.cdsProdutosCodigoSetText(Sender: TField;
  const Text: String);
var
  Valor: Double;
begin
  if TryStrToFloat(Text, Valor) then
  begin
    if Valor > 10000 then
      Sender.AsFloat := 10000
    else
      Sender.AsFloat := Valor;
  end
  else
    Sender.Clear;
end;

procedure TfrmVenda.dbgProdutoColEnter(Sender: TObject);
begin
  if vEstadoTela = etConsultar then
  begin
    dbgProduto.Options := dbgProduto.Options - [dgEditing];
    Exit;
  end;

  if (dbgProduto.SelectedField.FieldName <> 'C�digo')
     and (dbgProduto.SelectedField.FieldName <> 'Quant.') then
  begin
    dbgProduto.Options := dbgProduto.Options - [dgEditing];
  end
  else
  begin
    dbgProduto.Options := dbgProduto.Options + [dgEditing];
  end;
end;


procedure TfrmVenda.btnSpeedClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmClientes  = nil then
            frmClientes := TfrmClientes.Create(Application);

         frmClientes.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end;


end.

