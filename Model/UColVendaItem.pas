unit UColVendaItem;

interface

uses SysUtils, Classes;

type
   TColVendaItem = class(TList)

   private
      vID         : Integer
      vQuantidade : Integer;
    function vQuantidade: Integer;

   public

      function  Retorna(pIndex : Integer) : TColVendaItem;
      procedure Adiciona(pColVendaItem : TColVendaItem);

      constructor Create;

      published
         property ID         : Integer read vID write vID;
         property Quantidade : Integer read vQuantidade write vQuantidade;

      end;


implementation

{ TColVendaItem }

procedure TColVendaItem.Adiciona(pColVendaItem: TColVendaItem);
begin
   Self.Add(TColVendaItem(pColVendaItem));
end;

constructor TColVendaItem.Create;
begin
   Self.vID         := 0;
   Self.vQuantidade := 0;
end;

function TColVendaItem.Retorna(pIndex: Integer): TColVendaItem;
begin
   Result := TColVendaItem(Self[pIndex]);
end;


end.
