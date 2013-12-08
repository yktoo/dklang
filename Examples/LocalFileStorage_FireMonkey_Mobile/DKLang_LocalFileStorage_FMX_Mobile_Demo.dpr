program DKLang_LocalFileStorage_FMX_Mobile_Demo;

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
