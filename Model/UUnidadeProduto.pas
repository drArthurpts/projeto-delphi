unit UUnidadeProduto;

interface

uses SysUtils, Classes;

type
   TUnidadeProduto = Class(TPersistent)

       private
          vId        : Integer;
          vAtivo     : Boolean;
          vUnidade   : String;
          vDescricao : String;


       public
          constructor Create;
       published
            property Id        : Integer read vId write vId;
            property Ativo     : Boolean read vAtivo write vAtivo;
            property Unidade   : String  read vUnidade write vUnidade;
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
end;

{ TColUnidadeProd }

procedure TColUnidadeProd.Adiciona(pUnidadeProduto: TUnidadeProduto);
begin
   Self.Add(TUnidadeProduto(pUnidadeProduto));
end;

function TColUnidadeProd.Retorna(pIndex: Integer): TUnidadeProduto;
begin
   Result := TUnidadeProduto(Self[pIndex]);
end;
end.
