unit UClientesView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, Buttons, UEnumerationUtil,
   UCliente, UPessoaController, UEndereco;

type
  TfrmClientes = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    chkAtivo: TCheckBox;
    rdgTipoPessoa: TRadioGroup;
    lblCPFCNPJ: TLabel;
    edtCPFCNPJ: TMaskEdit;
    lblNome: TStaticText;
    edtNome: TEdit;
    grbEndereco: TGroupBox;
    lblEndereco: TLabel;
    edtEndereco: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblUF: TLabel;
    cmbUF: TComboBox;
    lblCidade: TLabel;
    edtCidade: TEdit;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoExit(Sender: TObject);
  private
    { Private declarations }
    vKey : Word;

    //Variaveis de classes
    vEstadoTela : TEstadoTela;
    vObjCliente : TCliente;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    function ProcessaConfirmacao   : Boolean;
    function ProcessaInclusao      : Boolean;
    function ProcessaAlteracao     : Boolean;
    function ProcessaExclusao      : Boolean;
    function ProcessaCliente       : Boolean;
    function ProcessaConsulta      : Boolean;  
    function ProcessaPessoa        : Boolean;
    function ProcessaEndereco      : Boolean;
    function ValidaCliente         : Boolean;
    function ValidaEndereco         : Boolean;



  public
    { Public declarations }

  end;

var
  frmClientes: TfrmClientes;

implementation

uses
  uMessageUtil;
  
{$R *.dfm}

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
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
         'Deseja realmente abortar essa opera��o?')) then
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

procedure TfrmClientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      Action := caFree;
      frmClientes := nil;
end;

procedure TfrmClientes.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

      if (Components[i] is TRadioGroup) then
         (Components[i] as TRadioGroup).Enabled := pOpcao;

      if (Components[i] is TComboBox) then
         (Components[i] as TComboBox).Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;

   end;

   grbEndereco.Enabled := pOpcao;

end;

procedure TfrmClientes.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Text := EmptyStr;

      if (Components[i] is TRadioGroup) then
         (Components[i] as TRadioGroup).ItemIndex := 0;

      if (Components[i] is TComboBox) then
         begin
         (Components[i] as TComboBox).Clear;
         (Components[i] as TComboBox).ItemIndex := -1;
         end;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;


   end;
end;

procedure TfrmClientes.DefineEstadoTela;
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

         if (frmClientes <> nil) and
         (frmClientes.Active) and
         (frmClientes.CanFocus) then
         btnIncluir.SetFocus;

         Application.ProcessMessages;    
      end;
      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclus�o';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         chkAtivo.Checked := True;

         if edtNome.CanFocus then
            edtNome.SetFocus; 
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Altera��o';

         if (edtCodigo.Text <> EmptyStr) then
         begin
            CamposEnabled(True);

            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;


            if (chkAtivo.CanFocus) then
               chkAtivo.SetFocus;
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

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consulta';

         CamposEnabled(False);

         if (edtCodigo.Text <> EmptyStr) then
         begin
            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := True;
            btnExcluir.Enabled   := True;
            btnListar.Enabled    := True;
            btnConfirmar.Enabled := False;
            chkAtivo.Enabled     := False;

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
   end;
end;

procedure TfrmClientes.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnListarClick(Sender: TObject);
begin
   vEstadoTela := etListar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmClientes.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
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

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmClientes.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaConfirmacao: Boolean;
begin
   Result:= False;

      try
        case vEstadoTela of
            etIncluir   : Result := ProcessaInclusao;
            etAlterar   : Result := ProcessaAlteracao;
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

function TfrmClientes.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaCliente then
      begin
         TMessageUtil.Informacao('Cliente cadastrado com sucesso! ' + #13 +
                                 'C�digo cadastrado: ' + IntToStr(vObjCliente.Id));
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

function TfrmClientes.ProcessaCliente: Boolean;
begin
   try
      Result := False;

      if (ProcessaPessoa) and (ProcessaEndereco) then
      begin
         //Grava��o no banco
         TPessoaController.getInstancia.GravaPessoa(vObjCliente);
         Result := True;
      end;
   except
     on E : Exception do
     begin
         Raise  Exception.Create(
         'Falha ao gavar os dados dos clientes [View]: '#13 +
         e.Message);
     end;
   end;
end;

function TfrmClientes.ProcessaPessoa: Boolean;
begin
   try
      Result := False;

      if not ValidaCliente then
         Exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjCliente = nil then
            vObjCliente := TCliente.Create
      end
      else
      if vEstadoTela = etAlterar then
      begin
           if vObjCliente = nil then
              Exit;

      end;
      if vObjCliente = nil then
              Exit;

      vObjCliente.Tipo_Pessoa         := 0;
      vObjCliente.Nome                := edtNome.Text;
      vObjCliente.Fisica_Juridica     := rdgTipoPessoa.ItemIndex;
      vObjCliente.Ativo               := chkAtivo.Checked;
      vObjCliente.IdentificadorPessoa := edtCPFCNPJ.Text;


      Result := True
   except
       on E : Exception do
       begin

          Raise Exception.Create(
          'Falha ao processar os dados da Pessoa [View]: ' + #13 + e.Message);
       end
   end;
end;

function TfrmClientes.ProcessaEndereco: Boolean;
var
   xEndereco : TEndereco;
begin
   try
       Result := False;

       xEndereco := nil;

       if (not ValidaEndereco) then
         Exit;


       Result := True;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao preencher os dados de endere�o do cliente [View]' + #13  +
            e.Message);

            
      end;
   end;

end;

function TfrmClientes.ValidaCliente: Boolean;
begin
   Result := False;

   if (edtNome.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Nome do cliente n�o pode ficar em branco. ');
      if edtNome.CanFocus then
      edtNome.SetFocus;
    Exit;

   end;

   Result := True;
end;

function TfrmClientes.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('C�digo do cliente n�o pode ficar em branco.');

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjCliente :=
        TCliente (TPessoaController.getInstancia.BuscaPessoa(
           StrToIntDef(edtCodigo.Text, 0)));

      if (vObjCliente <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum cliente encontrado para o c�digo informado');
         LimpaTela;

         if (edtCodigo.CanFocus) then
             edtCodigo.SetFocus;

         Exit;
      end;

      DefineEstadoTela;

      Result := True;

   except
       on E : Exception do
       begin
         Raise Exception.Create(
         'Falha ao consultar os dados do cliente [View].' + #13 +
         e.Message);

       end;
   end;
end;

procedure TfrmClientes.CarregaDadosTela;
begin
   if (vObjCliente = nil) then
   Exit;

   edtCodigo.Text          := IntToStr(vObjCliente.Id);
   rdgTipoPessoa.ItemIndex := vObjCliente.Fisica_Juridica;
   edtNome.Text            := vObjCliente.Nome;
   chkAtivo.Checked        := vObjCliente.Ativo;
   edtCPFCNPJ.Text         := vObjCliente.IdentificadorPessoa;

end;

function TfrmClientes.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaCliente then
      begin
         TMessageUtil.Informacao('Dados foram alterados com sucesso.');

         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;      
      end;

   except
      on E : Exception do
      begin
         Raise Exception.Create(
         'Falha ao alterar os dados do cliente [View]: ' +#13 +
         e.Message);
      end;  

   end;

end;

procedure TfrmClientes.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaExclusao: Boolean;
begin
   try
      Result := False;

      if (vObjCliente = nil) then
      begin
         TMessageUtil.Alerta(
            'N�o foi poss�vel carregar todos os dados cadastrados do cliente.');
         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
          if TMessageUtil.Pergunta('Confirma a exclus�o do cliente?') then
          begin
             Screen.Cursor := crHourGlass;

             TPessoaController.getInstancia.ExcluiPessoa(vObjCliente);
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
      TMessageUtil.Informacao('Cliente exclu�do com sucesso.');
      
      LimpaTela;
      vEstadoTela := etPadrao;
      DefineEstadoTela;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao excluir os dados do cliente [View]: ' + #13 +
         e.Message);
      end;
   end;
end;

function TfrmClientes.ValidaEndereco: Boolean;
begin
   Result := False;

   if (Trim(edtEndereco.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta('Endere�o do cliente n�o pode ficar em branco.');

      if (edtEndereco.CanFocus) then
         edtEndereco.SetFocus;
      Exit;
   end;

   if (Trim(edtNumero.Text = EmptyStr)) then
   begin

   end;


   Result := True;
end;

end.
