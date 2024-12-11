unit UUnidadeProdController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProduto;

type
   TUnidadeProdController = class
      public
         constructor Create;
         function GravaUnidadeProd(
                        pUnidadeProduto : TUnidadeProduto)         : Boolean;

         function ExcluiProduto(pUnidadeProduto : TUnidadeProduto) : Boolean;
          function PesquisaUnidade(pUnidade : String) : TColUnidadeProd;
         function BuscaDescUnidade(pUnidade : string) : TUnidadeProduto;
         function BuscaUnidadeProd(pID : Integer)                  :
         TUnidadeProduto;
         function BuscaUnidadeStr(pUnidade : string) : TUnidadeProduto;
         function RetornaCondicaoUnidadeProd(
                          pID_Produto : Integer)                   : String;
         function RetornaCondicaoStr(pUnidade : string)            : string;
         function RetornaDescUnidade (pUnidade : String)           : String;
         published
            class function getInstancia                            :
            TUnidadeProdController;

   end;


implementation

uses  UUnidadeProdutoDAO;

var
   _instance: TUnidadeProdController;


{ TUnidadeProdController }

function TUnidadeProdController.BuscaDescUnidade(
  pUnidade: string): TUnidadeProduto;
var
   xUnidadeProdDAO : TUnidadeProdutoDAO;
begin
     try
       try
         Result := nil;

         xUnidadeProdDAO := TUnidadeProdutoDAO.Create(
                            TConexao.getInstance.getConn);

         Result := xUnidadeProdDAO.Retorna(RetornaDescUnidade(pUnidade));
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

function TUnidadeProdController.BuscaUnidadeStr(
  pUnidade: string): TUnidadeProduto;
var
   xUnidadeDAO : TUnidadeProdutoDAO;
begin
   try
      try
         Result := nil;

         xUnidadeDAO := TUnidadeProdutoDAO.Create(TConexao.getInstance.getConn);

         Result := xUnidadeDAO.Retorna(RetornaCondicaoStr(pUnidade));

      finally
         if (xUnidadeDAO <> nil) then
            FreeAndNil(xUnidadeDAO);
      end;
   except
      on E : Exception do
      begin
         raise Exception.Create(
         'Falha ao retornar dados da Unidade de Produto. [Controller]'#13 +
         e.Message);
      end;
   end;  
end;

constructor TUnidadeProdController.Create;
begin
   inherited Create;
end;

function TUnidadeProdController.ExcluiProduto(
  pUnidadeProduto: TUnidadeProduto): Boolean;
var
   xUnidadeProdutoDAO  : TUnidadeProdutoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xUnidadeProdutoDAO := TUnidadeProdutoDAO.Create(TConexao.get.getConn);

         if (pUnidadeProduto.Id = 0) then
            Exit
         else
         begin
            xUnidadeProdutoDAO.Deleta(
               RetornaCondicaoUnidadeProd(pUnidadeProduto.Id));

         end;
         TConexao.get.confirmaTransacao;
         Result := True;
      finally
         if xUnidadeProdutoDAO <> nil then
            FreeAndNil(xUnidadeProdutoDAO);
      end;
   except
       on E : Exception do
       begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
               'Falha ao escluir os dados da unidade [Controller]: ' + #13 +
                e.Message);
       end;

   end;
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

function TUnidadeProdController.PesquisaUnidade(
  pUnidade: String): TColUnidadeProd;
var
   xUnidadeDAO : TUnidadeProdutoDAO;
   xCondicao : string;
begin
   try
       try
         Result := nil;

         xUnidadeDAO := TUnidadeProdutoDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pUnidade <> EmptyStr,
               'WHERE  ' + #13+
               '    (UNIDADE LIKE ''%' + pUnidade + '%'') '+ #13
               + 'ORDER BY UNIDADE, ID', EmptyStr);


         Result := xUnidadeDAO.RetornaLista(xCondicao);
       finally
          if (xUnidadeDAO <> nil) then
            FreeAndNil(xUnidadeDAO);
       end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da pessoa [Controller]: ' + #13 +
            e.Message);
      end;
   end;
end;

function TUnidadeProdController.RetornaCondicaoStr(
  pUnidade: string): string;
var
   xChave : string;
begin
   xChave := 'UNIDADE';

   Result :=
   'WHERE                                             '#13+
   '    '+xChave+ ' = ' + QuotedStr(pUnidade)+ ' '#13;
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

function TUnidadeProdController.RetornaDescUnidade(
  pUnidade: String): String;
var
   xChave : String;
begin
   xChave := 'UNIDADE';

   Result :=
   'WHERE ' +                                                       #13+
   '      ' + xChave+ ' = ' + QuotedStr(pUnidade)+ ' '#13;
end;

end.

