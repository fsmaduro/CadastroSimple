program AvaliacaoInfo;

uses
  Vcl.Forms,
  untModelCliente in 'Model\untModelCliente.pas',
  untEndereco in 'Classes\untEndereco.pas',
  untControllerCliente in 'Controller\untControllerCliente.pas',
  untViewCliente in 'View\untViewCliente.pas' {frmViewCliente},
  untEnviarEmail in 'Classes\untEnviarEmail.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmViewCliente, frmViewCliente);
  Application.Run;
end.
