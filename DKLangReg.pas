///*********************************************************************************************************************
///  $Id: DKLangReg.pas,v 1.3 2004-09-25 18:49:36 dale Exp $
///---------------------------------------------------------------------------------------------------------------------
///  DKLang Localization Package
///  Copyright 2002-2004 DK Software, http://www.dk-soft.org
///*********************************************************************************************************************
// Component, expert and component editor registration routines
unit DKLangReg;

interface

  procedure Register;

implementation
{$R *.dcr}
uses SysUtils, Classes, DesignEditors, DesignIntf, ToolsAPI, DKLang, DKL_Expt;

   //====================================================================================================================
   //  Component, Property and Editor registration
   //====================================================================================================================

  procedure Register;
  begin
    RegisterComponents('System', [TDKLanguageController]);
     // Register expert
    RegisterPackageWizard(DKLang_CreateExpert);
    RegisterComponentEditor(TDKLanguageController, TDKLangControllerEditor);
  end;

end.
