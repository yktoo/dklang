unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DKLang,
  FMX.StdCtrls, FMX.ListBox, FMX.Layouts, FMX.Memo;

type
  TfMain = class(TForm)
    cbLanguage: TComboBox;
    lSampleMessage: TLabel;
    bCancel: TButton;
    lcMain: TDKLanguageController;
    procedure cbLanguageChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

uses
  System.IOUtils; // for TPath

{$R *.fmx}

procedure TfMain.cbLanguageChange(Sender: TObject);
var iIndex: Integer;
begin
  iIndex := cbLanguage.ItemIndex;
  if iIndex<0 then iIndex := 0; // When there's no valid selection in cbLanguage we use the default language (Index=0)
  LangManager.LanguageID := LangManager.LanguageIDs[iIndex];
end;

procedure TfMain.FormCreate(Sender: TObject);
  var i: Integer;
  begin
     // the language files are added by including them with the Deployment Manager via Projects|Deployment
     // Remote path:
     //    iOS:     Startup\Documents\
     //    android: assets\internal\


     // Scan for language files in the local documents directory and register them in the LangManager object
    LangManager.ScanForLangFiles(TPath.GetDocumentsPath, '*.lng', False);

     // Fill cbLanguage with available languages
    for i := 0 to LangManager.LanguageCount-1 do cbLanguage.Items.Add(LangManager.LanguageNativeNames[i]);
     // Index=0 always means the default language
    cbLanguage.ItemIndex := 0;
  end;

end.
