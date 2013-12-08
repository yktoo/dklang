program DKLang_Resource_FMX_Mobile_Demo;

{$R 'LangFiles.res' 'LangFiles.rc'}

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
