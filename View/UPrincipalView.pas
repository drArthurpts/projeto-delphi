unit UPrincipalView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, DBCtrls, ExtCtrls, pngimage;

type
  TfrmPrincipal = class(TForm)
    MainCadastro: TMainMenu;
    menMenu: TMenuItem;
    MenCliente: TMenuItem;
    MenProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menRelVendas: TMenuItem;
    MenMovimentos: TMenuItem;
    menVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    imgLogo: TImage;
    MenUnidadedeProduto: TMenuItem;
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenClienteClick(Sender: TObject);
    procedure MenUnidadedeProdutoClick(Sender: TObject);
    procedure MenProdutosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UConexao, UClientesView, UUnidadeProdView, UProdutoView;

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
  Close; //Fecha o sistema
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  stbBarraStatus.Panels[0].Text := 'Teste';
end;

procedure TfrmPrincipal.MenClienteClick(Sender: TObject);
begin
  try
      Screen.Cursor := crHourGlass;

      if frmClientes = nil then
      frmClientes := TfrmClientes.Create(Application);

  frmClientes.Show;


  finally
      Screen.Cursor := crDefault;
  end;
end;

procedure TfrmPrincipal.MenUnidadedeProdutoClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;
     if (frmUnidadeProd = nil) then
         frmUnidadeProd := TfrmUnidadeProd.Create(Application);

     frmUnidadeProd.Show;
   finally
      Screen.Cursor := crDefault;

   end;
end;

procedure TfrmPrincipal.MenProdutosClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;
     if (frmProduto = nil) then
         frmProduto := TfrmProduto.Create(Application);

     frmProduto.Show;
   finally
      Screen.Cursor := crDefault;

   end;
end;

end.
