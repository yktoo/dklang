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
