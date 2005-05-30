//**********************************************************************************************************************
//  $Id: DKLang_MDI_Demo.dpr,v 1.1 2005-05-30 12:46:20 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org
//**********************************************************************************************************************
program DKLang_MDI_Demo;

uses
  Forms,
  Main in 'Main.pas' {fMain},
  ufMDIChild in 'ufMDIChild.pas' {fMDIChild};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
