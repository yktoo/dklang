//**********************************************************************************************************************
//  $Id: Main.pas,v 1.2 2005-06-19 12:32:23 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
// This is a basic example on how you use frames with DKLang Package. The three
// frames are translated from a single language file section. This is achieved
// by assigning the SectionName property in the base frame class
// (TfrFontSettings) so all three its descendants (inlined in the main form)
// also have the same value for SectionName. This way all tree frames are
// associated with the same translation.
//
// This is only one of four possible methods of translating frames.
//
// The second method would use empty value for SectionName thus causing the section
// to bear name frFontSettings; for the inlined frame to be translated automatically,
// the frame component should be named the same, ie. frFontSettings. Obviously, this
// allows for having only one instance of a frame on a form.
//
// The third method assumes you turn off autosaving (exclude dklcoAutoSaveLangSource
// from lcMain.Options) in the base frame class, but turning it back on in the inlined
// descendant frames. This way you can have several frame instances on a form, but
// each frame is translated separately. Do not forget to exclude frame properties
// from form's language controller (inspect this fMain.lcMain.IgnoreList to see how).
//
// And finally you can have no controller at all in the base frame, but rather serve
// all the form component hierarchy, including inlined frames' components, with the
// only form's controller. This way you also can have several frame instances with
// each property translated separately.
//
// It's up to you to decide which method is more suitable for your needs; you can use
// different methods in a project.
//
// Also this example demonstrates project constants usage.
//
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DKLang, ufrFontSettings;

type
  TfMain = class(TForm)
    bCancel: TButton;
    bOK: TButton;
    cbLanguage: TComboBox;
    frFontSettings_Interface: TfrFontSettings;
    frFontSettings_Table: TfrFontSettings;
    frFontSettings_Toolbar: TfrFontSettings;
    lcMain: TDKLanguageController;
    lLanguage: TLabel;
    procedure cbLanguageChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lcMainLanguageChanged(Sender: TObject);
  private
     // Updates the localizable font editor frame titles
    procedure UpdateFrameTitles;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}

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
    LangManager.ScanForLangFiles(ExtractFileDir(ParamStr(0)), '*.lng', False);
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
    frFontSettings_Table.Title     := LangManager.ConstantValue['SFontEditorTitle_Table'];
    frFontSettings_Toolbar.Title   := LangManager.ConstantValue['SFontEditorTitle_Toolbar'];
    frFontSettings_Interface.Title := LangManager.ConstantValue['SFontEditorTitle_Interface'];
  end;

end.
