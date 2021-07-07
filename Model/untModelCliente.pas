unit untModelCliente;

interface

uses SysUtils, Classes, untEndereco;

type
  TModelCliente = class(TComponent)
  private
    _Codigo: Integer;
    _Nome: String;
    _Identidade: String;
    _CPF: String;
    _Telefone: String;
    _Email: String;
    _Endereco: TEndereco;
    function getEndereco: TEndereco;
    procedure setEndereco(const Value: TEndereco);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;

    procedure Limpar;
    function DadosValidos(var oValid: String): Boolean;

    property Codigo: Integer read _Codigo write _Codigo;
    property Nome: String read _Nome write _Nome;
    property Identidade: String read _Identidade write _Identidade;
    property CPF: String read _CPF write _CPF;
    property Telefone: String read _Telefone write _Telefone;
    property Email: String read _Email write _Email;
    property Endereco: TEndereco read getEndereco write setEndereco;
  end;

implementation

function iif(iValid: Boolean; iValueTrue, iValueFalse: String): String;
begin
  if iValid then
    result := iValueTrue
  else
    result := iValueFalse;
end;

{ TModelCliente }

constructor TModelCliente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TModelCliente.DadosValidos(var oValid: String): Boolean;
begin
  result := True;
  {Validar Campos Obrigatórios}
  if _Codigo <= 0 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Código é Obrigatório.';
    result := False;
  end;

  if _Nome = '' then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Nome é Obrigatório.';
    result := False;
  end;

  if _Identidade = '' then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Identidade é Obrigatória.';
    result := False;
  end;

  if _CPF = '' then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'CPF é Obrigatório.';
    result := False;
  end;

  {Tamanho dos Campos}
  if length(_Nome) > 255 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Nome deve ter até 255 caracteres.';
    result := False;
  end;

  if length(_Identidade) > 20 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Identidade deve ter até 20 caracteres.';
    result := False;
  end;

  if length(_CPF) > 16 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'CPF deve ter até 16 caracteres.';
    result := False;
  end;

  if length(_Telefone) > 20 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Telefone deve ter até 20 caracteres.';
    result := False;
  end;

  if length(_Email) > 255 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Email deve ter até 255 caracteres.';
    result := False;
  end;

  if length(_Endereco.Cep) > 10 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Cep deve ter até 10 caracteres.';
    result := False;
  end;

  if length(_Endereco.Logradouro) > 255 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Logradouro deve ter até 255 caracteres.';
    result := False;
  end;

  if length(_Endereco.Numero) > 10 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Número deve ter até 10 caracteres.';
    result := False;
  end;

  if length(_Endereco.Complemento) > 100 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Complemento deve ter até 100 caracteres.';
    result := False;
  end;

  if length(_Endereco.Bairro) > 100 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Bairro deve ter até 100 caracteres.';
    result := False;
  end;

  if length(_Endereco.Cidade) > 100 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Cidade deve ter até 100 caracteres.';
    result := False;
  end;

  if length(_Endereco.Estado) > 2 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Estado deve ter até 2 caracteres.';
    result := False;
  end;

  if length(_Endereco.Pais) > 100 then
  begin
    oValid := oValid + iif(oValid <> '', #13, '') + 'Pais deve ter até 50 caracteres.';
    result := False;
  end;
end;

destructor TModelCliente.Destroy;
begin
  if Assigned(_Endereco) then
    FreeAndNil(_Endereco);

  inherited;
end;

procedure TModelCliente.Limpar;
begin
  _Codigo := 0;
  _Nome := '';
  _Identidade := '';
  _CPF := '';
  _Telefone := '';
  _Email := '';
  FreeAndNil(_Endereco);
end;

function TModelCliente.getEndereco: TEndereco;
begin
  if not Assigned(_Endereco) then
    _Endereco := TEndereco.Create(self);

  result := _Endereco;
end;

procedure TModelCliente.setEndereco(const Value: TEndereco);
begin
  _Endereco := Value;
end;

end.
