unit UPrincipalView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, DBCtrls, ExtCtrls, pngimage;

type
  TfrmPrincipal = class(TForm)
    MainCadastro: TMainMenu;
    menMenu: TMenuItem;
    menCliente: TMenuItem;
    MenProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menRelVendas: TMenuItem;
    MenMovimentos: TMenuItem;
    menVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    imgLogo: TImage;
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClienteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
  Close; //Fecha o sistema
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  stbBarraStatus.Panels[0].Text := 'Teste';
end;

procedure TfrmPrincipal.menClienteClick(Sender: TObject);
begin
// 
end;

end.
