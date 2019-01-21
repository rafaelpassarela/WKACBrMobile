unit UNFCeClass;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  MVCFramework.Serializer.Commons;

type
  [MapperJSONNaming(JSONNameLowerCase)]
  TNFCeItem = class
  private
    FValor: double;
    FDescricao: string;
    FId: Integer;
    FQuantidade: integer;
  public
    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: double read FValor write FValor;
    property Quantidade: integer read FQuantidade write FQuantidade;
  end;

  [MapperJSONNaming(JSONNameLowerCase)]
  TNFCe = class
  private
    FItens: TObjectList<TNFCeItem>;
    Fcpf: string;
    FNome: string;
    FNumero: integer;
    procedure Setcpf(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    function AsJsonString: String;

    property Numero: integer read FNumero write FNumero;
    property cpf: string read Fcpf write Setcpf;
    property Nome: string read FNome write FNome;

    [MapperListOf(TNFCeItem)]
    property Itens: TObjectList<TNFCeItem> read FItens write FItens;
  end;

implementation

uses
  ACBrValidador,
  MVCFramework.DataSet.Utils,
  MVCFramework.Serializer.JsonDataObjects,
  JsonDataObjects;

{ TNFCe }

function TNFCe.AsJsonString: String;
var
  Serializar: TMVCJsonDataObjectsSerializer;
  JsonObj: TJSONObject;
begin
  Serializar := TMVCJsonDataObjectsSerializer.Create;
  JsonObj := TJSONObject.Create;
  try
    Serializar.ObjectToJSONObject(Self, JsonObj, stDefault, []);
    Result := JsonObj.ToJSON;
  finally
    Serializar.Free;
    JsonObj.Free;
  end;
end;

constructor TNFCe.Create;
begin
  inherited create;
  FItens := TObjectList<TNFCeItem>.Create;
end;

destructor TNFCe.Destroy;
begin
  FItens.Free;
  inherited;
end;

procedure TNFCe.Setcpf(const Value: string);
var
  SMsgErro: string;
begin
  Fcpf := Value;
  if not Fcpf.Trim.IsEmpty then
  begin
    SMsgErro := ACBrValidador.ValidarCNPJouCPF(Value);
    if not SMsgErro.Trim.IsEmpty then
      raise Exception.Create(SMsgErro);
  end;
end;

end.