unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa;

type
   TPessoaController = class
      public
         constructor Create;
         function GravaPessoa(pPessoa : TPessoa) : Boolean;

         function BuscaPessoa(pID : Integer) : TPessoa;

         function RetornaCondicaoPessoa(pId_Pessoa : Integer) : String;
         published
            class function  getInstancia : TPessoaController;

   end;

var
   _instance: TPessoaController;

implementation

uses UPessoaDAO;

{ TPessoaController }

function TPessoaController.BuscaPessoa(pID: Integer): TPessoa;
var
      xPessoaDAO : TPessoaDAO ;
begin
   try
      try
         Result := nil;

         xPessoaDAO := TPessoaDAO.Create(TConexao.getInstance.getConn);
         Result := xPessoaDAO.Retorna(RetornaCondicaoPessoa(pID));
      finally
         if(xPessoaDAO <> nil) then
         FreeAndNil(xPessoaDAO);
      end;
   except
      on E : Excpetion do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da pessoa. [Controller]' + #13+       
            e.Message);
      end;
   end;
end;

constructor TPessoaController.Create;
begin
   inherited Create;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
   if _instance = nil then
      _instance := TPessoaController.Create;

   Result := _instance;

end;

function TPessoaController.GravaPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO : TPessoaDAO;
   xAux : Integer;

begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;

         xPessoaDAO :=
         TPessoaDAO.Create(TConexao.get.getConn);

         if pPessoa.Id = 0 then
            xPessoaDAO.Insere(pPessoa)
         else
            xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));

         TConexao.get.confirmaTransacao;
      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados da pessoa [Controller]. ' + #13 +
         e.Message);
      end;
   end;
end;

function TPessoaController.RetornaCondicaoPessoa(
  pId_Pessoa: Integer): String;

var
   xChave : String;
begin
   xChave := 'ID';

   Result :=
   'WHERE ' + #13 +
   '    ' + xChave + '  =  ' + QuotedStr(IntToStr(pId_Pessoa)) + ' '#13;
end;

end.
 