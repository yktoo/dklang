//**********************************************************************************************************************
//  $Id: Main.pas,v 1.2 2005-06-19 12:31:38 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
// This is a simple example on using DKLang Package in MDI application.
// While it seems to be a quite general task, there's a trick to make it
// live.
//
// The point is that each MDI child is created owned by the parent form
// (fMain). VCL requires that all owned components have unique names
// across their owner, so you would never be able to have two (or more)
// instances of a form owned by fMain if they aren't renamed.
//
// VCL offers a cheap solution for this: it renames the second instance
// of fMDIChild to fMDIChild_1, third to fMDIChild_2 and so on.
//
// But we want all of the forms being translated from the same section
// of the language file, don't we? So our answer to VCL's behaviour is
// that we set fMDIChild.lcMain.SectionName to 'fMDIChild', and now that
// works.  
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DKLang;

type
  TfMain = class(TForm)
    bCascade: TButton;
    bNewWindow: TButton;
    bTile: TButton;
    cbLanguage: TComboBox;
    lcMain: TDKLanguageController;
    pTop: TPanel;
    procedure bCascadeClick(Sender: TObject);
    procedure bNewWindowClick(Sender: TObject);
    procedure bTileClick(Sender: TObject);
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
