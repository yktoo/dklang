//**********************************************************************************************************************
//  $Id: DKLang_Simple_Demo.dpr,v 1.3 2005-08-15 11:19:01 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2005 DK Software, http://www.dk-soft.org
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
