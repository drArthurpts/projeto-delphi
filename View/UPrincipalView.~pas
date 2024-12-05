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
    procedure menVendasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UConexao, UClientesView, UUnidadeProdView, UProdutoView, UVendaView;

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
  Close; 
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
   stbBarraStatus.Panels[0].Text :=
      'Caminho BD: ' + TConexao.get.getCaminhoBanco;
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
    Screen.Cursor := crHourGlass;
   try
      if not Assigned(frmProduto) then
         frmProduto := TfrmProduto.Create(Application);

      frmProduto.ShowModal;
   finally
      if Assigned(frmProduto) then
         FreeAndNil(frmProduto); 
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmPrincipal.menVendasClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;
     if (frmVenda = nil) then
         frmVenda := TfrmVenda.Create(Application);

     frmVenda.ShowModal;
   finally
      Screen.Cursor := crDefault;

   end;
end;

end.
