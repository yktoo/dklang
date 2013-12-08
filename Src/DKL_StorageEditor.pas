///*********************************************************************************************************************
///  $Id: DKL_StorageEditor.pas 2013-12-06 00:00:00Z bjm $
///---------------------------------------------------------------------------------------------------------------------
///  DKLang Localization Package
///  Copyright 2013 Bruce J Miller, Rules of Thumb,inc., http://rules-of-thumb.com/
///*********************************************************************************************************************
///
/// The contents of this package are subject to the Mozilla Public License
/// Version 1.1 (the "License"); you may not use this file except in compliance
/// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
///
/// Alternatively, you may redistribute this library, use and/or modify it under the
/// terms of the GNU Lesser General Public License as published by the Free Software
/// Foundation; either version 2.1 of the License, or (at your option) any later
/// version. You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/
///
/// Software distributed under the License is distributed on an "AS IS" basis,
/// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
/// specific language governing rights and limitations under the License.
///
///*********************************************************************************************************************
// Designtime editor for language file importing for TDKLTranslationsStorage
//
// Requires Delphi XE5 or higher.
//

unit DKL_StorageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Menus,
  DesignIntf, DesignWindows, DKLangStorage;

type
  TDKLangTranslationStorageEditor = class(TDesignWindow)
    GroupBox1: TGroupBox;
    ListView: TListView;
    AddBtn: TButton;
    DeleteBtn: TButton;
    UpdateBtn: TButton;
    OpenDialog: TOpenDialog;
    PopupMenu: TPopupMenu;
    SelectAll1: TMenuItem;
    procedure SelectAll1Click(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure UpdateBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    fDirty: Boolean;
    fTranslationsStorage: TDKLTranslationsStorage;
    procedure RefreshList;
    procedure UpdateButtons;
    procedure UpdateStoredFile(storedFile: TStoredFile; const fn: string);
  public
    property TranslationsStorage:TDKLTranslationsStorage read fTranslationsStorage write fTranslationsStorage;
  end;

  procedure ShowDKLangTranslationStorageEditor(Designer: IDesigner; TranslationsStorage: TDKLTranslationsStorage);

implementation

uses DKLang, DKL_LanguageCodes;

{$R *.dfm}

procedure ShowDKLangTranslationStorageEditor(Designer: IDesigner; TranslationsStorage: TDKLTranslationsStorage);
var
  i: Integer;
  editor: TDKLangTranslationStorageEditor;
begin
  // first look for open editors with same storage component
  for i := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[i] is TDKLangTranslationStorageEditor then
    begin
      if TDKLangTranslationStorageEditor(Screen.Forms[i]).TranslationsStorage = TranslationsStorage then
      begin
        Editor := TDKLangTranslationStorageEditor(Screen.Forms[i]);
        Editor.Show;
        if Editor.WindowState = wsMinimized then
          Editor.WindowState := wsNormal;
        Exit;
      end;
    end;
  end;

  Editor := TDKLangTranslationStorageEditor.Create(Application);
  try
    Editor.Designer := Designer;
    Editor.TranslationsStorage := TranslationsStorage;
    Editor.Show;
  except
    Editor.Free;
    raise;
  end;
end;

procedure TDKLangTranslationStorageEditor.UpdateButtons;
var
  enable: Boolean;
begin
  AddBtn.Enabled := true;
  enable := ListView.Selected <> nil;
  DeleteBtn.Enabled := enable;
  UpdateBtn.Enabled := enable;
end;

procedure TDKLangTranslationStorageEditor.RefreshList;
var
  li: TListItem;
  storedFile: TStoredFile;
begin
  ListView.Items.Clear;

  for storedFile in fTranslationsStorage.Translations do
  begin
    li := ListView.Items.Add;
    li.Caption := storedFile.Description;
    li.SubItems.Add(ExtractFileName(storedFile.FileName));
    li.SubItems.Add(IntToStr(storedFile.FileSize));
    li.SubItems.Add(IntToStr(storedFile.StoredSize));
    li.SubItems.Add(storedFile.ImportDate);
    li.SubItems.Add(storedFile.FileName);
    li.Data := storedFile;
  end;

  UpdateButtons;
end;

procedure TDKLangTranslationStorageEditor.UpdateStoredFile(storedFile: TStoredFile; const fn: string);
var
  stream: TFileStream;
  dt: TDateTime;
  Tran: TDKLang_CompTranslations;
  wLangID: LANGID;
  description: string;
begin
  FileAge(fn,dt);

  Tran := TDKLang_CompTranslations.Create;
  try
    Tran.Text_LoadFromFile(fn, True);
     // Try to obtain LangID parameter
    wLangID := StrToIntDef(Tran.Params.Values[SDKLang_TranParam_LangID], 0);
    description := Format('%d %s',[wLangID,GetLanguageNameFromLANGID(wLangID)]);
  finally
    Tran.Free;
  end;

  stream := TFileStream.Create(fn,fmOpenRead);
  try
    StoredFile.Import(stream,fn,description,dt);
  finally
    stream.Free;
  end;

  fDirty := true;
end;

procedure TDKLangTranslationStorageEditor.AddBtnClick(Sender: TObject);
var
  i: Integer;
  storedFile: TStoredFile;
begin
  if OpenDialog.Execute then
  begin
    for i:=0 to OpenDialog.Files.Count-1 do
    begin
      storedFile := TStoredFile.Create;
      try
        UpdateStoredFile(storedFile,OpenDialog.Files[i]);
        fTranslationsStorage.Translations.Add(StoredFile);
      except
        storedFile.Free;
        raise;
      end;
    end;
    RefreshList;
    fDirty := true;
  end;
end;

procedure TDKLangTranslationStorageEditor.UpdateBtnClick(Sender: TObject);
var
  i: Integer;
  fn,oldInitialDir: string;
  storedFile: TStoredFile;
begin
  for i:=0 to ListView.Items.Count-1 do
  begin
    if ListView.Items[i].Selected then
    begin
      storedFile := TStoredFile(ListView.Items[i].Data);
      try
        fn := storedFile.Filename;
        if not FileExists(fn) then
        begin
          oldInitialDir := OpenDialog.InitialDir;
          try
            OpenDialog.FileName := ExtractFileName(fn);
            if DirectoryExists(ExtractFilePath(fn)) then
              OpenDialog.InitialDir := ExtractFilePath(fn);
            if OpenDialog.Execute then
              fn := OpenDialog.FileName;
          finally
            OpenDialog.FileName := '';
            OpenDialog.InitialDir := oldInitialDir;
          end;
        end;
        if FileExists(fn) then
          UpdateStoredFile(storedFile,fn);
      except
        fTranslationsStorage.Translations.Remove(storedFile);
        raise;
      end;
    end;
  end;

  RefreshList;
end;

procedure TDKLangTranslationStorageEditor.DeleteBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to ListView.Items.Count-1 do
    if ListView.Items[i].Selected then
    begin
      fTranslationsStorage.Translations.Remove(TStoredFile(ListView.Items[I].Data));
      fDirty := true;
    end;
  RefreshList;
end;

procedure TDKLangTranslationStorageEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if fDirty then
    Designer.Modified;
  Action := caFree;
end;

procedure TDKLangTranslationStorageEditor.FormShow(Sender: TObject);
begin
  RefreshList;
end;

procedure TDKLangTranslationStorageEditor.ListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  UpdateButtons;
end;

procedure TDKLangTranslationStorageEditor.SelectAll1Click(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to ListView.Items.Count-1 do
    ListView.Items[i].Selected := true;
end;

end.
