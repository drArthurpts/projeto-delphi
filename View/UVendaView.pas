unit UVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, NumEdit,UEnumerationUtil,
  UVendaController, DB, DBClient, Grids, DBGrids, Mask ,UVenda,UPessoaController,
  UClientesView,UPessoa;

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
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
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
    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao    : Boolean;
    function ProcessaConsulta    : Boolean;
    function ProcessaVenda       : Boolean;
    function ValidaCampos   : Boolean;


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

         edtData.Text := FormatDateTime('dd/mm/yyyy',Now);

         if dbgProduto.CanFocus then
            dbgProduto.SetFocus
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
      vObjVenda.IDCliente   := StrToInt(edtCodigo.Text);
      vObjVenda.TotalAcresc := edtDesconto.Value;
      vObjVenda.TotalVenda  := edtTotal.Value;


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

      end;
   end;
end;


end.
