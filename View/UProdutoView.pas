unit UProdutoView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,  UEnumerationUtil,
  NumEdit;

type
    TfrmProduto = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    edtDescricaoProd: TEdit;
    lblUnidade: TLabel;
    edtCodigo: TEdit;
    edtDescricaoUnidade: TEdit;
    Label1: TLabel;
    lblCodigo: TLabel;
    lblQuantidade: TLabel;
    lblPreco: TLabel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    edtUnidade: TEdit;
    btnSpeed: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnConfirmarClick(Sender: TObject);
  private
    { Private declarations }

    vKey : Word;
    vEstadoTela : TEstadoTela;
    procedure CamposEnabled(pOpcao : Boolean);
    procedure DefineEstadoTela;
    procedure LimpaTela;
    function ProcessaConfirmacao   : Boolean;
    function ProcessaInclusao      : Boolean;
    function ProcessaAlteracao     : Boolean;
    function ProcessaExclusao      : Boolean;
    function ProcessaCliente       : Boolean;
    function ProcessaConsulta      : Boolean;
    function ProcessaListagem      : Boolean;
  public
    { Public declarations }
  end;

var
  frmProduto: TfrmProduto;

implementation

uses
   uMessageUtil;

{$R *.dfm}

procedure TfrmProduto.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;
   end;



end;

procedure TfrmProduto.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnListar.Enabled    := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnabled(False);
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

         if (frmProduto <> nil) and
         (frmProduto.Active) and
         (frmProduto.CanFocus) then
         btnIncluir.SetFocus;

         Application.ProcessMessages;
      end;

      etIncluir :
      begin
         CamposEnabled(True);
         stbBarraStatus.Panels[0].Text := 'Inclusão';


         edtCodigo.Enabled := False;

         if edtDescricaoProd.CanFocus then
            edtDescricaoProd.SetFocus;

         if edtPreco.CanFocus then
            edtPreco.SetFocus;

         if edtQuantidade.CanFocus then
            edtQuantidade.SetFocus;


      end;
   end;
end;

procedure TfrmProduto.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmProduto.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;


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
end;

procedure TfrmProduto.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmProduto.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmProduto.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

function TfrmProduto.ProcessaConfirmacao: Boolean;
begin
   Result:= False;

      try
        case vEstadoTela of
            etIncluir   : Result := ProcessaInclusao;
            etAlterar   : Result := ProcessaAlteracao;
            etExcluir   : Result := ProcessaExclusao; 
            etConsultar : Result := ProcessaConsulta;

        end;
        if not Result then
         Exit;
      except
         on E : Exception do
         TMessageUtil.Alerta(E.Message);
      end;

      Result := True;
end;

function TfrmProduto.ProcessaAlteracao: Boolean;
begin

end;

function TfrmProduto.ProcessaCliente: Boolean;
begin

end;

function TfrmProduto.ProcessaConsulta: Boolean;
begin

end;

function TfrmProduto.ProcessaExclusao: Boolean;
begin

end;

function TfrmProduto.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaProduto then
      begin
         TMessageUtil.Informacao('Produto cadastrado com sucesso! ' + #13 +
                                 'Código cadastrado: ' + IntToStr(vObjProduto.Id));
         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
       on E : Exception do
       begin
          Raise Exception.Create(
          'Falha ao incluir os dados do cliente [View]: '#13 +
          e.Message);
       end;
   end;
end;

function TfrmProduto.ProcessaListagem: Boolean;
begin

end;

end.

