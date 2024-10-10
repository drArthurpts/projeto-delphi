unit UUnidadeProdView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, UEnumerationUtil,
  UUnidadeProduto;

type
  TfrmUnidadeProd = class(TForm)
    StbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    lblCodigo: TLabel;
    lblUnidade: TLabel;
    edtCodigo: TEdit;
    chkAtivo: TCheckBox;
    Label1: TLabel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    edtDescricao: TEdit;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    edtUnidade: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    vKey : Word;

    //Variaveis de classes
    vEstadoTela : TEstadoTela;
    vObjUnidadeProd : TUnidadeProduto;


    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao      : Boolean;
    function ProcessaProduto       : Boolean;
    function ProcessaAlteracao     : Boolean;
    function ProcessaExclusao      : Boolean;
    function ProcessaConsulta      : Boolean;
    function ProcessaDescricao     : Boolean;
    function ProcessaUnidade: Boolean;
  public
    { Public declarations }
  end;

var
  frmUnidadeProd: TfrmUnidadeProd;

implementation

uses
   uMessageUtil;
{$R *.dfm}

procedure TfrmUnidadeProd.FormKeyDown(Sender: TObject; var Key: Word;
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
            if (TMessageUtil.Pergunta('Deseja realmente abortar essa operação?')) then
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;
         end
         else
         begin
         if (TMessageUtil.Pergunta(
         'Deseja realmente abortar essa operação?')) then
         Close;
         end;
      end;
   end;
end;

procedure TfrmUnidadeProd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmUnidadeProd := nil;
end;

procedure TfrmUnidadeProd.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;

   end;



end;

procedure TfrmUnidadeProd.LimpaTela;
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


procedure TfrmUnidadeProd.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
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

         if (frmUnidadeProd <> nil) and
         (frmUnidadeProd.Active) and
         (frmUnidadeProd.CanFocus) then
          btnIncluir.SetFocus;

         Application.ProcessMessages;
      end;
      
      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;
      end;

   end;
end;
procedure TfrmUnidadeProd.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmUnidadeProd.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.btnSairClick(Sender: TObject);
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

procedure TfrmUnidadeProd.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmUnidadeProd.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmUnidadeProd.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmUnidadeProd.ProcessaConfirmacao: Boolean;
begin
   Result := False;
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

function TfrmUnidadeProd.ProcessaAlteracao: Boolean;
begin

end;

function TfrmUnidadeProd.ProcessaConsulta: Boolean;
begin

end;

function TfrmUnidadeProd.ProcessaExclusao: Boolean;
begin

end;

function TfrmUnidadeProd.ProcessaInclusao: Boolean;
begin
    try
      Result := False;

      if ProcessaProduto then
      begin
         TMessageUtil.Informacao('Produto cadastrado com sucesso! ' + #13 +
                                 'Código cadastrado: ');
         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
       on E : Exception do
       begin
          Raise Exception.Create(
          'Falha ao incluir os dados do produto [View]: '#13 +
          e.Message);
       end;
   end;
end;

function TfrmUnidadeProd.ProcessaProduto: Boolean;
begin
    try
      Result := False;
      if (ProcessaUnidade)   and
         (ProcessaDescricao) then

      begin


       


      Result := True;
      end;
   except
     on E : Exception do
     begin
         Raise  Exception.Create(
         'Falha ao processar os dados dos Produtos [View]: '#13 +
         e.Message);
     end;
   end;
end;

function TfrmUnidadeProd.ProcessaDescricao : Boolean;
begin
//   try
//   Result := False;
//
//
//
//
//   Result := True;
//   except
//      on E : Exception do
//     begin
//         Raise  Exception.Create(
//         'Falha ao processar a  do produto [View]: '#13 +
//         e.Message);
//     end;
//   end;
end;

function TfrmUnidadeProd.ProcessaUnidade: Boolean;
begin
   try
      Result := False;

//      if not ValidaProduto then
//      exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjUnidadeProd = nil then
            vObjUnidadeProd := TUnidadeProduto.Create;
      end
      else
      if vEstadoTela = etAlterar then

      begin
         if vObjUnidadeProd = nil then
            Exit;
      end;

      vObjUnidadeProd.Codigo     := edtCodigo.Text;
      vObjUnidadeProd.Unidade    := edtUnidade.Text;
      vObjUnidadeProd.Descricao  := edtDescricao.Text;
      vObjUnidadeProd.Ativo      := chkAtivo.Checked;

      Result := True;
   except
      on E : Exception do
     begin
         Raise  Exception.Create(
         'Falha ao processar a unidade do produto [View]: '#13 +
         e.Message);
     end;
   end;
end;


end.
