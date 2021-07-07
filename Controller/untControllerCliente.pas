unit untControllerCliente;

interface

uses SysUtils, Classes, untModelCliente, DB, DBClient, XMLDoc, XMLIntf;

type
  TDataState = (dsNone, dsEdit, dsInsert);
  TCliente = class(TModelCliente)
  private
    _DataSet : TClientDataSet;
    _DataState: TDataState;

    procedure PrepararDataSet();
    function GetLista: TClientDataSet;
    procedure DataSetAfterScroll(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;

    function Carregar(iCodigo: Integer): Boolean;
    function Novo(): Integer;
    function Gravar(): Boolean;
    function Deletar(iCodigo: Integer): Boolean;

    procedure GerarXml(iFileName: String);

    property Lista : TClientDataSet read GetLista;
    property DataState: TDataState read _DataState;
  end;

implementation

{ TCliente }

function TCliente.Carregar(iCodigo: Integer): Boolean;
begin
  result := _DataSet.FindKey([iCodigo]);
  {Obs.: O onAfterScroll se encarrega em carregar os dados no Objeto}
  if result then
    _DataState := dsEdit
  else
  begin
    self.Limpar();
    _DataState := dsNone;
  end;
end;

constructor TCliente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PrepararDataSet();
  _DataState := dsNone;
end;

function TCliente.Deletar(iCodigo: Integer): Boolean;
begin
  result := false;
  if _DataSet.FindKey([iCodigo]) then
  begin
    _DataSet.Delete;
    result := true;
  end;
end;

destructor TCliente.Destroy;
begin
  if Assigned(_DataSet) then
    FreeAndNil(_DataSet);
end;

procedure TCliente.GerarXml(iFileName: String);
var
  lXMLDocument: TXMLDocument;
  lNodeRegistro, lNodeEndereco: IXMLNode;
  lPath: String;
begin
  if trim(iFileName) = '' then
    raise Exception.Create('Url do arquivo não informado!');

  {verifica se o diretório existe, senão deve-se criar o mesmo}
  lPath := ExtractFilePath(iFileName);
  if not DirectoryExists(lPath) then
    ForceDirectories(lPath);

  lXMLDocument := TXMLDocument.Create(Self);
  try
    lXMLDocument.Active := True;
    lNodeRegistro := lXMLDocument.AddChild('Cliente');
    lNodeRegistro.ChildValues['Codigo'] := self.Codigo;
    lNodeRegistro.ChildValues['Nome'] := self.Nome;
    lNodeRegistro.ChildValues['Identidade'] := self.Identidade;
    lNodeRegistro.ChildValues['CPF'] := self.CPF;
    lNodeRegistro.ChildValues['Telefone'] := self.Telefone;
    lNodeRegistro.ChildValues['Email'] := self.Email;

    lNodeEndereco := lNodeRegistro.AddChild('Endereco');
    lNodeEndereco.ChildValues['Cep'] := self.Endereco.Cep;
    lNodeEndereco.ChildValues['Logradouro'] := self.Endereco.Logradouro;
    lNodeEndereco.ChildValues['Numero'] := self.Endereco.Numero;
    lNodeEndereco.ChildValues['Complemento'] := self.Endereco.Complemento;
    lNodeEndereco.ChildValues['Bairro'] := self.Endereco.Bairro;
    lNodeEndereco.ChildValues['Cidade'] := self.Endereco.Cidade;
    lNodeEndereco.ChildValues['Estado'] := self.Endereco.Estado;
    lNodeEndereco.ChildValues['Pais'] := self.Endereco.Pais;

    lXMLDocument.SaveToFile(iFileName);
  finally
    lXMLDocument.Free;
  end;
end;

function TCliente.GetLista: TClientDataSet;
begin
  if not Assigned(_DataSet) then
    PrepararDataSet();

  result := _DataSet;
end;

function TCliente.Gravar: Boolean;
var
  lValid: String;
begin
  if self.DadosValidos(lValid) then
  begin
    _DataSet.AfterScroll := nil;
    try
      if _DataState = dsEdit then
        _DataSet.Edit
      else
        _DataSet.Insert;

      _DataSet.FieldByName('codigo').AsInteger     := self.Codigo;
      _DataSet.FieldByName('nome').AsString        := self.Nome;
      _DataSet.FieldByName('identidade').AsString  := self.Identidade;
      _DataSet.FieldByName('CPF').AsString         := self.CPF;
      _DataSet.FieldByName('telefone').AsString    := self.Telefone;
      _DataSet.FieldByName('email').AsString       := self.Email;
      _DataSet.FieldByName('cep').AsString         := self.Endereco.Cep;
      _DataSet.FieldByName('logradouro').AsString  := self.Endereco.Logradouro;
      _DataSet.FieldByName('numero').AsString      := self.Endereco.Numero;
      _DataSet.FieldByName('complemento').AsString := self.Endereco.Complemento;
      _DataSet.FieldByName('bairro').AsString      := self.Endereco.Bairro;
      _DataSet.FieldByName('cidade').AsString      := self.Endereco.Cidade;
      _DataSet.FieldByName('estado').AsString      := self.Endereco.Estado;
      _DataSet.FieldByName('pais').AsString        := self.Endereco.Pais;

      _DataSet.Post;
    finally
      _DataSet.AfterScroll := DataSetAfterScroll;
    end;
  end
  else
    raise Exception.Create('Dados inválidos!'#13+lValid);
end;

function TCliente.Novo: Integer;
var
  lBookMark: TBookmark;
begin
  {Aqui esse código deve ser um campo com auto incremento,
   porem como não eciste estrutura de banco de dados será
   desenvolvido algo paleativo}

  self.Limpar();

  if _DataSet.IsEmpty then
    result := 1
  else
  begin
    _DataSet.AfterScroll := nil;
    try
      lBookMark := _DataSet.GetBookmark;

      _DataSet.Last;
      result := _DataSet.FieldByName('Codigo').AsInteger + 1;

    finally
      _DataSet.GotoBookmark(lBookMark);
      _DataSet.FreeBookmark(lBookMark);
      _DataSet.AfterScroll := DataSetAfterScroll;
    end;
  end;

  self.Codigo := result;
  _DataState := dsInsert;
end;

procedure TCliente.PrepararDataSet;
begin
  _DataSet := TClientDataSet.Create(self);
  _DataSet.AfterScroll := DataSetAfterScroll;

  _DataSet.FieldDefs.Add('codigo', ftInteger, 0, True);
  _DataSet.FieldDefs.Add('nome', ftString, 255, True);
  _DataSet.FieldDefs.Add('identidade', ftString, 20, True);
  _DataSet.FieldDefs.Add('CPF', ftString, 16, True);
  _DataSet.FieldDefs.Add('telefone', ftString, 20);
  _DataSet.FieldDefs.Add('email', ftString, 255);
  _DataSet.FieldDefs.Add('cep', ftString, 10);
  _DataSet.FieldDefs.Add('logradouro', ftString, 255);
  _DataSet.FieldDefs.Add('numero', ftString, 10);
  _DataSet.FieldDefs.Add('complemento', ftString, 100);
  _DataSet.FieldDefs.Add('bairro', ftString, 100);
  _DataSet.FieldDefs.Add('cidade', ftString, 100);
  _DataSet.FieldDefs.Add('estado', ftString, 2);
  _DataSet.FieldDefs.Add('pais', ftString, 50);

  _DataSet.IndexDefs.Add('idxCodigo','codigo', [ixPrimary]);

  _DataSet.CreateDataSet;

  _DataSet.IndexName := 'idxCodigo';

  _DataSet.Open;
end;

procedure TCliente.DataSetAfterScroll(DataSet: TDataSet);
begin
  self.Limpar();
  self.Codigo     := DataSet.FieldByName('codigo').AsInteger;
  self.Nome       := DataSet.FieldByName('nome').AsString;
  self.Identidade := DataSet.FieldByName('identidade').AsString;
  self.CPF        := DataSet.FieldByName('CPF').AsString;
  self.Telefone   := DataSet.FieldByName('telefone').AsString;
  self.Email      := DataSet.FieldByName('email').AsString;
  self.Endereco.Cep         := DataSet.FieldByName('cep').AsString;
  self.Endereco.Logradouro  := DataSet.FieldByName('logradouro').AsString;
  self.Endereco.Numero      := DataSet.FieldByName('numero').AsString;
  self.Endereco.Complemento := DataSet.FieldByName('complemento').AsString;
  self.Endereco.Bairro      := DataSet.FieldByName('bairro').AsString;
  self.Endereco.Cidade      := DataSet.FieldByName('cidade').AsString;
  self.Endereco.Estado      := DataSet.FieldByName('estado').AsString;
  self.Endereco.Pais        := DataSet.FieldByName('pais').AsString;
  _DataState := dsEdit;
end;

end.
