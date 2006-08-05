//**********************************************************************************************************************
//  $Id: Main.pas,v 1.4 2006-08-05 21:42:34 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, TntForms,
  Dialogs, ExtCtrls, StdCtrls, DKLang, TntStdCtrls, TntExtCtrls;

type
  TfMain = class(TTntForm)
    bCascade: TTntButton;
    bNewWindow: TTntButton;
    bTile: TTntButton;
    cbLanguage: TTntComboBox;
    lcMain: TDKLanguageController;
    pTop: TTntPanel;
    procedure bCascadeClick(Sender: TObject);
    procedure bNewWindowClick(Sender: TObject);
    procedure bTileClick(Sender: TObject);
    procedure cbLanguageChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses ufMDIChild;

  procedure TfMain.bCascadeClick(Sender: TObject);
  begin
    Cascade;
  end;

  procedure TfMain.bNewWindowClick(Sender: TObject);
  begin
    TfMDIChild.Create(Self);
  end;

  procedure TfMain.bTileClick(Sender: TObject);
  begin
    Tile;
  end;

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
  end;

end.
