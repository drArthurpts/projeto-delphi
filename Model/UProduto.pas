unit UProduto;

interface

type
   TProduto = class

private
    vID: Integer;
    vDescricao        : string;
    vUnidade          : string;
    vQuantidadeEstoque: Integer;
    vPrecoVenda       : Double;

public
    property ID               : Integer read vID write vID;
    property Descricao        : string read vDescricao write vDescricao;
    property Unidade          : string read vUnidade write vUnidade;
    property QuantidadeEstoque:
             Integer read vQuantidadeEstoque write vQuantidadeEstoque;
    property PrecoVenda       : Double read vPrecoVenda write vPrecoVenda;

  end;

implementation

end.
