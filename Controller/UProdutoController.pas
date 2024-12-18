unit UProdutoController;

interface

uses SysUtils, Math, StrUtils, UConexao, UProduto;

type
   TProdutoController = class
      public
         constructor Create;
         function GravaProduto(
                        pProduto : TProduto)          : Boolean;

         function ExcluiProduto(pProduto : TProduto)  : Boolean;
          function PesquisaProduto(pProduto : String) : TColProduto;

         function BuscaProduto(pID : Integer)         : TProduto;
         function RetornaCondicaoProduto(
                          pID : Integer)      : String;
         published
            class function getInstancia               : TProdutoController;

   end;

implementation

uses UProdutoDAO;

var
   _instance : TProdutoController;

{ TProdutoController }

function TProdutoController.BuscaProduto(pID : Integer):  TProduto;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
       try
         Result := nil;

         xProdutoDAO := TProdutoDAO.Create(
                            TConexao.getInstance.getConn);

         Result := xProdutoDAO.Retorna(RetornaCondicaoProduto(pID));
       finally
         if (xProdutoDAO <> nil) then
            FreeAndNil(xProdutoDAO);

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

constructor TProdutoController.Create;
begin
   inherited Create;
end;

function TProdutoController.ExcluiProduto(pProduto: TProduto): Boolean;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);

         if (pProduto.ID = 0) then
            exit
         else
         begin
            xProdutoDAO.Deleta(
               RetornaCondicaoProduto(pProduto.ID));

         end;
         TConexao.get.confirmaTransacao;

         Result := True;

      finally
         if xProdutoDAO <> nil then
            FreeAndNil(xProdutoDAO);
      end;
   except
       on E : Exception do
       begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
               'Falha ao excluir os dados do Produto [Controller]: ' + #13 +
                e.Message);
       end;

   end;
end;

class function TProdutoController.getInstancia: TProdutoController;
begin
   if _instance = nil then
      _instance := TProdutoController.Create;

   Result := _instance;
end;

function TProdutoController.GravaProduto(pProduto: TProduto): Boolean;
var
   xProdutoDAO : TProdutoDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);
         
         if pProduto.ID = 0 then
         begin
            pProduto.ID := xProdutoDAO.;
         end;

         xProdutoDAO.Insere(pProduto);

         TConexao.get.confirmaTransacao;
      finally
          if Assigned(xProdutoDAO) then
               FreeAndNil(xProdutoDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados do Produto [Controller]. ' + #13 +
         e.Message);
      end;
   end;
end;




function TProdutoController.ObterProximoID: Integer;
begin
  Query.SQL.Text := 'SELECT MAX(ID_PRODUTO) FROM Produto';
  Query.Open;
  if not Query.Fields[0].IsNull then
    Result := Query.Fields[0].AsInteger + 1
  else
    Result := 1;
  Query.Close;
end;

function TProdutoController.PesquisaProduto(
  pProduto: String): TColProduto;
var
   xProdutoDAO : TProdutoDAO;
   xCondicao : string;
begin
   try
       try
         Result := nil;

         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pProduto <> EmptyStr,
               'WHERE  ' + #13+
               '    (DESCRICAO LIKE ''%' + pProduto + '%'') '+ #13
               + 'ORDER BY ID', EmptyStr);


         Result := xProdutoDAO.RetornaLista(xCondicao);
       finally
          if (xProdutoDAO <> nil) then
            FreeAndNil(xProdutoDAO);
       end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados do Produto [Controller]: ' + #13 +
            e.Message);
      end;
   end;
end;

function TProdutoController.RetornaCondicaoProduto(
  pID: Integer): string;
var
   xChave : String;

begin
   xChave := 'ID';

   Result :=
   'WHERE ' +                                                       #13+
   '      ' + xChave+ ' = ' + QuotedStr(IntToStr(pId)) + ' '#13;
end;

end.
