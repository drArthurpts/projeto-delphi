unit UVendaItemController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVendaItem;

type
   TVendaItemController = class
      public
         constructor Create;
         function GravaVenda(pColVendaItem : TColVendaItem)  : Boolean;


         function PesquisaVenda(pVendaItem : String)   : TColVendaItem;

         function BuscaVenda(pID : Integer)            : TColVendaItem;
         function RetornaCondicaoVenda(
                          pID : Integer)               : String;
         published
            class function getInstancia                : TVendaItemController;

         end;


implementation

uses UVendaItemDAO;

var
   _instance : TVendaItemController;



{ TVendaItemController }

function TVendaItemController.BuscaVenda(pID: Integer): TColVendaItem;
var
   xVendaItemDAO : TVendaItemDAO;
begin
   try
       try
         Result := nil;

         xVendaItemDAO := TVendaItemDAO.Create(
                            TConexao.getInstance.getConn);

         Result := xVendaItemDAO.RetornaLista(RetornaCondicaoVenda(pID));
       finally
         if (xVendaItemDAO <> nil) then
            FreeAndNil(xVendaItemDAO);

       end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados. [Controller]' + #13 +
            e.Message);
      end;
   end;
end;

constructor TVendaItemController.Create;
begin
   inherited Create;
end;

class function TVendaItemController.getInstancia: TVendaItemController;
begin
   if _instance = nil then
      _instance := TVendaItemController.Create;

   Result := _instance;
end;

function TVendaItemController.GravaVenda(pColVendaItem: TColVendaItem): Boolean;
var
   xVendaItemDAO : TVendaItemDAO;
   xAux          : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xVendaItemDAO := nil;
         xVendaItemDAO := TVendaItemDAO.Create(TConexao.get.getConn);

         if (pColVendaItem.Retorna(0).ID = 0) then
            xVendaItemDAO.InsereLista(pColVendaItem);

         TConexao.get.confirmaTransacao;
      finally
         if (xVendaItemDAO <> nil) then
            FreeAndNil(xVendaItemDAO)
      end
   except
      on E: Exception do
       begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
            'Falha ao gravar dados do Item Venda. [Controller]'+ #13 +
            e.Message);
       end;
   end;
end;

function TVendaItemController.PesquisaVenda(pVendaItem: String): TColVendaItem;
begin

end;

function TVendaItemController.RetornaCondicaoVenda(pID: Integer): String;
var
   xChave : String;

begin
   xChave := 'ID_VENDA';

   Result :=
   'WHERE ' +                                                       #13+
   '      ' + xChave+ ' = ' + QuotedStr(IntToStr(pID)) + ' '#13;
end;

end.
 