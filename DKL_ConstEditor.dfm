object dDKL_ConstEditor: TdDKL_ConstEditor
  Left = 540
  Top = 205
  ActiveControl = vleMain
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'DKLang Constant Editor'
  ClientHeight = 435
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    592
    435)
  PixelsPerInch = 96
  TextHeight = 13
  object lCount: TLabel
    Left = 8
    Top = 408
    Width = 43
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '<count>'
  end
  object vleMain: TValueListEditor
    Left = 8
    Top = 8
    Width = 575
    Height = 373
    Anchors = [akLeft, akTop, akRight, akBottom]
    KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 0
    TitleCaptions.Strings = (
      'Constant name'
      'Constant value')
    OnStringsChange = vleMainStringsChange
    ColWidths = (
      236
      333)
  end
  object bOK: TButton
    Left = 188
    Top = 404
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 268
    Top = 404
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bLoad: TButton
    Left = 428
    Top = 404
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Load...'
    TabOrder = 5
    OnClick = bLoadClick
  end
  object bSave: TButton
    Left = 508
    Top = 404
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Save...'
    TabOrder = 6
    OnClick = bSaveClick
  end
  object cbSaveToLangSource: TCheckBox
    Left = 8
    Top = 384
    Width = 573
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 
      '&Also save the constants into the project language source file (' +
      '*.dklang)'
    TabOrder = 1
  end
  object bErase: TButton
    Left = 348
    Top = 404
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Erase'
    TabOrder = 4
    OnClick = bEraseClick
  end
end
