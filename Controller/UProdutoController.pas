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
                          pID_Produto : Integer)      : String;
         published
            class function getInstancia               : TProdutoController;

   end;

implementation

uses UProdutoDAO;

var
   _instance : TProdutoController;

{ TProdutoController }

function TProdutoController.BuscaProduto(pID: Integer): TProduto;
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

         if (pProduto.Id = 0) then
            Exit
         else
         begin
            xProdutoDAO.Deleta(
               RetornaCondicaoProduto(pProduto.Id));

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
               'Falha ao escluir os dados do Produto [Controller]: ' + #13 +
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
   xAux : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;
         xProdutoDAO := TProdutoDAO.Create(TConexao.get.getConn);

         if pProduto.Id = 0 then
         begin
            xProdutoDAO.Insere(pProduto);
         end
         else
         begin
            xProdutoDAO.Atualiza(
            pProduto, RetornaCondicaoProduto(pProduto.Id));
         end;

         TConexao.get.confirmaTransacao;
      finally
          if (xProdutoDAO <> nil) then
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
               + 'ORDER BY DESCRICAO, ID', EmptyStr);


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
