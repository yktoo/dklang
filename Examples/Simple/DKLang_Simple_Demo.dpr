//**********************************************************************************************************************
//  $Id: DKLang_Simple_Demo.dpr,v 1.2 2004-09-21 05:10:48 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org
//**********************************************************************************************************************
program DKLang_Simple_Demo;

uses
  Forms,
  Main in 'Main.pas' {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
