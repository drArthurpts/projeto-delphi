unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, UEnumerationUtil, NumEdit,
  UProduto, UProdutoController, UUnidadeProdController,Math, UUnidadeProduto,
  UUnidadeProdutoDAO,UConexao, DB, DBClient, UUnidadeProdView, UUnidadePesqView,
  UClassFuncoes;

type
  TfrmProduto = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    edtDescricaoProd: TEdit;
    lblUnidade: TLabel;
    edtDescricaoUnidade: TEdit;
    Label1: TLabel;
    lblQuantidade: TLabel;
    lblPreco: TLabel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    btnSpeed: TSpeedButton;
    edtPreco: TNumEdit;
    edtQuantidade: TNumEdit;
    lblDescProd: TLabel;
    cmbUnidade: TComboBox;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnConfirmarClick(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure cmbUnidadeChange(Sender: TObject);
    procedure btnSpeedClick(Sender: TObject);
    procedure cmbUnidadeEnter(Sender: TObject);
    procedure edtDescricaoProdKeyPress(Sender: TObject; var Key: Char);
    procedure cmbUnidadeKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCodigoChange(Sender: TObject);
    procedure edtDescricaoProdChange(Sender: TObject);
    procedure cmbUnidadeClick(Sender: TObject);
    procedure cmbUnidadeExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtPrecoExit(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);


  private
    { Private declarations }

    vKey: Word;
    vEstadoTela: TEstadoTela;
    vObjProduto: TProduto;
    vObjColProduto: TColProduto;
    procedure CamposEnabled(pOpcao: Boolean);
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    procedure CarregaUnidadeDesc;
    procedure LimpaTela;
    procedure CarregaDadoscmb;
    function  CarregaProduto : Boolean;
    function  ProcessaConfirmacao: Boolean;
    function  ProcessaInclusao: Boolean;
    function  ProcessaAlteracao: Boolean;
    function  ProcessaExclusao: Boolean;
    function  ProcessaConsulta: Boolean;
    function  ProcessaListagem: Boolean;
    function  ProcessaUnidadeProduto: Boolean;
    function  ProcessaProduto: Boolean;
    function  ValidaProduto  : Boolean;
  public
    { Public declarations }
  end;

var
  frmProduto      : TfrmProduto;
  vObjUnidadeProd : TUnidadeProduto;
  TUnidadesDAO    : TUnidadeProdutoDAO;
  Conexao         :  TConexao;


implementation

uses
  uMessageUtil, Types, UProdutoPesqView, UProdutoDAO;

{$R *.dfm}

procedure TfrmProduto.CamposEnabled(pOpcao: Boolean);
var
  i: Integer;
begin
  for i := 0 to pred(ComponentCount) do
  begin
    if (Components[i] is TEdit) then
      (Components[i] as TEdit).Enabled := pOpcao;
  end;

end;

procedure TfrmProduto.DefineEstadoTela;
begin
  btnIncluir.Enabled := (vEstadoTela in [etPadrao]);
  btnAlterar.Enabled := (vEstadoTela in [etPadrao]);
  btnExcluir.Enabled := (vEstadoTela in [etPadrao]);
  btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
  btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);
  btnConfirmar.Enabled := vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];
  btnCancelar.Enabled := vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

  case vEstadoTela of
    etPadrao:
      begin
        CamposEnabled(False);
        LimpaTela;

        stbBarraStatus.Panels[0].Text := EmptyStr;
        stbBarraStatus.Panels[1].Text := EmptyStr;
        cmbUnidade.Enabled := False;
        btnSpeed.Enabled := False;
        if (frmProduto <> nil) and (frmProduto.Active) and (frmProduto.CanFocus) then
          btnIncluir.SetFocus;
        Application.ProcessMessages;
      end;

    etIncluir:
      begin
        CamposEnabled(True);
        stbBarraStatus.Panels[0].Text := 'Inclusão';
        edtPreco.Enabled := True;
        edtQuantidade.Enabled := True;
        edtDescricaoUnidade.Enabled := False;
        edtCodigo.Enabled  := False;
        cmbUnidade.Enabled := True;
        btnSpeed.Enabled := True;
        if edtDescricaoProd.CanFocus then
          edtDescricaoProd.SetFocus;

//         if edtPreco.CanFocus then
//            edtPreco.SetFocus;
//
//         if edtQuantidade.CanFocus then
//            edtQuantidade.SetFocus;


      end;
    etConsultar:
      begin
        stbBarraStatus.Panels[0].Text := 'Consulta';
        edtCodigo.Enabled     := True;
        CamposEnabled(False);
        cmbUnidade.Enabled := False;
        edtDescricaoUnidade.Enabled := False;
        edtPreco.Enabled := False;
        btnSpeed.Enabled := False;
        edtQuantidade.Enabled := False;
        if (edtCodigo.Text <> EmptyStr) then
        begin
          btnAlterar.Enabled   := True;
          btnExcluir.Enabled   := True;
          btnConfirmar.Enabled := False;

          if (btnAlterar.CanFocus) then
            btnAlterar.SetFocus;
        end
        else
        begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled:= True;
            if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

        end;
      end;
      etAlterar:
      begin
        stbBarraStatus.Panels[0].Text := 'Alteração';
        if (edtCodigo.Text <> EmptyStr) then
        begin
          CamposEnabled(True);
          edtDescricaoUnidade.Enabled := False;
          edtQuantidade.Enabled := True;
          edtPreco.Enabled := True;
          edtCodigo.Enabled := False;
          btnAlterar.Enabled := False;
          btnConfirmar.Enabled := True;
          cmbUnidade.Enabled   := True;
          btnSpeed.Enabled := True;

        end
        else
        begin

          lblCodigo.Enabled := True;
          edtCodigo.Enabled := True;

          if (edtCodigo.CanFocus) then
              edtCodigo.SetFocus;
        end;
      end;
      etExcluir:
      begin
        stbBarraStatus.Panels[0].text := 'Exclusão';
        btnSpeed.Enabled := False;
        if (edtCodigo.Text <> EmptyStr) then
           ProcessaExclusao
        else
        begin
          lblCodigo.Enabled := True;
          edtCodigo.Enabled := True;

          if (edtCodigo.CanFocus) then
              edtCodigo.SetFocus;
        end;
      end;
    etListar:
      begin
        stbBarraStatus.Panels[0].Text := 'Listagem';

        if (edtCodigo.Text <> EmptyStr) then
          ProcessaListagem
        else
        begin
          lblDescProd.Enabled := True;
          edtCodigo.Enabled := True;

          if edtCodigo.CanFocus then
            edtCodigo.SetFocus;
        end;
      end;
       etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';
         if (frmProdutoPesqView = nil) then
         begin
            frmProdutoPesqView := TfrmProdutoPesqView.Create(Application);
         end;
        frmProdutoPesqView.ShowModal;

         if (frmProdutoPesqView.mProdutoID <> 0) then
         begin
            edtCodigo.Text := IntToStr(frmProdutoPesqView.mProdutoID);
            vEstadoTela    := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;
         edtCodigo.Enabled := False;
//         if edtCodigo.CanFocus then
//            edtCodigo.SetFocus;

      end;
      end;

  end;


procedure TfrmProduto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
          if (TMessageUtil.Pergunta('Deseja realmente abortar essa operação?')) then
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

procedure TfrmProduto.LimpaTela;
var
  i: Integer;
begin
  for i := 0 to pred(ComponentCount) do
  begin
    if (Components[i] is TEdit) then
      (Components[i] as TEdit).Text := EmptyStr;

    if (Components[i] is TNumEdit) then
      (Components[i] as TNumEdit).Value := 0;

      cmbUnidade.Clear;

  end;

end;

procedure TfrmProduto.btnIncluirClick(Sender: TObject);
begin
  vEstadoTela := etIncluir;
  DefineEstadoTela;
end;

procedure TfrmProduto.btnAlterarClick(Sender: TObject);
begin
  vEstadoTela := etAlterar;
  DefineEstadoTela;
end;

procedure TfrmProduto.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;

end;

procedure TfrmProduto.btnConsultarClick(Sender: TObject);
begin
  vEstadoTela := etConsultar;
  DefineEstadoTela;
end;

procedure TfrmProduto.btnListarClick(Sender: TObject);
begin
  vEstadoTela := etListar;
  DefineEstadoTela;
end;

procedure TfrmProduto.btnPesquisarClick(Sender: TObject);
begin
  vEstadoTela := etPesquisar;
  DefineEstadoTela;
end;

procedure TfrmProduto.btnSairClick(Sender: TObject);
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

procedure TfrmProduto.FormCreate(Sender: TObject);
begin
  vEstadoTela := etPadrao;

end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  DefineEstadoTela;
  CarregaDadoscmb;
end;

procedure TfrmProduto.btnCancelarClick(Sender: TObject);
begin
  vEstadoTela := etPadrao;
  DefineEstadoTela;
end;

procedure TfrmProduto.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  vKey := VK_CLEAR;
end;

procedure TfrmProduto.btnConfirmarClick(Sender: TObject);
begin
  ProcessaConfirmacao;
end;

function TfrmProduto.ProcessaConfirmacao: Boolean;
begin
  Result := False;
  try
    case vEstadoTela of
      etIncluir:
        Result := ProcessaInclusao;
      etAlterar:
        Result := ProcessaAlteracao;
      etExcluir:
        Result := ProcessaExclusao;
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

function TfrmProduto.ProcessaAlteracao: Boolean;
begin
  try
      Result := False;

      if edtCodigo.Enabled then
      begin
         ProcessaConsulta;
         exit;
      end;

      if ProcessaProduto then
      begin
         TMessageUtil.Informacao('Dados alterados com sucesso.');

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
            'Falha ao alterar os dados de Produto [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmProduto.ProcessaConsulta: Boolean;
begin
  try
    Result := False;

    if (edtCodigo.Text = EmptyStr) then
    begin
      TMessageUtil.Alerta('Código do produto não pode ficar em branco.');

      if (edtCodigo.CanFocus) then
          edtCodigo.SetFocus;

      Exit;
    end;

    vObjProduto := TProduto(TProdutoController.getInstancia.
    BuscaProduto(StrToIntDef(edtCodigo.Text, 0)));
    if (vObjProduto <> nil) then
    begin
       CarregaDadosTela;
       CarregaUnidadeDesc;
        if (edtDescricaoProd.CanFocus) then
            edtDescricaoProd.SetFocus;
    end
    else
    begin
      TMessageUtil.Alerta('Nenhum Produto encontrado.');
      LimpaTela;

      if (edtCodigo.CanFocus) then
          edtCodigo.SetFocus;
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

function TfrmProduto.ProcessaExclusao: Boolean;
begin
   try
      Result := False;

      if (vObjProduto = nil) then
      begin
         TMessageUtil.Alerta(
            'Não foi possível carregar todos os dados cadastrados do Produto.');
         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
          if TMessageUtil.Pergunta('Confirma a exclusão do produto?') then
          begin
             Screen.Cursor := crHourGlass;

             TProdutoController.getInstancia
             .ExcluiProduto(vObjProduto);

             TMessageUtil.Informacao('Produto excluído com sucesso.');
          end
          else
          begin
              LimpaTela;
              vEstadoTela := etPadrao;
              DefineEstadoTela;
              Exit;
          end;
      finally
         Screen.Cursor := crDefault;
         Application.ProcessMessages;
      end;

      Result := True;

      
      LimpaTela;
      vEstadoTela := etPadrao;
      DefineEstadoTela;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao excluir os dados do Produto [View]: ' + #13 +
         e.Message);
      end;
   end;
end;

function TfrmProduto.ProcessaInclusao: Boolean;
begin
   Result := False;
   try
      try
         if ProcessaUnidadeProduto then
         begin
            TMessageUtil.Informacao('Produto cadastrado com sucesso.'#13 +
               'Código cadastrado: ' + IntToStr(vObjProduto.ID));

            vEstadoTela := etPadrao;
            DefineEstadoTela;

            Result := True;
         end;
      except
         on E : Exception do
         begin
            Raise Exception.Create(
               'Falha ao incluir os dados do produto[View]: '#13 +
               e.Message);
         end;
      end;
   finally
      if vObjProduto <> nil then
         FreeAndNil(vObjProduto);
   end;
end;

function TfrmProduto.ProcessaListagem: Boolean;
begin

end;

function TfrmProduto.ProcessaUnidadeProduto: Boolean;
begin
  try
    Result := False;

    if (ProcessaProduto) then
    begin
      TProdutoController.getInstancia.GravaProduto(vObjProduto);
      Result := True;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao gavar os dados dos Produtos [View]: '#13 + e.Message);
    end;
  end;
end;

function TfrmProduto.ProcessaProduto: Boolean;
begin
  try
    Result := False;

    if not ValidaProduto then
      exit;

    if vEstadoTela = etIncluir then
    begin
      if vObjProduto = nil then
         vObjProduto := TProduto.Create;
    end
    else if vEstadoTela = etAlterar then
    begin
      if vObjProduto = nil then
         exit;
    end;
    if vObjProduto = nil then
       exit;

//    vObjProduto.ID                := 0;
    vObjProduto.QuantidadeEstoque := edtQuantidade.Value;
    vObjProduto.PrecoVenda        := edtPreco.Value;
    vObjProduto.Descricao         := edtDescricaoProd.Text;
    vObjProduto.UnidadeSaida      := cmbUnidade.Text;


    TProdutoController.getInstancia.GravaProduto(vObjProduto);

    Result := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao processar os dados do Produto [View]' + #13 + e.Message);
    end;

  end;
end;

function TfrmProduto.ValidaProduto: Boolean;
begin
  Result := False;
  if Trim(edtDescricaoProd.Text) = '' then
  begin
    TMessageUtil.Alerta('Decrição do produto não pode ficar em branco.');
    if edtDescricaoProd.CanFocus then
       edtDescricaoProd.SetFocus;
    exit;
  end;
   if (CompareValue(edtPreco.Value, 0) = EqualsValue) then
  begin
    TMessageUtil.Alerta('Preço do produto não pode ser 0.');
    if edtPreco.CanFocus then
      edtPreco.SetFocus;
    exit;
  end;
  if (CompareValue(edtQuantidade.Value, 0) = EqualsValue) then
  begin
    TMessageUtil.Alerta('Quantidade do produto não pode ser 0.');
    if edtQuantidade.CanFocus then
      edtQuantidade.SetFocus;
    exit;
  end;
  Result := True;
end;

procedure TfrmProduto.CarregaDadosTela;
var
   xObjUnidadeProduto : TUnidadeProduto;
begin
   if (vObjProduto = nil) then
      exit;

   edtCodigo.Text                 := IntToStr(vObjProduto.ID);
   edtDescricaoProd.Text          := vObjProduto.Descricao;
   edtQuantidade.Value            := vObjProduto.QuantidadeEstoque;
   edtPreco.Value                 := vObjProduto.PrecoVenda;
   cmbUnidade.Items.Clear;
   CarregaDadoscmb;
   cmbUnidade.ItemIndex := cmbUnidade.Items.IndexOf(vObjProduto.UnidadeSaida);
   edtDescricaoUnidade.Enabled    := False;

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

procedure TfrmProduto.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
   begin
      ProcessaConsulta;
   end;
      vKey := VK_CLEAR;
end;


procedure TfrmProduto.CarregaDadoscmb;
var
   xListaUnidades : TColUnidadeProd;
   Unidade        : TUnidadeProduto;
   i              : Integer;

begin
   xListaUnidades := TColUnidadeProd.Create;

   if cmbUnidade.Items.Count > 0 then
      Exit;

    xListaUnidades :=
            TUnidadeProdController.getInstancia.PesquisaUnidade(Trim(cmbUnidade.Text));

    try
       cmbUnidade.Items.Clear;

        for i := 0 to xListaUnidades.Count - 1 do
        begin
            Unidade := xListaUnidades[i];
            cmbUnidade.Items.AddObject(Unidade.Unidade, Unidade);
        end;

    except

    end;
    end;

procedure TfrmProduto.cmbUnidadeChange(Sender: TObject);
var
   xDescricaoUnidade : TUnidadeProduto;
   xCodigoReplace : string;
begin
   xDescricaoUnidade := TUnidadeProduto.create;

   if cmbUnidade.ItemIndex >= 0 then
   begin
      xDescricaoUnidade :=
         TUnidadeProduto(cmbUnidade.Items.Objects[cmbUnidade.ItemIndex]);

      edtDescricaoUnidade.Text := xDescricaoUnidade.Descricao;
   end
   else
      edtDescricaoUnidade.Text := '';

   xCodigoReplace := TFuncoes.SoNumero(cmbUnidade.Text);
   cmbUnidade.Text := xCodigoReplace;
   cmbUnidade.Text := TFuncoes.removeCaracterEspecial(cmbUnidade.Text, True);
end;


procedure TfrmProduto.btnSpeedClick(Sender: TObject);
var
   xUnidadeCmb: string;
   xIndex: Integer;
begin
   try
      Screen.Cursor := crHourGlass;

      
      xUnidadeCmb := cmbUnidade.Text;


      if frmUnidadeProd = nil then
         frmUnidadeProd := TfrmUnidadeProd.Create(Application);
         
      frmUnidadeProd.ShowModal;


      cmbUnidade.Items.Clear;
      CarregaDadoscmb;


      xIndex := cmbUnidade.Items.IndexOf(xUnidadeCmb);
      if xIndex <> -1 then
         cmbUnidade.ItemIndex := xIndex
      else
         cmbUnidade.ItemIndex := 0;

   finally
      Screen.Cursor := crDefault;
   end;
end;


procedure TfrmProduto.cmbUnidadeEnter(Sender: TObject);
begin
   CarregaDadoscmb;
end;

procedure TfrmProduto.edtDescricaoProdKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Key in ['0'..'9'] then
      Key := #0;
end;

function TfrmProduto.CarregaProduto: Boolean;
begin

end;

procedure TfrmProduto.CarregaUnidadeDesc;
var
  xUnidadeProduto: TUnidadeProduto;
begin
  try
    xUnidadeProduto := nil;
    if vObjProduto.UnidadeSaida <> '' then
    begin
      xUnidadeProduto := TUnidadeProdController.getInstancia.BuscaDescUnidade(vObjProduto.UnidadeSaida);
      if xUnidadeProduto <> nil then
      begin
        edtDescricaoUnidade.Enabled := True;
        edtDescricaoUnidade.Text := xUnidadeProduto.Descricao;
        edtDescricaoUnidade.Enabled := False;
        CarregaDadoscmb;
      end
      else
      begin
        TMessageUtil.Alerta('Nenhuma unidade encontrada para o produto informado.');
        edtDescricaoUnidade.Text := '';
        LimpaTela;
      end;
    end
    else
    begin
      edtDescricaoUnidade.Text := '';
    end;
    
  finally
    if xUnidadeProduto <> nil then
      FreeAndNil(xUnidadeProduto);
    CarregaDadoscmb;
  end;
end;


procedure TfrmProduto.cmbUnidadeKeyPress(Sender: TObject; var Key: Char);
begin
    if Key in ['0'..'9'] then
       Key := #0;
end;

procedure TfrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   LimpaTela;
end;

procedure TfrmProduto.edtCodigoChange(Sender: TObject);
begin
   edtCodigo.Text := TFuncoes.SoNumero(edtCodigo.Text);
end;

procedure TfrmProduto.edtDescricaoProdChange(Sender: TObject);
begin
   edtDescricaoProd.Text := TFuncoes.removeCaracterEspecial(edtDescricaoProd.Text, true);
end;

procedure TfrmProduto.cmbUnidadeClick(Sender: TObject);
begin
//   cmbUnidade.Style := csDropDownList;
end;

procedure TfrmProduto.cmbUnidadeExit(Sender: TObject);
begin
   if Trim(cmbUnidade.Text) = '' then
      edtDescricaoUnidade.Text := EmptyStr;
end;

procedure TfrmProduto.FormActivate(Sender: TObject);
begin
   CarregaDadoscmb;
end;

procedure TfrmProduto.edtPrecoExit(Sender: TObject);
begin
   if edtPreco.Value < 0 then
      edtPreco.Value := 0;
end;

procedure TfrmProduto.edtQuantidadeExit(Sender: TObject);
begin
   if edtQuantidade.Value < 0 then
      edtQuantidade.Value := 0;
end;

end.

