//**********************************************************************************************************************
//  $Id: Main.pas,v 1.1.1.1 2004-09-08 13:14:32 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2004 Dmitry Kann, http://www.dk-soft.org
//**********************************************************************************************************************
// This is a most simple example on how DKLang Package works. Only GUI elements are
// localized in this example. Notice that lcMain.IgnoreList contains '*.Font.Name'
// to avoid font names from being saved into the project language source file

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DKLang;

type
  TfMain = class(TForm)
    bCancel: TButton;
    lcMain: TDKLanguageController;
    lSampleMessage: TLabel;
    cbLanguage: TComboBox;
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
{$R *.dfm}

  procedure TfMain.cbLanguageChange(Sender: TObject);
  begin
     // This is the most straightforward way but not always correct, at least because cbLanguage.ItemIndex might be <0
    LangManager.LanguageID := LangManager.LanguageIDs[cbLanguage.ItemIndex];
  end;

  procedure TfMain.FormCreate(Sender: TObject);
  var i: Integer;
  begin
     // Scan for language files in the app directory and register them in the LangManager object
    LangManager.ScanForLangFiles(ExtractFileDir(ParamStr(0)), '*.lng', False);
     // Fill cbLanguage with available languages
    for i := 0 to LangManager.LanguageCount-1 do cbLanguage.Items.Add(LangManager.LanguageNames[i]);
     // Index=0 always means the default language
    cbLanguage.ItemIndex := 0; 
  end;

end.
