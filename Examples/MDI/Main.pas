//**********************************************************************************************************************
//  $Id: Main.pas,v 1.1 2005-05-30 12:46:20 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
// This is a simple example on using DKLang Package in MDI application.
//
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DKLang;

type
  TfMain = class(TForm)
    cbLanguage: TComboBox;
    pTop: TPanel;
    bNewWindow: TButton;
    lcMain: TDKLanguageController;
    procedure cbLanguageChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bNewWindowClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses ufMDIChild;

  procedure TfMain.bNewWindowClick(Sender: TObject);
  begin
    TfMDIChild.Create(Self);
  end;

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
