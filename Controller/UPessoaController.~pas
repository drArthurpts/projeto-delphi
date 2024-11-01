unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa, UEndereco;

type
   TPessoaController = class
      public
         constructor Create;
         function GravaPessoa(pPessoa : TPessoa;
                              pColEndereco : TColEndereco) : Boolean;

         function ExcluiPessoa (pPessoa : TPessoa) : Boolean;
         function PesquisaPessoa(pNome : String) : TColPessoa;
         function BuscaPessoa(pID : Integer) : TPessoa;

         function BuscaEnderecoPessoa(pID_Pessoa : Integer)  :  TColEndereco;

         function RetornaCondicaoPessoa(
                  pId_Pessoa : Integer;
                   pRelacionada : Boolean = False) : String;

         function ValidaCPF(const CPF : String) : Boolean;

         function ValidaCNPJ (const CNPJ : String) : Boolean;

         published
            class function  getInstancia : TPessoaController;

   end;

var
   _instance: TPessoaController;

implementation

uses UPessoaDAO, UEnderecoDAO;

{ TPessoaController }

function TPessoaController.BuscaEnderecoPessoa(
  pID_Pessoa: Integer): TColEndereco;
var
   xEnderecoDAO : TEnderecoDAO;
begin
   try
       try
         Result := nil;

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.getInstance.getConn);

         Result :=
            xEnderecoDAO.RetornaLista(RetornaCondicaoPessoa(pID_Pessoa, True));
       finally
         if (xEnderecoDAO <> nil) then
            FreeAndNil(xEnderecoDAO);
       end;
   except
       on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados do endereço da pessoa. [Controller]' + #13+
            e.Message);
      end;
   end;

end;

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
      on E : Exception do
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

function TPessoaController.ExcluiPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO   : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO := TEnderecoDAO.Create(TConexao.get.getConn);

         if (pPessoa.Id = 0) then
            Exit
         else
         begin
            xPessoaDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id));
            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
         end;


         TConexao.get.confirmaTransacao;

         Result := True;

      finally
         if xPessoaDAO <> nil then
            FreeAndNil(xPessoaDAO);

         if xEnderecoDAO <> nil then
            FreeAndNil(xEnderecoDAO);
      end;
   except
       on E : Exception do
       begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
               'Falha ao escluir os dados da pessoa [Controller]: ' + #13 +
                e.Message);
       end;

   end;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
   if _instance = nil then
      _instance := TPessoaController.Create;

   Result := _instance;

end;

function TPessoaController.GravaPessoa(
   pPessoa: TPessoa ;
   pColEndereco : TColEndereco): Boolean;
var
   xPessoaDAO   : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
   xAux : Integer;

begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;

         xPessoaDAO :=
            TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.get.getConn);

         if pPessoa.Id = 0 then
         begin
            xPessoaDAO.Insere(pPessoa);

            for xAux := 0 to pred(pColEndereco.Count) do
               pColEndereco.Retorna(xAux).ID_Pessoa := pPessoa.Id;
               

            xEnderecoDAO.InsereLista(pColEndereco)
         end
         else
         begin

            xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));
            
            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
            xEnderecoDAO.InsereLista(pColEndereco);
         end;

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

function TPessoaController.PesquisaPessoa(pNome: String): TColPessoa;
var
   xPessoaDAO : TPessoaDAO;
   xCondicao : string;
begin
   try
       try
         Result := nil;

         xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pNome <> EmptyStr,
               'WHERE  ' + #13+
               '    (NOME LIKE ''%' + pNome + '%'') '+ #13
               + 'ORDER BY NOME, ID', EmptyStr);
               

         Result := xPessoaDAO.RetornaLista(xCondicao);
       finally
          if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);
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

function TPessoaController.RetornaCondicaoPessoa(
  pId_Pessoa: Integer ; pRelacionada : Boolean): String;
var
    xChave : String;
begin
   if (pRelacionada = True) then
       xChave := 'ID_PESSOA'
   else
       xChave := 'ID';

   Result :=
   'WHERE ' + #13 +
   '    ' + xChave + '  =  ' + QuotedStr(IntToStr(pId_Pessoa)) + ' '#13;
end;


function TPessoaController.ValidaCNPJ(const CNPJ: String): Boolean;
var
  Soma, Resto, DigitoVerificador1, DigitoVerificador2: Integer;
  i: Integer;
  Peso1: array[1..12] of Integer;
  Peso2: array[1..13] of Integer;
begin
 
  Peso1[1] := 5; Peso1[2] := 4; Peso1[3] := 3; Peso1[4] := 2;
  Peso1[5] := 9; Peso1[6] := 8; Peso1[7] := 7; Peso1[8] := 6;
  Peso1[9] := 5; Peso1[10] := 4; Peso1[11] := 3; Peso1[12] := 2;

  Peso2[1] := 6; Peso2[2] := 5; Peso2[3] := 4; Peso2[4] := 3;
  Peso2[5] := 2; Peso2[6] := 9; Peso2[7] := 8; Peso2[8] := 7;
  Peso2[9] := 6; Peso2[10] := 5; Peso2[11] := 4; Peso2[12] := 3;
  Peso2[13] := 2;

  Result := False;


  if Length(CNPJ) <> 14 then
    Exit;


  if CNPJ = StringOfChar(CNPJ[1], 14) then
    Exit;

  Soma := 0;
  for i := 1 to 12 do
    Soma := Soma + StrToInt(CNPJ[i]) * Peso1[i];

  Resto := Soma mod 11;
  if Resto < 2 then
    DigitoVerificador1 := 0
  else
    DigitoVerificador1 := 11 - Resto;


  if DigitoVerificador1 <> StrToInt(CNPJ[13]) then
    Exit;


  Soma := 0;
  for i := 1 to 13 do
    Soma := Soma + StrToInt(CNPJ[i]) * Peso2[i];

  Resto := Soma mod 11;
  if Resto < 2 then
    DigitoVerificador2 := 0
  else
    DigitoVerificador2 := 11 - Resto;


  if DigitoVerificador2 = StrToInt(CNPJ[14]) then
    Result := True;
end;

function TPessoaController.ValidaCPF(const CPF: String): Boolean;
var
   Soma,
   Resto,
   DigitoVerificador1,
   DigitoVerificador2 : Integer;
   i: Integer;
begin

   Result := False;

   if Length(CPF) <> 11 then
      exit;

   if (CPF = '11111111111') or (CPF = '22222222222') or
      (CPF = '33333333333') or (CPF = '44444444444') or
      (CPF = '55555555555') or (CPF = '66666666666') or
      (CPF = '77777777777') or (CPF = '88888888888') or
      (CPF = '99999999999') then
      exit;

   Soma := 0;

   for i := 1 to 9 do
      Soma := Soma + StrToInt(CPF[i]) * (11 - i);

   Resto := (Soma * 10) mod 11;

   if (Resto = 10) or (Resto = StrToInt(CPF[10])) then
   begin
      Soma := 0;
      for i := 1 to 10 do
         Soma := Soma + StrToInt(CPF[i]) * (12 - i);
      Resto := (Soma * 10 ) mod 11;
      if (Resto = 10) or (Resto =  StrToInt(CPF[11])) then
      begin
         Result := True;
         exit;
      end;
   end;
end;

end.


