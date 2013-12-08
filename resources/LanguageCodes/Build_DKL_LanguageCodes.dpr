program Build_DKL_LanguageCodes;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  System.SysUtils,
  System.Classes,
  WinApi.Windows;

const
  sUnitName = 'DKL_LanguageCodes';

var
  s,sUnit: string;
  slFile,row,list: TStringList;

  procedure Insert(const key: string; const newValue: string);
  begin
    sUnit := StringReplace(sUnit,key,newValue,[rfReplaceAll,rfIgnoreCase]);
  end;

  function xHexToIntStr(const hex: string): string;
  begin
    result := Format('%5d',[StrToInt('$' + Copy(hex,3,Length(hex)))]);
  end;

  function EscapeQuoteAndPad(const src: string; targetLen: Integer): string;
  var
    len: Integer;
  begin
    result := '''' + StringReplace(Trim(src),'''','''''',[rfReplaceAll]) + '''';
    len := Length(result);
    if len < targetLen then
      result := Copy(result + StringOfChar(' ',targetLen),1,targetLen);
  end;

begin
  try
    slFile := TStringList.Create;
    list := TStringList.Create;
    row := TStringList.Create;
    try
      // otherwise will split on spaces
      row.Delimiter := Char(9);
      row.StrictDelimiter := true;

      slFile.LoadFromFile(sUnitName+'.inc.template', TEncoding.UTF8);
      sUnit := slFile.Text;

      Insert('$UNITNAME',sUnitName);
      DateTimeToString(s,'yyyy-mm-dd hh:nn:ss',Now);
      Insert('$DATETIME',s);
      DateTimeToString(s,'yyyy',Now);
      Insert('$YEAR',s);

      slFile.LoadFromFile('LangID_ISO_639_1.tab');
      for s in slFile do
      begin
        row.DelimitedText := s;
        if row.Count > 1 then
          list.Add(Format('    ''%s'',',[row[1]]));
      end;
      s := Trim(list.Text);
      // remove trailing ,
      Delete(s,Length(s),1);
      Insert('$ISO_639_1_LangCodesIndexedByLANGID_COUNT', IntToStr(list.Count));
      Insert('$ISO_639_1_LangCodesIndexedByLANGID_LIST',s);



    //  0 LCID
    //  1 culture name
    //  2 locale
    //  3 language name
    //  4 local language name
    //  5 ANSI codepage
    //  6 OEM codepage
    //  7 country/region abbreviation
    //  8 language abbreviation

    //  lcid: LANGID;
    //  cultureCode: string;
    //  cultureName: string
    //  langName: string;
    //  nativeLangName: string;

      list.Clear;
      slFile.LoadFromFile('MicrosoftNationalLanguageSupportReference.tab', TEncoding.UTF8);
      for s in slFile do
      begin
        row.DelimitedText := s;
        if row.Count > 4 then
          list.Add(Format('    (lcid:%s; cultureCode:%s;cultureName:%s;langName:%s;nativeLangName:%s),',
                             [xHexToIntStr(row[0]),
                              EscapeQuoteAndPad(row[1],12),
                              EscapeQuoteAndPad(row[2],44),
                              EscapeQuoteAndPad(row[3],30),
                              EscapeQuoteAndPad(row[4],0)
                              ]));
      end;
      s := Trim(list.Text);
      // remove trailing ,
      Delete(s,Length(s),1);
      Insert('$MS_NLS_REF_COUNT', IntToStr(list.Count));
      Insert('$MS_NLS_REF_LIST',s);

      slFile.Text := sUnit;
      slFile.SaveToFile('.\..\..\src\' + sUnitName + '.inc',TEncoding.UTF8);
    finally
      row.Free;
      list.Free;
      slFile.Free;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
