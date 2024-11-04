unit UVendaItem;

interface

uses SysUtils, Classes;

type
   TVendaItem = Class(TPersistent)

   private
      vID            : Integer;
      vIDVenda       : Integer;
      vIDProduto     : Integer;
      vQuantidade    : Integer;
      vUnidade       : string;
      vTotalDesc     : Double;
      vValorUnidade  : Double;
      vTotalItem    : Double;

   public
      constructor Create;
      published
         property ID                 : Integer read vID write vID;
         property IDVenda            : Integer read vIDVenda write vIDVenda;
         property IDProduto          : Integer read vIDProduto write vIDProduto;
         property Quantidade         : Integer read vQuantidade write vQuantidade;
         property Unidade            : string read vUnidade write vUnidade;
         property TotalDesc          : Double read vTotalDesc write vTotalDesc;
         property ValorUnidade       : Double read vValorUnidade write vValorUnidade;
         property TotalItem          : Double read  vTotalItem write vTotalItem;
      end;

       TColVendaItem = class(TList)
      public
         function  Retorna(pIndex : Integer) : TVendaItem;
         procedure Adiciona(pVendaItem : TVendaItem);
      end;

implementation



constructor TVendaItem.Create;
begin
   Self.vID                := 0;
   Self.vIDVenda           := 0;
   Self.vIDProduto         := 0;
   Self.vQuantidade        := 0;
   Self.vUnidade           := EmptyStr;
   Self.vTotalDesc         := 0;
   Self.vValorUnidade      := 0;
   Self.vTotalItem         := 0;
end;


procedure TColVendaItem.Adiciona(pVendaItem: TVendaItem);
begin
   Self.Add(TVendaItem(pVendaItem));
end;

function TColVendaItem.Retorna(pIndex: Integer): TVendaItem;
begin
   Result := TVendaItem(Self[pIndex]);
end;

end.
 