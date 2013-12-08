program DKLang_Constants_FMX_Desktop_Demo;

uses
  FMX.Forms,
  Main in 'Main.pas' {fMain};

{$R *.res}
{$R *.dkl_const.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
