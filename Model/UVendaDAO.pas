unit UVendaDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db , Classes , SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UVenda, UConexao,UPessoaController,UPessoa;


type
   TVendaDAO = Class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere (pVenda : TVenda)                          : Boolean;
         function InsereLista (pColVenda : TColVenda)               : Boolean;
         function Atualiza(pVenda : TVenda; pCondicao : String)     : Boolean;
         function Retorna (pCondicao : String)                      : TVenda;
         function RetornaLista (pCondicao : String = '')            : TColVenda;
         function RetornaColecaoVenda(pDataIni: String; pDataFim    : String;
            pCodVenda: Integer): TColVenda;
private
   vObjVenda : TVenda;

end;

implementation


function TVendaDAO.Atualiza(pVenda: TVenda;
  pCondicao: String): Boolean;
begin
    Result := inherited Atualiza(pVenda, pCondicao);
end;

constructor TVendaDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'VENDA';
   vConexao  := pConexao;
   vClass    := TVenda;
end;

function TVendaDAO.Insere(pVenda: TVenda): Boolean;
begin
   Result := inherited Insere(pVenda, 'ID');
end;

function TVendaDAO.InsereLista(pColVenda: TColVenda): Boolean;
begin
   Result  := inherited InsereLista(pColVenda);
end;

function TVendaDAO.Retorna(pCondicao: String): TVenda;
begin
   Result := TVenda(inherited Retorna(pCondicao));
end;

function TVendaDAO.RetornaColecaoVenda(pDataIni, pDataFim: String;
  pCodVenda: Integer): TColVenda;
var
   xQryColVenda : TSQLQuery;
   xVenda       : TVenda;
   xColVenda    : TColVenda;
begin
   try
      try
         xColVenda := nil;
         xColVenda := TColVenda.Create;

         xVenda := nil;

         xQryColVenda := nil;
         xQryColVenda := TSQLQuery.Create(Nil);
         xQryColVenda.SQLConnection := vConexao;
         xQryColVenda.Close;
         xQryColVenda.SQL.Clear;
         xQryColVenda.SQL.Text :=
            'SELECT * FROM VENDA                               '+
            ' WHERE DATAVENDA BETWEEN :DATAINIC AND :DATAFIM ';


         if pCodVenda > 0 then
         begin
            xQryColVenda.SQL.Text := xQryColVenda.SQL.Text +
            '   AND VENDA.ID = :CODVENDA';
            xQryColVenda.ParamByName('CODVENDA').AsString:= IntToStr(pCodVenda);
         end;

         xQryColVenda.ParamByName('DATAINIC').AsDate := StrToDate(pDataIni);
         xQryColVenda.ParamByName('DATAFIM').AsDate := StrToDate(pDataFim);

         xQryColVenda.Open;

         if not xQryColVenda.IsEmpty then
         begin
            xQryColVenda.First;
            while not xQryColVenda.Eof do
            begin
               xVenda := TVenda.Create;
               xVenda.ID          := xQryColVenda.FieldByName('ID').AsInteger;
               xVenda.DataVenda   := (xQryColVenda.FieldByName('DATAVENDA').AsDateTime);
               xVenda.TotalDesconto := xQryColVenda.FieldByName('TOTALDESCONTO').AsFloat;
               xVenda.TotalVenda  := xQryColVenda.FieldByName('TOTALVENDA').AsFloat;
               xVenda.ID_Cliente  := xQryColVenda.FieldByName('ID_CLIENTE').AsInteger;
               xVenda.FormaPagamento := xQryColVenda.FieldByName('FORMAPAGAMENTO').AsString;
               xColVenda.Adiciona(xVenda);
               xQryColVenda.Next;
            end;
         end;
        Result := xColVenda;
      except
         on E: Exception do
            raise Exception.Create('Falha ao buscar vendas no banco de dados.' +
               E.Message);
      end;
   finally
      if xQryColVenda <> nil then
      begin
         xQryColVenda.Close;
         FreeAndNil(xQryColVenda);
      end;
   end;
end;

function TVendaDAO.RetornaLista(pCondicao: String): TColVenda;
begin
   Result := TColVenda(inherited RetornaLista(pCondicao));
end;

end.

