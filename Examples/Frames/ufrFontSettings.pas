unit ufrFontSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DKLang, StdCtrls, ExtCtrls;

type
  TfrFontSettings = class(TFrame)
    bSelectFont: TButton;
    pSample: TPanel;
    gbMain: TGroupBox;
    lcMain: TDKLanguageController;
    procedure bSelectFontClick(Sender: TObject);
  private
     // Prop handlers
    function  GetSelectedFont: TFont;
    procedure SetSelectedFont(Value: TFont);
  public
     // Props
     // -- A font selected in the editor
    property SelectedFont: TFont read GetSelectedFont write SetSelectedFont;
  end;

implementation
{$R *.dfm}

  procedure TfrFontSettings.bSelectFontClick(Sender: TObject);
  var fd: TFontDialog;
  begin
    fd := TFontDialog.Create(Self);
    try
      fd.Font.Assign(SelectedFont);
      if fd.Execute then SelectedFont := fd.Font;
    finally
      fd.Free;
    end;
  end;

  function TfrFontSettings.GetSelectedFont: TFont;
  begin
    Result := pSample.Font;
  end;

  procedure TfrFontSettings.SetSelectedFont(Value: TFont);
  begin
    pSample.Font.Assign(Value);
  end;

end.

