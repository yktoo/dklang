///*********************************************************************************************************************
///  $Id: DKL_ResFile.pas,v 1.1 2006-08-09 14:20:36 dale Exp $
///---------------------------------------------------------------------------------------------------------------------
///  DKLang Localization Package
///  Copyright 2002-2006 DK Software, http://www.dk-soft.org
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
// Routines and classes to handle .res resource files
//
unit DKL_ResFile;

interface
uses Windows, SysUtils, Classes, Contnrs, TntClasses;

type

   //===================================================================================================================
   // Resource entry header
   //===================================================================================================================

  PResResourceEntryHeader = ^TResResourceEntryHeader;
  TResResourceEntryHeader = packed record
    iDataSize:   Integer; // Data size in bytes
    iHeaderSize: Integer; // Header size in bytes
  end;

   //===================================================================================================================
   // Resource entry properties
   //===================================================================================================================

  PResResourceEntryProps = ^TResResourceEntryProps;
  TResResourceEntryProps = packed record
    cDataVersion:     Cardinal;
    wMemoryFlags:     Word;
    wLanguage:        LANGID;
    cVersion:         Cardinal;
    cCharacteristics: Cardinal;
  end;

   //===================================================================================================================
   // .res file handler
   //===================================================================================================================

  TDKLang_ResEntry = class;
  
  TDKLang_ResFile = class(TObject)
  private
     // Entry list
    FEntries: TObjectList;
     // Loads .res file contents from the stream
    procedure LoadFromStream(Stream: TStream);
     // Saves .res file contents into the stream
    procedure SaveToStream(Stream: TStream);
    function GetEntries(Index: Integer): TDKLang_ResEntry;
    function GetEntryCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
     // Adds an entry and returns its index
    function  AddEntry(Item: TDKLang_ResEntry): Integer;
     // Deletes the entry
    procedure DeleteEntry(Index: Integer);
     // Clears the entry list
    procedure ClearEntries; 
     // Loads .res file contents from the file
    procedure LoadFromFile(const wsFileName: WideString);
     // Saves .res file contents into the file
    procedure SaveToFile(const wsFileName: WideString);
     // Props
     // -- Entry count
    property EntryCount: Integer read GetEntryCount;
     // -- Entries by index
    property Entries[Index: Integer]: TDKLang_ResEntry read GetEntries; default;
  end;

   //===================================================================================================================
   // Single resource entry
   //===================================================================================================================

  TDKLang_ResEntry = class(TObject)
  private
     // Prop storage
    FCharacteristics: Cardinal;
    FDataVersion: Cardinal;
    FLanguage: LANGID;
    FMemoryFlags: Word;
    FName: WideString;
    FRawData: String;
    FResType: WideString;
    FVersion: Cardinal;
  public
     // Props
     // -- Characteristics
    property Characteristics: Cardinal read FCharacteristics write FCharacteristics;
     // -- Data version
    property DataVersion: Cardinal read FDataVersion write FDataVersion;
     // -- Language
    property Language: LANGID read FLanguage write FLanguage;
     // -- Memory flags
    property MemoryFlags: Word read FMemoryFlags write FMemoryFlags;
     // -- Entry name
    property Name: WideString read FName write FName;
     // -- Raw (unparsed) entry data
    property RawData: String read FRawData write FRawData;
     // -- Entry resource type
    property ResType: WideString read FResType write FResType;
     // -- Version
    property Version: Cardinal read FVersion write FVersion;
  end;

implementation //=======================================================================================================
uses TntDialogs;

   //===================================================================================================================
   // TDKLang_ResFile
   //===================================================================================================================

  function TDKLang_ResFile.AddEntry(Item: TDKLang_ResEntry): Integer;
  begin
    Result := FEntries.Add(Item);
  end;

  procedure TDKLang_ResFile.ClearEntries;
  begin
    FEntries.Clear;
  end;

  constructor TDKLang_ResFile.Create;
  begin
    inherited Create;
    FEntries := TObjectList.Create(True);
  end;

  procedure TDKLang_ResFile.DeleteEntry(Index: Integer);
  begin
    FEntries.Delete(Index);
  end;

  destructor TDKLang_ResFile.Destroy;
  begin
    FEntries.Free;
    inherited Destroy;
  end;

  function TDKLang_ResFile.GetEntries(Index: Integer): TDKLang_ResEntry;
  begin
    Result := TDKLang_ResEntry(FEntries[Index]);
  end;

  function TDKLang_ResFile.GetEntryCount: Integer;
  begin
    Result := FEntries.Count;
  end;

  procedure TDKLang_ResFile.LoadFromFile(const wsFileName: WideString);
  var Stream: TStream;
  begin
    Stream := TTntFileStream.Create(wsFileName, fmOpenRead or fmShareDenyWrite);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;

  procedure TDKLang_ResFile.LoadFromStream(Stream: TStream);
  var
    pBuffer, pData: PByte;
    iBufferSize, iBytesLeft, iBlockSize: Integer;
    Header: TResResourceEntryHeader;

     // Retrieves a string or numeric identifier from the data and shifts the pointer appropriately
    function RetrieveIdentifier(var p: PByte): WideString;
    begin
       // Numeric ID
      if PWord(p)^=$ffff then begin
        Inc(p, SizeOf(Word));
        Result := IntToStr(PWord(p)^);
        Inc(p, SizeOf(Word))
       // A wide string name
      end else begin
        Result := WideString(PWideChar(p));
        Inc(p, (Length(Result)+1)*SizeOf(WideChar));
      end;
    end;

     // Processes a resource entry
    procedure ProcessResourceEntry;
    var
      p: PByte;
      wsName, wsType: WideString;
      EntryProps: TResResourceEntryProps;
      Entry: TDKLang_ResEntry;
      sRawData: String;
    begin
      p := pData;
       // Skip the header
      Inc(p, SizeOf(Header));
       // Retrieve resource type and name
      wsType := RetrieveIdentifier(p);
      wsName := RetrieveIdentifier(p);
       // Align the pointer to a 4-byte boundary
      if (Integer(p) mod 4)<>0 then Inc(p, 4-Integer(p) mod 4);
       // Read entry properties
      Move(p^, EntryProps, SizeOf(EntryProps));
       // Create an entry
      Entry := TDKLang_ResEntry.Create;
      try
        Entry.ResType         := wsType;
        Entry.Name            := wsName;
        Entry.DataVersion     := EntryProps.cDataVersion;
        Entry.MemoryFlags     := EntryProps.wMemoryFlags;
        Entry.Language        := EntryProps.wLanguage;
        Entry.Version         := EntryProps.cVersion;
        Entry.Characteristics := EntryProps.cCharacteristics;
        SetString(sRawData, PChar(Integer(pData)+Header.iHeaderSize), Header.iDataSize);
        Entry.RawData         := sRawData;
         // Register the entry in the list
        AddEntry(Entry);
      except
        Entry.Free;
        raise;
      end;
    end;

  begin
     // Clear the entry list
    ClearEntries;
     // Allocate the buffer
    iBufferSize := Stream.Size;
    GetMem (pBuffer, iBufferSize);
    try
       // Read the entire file into the buffer
      Stream.ReadBuffer(pBuffer^, iBufferSize);
       // Scan the buffer
      iBytesLeft := iBufferSize;
      pData := pBuffer;
      while iBytesLeft>=SizeOf(Header) do begin
         // Read the header
        Move(pData^, Header, SizeOf(Header));
         // Process the entry
        ProcessResourceEntry;
         // Shift pointers
        iBlockSize := ((Header.iDataSize+Header.iHeaderSize+3) div 4)*4;
        Inc(pData,      iBlockSize);
        Dec(iBytesLeft, iBlockSize);
      end;
    finally
      FreeMem(pBuffer);
    end;
  end;

  procedure TDKLang_ResFile.SaveToFile(const wsFileName: WideString);
  var Stream: TStream;
  begin
    Stream := TTntFileStream.Create(wsFileName, fmCreate);
    try
      SaveToStream(Stream);
    finally
      Stream.Free;
    end;
  end;

  procedure TDKLang_ResFile.SaveToStream(Stream: TStream);
  begin
    //!!!
  end;

end.
