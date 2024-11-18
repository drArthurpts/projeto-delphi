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
   inherited Create;
end;

class function TVendaItemController.getInstancia: TVendaItemController;
begin
   if _instance = nil then
      _instance := TVendaItemController.Create;

   Result := _instance;
end;

function TVendaItemController.GravaVenda(pVendaItem: TVendaItem): Boolean;
var
   xVendaItemDAO : TVendaItemDAO;
   xAux : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xVendaItemDAO := TVendaItemDAO.Create(TConexao.get.getConn);

         if pVendaItem.ID = 0 then
         begin
            xVendaItemDAO.Insere(pVendaItem);
         end
         else
         begin
            xVendaItemDAO.Atualiza(
            pVendaItem, RetornaCondicaoVenda(pVendaItem.ID));
         end;

         TConexao.get.confirmaTransacao;
      finally
          if (xVendaItemDAO <> nil) then
               FreeAndNil(xVendaItemDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados do Item Venda [Controller]. ' + #13 +
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
   xChave := 'ID';

   Result :=
   'WHERE ' +                                                       #13+
   '      ' + xChave+ ' = ' + QuotedStr(IntToStr(pID)) + ' '#13;
end;

end.
 