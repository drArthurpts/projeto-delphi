unit UUnidadeProdController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProduto;

type
   TUnidadeProdController = class
      public
         constructor Create;
         function GravaUnidadeProd(
                        pUnidadeProduto : TUnidadeProduto) : Boolean;

   end;

implementation

{ TUnidadeProdController }

constructor TUnidadeProdController.Create;
begin
   inherited Create;
end;

function TUnidadeProdController.GravaUnidadeProd(
  pUnidadeProduto: TUnidadeProduto): Boolean;
var
   xUnidadeProdutoDAO : TUnidadeProdutoDAO;
   xAux : Integer;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;


         xUnidadeProdutoDAO := TUnidadeProdutoDAo.Crate(TConexao.get.getConn);
      finally

      end;


   except


   end;

end.
 