unit UVendaItemController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVendaItem;

type
   TVendaItemController = class
      public
         constructor Create;
         function GravaVenda(pVendaItem : TVendaItem)  : Boolean;


         function PesquisaVenda(pVendaItem : String)   : TColVendaItem;

         function BuscaVenda(pID : Integer)            : TVendaItem;
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

function TVendaItemController.BuscaVenda(pID: Integer): TVendaItem;
var
   xVendaItemDAO : TVendaItemDAO;
begin
   try
       try
         Result := nil;

         xVendaItemDAO := TVendaItemDAO.Create(
                            TConexao.getInstance.getConn);

         Result := xVendaItemDAO.Retorna(RetornaCondicaoVenda(pID));
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

end;

class function TVendaItemController.getInstancia: TVendaItemController;
begin

end;

function TVendaItemController.GravaVenda(pVendaItem: TVendaItem): Boolean;
begin

end;

function TVendaItemController.PesquisaVenda(pVendaItem: String): TColVendaItem;
begin

end;

function TVendaItemController.RetornaCondicaoVenda(pID: Integer): String;
begin

end;

end.
 