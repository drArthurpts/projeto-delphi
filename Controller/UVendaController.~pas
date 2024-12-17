unit UVendaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVenda;

type
   TVendaController = class
      public
         constructor Create;
         function GravaVenda(pVenda : TVenda)       : Boolean;


         function PesquisaVenda(pCodigoVenda : Integer;
                  pDataInicio : String; pDataFim : String) : TColVenda;

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
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xVendaDAO := nil;

         xVendaDAO := TVendaDAO.Create(TConexao.get.getConn);

         if (pVenda.ID = 0) then
            xVendaDAO.Insere(pVenda);

         TConexao.get.confirmaTransacao;
      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);
      end;
   except
       on E: Exception do
       begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
            'Falha ao gravar dados da venda. [Controller]'+ #13 +
            e.Message);
       end;
   end;
end;


function TVendaController.PesquisaVenda(pCodigoVenda: Integer;
  pDataInicio : String ; pDataFim: String): TColVenda;
var
   xVendaDAO    : TVendaDAO;
   xListaVendaC : TColVenda;
   xCondicao    : string;
   xVenda       : TVenda;
begin
   try
      try
         Result := nil;

         xListaVendaC := nil;
         xListaVendaC := TColVenda.Create;

         xVendaDAO := TVendaDAO.Create(TConexao.getInstance.getConn);
         xListaVendaC :=
            xVendaDAO.RetornaColecaoVenda(pDataInicio, pDataFim, pCodigoVenda);

         Result := xListaVendaC;
      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
            'Falha ao pesquisar dados da venda. [Controller]'#13 +
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
   'WHERE ' +                                               #13+
   '      ' + xChave+ ' = ' + QuotedStr(IntToStr(pID)) + ' '#13;
end;

end.
 