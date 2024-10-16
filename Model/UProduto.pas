unit UProduto;

interface

type
   TProduto = class

private
    vID: Integer;
    vDescricao        : string;
    vUnidade          : string;
    FQuantidadeEstoque: Integer;
    FPrecoVenda       : Double;

public
    property ID               : Integer read vID write vID;
    property Descricao        : string read vDescricao write vDescricao;
    property UnidadeSaida     : string read vUnidadeSaida write vUnidadeSaida;
    property QuantidadeEstoque:
             Double read vQuantidadeEstoque write vQuantidadeEstoque;
    property PrecoVenda       : Double read vPrecoVenda write vPrecoVenda;
    property Imagem           : TBlobField read vImagem write vImagem;
  end;

implementation

end.
 