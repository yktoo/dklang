///*********************************************************************************************************************
///  $Id: DKL_LanguageCodes.pas 2013-12-06 00:00:00Z bjm $
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
//
// Language code/name lookups
//


unit DKL_LanguageCodes;

interface

function GetLanguageCodeFromLangId(aLANGID: UInt32): string;
function GetCultureCodeFromLangId(aLANGID: UInt32): string;
function GetCultureNameFromLangId(aLANGID: UInt32): string;
function GetCultureNativeNameFromLangId(aLANGID: UInt32): string;
function GetLanguageNameFromLangId(aLANGID: UInt32): string;
function GetLanguageNativeNameFromLangId(aLANGID: UInt32): string;

// works with either 'en' or 'en-US' types
function GetLangIdFromCultureCode(cultureCode: string): UInt32;


implementation

uses
  SysUtils;

type
  TLangRec = record
    lcid: UInt32;
    cultureCode: string;
    cultureName: string;
    langName: string;
    nativeLangName: string;
  end;

const

// DKL_LanguageCodes.inc holds the language data. It is generated on-demand
//  by Build_DKL_LanguageCodes.exe.

{$I DKL_LanguageCodes.inc}


function GetLangRecFromLCID(aLANGID: UInt32): TLangRec;
var langRec: TLangRec;
begin
  for langRec in LangRecs do
    if langRec.lcid = aLANGID then
      exit(langRec);
end;

function GetLangRecFromCultureCode(cultureCode: string): TLangRec;
var langRec: TLangRec;
begin
  for langRec in LangRecs do
    if SameText(cultureCode,langRec.culturecode) then
      exit(langRec);
end;

function GetLanguageCodeFromLangId(aLANGID: UInt32): string;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromLCID(aLANGID);

  // check to see if correct rec was found
  if langRec.lcid = aLANGID then
  begin
    result := langRec.cultureCode;
    if result.IndexOf('-') = -1 then exit;

    // strip culture suffix
    exit(result.Substring(0,result.IndexOf('-')));
  end;

  result := IntToStr(aLANGID);
end;

function GetCultureCodeFromLangId(aLANGID: UInt32): string;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromLCID(aLANGID);

  // check to see if correct rec was found
  if langRec.lcid = aLANGID then
    exit(langRec.cultureCode);

  result := IntToStr(aLANGID);
end;

function GetCultureNameFromLangId(aLANGID: UInt32): string;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromLCID(aLANGID);

  // check to see if correct rec was found
  if langRec.lcid = aLANGID then
  begin
    if langRec.cultureName <> '' then
      exit(langRec.cultureName)
    else
      exit(langRec.cultureCode);
  end;

  result := IntToStr(aLANGID);
end;

function GetCultureNativeNameFromLangId(aLANGID: UInt32): string;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromLCID(aLANGID);

  // check to see if correct rec was found
  if langRec.lcid = aLANGID then
  begin
    if  langRec.nativeLangName <> '' then
      exit(langRec.nativeLangName)
    else
      exit(langRec.langName);
  end;

  // not in list, so return the id as string
  result := IntToStr(aLANGID);
end;

function GetLanguageNativeNameFromLangId(aLANGID: UInt32): string;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromLCID(aLANGID);

  // check to see if correct rec was found
  if langRec.lcid = aLANGID then
  begin
    if  langRec.nativeLangName <> '' then
      result := langRec.nativeLangName
    else
      result := langRec.langName;

    if result.IndexOf('(') = -1 then exit;

    // strip culture suffix
    exit(result.Substring(0,result.IndexOf('(')).Trim);
  end;

  // not in list, so return the id as string
  result := IntToStr(aLANGID);
end;

function GetLanguageNameFromLangId(aLANGID: UInt32): string;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromLCID(aLANGID);

  // check to see if correct rec was found
  if langRec.lcid = aLANGID then
    exit(langRec.langName);

  // not in list, so return the id as string
  result := IntToStr(aLANGID);
end;

function GetLangIdFromCultureCode(cultureCode: string): UInt32;
var langRec: TLangRec;
begin
  langRec := GetLangRecFromCultureCode(cultureCode);

  // check to see if correct rec was found
  if SameText(langRec.cultureCode, cultureCode) then
    exit(langRec.lcid);

  // not in list, so return zero
  result := 0;
end;

end.
