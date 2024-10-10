unit UUnidadeProduto;

interface

uses SysUtils, Classes;

type
   TUnidadeProduto = Class(TPersistent)

//      ID         INTEIRO NOT NULL /* INTEIRO = INTEGER */,
//      ATIVO      INTEIRO /* INTEIRO = INTEGER */,
//      UNIDADE    VARCHAR2 /* VARCHAR2 = VARCHAR(2) */,
//      DESCRICAO  VARCHAR20 /* VARCHAR20 = VARCHAR(20) */



       private
          vId        : Integer;
          vAtivo     : Boolean;
          vUnidade   : String;
          vDescricao : String;
          vCodigo    : String;



       public
          constructor Create;
       published
            property Id        : Integer read vId write vId;
            property Ativo     : Boolean read vAtivo write vAtivo;
            property Unidade   : String  read vUnidade write vUnidade;
            property Codigo    : String  read vCodigo write vCodigo;
            property Descricao : String  read vDescricao write vDescricao;
   end;

   TColUnidadeProd = Class(TList)
      public
         function Retorna(pIndex : Integer) : TUnidadeProduto;
         procedure Adiciona(PUnidadeProduto : TUnidadeProduto);
    end;
implementation

{ TUnidadeProduto }

constructor TUnidadeProduto.Create;
begin
    Self.vId        := 0;
    Self.vAtivo     := False;
    Self.vUnidade   := EmptyStr;
    Self.vDescricao := EmptyStr;
    Self.vCodigo    := EmptyStr;
end;

{ TColUnidadeProd }

procedure TColUnidadeProd.Adiciona(pUnidadeProduto: TUnidadeProduto);
begin
   Self.Add(TUnidadeProduto(pUnidadeProduto))
end;

function TColUnidadeProd.Retorna(pIndex: Integer): TUnidadeProduto;
begin
   Result := TUnidadeProduto(Self[pIndex]);  
end;

end.
