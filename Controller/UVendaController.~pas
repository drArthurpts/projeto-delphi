unit UVendaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVenda;

type
   TVendaController = class
      public
         constructor Create;
         function GravaVenda(pVenda : TVenda)       : Boolean;


         function PesquisaVenda(pVenda : String)   : TColVenda;

         function BuscaVenda(pID : Integer)         : TVenda;
         function RetornaCondicaoVenda(
                          pID : Integer)            : String;
         published
            class function getInstancia             : TVendaController;

         end;

implementation

uses UVendaDAO;

var
   _instance : TVendaController;




{ TVendaController }

function TVendaController.BuscaVenda(pID: Integer): TVenda;
var
   xVendaDAO : TVendaDAO;
begin
   try
       try
         Result := nil;

         xVendaDAO := TVendaDAO.Create(
                            TConexao.getInstance.getConn);

         Result := xVendaDAO.Retorna(RetornaCondicaoVenda(pID));
       finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);

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

constructor TVendaController.Create;
begin
   inherited Create;
end;

class function TVendaController.getInstancia: TVendaController;
begin
   if _instance = nil then
      _instance := TVendaController.Create;

   Result := _instance;
end;

function TVendaController.GravaVenda(pVenda: TVenda): Boolean;
var
   xVendaDAO : TVendaDAO;
   xAux : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xVendaDAO := TVendaDAO.Create(TConexao.get.getConn);

         if pVenda.ID = 0 then
         begin
            xVendaDAO.Insere(pVenda);
         end
         else
         begin
            xVendaDAO.Atualiza(
            pVenda, RetornaCondicaoVenda(pVenda.ID));
         end;

         TConexao.get.confirmaTransacao;
      finally
          if (xVendaDAO <> nil) then
               FreeAndNil(xVendaDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados da Venda [Controller]. ' + #13 +
         e.Message);
      end;
   end;
end;


function TVendaController.PesquisaVenda(pVenda: String): TColVenda;
var
   xVendaDAO : TVendaDAO;
   xCondicao : string;
begin
   try
       try
         Result := nil;

         xVendaDAO := TVendaDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pVenda <> EmptyStr,
               'WHERE  ' + #13+
               '    (ID LIKE ''%' + pVenda + '%'') '+ #13
               + 'ORDER BY ID', EmptyStr);


         Result := xVendaDAO.RetornaLista(xCondicao);
       finally
          if (xVendaDAO <> nil) then
              FreeAndNil(xVendaDAO);
       end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da Venda [Controller]: ' + #13 +
            e.Message);
      end;
   end;
end;

function TVendaController.RetornaCondicaoVenda(pID: Integer): String;
var
   xChave : String;

begin
   xChave := 'ID';

   Result :=
   'WHERE ' +                                                       #13+
   '      ' + xChave+ ' = ' + QuotedStr(IntToStr(pID)) + ' '#13;
end;

end.
 