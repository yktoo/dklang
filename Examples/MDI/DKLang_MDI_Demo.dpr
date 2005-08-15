//**********************************************************************************************************************
//  $Id: DKLang_MDI_Demo.dpr,v 1.2 2005-08-15 11:19:01 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright 2002-2005 DK Software, http://www.dk-soft.org
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
