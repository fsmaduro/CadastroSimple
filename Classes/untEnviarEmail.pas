unit untEnviarEmail;

interface

uses SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdMessage,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdText, IdSASLUserPass, IdSASLLogin, IdSASL_CRAM_MD5, IdUserPassProvider, IdSASLSKey,
  IdSASLPlain, IdSASLOTP, IdSASLExternal, IdSASLAnonymous, IdAttachmentFile;

type
  TTipoTLS = (utNoTLSSupport, utUseImplicitTLS, utUseRequireTLS, utUseExplicitTLS);
  TMetodoSSL = (sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1);
  TModoSSL = (sslmUnassigned, sslmClient, sslmServer, sslmBoth);
  TConfigSMTP = class(TComponent)
  private
    _Email: String;
    _SMTP: String;
    _Usuario: String;
    _Senha: String;
    _Porta: integer;
    _RequerAutenticacao: Boolean;
    _UsarSSL: Boolean;
    _UsarTipoTLS: TTipoTLS;
    _MetodoSSL: TMetodoSSL;
    _ModoSSL: TModoSSL;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;

    property Email: String read _Email write _Email;
    property SMTP: String read _SMTP write _SMTP;
    property Usuario: String read _Usuario write _Usuario;
    property Senha: String read _Senha write _Senha;
    property Porta: integer read _Porta write _Porta;
    property RequerAutenticacao: Boolean read _RequerAutenticacao write _RequerAutenticacao;
    property UsarSSL: Boolean read _UsarSSL write _UsarSSL;
    property UsarTipoTLS: TTipoTLS read _UsarTipoTLS write _UsarTipoTLS;
    property MetodoSSL: TMetodoSSL read _MetodoSSL write _MetodoSSL;
    property ModoSSL: TModoSSL read _ModoSSL write _ModoSSL;
  end;

  TEnviarEmail = class(TComponent)
  private
    _ConfigSMTP : TConfigSMTP;
    _Para: String;
    _Assunto: String;
    _TextoEmail: TStringList;
    _Anexo: String;
  public
    constructor Create(AOwner: TConfigSMTP);
    destructor Destroy;

    function Enviar(): Boolean;

    property Para: String read _Para write _Para;
    property Assunto: String read _Assunto write _Assunto;
    property TextoEmail: TStringList read _TextoEmail write _TextoEmail;
    property Anexo: String read _Anexo write _Anexo;
  end;

implementation

{ TEnviarEmail }

constructor TEnviarEmail.Create(AOwner: TConfigSMTP);
begin
  inherited Create(AOwner);
  _TextoEmail := TStringList.Create;
  _ConfigSMTP := AOwner;
end;

destructor TEnviarEmail.Destroy;
begin
  FreeAndNil(_TextoEmail);
  inherited;
end;

function TEnviarEmail.Enviar: Boolean;
var
  lIdSmtp    : TIdSMTP;
  lIdMessage : TIdMessage;
  lIdSSL     : TIdSSLIOHandlerSocketOpenSSL;
  lTextoMsg  : TidText;
  lIdUserPvd : TIdUserPassProvider;
  IdSASLLog  : TIdSASLLogin;
  IdSASLMD5  : TIdSASLCRAMMD5;
  IdSASLKey  : TIdSASLSKey;
  IdSASLAnn  : TIdSASLAnonymous;
  IdSASLExt  : TIdSASLExternal;
  IdSASLOtp  : TIdSASLOTP;
  IdSASLPla  : TIdSASLPlain;

  lAutenticado: Boolean;
begin
  result := False;

  lIdSmtp := TIdSMTP.Create(self);
  lIdMessage := TIdMessage.Create(self);
  lIdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(self);
  lIdUserPvd := TIdUserPassProvider.Create(self);
  IdSASLLog := TIdSASLLogin.Create(self);
  IdSASLMD5 := TIdSASLCRAMMD5.Create(self);
  IdSASLKey := TIdSASLSKey.Create(self);
  IdSASLAnn := TIdSASLAnonymous.Create(self);
  IdSASLExt := TIdSASLExternal.Create(self);
  IdSASLOtp := TIdSASLOTP.Create(self);
  IdSASLPla := TIdSASLPlain.Create(self);
  try
    lIdMessage.Recipients.EMailAddresses := _Para;

    lIdMessage.FromList.Add;
    lIdMessage.FromList.Items[0].Address := _ConfigSMTP.Email;

    lIdMessage.ReplyTo.Clear;
    lIdMessage.ReplyTo.Add;
    lIdMessage.ReplyTo.Items[0].Address := _ConfigSMTP.Email; // quem recebe a mensagem de resposta

    lIdMessage.Priority                  := mpHighest;
    lIdMessage.Subject                   := _Assunto;
    lIdMessage.CharSet                   := 'iso-8859-1';
    lIdMessage.Encoding                  := meMIME;
    lIdMessage.ContentType               := 'multipart/mixed';

    {Texto do Email}
    lIdMessage.Body.Assign(_TextoEmail);
    lTextoMsg  := TidText.Create(lIdMessage.MessageParts, _TextoEmail);
    lTextoMsg.ContentType := 'text/html';
    lTextoMsg.Body.Text   := _TextoEmail.Text;

    {Anexo do Email}
    if (_Anexo <> '') and (FileExists(_Anexo)) then
      TIdAttachmentFile.Create(lIdMessage.MessageParts, TFileName(_Anexo));

    {Conexão SMTP}
    lIdSmtp.Host     := _ConfigSMTP.SMTP;
    lIdSmtp.Username := _ConfigSMTP.Usuario;
    lIdSmtp.Password := _ConfigSMTP.Senha;
    lIdSmtp.Port     := _ConfigSMTP.Porta;
    lIdSmtp.ConnectTimeout := 20000;
    lIdSmtp.ReadTimeout := 20000;

    lIdUserPvd.Username := lIdSmtp.Username;
    lIdUserPvd.Password := lIdSmtp.Password;

    {Conexão SMTP >> SSL}
    if _ConfigSMTP.RequerAutenticacao then
      lIdSmtp.AuthType := satDefault
    else
      lIdSmtp.AuthType := satNone;

    if _ConfigSMTP.UsarSSL then
    begin
      lIdSmtp.AuthType := satDefault;
      lIdSmtp.IOHandler := lIdSSL;
      IdSASLLog.UserPassProvider := lIdUserPvd;
      IdSASLMD5.UserPassProvider := lIdUserPvd;
      IdSASLKey.UserPassProvider := lIdUserPvd;
      IdSASLOtp.UserPassProvider := lIdUserPvd;
      IdSASLPla.UserPassProvider := lIdUserPvd;

      lIdSmtp.SASLMechanisms.Clear;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLMD5;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLLog;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLKey;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLAnn;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLExt;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLOtp;
      lIdSmtp.SASLMechanisms.Add.SASL := IdSASLPla;

      case _ConfigSMTP.UsarTipoTLS of
        utNoTLSSupport   : lIdSmtp.UseTLS := TIdUseTLS(utNoTLSSupport);
        utUseImplicitTLS : lIdSmtp.UseTLS := TIdUseTLS(utUseImplicitTLS);
        utUseRequireTLS  : lIdSmtp.UseTLS := TIdUseTLS(utUseRequireTLS);
        utUseExplicitTLS : lIdSmtp.UseTLS := TIdUseTLS(utUseExplicitTLS);
      end;

      lIdSSL.Destination := lIdSmtp.Host+':'+IntToStr(lIdSmtp.Port);
      lIdSSL.Host := lIdSmtp.Host;
      lIdSSL.Port := lIdSmtp.Port;

      case _ConfigSMTP.MetodoSSL of
        sslvSSLv2  : lIdSSL.SSLOptions.Method := TIdSSLVersion(sslvSSLv2);
        sslvSSLv23 : lIdSSL.SSLOptions.Method := TIdSSLVersion(sslvSSLv23);
        sslvSSLv3  : lIdSSL.SSLOptions.Method := TIdSSLVersion(sslvSSLv3);
        sslvTLSv1  : lIdSSL.SSLOptions.Method := TIdSSLVersion(sslvTLSv1);
      end;

      case _ConfigSMTP.ModoSSL of
        sslmUnassigned : lIdSSL.SSLOptions.Mode := TIdSSLMode(sslmUnassigned);
        sslmClient     : lIdSSL.SSLOptions.Mode := TIdSSLMode(sslmClient);
        sslmServer     : lIdSSL.SSLOptions.Mode := TIdSSLMode(sslmServer);
        sslmBoth       : lIdSSL.SSLOptions.Mode := TIdSSLMode(sslmBoth);
      end;

      lIdSSL.SSLOptions.VerifyMode := [];
      lIdSSL.SSLOptions.VerifyDepth := 0;
    end;

    lIdSmtp.Connect;

    if lIdSmtp.Connected then
    begin
      Sleep(200); // tempo de espera para atualizar a conexao com o servidor

      if _ConfigSMTP.RequerAutenticacao then
      begin
        lAutenticado := lIdSmtp.Authenticate;

        if not lAutenticado then
          raise Exception.Create('Não foi possível autenticar no SMTP.');
      end;

      lIdSmtp.Send(lIdMessage);

      result := True;
    end
    else
      raise Exception.Create('Não foi possível conectar ao SMTP.');
  finally
    FreeAndNil(lIdSmtp);
    FreeAndNil(lIdMessage);
    FreeAndNil(lIdSSL);
    FreeAndNil(lIdUserPvd);
    FreeAndNil( IdSASLLog );
    FreeAndNil( IdSASLMD5 );
    FreeAndNil( IdSASLKey );
    FreeAndNil( IdSASLAnn );
    FreeAndNil( IdSASLExt );
    FreeAndNil( IdSASLOtp );
    FreeAndNil( IdSASLPla );
  end;
end;

{ TConfigSMTP }

constructor TConfigSMTP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TConfigSMTP.Destroy;
begin
  inherited;
end;

end.
