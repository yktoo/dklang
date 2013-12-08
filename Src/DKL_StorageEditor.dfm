object DKLangTranslationStorageEditor: TDKLangTranslationStorageEditor
  Left = 0
  Top = 0
  Caption = 'DKLang Translation Storage'
  ClientHeight = 187
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 546
    Height = 187
    Align = alClient
    Caption = 'Stored Translations'
    TabOrder = 0
    DesignSize = (
      546
      187)
    object ListView: TListView
      Left = 2
      Top = 15
      Width = 420
      Height = 170
      Align = alLeft
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          AutoSize = True
          Caption = 'Language'
          MinWidth = 100
        end
        item
          AutoSize = True
          Caption = 'Filename'
          MinWidth = 80
        end
        item
          Alignment = taRightJustify
          Caption = 'File Size'
          MinWidth = 50
        end
        item
          Alignment = taRightJustify
          Caption = 'Stored Size'
          MinWidth = 50
        end
        item
          Caption = 'Import Date'
          Width = 80
        end
        item
          Caption = 'Full Path'
          Width = 200
        end>
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = ListViewSelectItem
    end
    object AddBtn: TButton
      Left = 423
      Top = 11
      Width = 120
      Height = 23
      Hint = 
        '|Uploads new file onto form and add it to the FileStorage.Files ' +
        'list.'
      Anchors = [akTop, akRight]
      Caption = '&Add translation(s)...'
      TabOrder = 1
      OnClick = AddBtnClick
    end
    object DeleteBtn: TButton
      Left = 423
      Top = 35
      Width = 120
      Height = 23
      Hint = '|Deletes selected file from the FileStorage.Files list.'
      Anchors = [akTop, akRight]
      Caption = '&Delete translation(s)'
      Enabled = False
      TabOrder = 2
      OnClick = DeleteBtnClick
    end
    object UpdateBtn: TButton
      Left = 423
      Top = 59
      Width = 120
      Height = 23
      Hint = '|Updates selected file from the FileStorage.Files list.'
      Anchors = [akTop, akRight]
      Caption = 'Update translation(s)'
      Enabled = False
      TabOrder = 3
      OnClick = UpdateBtnClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Translations (*.lng)|*.lng|Any File (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist]
    Title = 'Please point file to upload in Storage'
    Left = 8
    Top = 100
  end
  object PopupMenu: TPopupMenu
    Left = 64
    Top = 100
    object SelectAll1: TMenuItem
      Caption = 'Select &All'
      ShortCut = 16449
      OnClick = SelectAll1Click
    end
  end
end
