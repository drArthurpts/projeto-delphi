unit UVenda;

interface

uses SysUtils, Classes;

type
   TVenda = Class(TPersistent)

   private
      vID          : Integer;
      vIDCliente   : Integer;
      vDataVenda   : TDateTime;
      vFaturada    : Integer;
      vTotalAcresc : Double;
      vTotalDesc   : Double;
      vTotalVenda  : Double;

   public
      constructor Create;
      published
         property ID          : Integer read vID write vID;
         property IDCliente   : Integer  read vIDCliente write vIDCliente;
         property DataVenda   : TDateTime read vDataVenda write vDataVenda;
         property Faturada    : Integer read vFaturada write vFaturada;
         property TotalAcresc : Double read vTotalAcresc write vTotalAcresc;
         property TotalDesc   : Double read vTotalDesc write vTotalDesc;
         property TotalVenda  : Double read vTotalVenda write vTotalVenda;

      end;

       TColVenda = class(TList)
      public
         function  Retorna(pIndex : Integer) : TVenda;
         procedure Adiciona(pVenda : TVenda);
      end;
implementation

constructor TVenda.Create;
begin
    Self.vID                := 0;
    Self.vIDCliente         := 0;
    Self.vDataVenda         := 0;
    Self.vFaturada          := 0;
    Self.vTotalAcresc       := 0;
    Self.vTotalDesc         := 0;
    Self.TotalVenda         := 0;
end;

{ TColVenda }

procedure TColVenda.Adiciona(pVenda: TVenda);
begin
   Self.Add(TVenda(pVenda));
end;

function TColVenda.Retorna(pIndex: Integer): TVenda;
begin
   Result := TVenda(Self[pIndex]);
end;

end.
