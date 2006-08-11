//**********************************************************************************************************************
//  $Id: Main.pas,v 1.5 2006-08-11 12:15:50 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, TntForms,
  Dialogs, StdCtrls, DKLang, ufrFontSettings, TntStdCtrls;

type
  TfMain = class(TTntForm)
    bCancel: TTntButton;
    bOK: TTntButton;
    cbLanguage: TTntComboBox;
    frFontSettings_Interface: TfrFontSettings;
    frFontSettings_Table: TfrFontSettings;
    frFontSettings_Toolbar: TfrFontSettings;
    lcMain: TDKLanguageController;
    lLanguage: TTntLabel;
    procedure cbLanguageChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lcMainLanguageChanged(Sender: TObject);
  private
     // Updates the localizable font editor frame titles
    procedure UpdateFrameTitles;
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses TntSystem, TntSysUtils;

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
     // Scan for language files in the app directory and register them in the LangManager object
    LangManager.ScanForLangFiles(WideExtractFileDir(WideParamStr(0)), '*.lng', False);
     // Fill cbLanguage with available languages
    for i := 0 to LangManager.LanguageCount-1 do cbLanguage.Items.Add(LangManager.LanguageNames[i]);
     // Index=0 always means the default language
    cbLanguage.ItemIndex := 0;
     // Let's now differentiate the trilling frames
    UpdateFrameTitles; 
  end;

  procedure TfMain.lcMainLanguageChanged(Sender: TObject);
  begin
     // Since frame titles are localized with project constants, we should update them here in response to language
     //   change
    UpdateFrameTitles;
  end;

  procedure TfMain.UpdateFrameTitles;
  begin
    frFontSettings_Table.Title     := DKLangConstW('SFontEditorTitle_Table');
    frFontSettings_Toolbar.Title   := DKLangConstW('SFontEditorTitle_Toolbar');
    frFontSettings_Interface.Title := DKLangConstW('SFontEditorTitle_Interface');
  end;

end.
