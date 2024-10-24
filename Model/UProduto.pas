unit UProduto;

interface

uses SysUtils, Classes;

type
   TProduto = class(TPersistent)

      private
          vID               : Integer;
          vDescricao        : String;
          vUnidade_ID       : Integer;
          vQuantidadeEstoque: Double;
          vPrecoVenda       : Double;

      public
         constructor Create;
      published
          property ID               : Integer read vID write vID;
          property Descricao        : string  read vDescricao write vDescricao;
          property Unidade_ID       : Integer  read vUnidade_ID write vUnidade_ID;
          property QuantidadeEstoque: Double  read vQuantidadeEstoque write vQuantidadeEstoque;
          property PrecoVenda       : Double  read vPrecoVenda write vPrecoVenda;

        end;

  TColProduto = class(TList)
      public
         function  Retorna(pIndex : Integer) : TProduto;
         procedure Adiciona(pProduto : TProduto);
  end;
implementation

constructor TProduto.Create;
begin
    Self.vID                := 0;
    Self.vDescricao         := EmptyStr;
    Self.vUnidade_ID        := 0;
    Self.vQuantidadeEstoque := 0;
    Self.vPrecoVenda        := 0;
end;


{ TColProduto }

procedure TColProduto.Adiciona(pProduto: TProduto);
begin
   Self.Add(TProduto(pProduto));
end;

function TColProduto.Retorna(pIndex: Integer): TProduto;
begin
   Result := TProduto(Self[pIndex]);
end;

end.
