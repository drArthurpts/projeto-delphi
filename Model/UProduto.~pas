unit UProduto;

interface

uses SysUtils, Classes;

type
   TProduto = class(TPersistent)

      private
          vID               : Integer;
          vDescricao        : string;
          vQuantidadeEstoque: Double;
          vPrecoVenda       : Double;
          vUnidade          : string;

      public
         constructor Create;
      published
          property ID               : Integer read vID write vID;
          property Descricao        : string  read vDescricao write vDescricao;
          property QuantidadeEstoque: Double  read vQuantidadeEstoque write vQuantidadeEstoque;
          property PrecoVenda       : Double  read vPrecoVenda write vPrecoVenda;
          property Unidade          :  string read vUnidade write vUnidade;

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
    Self.vQuantidadeEstoque := 0;
    Self.vPrecoVenda        := 0;
    Self.vUnidade           := EmptyStr;
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
