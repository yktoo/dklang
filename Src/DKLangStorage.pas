///*********************************************************************************************************************
///  $Id: DKLangStorage.pas 2013-12-06 00:00:00Z bjm $
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
// Translations stored in zlib on form
//

unit DKLangStorage;

interface

uses
  System.Classes, System.Generics.Collections;

type

// TStoredFile persists the contents of any file through Delphi's component persistence
// It is content agnostic.
// File contents are stored zlib compressed in a TMemoryStream
// File contents can be released by calling Clear

  TStoredFile = class
  strict private
    fFileName: string;  // now in the form: c:\dir\filename.ext|2011.07.23
    fFileDate: string;
    fFileDescription: string;
    fFileSize: Int32;
    fData: TMemoryStream;
    function GetStoredSize: Int32;
  private
    procedure Clear;
    function  Extract(stream: TStream): Boolean; overload;// True if successfull
    procedure ReadData(stream: TStream);
    procedure WriteData(stream: TStream);
  public
    constructor Create;
    destructor  Destroy; override;
    function Import(stream: TStream; const aFileName: String; const aDescription: string; aDateStamp: TDateTime): Boolean; // True if successfull
    property FileName: string read fFileName;
    property ImportDate: string read fFileDate;
    property Description: string read fFileDescription;
    property FileSize: Int32 read fFileSize;
    property StoredSize: Int32 read GetStoredSize;
  end;

  TTranslationFiles = class(TObjectList<TStoredFile>);

{$IFDEF CONDITIONALEXPRESSIONS}
{$IF CompilerVersion >= 29.0}  // XE8 up
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid)]
{$ELSE}
{$IF CompilerVersion >= 25.0}  // XE4 up
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice or pidAndroid)]
{$IFEND}
{$IFEND}
{$ENDIF}
  TDKLTranslationsStorage = class(TComponent)
  private
    fFiles: TTranslationFiles;
    fReleaseMemoryOnTranslationRegistration: Boolean;
    function  GetCount: Integer;
    function  GetFileSize: Integer;
    function  GetStoredSize: Integer;
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure Loaded; override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Count: Integer read GetCount stored false;
    property FileSize: Integer read GetFileSize stored false;
    property StoredSize: Integer read GetStoredSize stored false;
    property Translations: TTranslationFiles read fFiles write fFiles stored false;
    property ReleaseMemoryOnTranslationRegistration: Boolean read fReleaseMemoryOnTranslationRegistration write fReleaseMemoryOnTranslationRegistration stored true default false;
  end;



implementation

uses
  System.SysUtils, System.ZLib, DKLang;

  // stream utilities

  procedure StreamWriteUnicodeStr(Stream: TStream; const ws: UnicodeString);
  var
    w: Word;
    c: TCharArray;
  begin
    w := Length(ws);
    c := ws.ToCharArray;
    Stream.WriteBuffer(w, 2);
    Stream.WriteBuffer(c[0], w*2);
  end;

  function StreamReadUnicodeStr(Stream: TStream): UnicodeString;
  var
    w: Word;
    b: TBytes;
  begin
    Stream.ReadBuffer(w, 2);
    SetLength(b,w*2);
    Stream.ReadBuffer(b[0],w*2);
    result := TEncoding.Unicode.GetString(b);
  end;


constructor TStoredFile.Create;
begin
  inherited;

  fFileName := '';
  fFileDate := '';
  fFileSize := 0;
  fData := TMemoryStream.Create;
end;

destructor TStoredFile.Destroy;
begin
  if fData <> nil then
    fData.Free;

  inherited;
end;

function TStoredFile.GetStoredSize: Int32;
begin
  result := fData.Size;
end;

procedure TStoredFile.Clear;
begin
  FreeAndNil(fData);
end;

procedure TStoredFile.ReadData(stream: TStream);
var
  n: Int32;
begin
  fFileName := StreamReadUnicodeStr(Stream);
  fFileDate := StreamReadUnicodeStr(Stream);
  fFileDescription := StreamReadUnicodeStr(Stream);

  // read the original file size
  stream.Read(fFileSize, SizeOf(fFileSize));

  // read the data
  Stream.Read(n, Sizeof(n));
  fData.CopyFrom(stream,n);
end;

procedure TStoredFile.WriteData(Stream: TStream);
var
  n: Int32;
begin
  StreamWriteUnicodeStr(Stream, fFileName);
  StreamWriteUnicodeStr(Stream, fFileDate);
  StreamWriteUnicodeStr(Stream, fFileDescription);

  // store the original file size
  stream.Write(fFileSize, SizeOf(fFileSize));

  // store the data
  n := fData.Size;
  stream.Write(n, SizeOf(n));
  fData.Position := 0;
  stream.CopyFrom(fData,n);
end;

function TStoredFile.Import(stream: TStream; const aFileName: String; const aDescription: string; aDateStamp: TDateTime): Boolean; // True if successfull
var
  ZLibStream: TCompressionStream;
  len: Int32;
begin
  DateTimeToString(fFileDate,'yyyy-mm-dd hh:nn:ss',aDateStamp);
  fFileName := aFileName;
  fFileDescription := aDescription;

  fFileSize := 0;
  len := stream.Size;
  fData.Clear;
  ZLibStream := TCompressionStream.Create(fData);
  try
    ZLibStream.CopyFrom(stream, len);
    fFileSize := len;
    result := true;
  finally
    ZLibStream.Free;
  end;
end;

function TStoredFile.Extract(stream: TStream): Boolean;
var
  ZLibStream: TDecompressionStream;
begin
  fData.Position := 0;
  ZLibStream := TDecompressionStream.Create(fData);
  try
    stream.CopyFrom(ZLibStream,fFileSize);
    result := true;
  finally
    ZLibStream.Free;
  end;
end;



constructor TDKLTranslationsStorage.Create(aOwner: TComponent);
begin
  inherited;

  fFiles := TTranslationFiles.Create;
end;

destructor TDKLTranslationsStorage.Destroy;
begin
  fFiles.Free;

  inherited;
end;

procedure TDKLTranslationsStorage.Loaded;
var
  storedFile: TStoredFile;
  stream: TMemoryStream;
begin
  inherited;

  if DKLang_IsDesignTime then exit;

  for storedFile in fFiles  do
  begin
    stream := TMemoryStream.Create;
    try
      storedFile.Extract(stream);
      stream.Position := 0;
      // add to LangManager
      TDKLanguageManager.RegisterLangStream(stream);
      if fReleaseMemoryOnTranslationRegistration then
        storedFile.Clear;
    finally
      stream.Free;
    end;
  end;
end;

function TDKLTranslationsStorage.GetCount: Integer;
begin
  result := fFiles.Count;
end;

function TDKLTranslationsStorage.GetFileSize: Integer;
var
  storedFile: TStoredFile;
begin
  result := 0;
  for storedFile in fFiles do
    Inc(result,storedFile.FileSize);
end;

function TDKLTranslationsStorage.GetStoredSize: Integer;
var
  storedFile: TStoredFile;
begin
  result := 0;
  for storedFile in fFiles do
    Inc(result,storedFile.StoredSize);
end;

procedure TDKLTranslationsStorage.ReadData(Stream: TStream);
var
  i,n: Int32;
  storedFile: TStoredFile;
begin
  Stream.Read(n, SizeOf(n));

  if n <> 0 then
    for i := 0 to n - 1 do
    begin
     storedFile := TStoredFile.Create;
     storedFile.ReadData(Stream);
     fFiles.Add(storedFile);
    end;
end;

procedure TDKLTranslationsStorage.WriteData(Stream: TStream);
var
  n: Int32;
  storedFile: TStoredFile;
begin
  // write data
  n := fFiles.Count;
  Stream.Write(n, SizeOf(n));
  for storedFile in fFiles do
    storedFile.WriteData(Stream);
end;

procedure TDKLTranslationsStorage.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('StoredTranslationFiles', ReadData, WriteData, fFiles.Count <> 0);
end;



end.
