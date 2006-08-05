unit ufrFontSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, TntForms,
  Dialogs, DKLang, StdCtrls, ExtCtrls, TntStdCtrls, TntExtCtrls;

type
  TfrFontSettings = class(TTntFrame)
    bSelectFont: TTntButton;
    gbMain: TTntGroupBox;
    lcMain: TDKLanguageController;
    pSample: TTntPanel;
    procedure bSelectFontClick(Sender: TObject);
  private
     // Prop handlers
    function  GetSelectedFont: TFont;
    function  GetTitle: WideString;
    procedure SetSelectedFont(Value: TFont);
    procedure SetTitle(const Value: WideString);
  public
     // Props
     // -- Frame title, assigned at runtime (we cannot localize it at design time since all of the controllers share the
     //    same translation in this example)
    property Title: WideString read GetTitle write SetTitle;
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

  function TfrFontSettings.GetTitle: WideString;
  begin
    Result := gbMain.Caption;
  end;

  procedure TfrFontSettings.SetSelectedFont(Value: TFont);
  begin
    pSample.Font.Assign(Value);
  end;

  procedure TfrFontSettings.SetTitle(const Value: WideString);
  begin
    gbMain.Caption := Value;
  end;

end.

