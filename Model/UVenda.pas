unit UVenda;

interface

uses SysUtils, Classes;

type
   TVenda = Class(TPersistent)

   private
      vID             : Integer;
      vID_Cliente     : Integer;
      vDataVenda      : TDateTime;
      vFaturada       : Integer;
      vTotalAcrescimo : Double;
      vTotalDesconto  : Double;
      vTotalVenda     : Double;
      vNomeCliente    : string;

   public
      constructor Create;
      published
         property ID              : Integer read vID write vID;
         property ID_Cliente      : Integer  read vID_Cliente write vID_Cliente;
         property DataVenda       : TDateTime read vDataVenda write vDataVenda;
         property Faturada        : Integer read vFaturada write vFaturada;
         property TotalAcrescimo  : Double read vTotalAcrescimo write vTotalAcrescimo;
         property TotalDesconto   : Double read vTotalDesconto write vTotalDesconto;
         property TotalVenda      : Double read vTotalVenda write vTotalVenda;
         property NomeCliente     : String read vNomeCliente write vNomeCliente;

      end;

       TColVenda = class(TList)
      public
         function  Retorna(pIndex : Integer) : TVenda;
         procedure Adiciona(pVenda : TVenda);
      end;
implementation

constructor TVenda.Create;
begin
    Self.vID             := 0;
    Self.vID_Cliente     := 0;
    Self.vDataVenda      := 0;
    Self.vFaturada       := 0;
    Self.vTotalAcrescimo := 0;
    Self.vTotalDesconto  := 0;
    Self.TotalVenda      := 0;
    Self.vNomeCliente    := EmptyStr;
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
