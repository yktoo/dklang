//**********************************************************************************************************************
//  $Id: DKLang_Frames_Demo.dpr,v 1.1 2005-01-23 18:14:44 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org
//**********************************************************************************************************************
program DKLang_Frames_Demo;

uses
  Forms,
  Main in 'Main.pas' {fMain},
  ufrFontSettings in 'ufrFontSettings.pas' {frFontSettings: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
