unit DKL_ConstEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DKLang,
  StdCtrls, Grids, ValEdit;

type
  TdDKL_ConstEditor = class(TForm)
    vleMain: TValueListEditor;
    bOK: TButton;
    bCancel: TButton;
    lCount: TLabel;
    bLoad: TButton;
    bSave: TButton;
    cbSaveToLangSource: TCheckBox;
    bErase: TButton;
    procedure bOKClick(Sender: TObject);
    procedure vleMainStringsChange(Sender: TObject);
    procedure bLoadClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure bEraseClick(Sender: TObject);
  private
     // The constants being edited
    FConsts: TDKLang_Constants;
     // True if the constants are to be erased from the project resources
    FErase: Boolean;
     // Initializes the dialog
    procedure InitializeDialog(AConsts: TDKLang_Constants; bEraseAllowed: Boolean);
     // Updates the count info
    procedure UpdateCount;
  end;

   // Show constant editor dialog
   //   AConsts       - The constants being edited
   //   bEraseAllowed - Entry: is erase allowed (ie constant resource exists); return: True if user has pressed Erase
   //                   button
  function EditConstants(AConsts: TDKLang_Constants; var bEraseAllowed: Boolean): Boolean;

implementation
{$R *.dfm}

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
    for i := 0 to vleMain.Strings.Count-1 do FConsts.Add(vleMain.Strings.Names[i], LineToMultiline(vleMain.Strings.ValueFromIndex[i]), []);
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

  procedure TdDKL_ConstEditor.InitializeDialog(AConsts: TDKLang_Constants; bEraseAllowed: Boolean);
  var i: Integer;
  begin
    FConsts                    := AConsts;
    cbSaveToLangSource.Checked := FConsts.AutoSaveLangSource;
    bErase.Enabled             := bEraseAllowed;
    FErase                     := False;
     // Copy the constans into the editor
    for i := 0 to FConsts.Count-1 do vleMain.Strings.Add(FConsts[i].sName+'='+MultilineToLine(FConsts[i].sValue));
     // Update count info
    UpdateCount;
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
