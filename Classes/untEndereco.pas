unit untEndereco;

interface

uses SysUtils, Classes, System.JSON,
     IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TBuscaCEP = class(TComponent)
  private
    _Cep: String;
    _Logradouro: String;
    _Complemento: String;
    _Bairro: String;
    _Localidade: String;
    _UF: String;
    _IBGE: String;
    _Gia: String;
    _DDD: String;
    _Siafi: String;
    procedure SetCep(const Value: String);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;
    property Cep: String read _Cep write SetCep;
    property Logradouro: String read _Logradouro;
    property Complemento: String read _Complemento;
    property Bairro: String read _Bairro;
    property Localidade: String read _Localidade;
    property UF: String read _UF;
    property IBGE: String read _IBGE;
    property Gia: String read _Gia;
    property DDD: String read _DDD;
    property Siafi: String read _Siafi;
  end;

  TEndereco = class(TComponent)
  private
    _Cep: String;
    _Logradouro: String;
    _Numero: String;
    _Complemento: String;
    _Bairro: String;
    _Cidade: String;
    _Estado: String;
    _Pais: String;

  public
    constructor Create(AOwner: TComponent);
    procedure ReadCEP(iCep: String);

    property Cep: String read _Cep write _Cep;
    property Logradouro: String read _Logradouro write _Logradouro;
    property Numero: String read _Numero write _Numero;
    property Complemento: String read _Complemento write _Complemento;
    property Bairro: String read _Bairro write _Bairro;
    property Cidade: String read _Cidade write _Cidade;
    property Estado: String read _Estado write _Estado;
    property Pais: String read _Pais write _Pais;
  end;

implementation

{ TEndereco }

constructor TEndereco.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TEndereco.ReadCEP(iCep: String);
var
  lObjBuscaCep: TBuscaCEP;
begin
  lObjBuscaCep := TBuscaCEP.Create(self);
  try
    lObjBuscaCep.Cep := iCep;
    _Cep := iCep;
    _Logradouro := lObjBuscaCep.Logradouro;
    _Complemento := lObjBuscaCep.Complemento;
    _Bairro := lObjBuscaCep.Bairro;
    _Cidade := lObjBuscaCep.Localidade;
    _Estado := lObjBuscaCep.UF;
    _Pais := 'Brasil';
  finally
    FreeAndNil(lObjBuscaCep);
  end;
end;

{ TBuscaCEP }

constructor TBuscaCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBuscaCEP.Destroy;
begin
  inherited;
end;

procedure TBuscaCEP.SetCep(const Value: String);
var
  lObjHTTP : TIdHTTP;
  lObjJson: TJSONObject;
  lResponse,
  lCepLimpo: String;
begin
  lCepLimpo := StringReplace(Value,'.','',[rfReplaceAll]);
  lCepLimpo := StringReplace(lCepLimpo,'-','',[rfReplaceAll]);

  lObjHTTP := TIdHTTP.Create(Self);
  try
    lResponse := lObjHTTP.Get('http://viacep.com.br/ws/'+lCepLimpo+'/json/');

    if lObjHTTP.ResponseCode <> 200 then
      raise Exception.Create('Falha ao consultar CEP!'#13+lResponse);

  finally
    FreeAndNil(lObjHTTP);
  end;

  lObjJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(lResponse), 0) as TJSONObject;
  try
    _Cep := lObjJson.Get('cep').JsonValue.Value;
    _Logradouro := lObjJson.Get('logradouro').JsonValue.Value;
    _Complemento := lObjJson.Get('complemento').JsonValue.Value;
    _Bairro := lObjJson.Get('bairro').JsonValue.Value;
    _Localidade := lObjJson.Get('localidade').JsonValue.Value;
    _UF := lObjJson.Get('uf').JsonValue.Value;
    _IBGE := lObjJson.Get('ibge').JsonValue.Value;
    _Gia := lObjJson.Get('gia').JsonValue.Value;
    _DDD := lObjJson.Get('ddd').JsonValue.Value;
    _Siafi := lObjJson.Get('siafi').JsonValue.Value;
  finally
    FreeAndNil(lObjJson)
  end;
end;

end.
