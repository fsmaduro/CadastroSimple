unit untViewCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, ShellApi,
  Vcl.Grids, Vcl.DBGrids, untControllerCliente, untEndereco, untEnviarEmail;

type
  TfrmViewCliente = class(TForm)
    edtCodigo: TLabeledEdit;
    edtNome: TLabeledEdit;
    edtIdentidade: TLabeledEdit;
    edtCPF: TLabeledEdit;
    edtTelefone: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtCEP: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    edtComplemento: TLabeledEdit;
    edtNumero: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtPais: TLabeledEdit;
    edtEstado: TLabeledEdit;
    edtCidade: TLabeledEdit;
    DBGrid1: TDBGrid;
    dsClientes: TDataSource;
    btnNovo: TButton;
    btnGravar: TButton;
    btnPrimeiro: TButton;
    btnRetornar: TButton;
    btnAvancar: TButton;
    btnUltimo: TButton;
    Bevel1: TBevel;
    btnEnviarEmail: TButton;
    edtEmailPara: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnPrimeiroClick(Sender: TObject);
    procedure btnRetornarClick(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure edtCEPEnter(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
  private
    lObjCliente : TCliente;
    mOldCep: String;

    procedure PreencherCamposTela;
    procedure PreencherCamposObjeto;
    function GerarXML: String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmViewCliente: TfrmViewCliente;

implementation

{$R *.dfm}

procedure TfrmViewCliente.btnAvancarClick(Sender: TObject);
begin
  lObjCliente.Lista.Next;
  PreencherCamposTela();
end;

function TfrmViewCliente.GerarXML(): String;
var
  lUrl: String;
begin
  if lObjCliente.Codigo <= 0 then
    raise Exception.Create('Selectione um Cliente');

  lUrl := ExtractFilePath(Application.ExeName)+'XML\Cliente_'+IntToStr(lObjCliente.Codigo)+'.xml';

  lObjCliente.GerarXml(lUrl);

  result := lUrl;
end;

procedure TfrmViewCliente.btnEnviarEmailClick(Sender: TObject);
var
  lUrlArquivo: String;
  lConfigSMTP: TConfigSMTP;
  lEnviarEmail: TEnviarEmail;
begin
  lUrlArquivo := GerarXML();

  lConfigSMTP := TConfigSMTP.Create(self);
  try
    {configurações do SMTP}
    lConfigSMTP.Email := 'seuemail@gmail.com';
    lConfigSMTP.SMTP := 'smtp.gmail.com';
    lConfigSMTP.Usuario := 'seuemail@gmail.com';
    lConfigSMTP.Senha := '123456';
    lConfigSMTP.Porta := 587;
    lConfigSMTP.RequerAutenticacao := true;
    lConfigSMTP.UsarSSL := true;
    lConfigSMTP.UsarTipoTLS := utUseExplicitTLS;
    lConfigSMTP.MetodoSSL := sslvSSLv23;
    lConfigSMTP.ModoSSL := sslmClient;

    {Objeto de Envio de Email}
    lEnviarEmail := TEnviarEmail.Create(lConfigSMTP);
    try
      lEnviarEmail.Para := edtEmailPara.Text;
      lEnviarEmail.Assunto := 'Cadastro de Cliente';
      lEnviarEmail.Anexo := lUrlArquivo;

      lEnviarEmail.TextoEmail.Add('Código: '+IntToStr(lObjCliente.Codigo));
      lEnviarEmail.TextoEmail.Add('Nome: '+lObjCliente.Nome);
      lEnviarEmail.TextoEmail.Add('Identidade: '+lObjCliente.Identidade);
      lEnviarEmail.TextoEmail.Add('CPF: '+lObjCliente.CPF);
      lEnviarEmail.TextoEmail.Add('Telefone: '+lObjCliente.Telefone);
      lEnviarEmail.TextoEmail.Add('Email: '+lObjCliente.Email);
      lEnviarEmail.TextoEmail.Add('-=-=-=- Endereço -=-=-=-');
      lEnviarEmail.TextoEmail.Add('Cep: '+lObjCliente.Endereco.Cep);
      lEnviarEmail.TextoEmail.Add('Logradouro: '+lObjCliente.Endereco.Logradouro);
      lEnviarEmail.TextoEmail.Add('Número: '+lObjCliente.Endereco.Numero);
      lEnviarEmail.TextoEmail.Add('Complemento: '+lObjCliente.Endereco.Complemento);
      lEnviarEmail.TextoEmail.Add('Bairro: '+lObjCliente.Endereco.Bairro);
      lEnviarEmail.TextoEmail.Add('Cidade: '+lObjCliente.Endereco.Cidade);
      lEnviarEmail.TextoEmail.Add('Estado: '+lObjCliente.Endereco.Estado);
      lEnviarEmail.TextoEmail.Add('Pais: '+lObjCliente.Endereco.Pais);

      if not lEnviarEmail.Enviar() then
        raise Exception.Create('Não foi possível enviar o email!');
    finally
      FreeAndNil(lEnviarEmail);
    end;
  finally
    FreeAndNil(lConfigSMTP);
  end;
end;

procedure TfrmViewCliente.btnGravarClick(Sender: TObject);
begin
  PreencherCamposObjeto();
  lObjCliente.Gravar();
end;

procedure TfrmViewCliente.btnNovoClick(Sender: TObject);
begin
  lObjCliente.Novo();
  PreencherCamposTela();
end;

procedure TfrmViewCliente.btnPrimeiroClick(Sender: TObject);
begin
  lObjCliente.Lista.First;
  PreencherCamposTela();
end;

procedure TfrmViewCliente.btnRetornarClick(Sender: TObject);
begin
  lObjCliente.Lista.Prior;
  PreencherCamposTela();
end;

procedure TfrmViewCliente.btnUltimoClick(Sender: TObject);
begin
  lObjCliente.Lista.Last;
  PreencherCamposTela();
end;

procedure TfrmViewCliente.edtCEPEnter(Sender: TObject);
begin
  mOldCep := edtCEP.Text;
end;

procedure TfrmViewCliente.edtCEPExit(Sender: TObject);
var
  lObjBuscaCep: TBuscaCEP;
begin
  if edtCEP.Text <> mOldCep then {verifico para não consultar sem alteração}
  begin
    lObjBuscaCep := TBuscaCEP.Create(self);
    try
      lObjBuscaCep.Cep := edtCEP.Text;
      edtLogradouro.Text := lObjBuscaCep.Logradouro;
      edtComplemento.Text := lObjBuscaCep.Complemento;
      edtBairro.Text := lObjBuscaCep.Bairro;
      edtCidade.Text := lObjBuscaCep.Localidade;
      edtEstado.Text := lObjBuscaCep.UF;
      edtPais.Text := 'Brasil';
    finally
      FreeAndNil(lObjBuscaCep);
    end;
  end;
end;

procedure TfrmViewCliente.FormCreate(Sender: TObject);
begin
  lObjCliente := TCliente.Create(self);
  dsClientes.DataSet := lObjCliente.Lista;
end;

procedure TfrmViewCliente.PreencherCamposTela;
begin
  edtCodigo.Text := IntToStr(lObjCliente.Codigo);
  edtNome.Text := lObjCliente.Nome;
  edtIdentidade.Text := lObjCliente.Identidade;
  edtCPF.Text := lObjCliente.CPF;
  edtTelefone.Text := lObjCliente.Telefone;
  edtEmail.Text := lObjCliente.Email;
  edtCEP.Text := lObjCliente.Endereco.Cep;
  edtLogradouro.Text := lObjCliente.Endereco.Logradouro;
  edtNumero.Text := lObjCliente.Endereco.Numero;
  edtComplemento.Text := lObjCliente.Endereco.Complemento;
  edtBairro.Text := lObjCliente.Endereco.Bairro;
  edtCidade.Text := lObjCliente.Endereco.Cidade;
  edtEstado.Text := lObjCliente.Endereco.Estado;
  edtPais.Text := lObjCliente.Endereco.Pais;
end;

procedure TfrmViewCliente.PreencherCamposObjeto;
begin
  lObjCliente.Codigo := StrToIntDef(edtCodigo.Text,0);
  lObjCliente.Nome := edtNome.Text;
  lObjCliente.Identidade := edtIdentidade.Text;
  lObjCliente.CPF := edtCPF.Text;
  lObjCliente.Telefone := edtTelefone.Text;
  lObjCliente.Email := edtEmail.Text;
  lObjCliente.Endereco.Cep := edtCEP.Text;
  lObjCliente.Endereco.Logradouro := edtLogradouro.Text;
  lObjCliente.Endereco.Numero := edtNumero.Text;
  lObjCliente.Endereco.Complemento := edtComplemento.Text;
  lObjCliente.Endereco.Bairro := edtBairro.Text;
  lObjCliente.Endereco.Cidade := edtCidade.Text;
  lObjCliente.Endereco.Estado := edtEstado.Text;
  lObjCliente.Endereco.Pais := edtPais.Text;
end;

end.
