///*********************************************************************************************************************
///  $Id: DKL_ConstEditor.pas,v 1.11 2006-05-13 08:06:57 dale Exp $
///---------------------------------------------------------------------------------------------------------------------
///  DKLang Localization Package
///  Copyright 2002-2005 DK Software, http://www.dk-soft.org
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
/// The initial developer of the original code is Dmitry Kann, http://www.dk-soft.org/
///
///**********************************************************************************************************************
// Designtime project constant editor dialog declaration
//
unit DKL_ConstEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DKLang,
  StdCtrls, Grids, ValEdit;

type
  TdDKL_ConstEditor = class(TForm)
    bCancel: TButton;
    bErase: TButton;
    bLoad: TButton;
    bOK: TButton;
    bSave: TButton;
    cbSaveToLangSource: TCheckBox;
    lCount: TLabel;
    vleMain: TValueListEditor;
    procedure bEraseClick(Sender: TObject);
    procedure bLoadClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure vleMainStringsChange(Sender: TObject);
  private
     // The constants being edited
    FConsts: TDKLang_Constants;
     // True if the constants are to be erased from the project resources
    FErase: Boolean;
     // Initializes the dialog
    procedure InitializeDialog(AConsts: TDKLang_Constants; bEraseAllowed: Boolean);
     // Updates the count info
    procedure UpdateCount;
     // Storing/restoring the settings
    procedure SaveSettings;
    procedure LoadSettings; 
  end;

const
  SRegKey_DKLangConstEditor = 'Software\DKSoftware\DKLang\ConstEditor';

   // Show constant editor dialog
   //   AConsts       - The constants being edited
   //   bEraseAllowed - Entry: is erase allowed (ie constant resource exists); return: True if user has pressed Erase
   //                   button
  function EditConstants(AConsts: TDKLang_Constants; var bEraseAllowed: Boolean): Boolean;

implementation
{$R *.dfm}
uses Registry;

  function EditConstants(AConsts: TDKLang_Constants; var bEraseAllowed: Boolean): Boolean;
  begin
    with TdDKL_ConstEditor.Create(Application) do
      try
        InitializeDialog(AConsts, bEraseAllowed);
        Result := ShowModal=mrOK;
        bEraseAllowed := FErase;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdDKL_ConstEditor
   //===================================================================================================================

  procedure TdDKL_ConstEditor.bEraseClick(Sender: TObject);
  begin
    if Application.MessageBox('Are you sure you want to delete the constants from project resources?', 'Confirm', MB_ICONEXCLAMATION or MB_OKCANCEL)=IDOK then begin
      FErase := True;
      ModalResult := mrOK;
    end;
  end;

  procedure TdDKL_ConstEditor.bLoadClick(Sender: TObject);
  begin
    with TOpenDialog.Create(Self) do
      try
        DefaultExt := 'txt';
        Filter     := 'All files (*.*)|*.*';
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := 'Select a text file to load from';
        if Execute then vleMain.Strings.LoadFromFile(FileName);
      finally
        Free;
      end;
  end;

  procedure TdDKL_ConstEditor.bOKClick(Sender: TObject);
  var i: Integer;
  begin
     // Copy the constans from the editor back into FConsts
    FConsts.Clear;
    FConsts.AutoSaveLangSource := cbSaveToLangSource.Checked;
    for i := 1 to vleMain.Strings.Count do FConsts.Add(vleMain.Cells[0, i], DecodeControlChars(vleMain.Cells[1, i]), []);
    ModalResult := mrOK;
  end;

  procedure TdDKL_ConstEditor.bSaveClick(Sender: TObject);
  begin
    with TSaveDialog.Create(Self) do
      try
        DefaultExt := 'txt';
        Filter     := 'All files (*.*)|*.*';
        Options    := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
        Title      := 'Select a text file to save to';
        if Execute then vleMain.Strings.SaveToFile(FileName);
      finally
        Free;
      end;
  end;

  procedure TdDKL_ConstEditor.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    SaveSettings;
  end;

  procedure TdDKL_ConstEditor.FormShow(Sender: TObject);
  begin
    LoadSettings;
  end;

  procedure TdDKL_ConstEditor.InitializeDialog(AConsts: TDKLang_Constants; bEraseAllowed: Boolean);
  var i: Integer;
  begin
    FConsts                    := AConsts;
    cbSaveToLangSource.Checked := FConsts.AutoSaveLangSource;
    bErase.Enabled             := bEraseAllowed;
    FErase                     := False;
     // Copy the constans into the editor
    for i := 0 to FConsts.Count-1 do vleMain.Strings.Add(FConsts[i].sName+'='+EncodeControlChars(FConsts[i].sValue));
     // Update count info
    UpdateCount;
  end;

  procedure TdDKL_ConstEditor.LoadSettings;
  var
    rif: TRegIniFile;
    rBounds: TRect;
  begin
    rif := TRegIniFile.Create(SRegKey_DKLangConstEditor);
    try
       // Restore form bounds
      rBounds := Rect(
        rif.ReadInteger('', 'Left',   MaxInt),
        rif.ReadInteger('', 'Top',    MaxInt),
        rif.ReadInteger('', 'Right',  MaxInt),
        rif.ReadInteger('', 'Bottom', MaxInt));
       // If all the coords are valid
      if (rBounds.Left<MaxInt) and (rBounds.Top<MaxInt) and (rBounds.Right<MaxInt) and (rBounds.Bottom<MaxInt) then
        BoundsRect := rBounds;
       // Load other settings
      vleMain.ColWidths[0] := rif.ReadInteger('', 'NameColWidth', vleMain.ClientWidth div 2);
    finally
      rif.Free;
    end;
  end;

  procedure TdDKL_ConstEditor.SaveSettings;
  var
    rif: TRegIniFile;
    rBounds: TRect;
  begin
    rif := TRegIniFile.Create(SRegKey_DKLangConstEditor);
    try
       // Store form bounds
      rBounds := BoundsRect;
      rif.WriteInteger('', 'Left',         rBounds.Left);
      rif.WriteInteger('', 'Top',          rBounds.Top);
      rif.WriteInteger('', 'Right',        rBounds.Right);
      rif.WriteInteger('', 'Bottom',       rBounds.Bottom);
       // Store other settings
      rif.WriteInteger('', 'NameColWidth', vleMain.ColWidths[0]);
    finally
      rif.Free;
    end;
  end;

  procedure TdDKL_ConstEditor.UpdateCount;
  begin
    lCount.Caption := Format('%d constants', [vleMain.Strings.Count]);
  end;

  procedure TdDKL_ConstEditor.vleMainStringsChange(Sender: TObject);
  begin
    UpdateCount;
  end;

end.
