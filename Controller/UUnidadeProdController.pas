unit UUnidadeProdController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProduto;

type
   TUnidadeProdController = class
      public
         constructor Create;
         function GravaUnidadeProd(
                        pUnidadeProduto : TUnidadeProduto) : Boolean;

         function BuscaUnidadeProd(pID : Integer)          : TUnidadeProduto;
         function RetornaCondicaoUnidadeProd(
                          pID_Produto : Integer)           : String;
         published
            class function getInstancia                    :
            TUnidadeProdController;

   end;


implementation

uses  UUnidadeProdutoDAO;

var
   _instance: TUnidadeProdController;


{ TUnidadeProdController }

function TUnidadeProdController.BuscaUnidadeProd(
  pID: Integer): TUnidadeProduto;
var
   xUnidadeProdDAO : TUnidadeProdutoDAO;
begin
   try
       try
         Result := nil;

         xUnidadeProdDAO := TUnidadeProdutoDAO.Create(
                            TConexao.getInstance.getConn);

         Result := xUnidadeProdDAO.Retorna(RetornaCondicaoUnidadeProd(pID));
       finally
         if (xUnidadeProdDAO <> nil) then
            FreeAndNil(xUnidadeProdDAO);

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

constructor TUnidadeProdController.Create;
begin
   inherited Create;
end;

class function TUnidadeProdController.getInstancia: TUnidadeProdController;
begin
   if _instance = nil then
      _instance := TUnidadeProdController.Create;

   Result := _instance;
end;

function TUnidadeProdController.GravaUnidadeProd(
  pUnidadeProduto: TUnidadeProduto): Boolean;
var
   xUnidadeProdutoDAO : TUnidadeProdutoDAO;
   xAux : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;


         xUnidadeProdutoDAO := TUnidadeProdutoDAO.Create(TConexao.get.getConn);

         if pUnidadeProduto.Id = 0 then
         begin
            xUnidadeProdutoDAO.Insere(pUnidadeProduto);
         end
         else
         begin
            xUnidadeProdutoDAO.Atualiza(
            pUnidadeProduto, RetornaCondicaoUnidadeProd(pUnidadeProduto.Id));


         end;
         TConexao.get.confirmaTransacao;
      finally
          if (xUnidadeProdutoDAO <> nil) then
               FreeAndNil(xUnidadeProdutoDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados de Unidade do Produto [Controller]. ' + #13 +
         e.Message);
      end;
   end;
   end;

function TUnidadeProdController.RetornaCondicaoUnidadeProd(
  pID_Produto: Integer): String;
var
   xChave : String;
begin
   xChave := 'ID';

   Result :=
   'WHERE ' +                                                       #13+
   '      ' + xChave+ ' = ' + QuotedStr(IntToStr(pID_Produto))+ ' '#13;
end;

end.
 