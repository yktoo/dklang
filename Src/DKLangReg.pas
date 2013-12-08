///*********************************************************************************************************************
///  $Id: DKLangReg.pas 2013-12-06 00:00:00Z bjm Exp $
///---------------------------------------------------------------------------------------------------------------------
///  DKLang Localization Package
///  Copyright 2002-2013 DK Software, http://www.dk-soft.org
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
/// Upgraded to Delphi 2009 by Bruce J. Miller, rules-of-thumb.com Dec 2008
///
/// Upgraded to Delphi XE5 (for FireMonkey) by Bruce J. Miller, rules-of-thumb.com Nov 2013
///
///**********************************************************************************************************************
// Component, expert and component editor registration routines
//
//
// NextGen (mobile FireMonkey, for now) defaults to zero-based indexing of strings
// and this keeps the code simpler, at least until Delphi moves completely to
// zero-based string indexing


unit DKLangReg;

interface

uses
  DesignEditors,DesignIntf;

type
  TDKLTranslationsStorageProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: String; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TDKLTranslationsStorageCompEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
  end;

  procedure Register;

implementation
{$R *.dcr}
uses Classes, ToolsAPI, DKLang, DKLangStorage, DKL_Expt, DKL_StorageEditor;

   //====================================================================================================================
   //  Component registration
   //====================================================================================================================

  procedure Register;
  begin
    // Register components
    RegisterComponents('DKLang', [TDKLanguageController,TDKLTranslationsStorage]);

    // Register expert and editor
    RegisterPackageWizard(DKLang_CreateExpert);
    RegisterComponentEditor(TDKLanguageController, TDKLangControllerEditor);

    // Register storage editor
    RegisterComponentEditor(TDKLTranslationsStorage, TDKLTranslationsStorageCompEditor);
    RegisterPropertyEditor(TypeInfo(TTranslationFiles), TDKLTranslationsStorage, 'Translations', TDKLTranslationsStorageProperty);

  end;

procedure TDKLTranslationsStorageProperty.Edit;
begin
  ShowDKLangTranslationStorageEditor(Designer, TDKLTranslationsStorage(GetComponent(0)));
end;

function TDKLTranslationsStorageProperty.GetValue: String;
begin
  if TDKLTranslationsStorage(GetComponent(0)).Translations.Count = 0 then
    Result := '(None)'
  else
    Result := '(Stored Translations)';
end;

function TDKLTranslationsStorageProperty.GetAttributes: TPropertyAttributes;
begin
  result := [paDialog];
end;


procedure TDKLTranslationsStorageCompEditor.ExecuteVerb(Index: Integer);
begin
  if Index = GetVerbCount - 1 then
    ShowDKLangTranslationStorageEditor(Designer, TDKLTranslationsStorage(Component))
  else
    inherited ExecuteVerb(Index);
end;

function TDKLTranslationsStorageCompEditor.GetVerbCount: Integer;
begin
  result := inherited GetVerbCount + 1;
end;

function TDKLTranslationsStorageCompEditor.GetVerb(Index: Integer): string;
begin
  if Index = GetVerbCount - 1 then
    result := 'Language Files Importer...'
  else
    result := inherited GetVerb(Index);
end;


end.
