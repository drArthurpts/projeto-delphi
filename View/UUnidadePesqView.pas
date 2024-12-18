unit UUnidadePesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids, DBGrids,
  UMessageUtil, UUnidadeProduto, UUnidadeProdController;

type
  TfrmUnidadePesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlResultado: TPanel;
    grbFiltrar: TGroupBox;
    lblUnidade: TLabel;
    edtNome: TEdit;
    lblInfo: TLabel;
    btnFiltrar: TBitBtn;
    grbGrid: TGroupBox;
    dbgUnidade: TDBGrid;
    dtsUnidade: TDataSource;
    cdsUnidade: TClientDataSet;
    cdsUnidadeID: TIntegerField;
    cdsUnidadeUnidade: TStringField;
    cdsUnidadeAtivo: TIntegerField;
    cdsUnidadeDescricao: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsUnidadeBeforeDelete(DataSet: TDataSet);
    procedure dbgUnidadeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgUnidadeDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    vKey: Word;
    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;
  public
    { Public declarations }
    mUnidadeID: Integer;
    mUnidadeUnidade: string;

  end;

var
  frmUnidadePesq: TfrmUnidadePesq;

implementation

uses
  Math, StrUtils;

{$R *.dfm}

procedure TfrmUnidadePesq.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
      end;

    VK_UP:
      begin
        vKey := VK_CLEAR;

        if (ActiveControl = dbgUnidade) then
          exit;

        Perform(WM_NEXTDLGCTL, 1, 0);
      end;
  end;
end;

procedure TfrmUnidadePesq.LimparTela;
var
  i: Integer;
begin
  for i := 0 to pred(ComponentCount) do
  begin
    if (Components[i] is TEdit) then
      (Components[i] as TEdit).Text := EmptyStr;
  end;

  if (not cdsUnidade.IsEmpty) then
    cdsUnidade.EmptyDataSet;

  if (edtNome.CanFocus) then
    edtNome.SetFocus;

//   mUnidadeID   := 0;
//   mUnidadeUnidade := EmptyStr;
end;

procedure TfrmUnidadePesq.ProcessaConfirmacao;
begin
  if (not cdsUnidade.IsEmpty) then
  begin
    mUnidadeID := cdsUnidadeID.Value;
    mUnidadeUnidade := cdsUnidadeUnidade.Value;
    Self.ModalResult := mrOk;
    LimparTela;
    Close;
  end
  else
  begin
    TMessageUtil.Alerta('Nenhuma Unidade encontrada.');

    if edtNome.CanFocus then
      edtNome.SetFocus;
  end;
end;

procedure TfrmUnidadePesq.ProcessaPesquisa;
var
  xListaUnidade: TColUnidadeProd;
  xAux: Integer;
begin
  try
    try
      xListaUnidade := TColUnidadeProd.Create;

      xListaUnidade := TUnidadeProdController.getInstancia.PesquisaUnidade(Trim(edtNome.Text));

      cdsUnidade.EmptyDataSet;

      if xListaUnidade <> nil then
      begin
        for xAux := 0 to pred(xListaUnidade.Count) do
        begin
          cdsUnidade.Append;
          cdsUnidadeID.Value := xListaUnidade.Retorna(xAux).Id;
          cdsUnidadeUnidade.Value := xListaUnidade.Retorna(xAux).Unidade;
          cdsUnidadeAtivo.Value := IfThen(xListaUnidade.Retorna(xAux).Ativo, 1, 0);
          cdsUnidadeDescricao.Value := xListaUnidade.Retorna(xAux).Descricao;
          cdsUnidade.Post;
        end;
      end;

      if (cdsUnidade.RecordCount = 0) then
      begin
        TMessageUtil.Alerta('Nenhuma unidade encontrada para esse filtro.');
        if edtNome.CanFocus then
          edtNome.SetFocus;
      end
      else
      begin
        cdsUnidade.First;
        if dbgUnidade.CanFocus then
          dbgUnidade.SetFocus;
      end;

    finally
      if (xListaUnidade <> nil) then
        FreeAndNil(xListaUnidade);
    end;

  except
    on E: Exception do
    begin
      raise Exception.Create('Falha ao pesquisar os dados da pessoa [View] : ' + #13 + e.Message);
    end;
  end;
end;

procedure TfrmUnidadePesq.btnFiltrarClick(Sender: TObject);
begin
  mUnidadeID := 0;
  mUnidadeUnidade := EmptyStr;
  ProcessaPesquisa;
end;

procedure TfrmUnidadePesq.btnConfirmarClick(Sender: TObject);
begin
  ProcessaConfirmacao;
end;

procedure TfrmUnidadePesq.btnLimparClick(Sender: TObject);
begin
  LimparTela;
end;

procedure TfrmUnidadePesq.btnSairClick(Sender: TObject);
begin
  LimparTela;
  Close;
end;

procedure TfrmUnidadePesq.cdsUnidadeBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfrmUnidadePesq.dbgUnidadeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (btnConfirmar.CanFocus) then
    btnConfirmar.SetFocus;
end;

procedure TfrmUnidadePesq.dbgUnidadeDblClick(Sender: TObject);
begin
  ProcessaConfirmacao;
end;

procedure TfrmUnidadePesq.FormShow(Sender: TObject);
begin
  LimparTela;
end;

end.

