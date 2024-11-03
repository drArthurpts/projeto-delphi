unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, UEnumerationUtil, NumEdit,
  UProduto, UProdutoController, UUnidadeProdController,Math, UUnidadeProduto,
  UUnidadeProdutoDAO,UConexao, DB, DBClient, UUnidadeProdView;

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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

  private
    { Private declarations }

    vKey: Word;
    vEstadoTela: TEstadoTela;
    vObjProduto: TProduto;
    vObjColProduto: TColProduto;
    procedure CamposEnabled(pOpcao: Boolean);
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    procedure LimpaTela;
    procedure CarregaDadoscmb;
    function  ProcessaConfirmacao: Boolean;
    function  ProcessaInclusao: Boolean;
    function  ProcessaAlteracao: Boolean;
    function  ProcessaExclusao: Boolean;
    function  ProcessaConsulta: Boolean;
    function  ProcessaListagem: Boolean;
    function  ProcessaUnidadeProduto: Boolean;
    function  ProcessaProduto: Boolean;
    function  ValidaProduto: Boolean;
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
        if (frmProduto <> nil) and (frmProduto.Active) and (frmProduto.CanFocus) then
          btnIncluir.SetFocus;

        Application.ProcessMessages;
      end;

    etIncluir:
      begin
        CamposEnabled(True);
        stbBarraStatus.Panels[0].Text := 'Inclus�o';

        edtCodigo.Enabled  := False;
        cmbUnidade.Enabled := True;

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

        CamposEnabled(False);

        if (edtCodigo.Text <> EmptyStr) then
        begin
          btnAlterar.Enabled   := True;
          btnExcluir.Enabled   := True;
          cmbUnidade.Enabled   := True;
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
        stbBarraStatus.Panels[0].Text := 'Altera��o';

        if (edtCodigo.Text <> EmptyStr) then
        begin
          CamposEnabled(True);

          edtCodigo.Enabled := False;
          btnAlterar.Enabled := False;
          btnConfirmar.Enabled := True;

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

        //


        stbBarraStatus.Panels[0].text := 'Exclus�o';

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
            frmProdutoPesqView := TfrmProdutoPesqView.Create(Application);

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
         frmProdutoPesqView.mProdutoID   := 0;
         frmProdutoPesqView.mProdutoDescricao := EmptyStr;

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;
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

procedure TfrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmProduto := nil;
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
    if (TMessageUtil.Pergunta('Deseja realmente abortar essa opera��o?')) then
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
      TMessageUtil.Alerta('C�digo do produto n�o pode ficar em branco.');

      if (edtCodigo.CanFocus) then
          edtCodigo.SetFocus;

      Exit;
    end;

    vObjProduto := TProduto(TProdutoController.getInstancia.
    BuscaProduto(StrToIntDef(edtCodigo.Text, 0)));

    if (vObjProduto <> nil) then
       CarregaDadosTela
    else
    begin
      TMessageUtil.Alerta('Nenhum Produto encontrado');
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
//  try
//    Result := False;
//
//    if (edtDescricaoProd.Text <> EmptyStr) and (Trim(edtDescricaoProd.Text) = EmptyStr) then
//    begin
//      ProcessaConsulta;
//      exit;
//    end;
//
//    if (vObjProduto = nil) then
//    begin
//      TMessageUtil.Alerta('N�o foi poss�vel carregar todos os dados cadastrados do Produto.');
//      LimpaTela;
//      vEstadoTela := etPadrao;
//      DefineEstadoTela;
//      exit;
//    end;
//
//    try
//      if TMessageUtil.Pergunta('Confirma a exclus�o do Produto?') then
//      begin
//        Screen.Cursor := crHourGlass;
//
//        TProdutoController.getInstancia.ExcluiProduto(vObjProduto);
//
//        TMessageUtil.Informacao('Produto exclu�do com sucesso.');
//      end
//      else
//      begin
//        LimpaTela;
//        vEstadoTela := etPadrao;
//        DefineEstadoTela;
//        exit;
//      end;
//    finally
//      Screen.Cursor := crDefault;
//      Application.ProcessMessages;
//    end;
//
//    Result := True;
//
//    LimpaTela;
//    vEstadoTela := etPadrao;
//    DefineEstadoTela;
//  except
//    on E: Exception do
//    begin
//      raise Exception.Create('Falha ao excluir os dados do Produto [View]: ' + #13 + e.Message);
//    end;
//  end;

   try
      Result := False;

      if (vObjProduto = nil) then
      begin
         TMessageUtil.Alerta(
            'N�o foi poss�vel carregar todos os dados cadastrados do Produto.');
         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
          if TMessageUtil.Pergunta('Confirma a exclus�o do produto?') then
          begin
             Screen.Cursor := crHourGlass;

             TProdutoController.getInstancia
             .ExcluiProduto(vObjProduto);

             TMessageUtil.Informacao('Produto exclu�do com sucesso.');
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
  try
    Result := False;

    if ProcessaUnidadeProduto then
    begin
      TMessageUtil.Informacao('Produto cadastrado com sucesso! ' + #13+
                              'C�digo cadastrado: ' + IntToStr(vObjProduto.ID));

      vEstadoTela := etPadrao;
      DefineEstadoTela;

      Result := True;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao incluir os dados do Produto [View]: '#13 + e.Message);
    end;
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
//         Grava��o no banco
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
    vObjProduto.UnidadeSaida           := cmbUnidade.Text;


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

  if (CompareValue(edtPreco.Value, 0) = EqualsValue) then
  begin
    TMessageUtil.Alerta('Pre�o do produto n�o pode ser 0.');
    if edtPreco.CanFocus then
      edtPreco.SetFocus;
    exit;
  end;

  if (CompareValue(edtQuantidade.Value, 0) = EqualsValue) then
  begin
    TMessageUtil.Alerta('Quantidade do produto n�o pode ser 0.');
    if edtQuantidade.CanFocus then
      edtQuantidade.SetFocus;
    exit;
  end;

  if Trim(edtDescricaoProd.Text) = '' then
  begin
    TMessageUtil.Alerta('Decri��o do produto n�o pode ficar em branco.');
    if edtDescricaoProd.CanFocus then
       edtDescricaoProd.SetFocus;
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

   try
      if vObjProduto.ID <> 0 then
      begin
         xObjUnidadeProduto := nil;
         xObjUnidadeProduto := TUnidadeProduto.create;
         //xObjUnidadeProduto := TUnidadeProdController.BuscaUnidade(vObjProduto.Unidade_ID);
         cmbUnidade.Text := xObjUnidadeProduto.Unidade;
         edtDescricaoUnidade.Text := xObjUnidadeProduto.Descricao;

         if  xObjUnidadeProduto <> nil then
             edtDescricaoUnidade.Text :=  xObjUnidadeProduto.Descricao;
      end;
   finally
      if xObjUnidadeProduto <> nil then
         FreeAndNil(xObjUnidadeProduto);
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

procedure TfrmProduto.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
   begin
      ProcessaConsulta;
   end;
   //else
      vKey := VK_CLEAR;
end;


procedure TfrmProduto.CarregaDadoscmb;
var
   xListaUnidades : TColUnidadeProd;
   Unidade        : TUnidadeProduto;
   i              : Integer;

begin
   xListaUnidades := TColUnidadeProd.Create;

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
         TMessageUtil.Alerta('Decri��o do produto n�o pode ficar em branco.');
    end;
    end;


procedure TfrmProduto.cmbUnidadeChange(Sender: TObject);
var
   Unidade : TUnidadeProduto;
begin
   if cmbUnidade.ItemIndex >= 0 then
   begin
      Unidade := TUnidadeProduto(cmbUnidade.Items.Objects[cmbUnidade.ItemIndex]);
      edtDescricaoUnidade.Text := Unidade.Descricao;
   end
   else
   begin
      edtDescricaoUnidade.Text := '';
   end;
end;

procedure TfrmProduto.btnSpeedClick(Sender: TObject);
begin

    if frmUnidadeProd  = nil then
       frmUnidadeProd  := TfrmUnidadeProd.Create(Application);
       frmUnidadeProd.Show;
end;

procedure TfrmProduto.cmbUnidadeEnter(Sender: TObject);
begin
   CarregaDadoscmb;
end;

end.

