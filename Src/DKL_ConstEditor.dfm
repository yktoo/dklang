object dDKL_ConstEditor: TdDKL_ConstEditor
  Left = 357
  Top = 191
  ActiveControl = gMain
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'DKLang Constant Editor'
  ClientHeight = 875
  ClientWidth = 1066
  Color = clBtnFace
  Constraints.MinHeight = 415
  Constraints.MinWidth = 831
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    1066
    875)
  PixelsPerInch = 130
  TextHeight = 19
  object lCount: TLabel
    Left = 11
    Top = 838
    Width = 63
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Anchors = [akLeft, akBottom]
    Caption = '<count>'
    ExplicitTop = 565
  end
  object lDeleteHint: TLabel
    Left = 11
    Top = 783
    Width = 306
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Anchors = [akLeft, akBottom]
    Caption = 'Use Ctrl+Delete to delete the current entry.'
    ExplicitTop = 510
  end
  object lblSearchPos: TLabel
    Left = 437
    Top = 11
    Width = 123
    Height = 19
    Caption = '<SEARCH_POS>'
  end
  object gMain: TStringGrid
    Left = 12
    Top = 38
    Width = 1045
    Height = 737
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultRowHeight = 22
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = gMainDrawCell
    OnKeyDown = gMainKeyDown
    OnMouseUp = gMainMouseUp
    OnSelectCell = gMainSelectCell
    ColWidths = (
      286
      284)
  end
  object bOK: TButton
    Left = 506
    Top = 832
    Width = 104
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 617
    Top = 832
    Width = 104
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bLoad: TButton
    Left = 839
    Top = 832
    Width = 103
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = '&Load...'
    TabOrder = 5
    OnClick = bLoadClick
  end
  object bSave: TButton
    Left = 949
    Top = 832
    Width = 104
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = '&Save...'
    TabOrder = 6
    OnClick = bSaveClick
  end
  object cbSaveToLangSource: TCheckBox
    Left = 11
    Top = 805
    Width = 1039
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akRight, akBottom]
    Caption = 
      '&Also save the constants into the project language source file (' +
      '*.dklang)'
    TabOrder = 1
  end
  object bErase: TButton
    Left = 728
    Top = 832
    Width = 104
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = '&Erase'
    TabOrder = 4
    OnClick = bEraseClick
  end
  object edtSearch: TEdit
    Left = 11
    Top = 7
    Width = 214
    Height = 27
    ParentShowHint = False
    ShowHint = False
    TabOrder = 7
    TextHint = 'Search...'
    OnChange = edtSearchChange
  end
  object btnGotoFirstMatch: TButton
    Left = 231
    Top = 7
    Width = 109
    Height = 27
    Caption = '<- &Previous'
    TabOrder = 8
    TabStop = False
    OnClick = btnGotoFirstMatchClick
  end
  object btnGotoNextMatch: TButton
    Left = 346
    Top = 7
    Width = 85
    Height = 27
    Caption = '&Next ->'
    TabOrder = 9
    TabStop = False
    OnClick = btnGotoNextMatchClick
  end
end
