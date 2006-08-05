//**********************************************************************************************************************
//  $Id: Main.pas,v 1.1 2006-08-05 21:33:31 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org
//**********************************************************************************************************************
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, TntSystem, TntClasses, TntForms,
  TntSysUtils,
  StdCtrls, DKLang, TntDialogs, ActnList, TntActnList, Menus, TntMenus,
  TntStdCtrls, ComCtrls, TntComCtrls;

type
  TfMain = class(TTntForm)
    aEditCopy: TTntAction;
    aEditCut: TTntAction;
    aEditDateAndTime: TTntAction;
    aEditFind: TTntAction;
    aEditFindNext: TTntAction;
    aEditGoToLine: TTntAction;
    aEditPaste: TTntAction;
    aEditReplace: TTntAction;
    aEditSelectAll: TTntAction;
    aEditUndo: TTntAction;
    aFileExit: TTntAction;
    aFileNew: TTntAction;
    aFileOpen: TTntAction;
    aFileSave: TTntAction;
    aFileSaveAs: TTntAction;
    aFormatFont: TTntAction;
    aFormatWordWrap: TTntAction;
    aHelpAbout: TTntAction;
    alMain: TTntActionList;
    aViewStatusBar: TTntAction;
    dklcMain: TDKLanguageController;
    fdMain: TFontDialog;
    iEditCopy: TTntMenuItem;
    iEditCut: TTntMenuItem;
    iEditDateAndTime: TTntMenuItem;
    iEditFind: TTntMenuItem;
    iEditFindNext: TTntMenuItem;
    iEditGoToLine: TTntMenuItem;
    iEditPaste: TTntMenuItem;
    iEditReplace: TTntMenuItem;
    iEditSelectAll: TTntMenuItem;
    iEditUndo: TTntMenuItem;
    iFileExit: TTntMenuItem;
    iFileNew: TTntMenuItem;
    iFileOpen: TTntMenuItem;
    iFileSave: TTntMenuItem;
    iFileSaveAs: TTntMenuItem;
    iFormatFont: TTntMenuItem;
    iFormatWordWrap: TTntMenuItem;
    iHelpAbout: TTntMenuItem;
    iSepEditCut: TTntMenuItem;
    iSepEditFind: TTntMenuItem;
    iSepEditSelectAll: TTntMenuItem;
    iSepFileExit: TTntMenuItem;
    iSepViewLanguage: TTntMenuItem;
    iViewStatusBar: TTntMenuItem;
    mMain: TTntMemo;
    mmMain: TTntMainMenu;
    odMain: TTntOpenDialog;
    sdMain: TTntSaveDialog;
    smEdit: TTntMenuItem;
    smFile: TTntMenuItem;
    smFormat: TTntMenuItem;
    smHelp: TTntMenuItem;
    smView: TTntMenuItem;
    smViewLanguage: TTntMenuItem;
    TheStatusBar: TTntStatusBar;
    procedure aEditCopyExecute(Sender: TObject);
    procedure aEditCutExecute(Sender: TObject);
    procedure aEditDateAndTimeExecute(Sender: TObject);
    procedure aEditFindExecute(Sender: TObject);
    procedure aEditFindNextExecute(Sender: TObject);
    procedure aEditGoToLineExecute(Sender: TObject);
    procedure aEditPasteExecute(Sender: TObject);
    procedure aEditReplaceExecute(Sender: TObject);
    procedure aEditSelectAllExecute(Sender: TObject);
    procedure aEditUndoExecute(Sender: TObject);
    procedure aFileExitExecute(Sender: TObject);
    procedure aFileNewExecute(Sender: TObject);
    procedure aFileOpenExecute(Sender: TObject);
    procedure aFileSaveAsExecute(Sender: TObject);
    procedure aFileSaveExecute(Sender: TObject);
    procedure aFormatFontExecute(Sender: TObject);
    procedure aFormatWordWrapExecute(Sender: TObject);
    procedure aHelpAboutExecute(Sender: TObject);
    procedure aViewStatusBarExecute(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UpdateStateNotify(Sender: TObject);
  private
     // True if open file is Unicode
    FIsUnicodeFile: Boolean;
     // Prop storage
    FFileName: WideString;
     // Updates form interface
    procedure UpdateState;
     // Language item click handler
    procedure LanguageItemClick(Sender: TObject);
     // Loads the specified file
    procedure DoLoadFile(const wsFileName: WideString);
     // Saves the text into the specified file
    procedure DoSaveFile(const wsFileName: WideString; bUnicode: Boolean);
     // Returns True if text can be discarded
    function  CanDiscardText: Boolean;
     // Prop handlers
    function  GetDisplayFileName: WideString;
  public
     // Props
     // -- Name of the file being edited, always not empty
    property DisplayFileName: WideString read GetDisplayFileName;
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses
  StrUtils
  {$IFNDEF VER140}, XPMan {$ENDIF};

  procedure TfMain.aEditCopyExecute(Sender: TObject);
  begin
    mMain.CopyToClipboard;
  end;

  procedure TfMain.aEditCutExecute(Sender: TObject);
  begin
    mMain.CutToClipboard;
  end;

  procedure TfMain.aEditDateAndTimeExecute(Sender: TObject);
  begin
    mMain.SelText := DateTimeToStr(Now);
  end;

  procedure TfMain.aEditFindExecute(Sender: TObject);
  begin
    { Find not implemented since there's no TTntFindDialog yet }
  end;

  procedure TfMain.aEditFindNextExecute(Sender: TObject);
  begin
    { Find not implemented since there's no TTntFindDialog yet }
  end;

  procedure TfMain.aEditGoToLineExecute(Sender: TObject);
  var ws: WideString;
  begin
    ws := IntToStr(mMain.CaretPos.y+1);
    if WideInputQuery(LangManager.ConstantValue['SDlgTitle_GoToLine'], LangManager.ConstantValue['SGoToLinePrompt'], ws) then begin
      mMain.CaretPos := Point(0, StrToInt(ws)-1);
      mMain.Perform(EM_SCROLLCARET, 0, 0);
    end;
  end;

  procedure TfMain.aEditPasteExecute(Sender: TObject);
  begin
    mMain.PasteFromClipboard;
  end;

  procedure TfMain.aEditReplaceExecute(Sender: TObject);
  begin
    { Replace not implemented since there's no TTntReplaceDialog yet }
  end;

  procedure TfMain.aEditSelectAllExecute(Sender: TObject);
  begin
    mMain.SelectAll;
  end;

  procedure TfMain.aEditUndoExecute(Sender: TObject);
  begin
    mMain.Undo;
  end;

  procedure TfMain.aFileExitExecute(Sender: TObject);
  begin
    Close;
  end;

  procedure TfMain.aFileNewExecute(Sender: TObject);
  begin
    if CanDiscardText then begin
      mMain.Clear;
      mMain.Modified := False;
      FIsUnicodeFile := True;
      FFileName := '';
      UpdateState;
    end;
  end;

  procedure TfMain.aFileOpenExecute(Sender: TObject);
  begin
    odMain.FileName := FFileName;
    if odMain.Execute and CanDiscardText then DoLoadFile(odMain.FileName);
  end;

  procedure TfMain.aFileSaveAsExecute(Sender: TObject);
  begin
    sdMain.FileName := FFileName;
    if FIsUnicodeFile then sdMain.FilterIndex := 2 else sdMain.FilterIndex := 1;
    if sdMain.Execute then DoSaveFile(sdMain.FileName, sdMain.FilterIndex=2);
  end;

  procedure TfMain.aFileSaveExecute(Sender: TObject);
  begin
    if FFileName='' then aFileSaveAs.Execute else DoSaveFile(FFileName, FIsUnicodeFile);
  end;

  procedure TfMain.aFormatFontExecute(Sender: TObject);
  begin
    fdMain.Font.Assign(mMain.Font);
    if fdMain.Execute then mMain.Font.Assign(fdMain.Font);
  end;

  procedure TfMain.aFormatWordWrapExecute(Sender: TObject);
  begin
    mMain.WordWrap := not mMain.WordWrap;
    UpdateState;
  end;

  procedure TfMain.aHelpAboutExecute(Sender: TObject);
  begin
    MessageBoxW(
      Application.Handle,
      PWideChar(WideFormat(
        '%s v1.00'#13#10'%s', [LangManager.ConstantValue['SApplicationName'], LangManager.ConstantValue['SCopyright']])),
      PWideChar(LangManager.ConstantValue['SDlgTitle_About']),
      MB_ICONINFORMATION or MB_OK);
  end;

  procedure TfMain.aViewStatusBarExecute(Sender: TObject);
  begin
    TheStatusBar.Visible := not TheStatusBar.Visible;
    UpdateState;
  end;

  function TfMain.CanDiscardText: Boolean;
  begin
    Result := True;
    if mMain.Modified then
      case MessageBoxW(
          Application.Handle,
          PWideChar(WideFormat(LangManager.ConstantValue['SMsg_ConfirmFileDiscard'], [DisplayFileName])),
          PWideChar(LangManager.ConstantValue['SDlgTitle_Warning']),
          MB_ICONWARNING or MB_YESNOCANCEL) of
        IDYES: Result := aFileSave.Execute and not mMain.Modified;
        IDNO:  { nothing };
        else   Result := False;
      end;
  end;

  procedure TfMain.DoLoadFile(const wsFileName: WideString);
  begin
    mMain.Lines.LoadFromFile(wsFileName);
    mMain.Modified := False;
    FIsUnicodeFile := mMain.Lines.LastFileCharSet in [csUnicode, csUnicodeSwapped];
    FFileName := wsFileName;
    UpdateState;
  end;

  procedure TfMain.DoSaveFile(const wsFileName: WideString; bUnicode: Boolean);
  begin
    if bUnicode then
      mMain.Lines.SaveToFile(wsFileName)
    else
      mMain.Lines.AnsiStrings.SaveToFile(wsFileName);
    mMain.Modified := False;
    FIsUnicodeFile := bUnicode;
    FFileName := wsFileName;
    UpdateState;
  end;

  function TfMain.GetDisplayFileName: WideString;
  begin
    Result := FFileName;
    if Result='' then Result := LangManager.ConstantValue['SDefaultFileName'];
  end;

  procedure TfMain.LanguageItemClick(Sender: TObject);
  begin
     // We stored language ID in Tag of each menu item (which is Sender here)
    LangManager.LanguageID := (Sender as TComponent).Tag;
    UpdateState;
  end;

  procedure TfMain.TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
    CanClose := CanDiscardText;
  end;

  procedure TfMain.TntFormCreate(Sender: TObject);

    procedure CreateLanguageMenu;
    var
      i: Integer;
      mi: TTntMenuItem;
    begin
      for i := 0 to LangManager.LanguageCount-1 do begin
        mi := WideNewItem(LangManager.LanguageNames[i], 0, False, True, LanguageItemClick, 0, '');
        mi.Tag := LangManager.LanguageIDs[i];
        smViewLanguage.Add(mi);
      end;
    end;

  begin
     // Initially we prefer Unicode files
    FIsUnicodeFile := True;
     // Scan for language files in the app directory and register them in the LangManager object
    LangManager.ScanForLangFiles(WideExtractFileDir(WideParamStr(0)), '*.lng', False);
     // Create available languages menu
    CreateLanguageMenu;
     // Update interface elements
    UpdateState;
  end;

  procedure TfMain.UpdateState;
  const awsModified: Array[Boolean] of WideString = ('', '*');

    procedure UpdateLanguageMark;
    var
      i: Integer;
      CurLang: LANGID;
    begin
      CurLang := LangManager.LanguageID; // To avoid excess synch calls
      for i := 0 to smViewLanguage.Count-1 do
        with smViewLanguage[i] do Checked := Tag=CurLang;
    end;

  begin
     // Update form caption
    Caption := WideFormat(
      '[%s%s] - %s', [DisplayFileName, awsModified[mMain.Modified], LangManager.ConstantValue['SApplicationName']]);
    Application.Title := Caption;
     // Update language menu
    UpdateLanguageMark;
     // Update misc
    aFormatWordWrap.Checked := mMain.WordWrap;
    if mMain.WordWrap then mMain.ScrollBars := ssVertical else mMain.ScrollBars := ssBoth;
    aViewStatusBar.Checked := TheStatusBar.Visible;
  end;

  procedure TfMain.UpdateStateNotify(Sender: TObject);
  begin
    UpdateState;
  end;

end.
