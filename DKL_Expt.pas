unit DKL_Expt;

interface
uses Classes, ToolsAPI, DesignEditors;

   // Creates DKLang expert instance
  function DKLang_CreateExpert: IOTAWizard;

type
   // TDKLanguageController component editor
  TDKLangControllerEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function  GetVerb(Index: Integer): string; override;
    function  GetVerbCount: Integer; override;
  end;

resourcestring
  SDKLExptErr_CannotObtainNTAIntf    = 'Cannot obtain INTAServices interface';
  SDKLExptErr_CannotObtainOTAIntf    = 'Cannot obtain IOTAServices interface';
  SDKLExptErr_CannotObtainModSvcIntf = 'Cannot obtain IOTAModuleServices interface';
  SDKLExptErr_CannotFindProjectMenu  = 'Cannot locate ''Project'' submenu';
  SDKLExptErr_CannotFindProject      = 'No active project found';
  SDKLExptErr_CannotObtainResources  = 'Failed to get project resource interface. Check whether project is open and active, and it uses a resource file';
  SDKLExptErr_CannotSaveLangSource   = 'Failed to update project language source. Check whether project is open and active';

  SDKLExptMsg_LCsUpdated             = '%d language controllers have updated the project language source.';

  SDKLExptMenuItem_EditConstants     = 'Edit pro&ject constants...';
  SDKLExptMenuItem_UpdateLangSource  = 'Update project lan&guage source';

implementation //=======================================================================================================
uses
  SysUtils, Windows, Registry, Menus, Graphics, Dialogs, DesignIntf, TypInfo, Forms, RTLConsts, 
  DKLang, DKL_ConstEditor;

   // Returns the current active project, if any; raises an exception otherwise
  function GetActualProject: IOTAProject;
  begin
    Result := GetActiveProject;
    if Result=nil then DKLangError(SDKLExptErr_CannotFindProject);
  end;

   // Stores the LSObject's language source data in the current project's language source file. Returns True if
   //   succeeded
  function UpdateProjectLangSource(LSObject: IDKLang_LanguageSourceObject): Boolean;
  var Proj: IOTAProject;
  begin
     // If a project is open
    Proj := GetActiveProject;
    Result := Proj<>nil;
    if Result then UpdateLangSourceFile(ChangeFileExt(Proj.FileName, '.'+SDKLang_LangSourceExtension), LSObject, []);
  end;

   // Finds first TDKLanguageController instance among components owned by RootComp, if any, and calls
   //   UpdateProjectLangSource(). Returns True if succeeded
  function LC_UpdateProjectLangSource(RootComp: TComponent): Boolean;
  var
    i: Integer;
    LC: TDKLanguageController;
  begin
    Result := False;
    if RootComp<>nil then
      for i := 0 to RootComp.ComponentCount-1 do
         // If found
        if RootComp.Components[i] is TDKLanguageController then begin
          LC := TDKLanguageController(RootComp.Components[i]);
          if dklcoAutoSaveLangSource in LC.Options then begin
            UpdateProjectLangSource(LC);
            Result := True;
          end;
          Break;
        end;
  end;

type
  TDKLang_Expert = class;

   //===================================================================================================================
   // TDKLang_FormNotifier
   //===================================================================================================================

  TDKLang_FormNotifier = class(TNotifierObject, IOTANotifier, IOTAFormNotifier)
  private
     // The module with which the notifier is associated
    FModule: IOTAModule;
     // IOTANotifier
    procedure Destroyed;
     // IOTAFormNotifier
    procedure FormActivated;
    procedure FormSaving;
    procedure ComponentRenamed(ComponentHandle: TOTAHandle; const OldName, NewName: String);
  public
    constructor Create(AModule: IOTAModule);
  end;

   //===================================================================================================================
   // TDKLang_OTAIDENotifier
   //===================================================================================================================

  TDKLang_OTAIDENotifier = class(TNotifierObject, IOTAIDENotifier)
  private
     // Expert owner
    FExpert: TDKLang_Expert;
     // IOTAIDENotifier
    procedure FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
    procedure AfterCompile(Succeeded: Boolean);
  public
    constructor Create(AExpert: TDKLang_Expert);
  end;

   //===================================================================================================================
   // TDKLang_Expert
   //===================================================================================================================

  TDKLang_Expert = class(TNotifierObject, IOTAWizard)
  private
     // IDE interface
    FNTAServices: INTAServices;
    FOTAServices: IOTAServices;
    FModServices: IOTAModuleServices;
     // OTA notifier index
    FOTANotifierIndex: Integer;
     // Menu item owner
    FMenuOwner: TComponent;
     // Menu items
    FItem_EditConstants: TMenuItem;
    FItem_UpdateLangSource: TMenuItem;
     // Adds and returns a menu item
    function  NewMenuItem(const sCaption: String; Menu: TMenuItem; AOnClick: TNotifyEvent): TMenuItem;
     // Menu item click events
    procedure ItemClick_EditConstants(Sender: TObject);
    procedure ItemClick_UpdateLangSource(Sender: TObject);
     // Invokes the constant editor for editing constant data in the project resources. Returns True if user saved the
     //   changes
    function  EditConstantsResource: Boolean;
     // IOTAWizard
    function  GetIDString: string;
    function  GetName: string;
    function  GetState: TWizardState;
    procedure Execute;
  public
    constructor Create;
    destructor Destroy; override;
  end;

   //===================================================================================================================
   // TDKLang_FormNotifier
   //===================================================================================================================

  procedure TDKLang_FormNotifier.ComponentRenamed(ComponentHandle: TOTAHandle; const OldName, NewName: String);
  begin
    { stub }
  end;

  constructor TDKLang_FormNotifier.Create(AModule: IOTAModule);
  begin
    inherited Create;
    FModule := AModule;
  end;

  procedure TDKLang_FormNotifier.Destroyed;
  begin
    FModule := nil;
  end;

  procedure TDKLang_FormNotifier.FormActivated;
  begin
    { stub }
  end;

  procedure TDKLang_FormNotifier.FormSaving;
  var
    i: Integer;
    NTAFormEditor: INTAFormEditor;
  begin
    if FModule=nil then Exit;
     // Find the FormEditor interface for the module
    for i := 0 to FModule.ModuleFileCount-1 do
      if Supports(FModule.ModuleFileEditors[i], INTAFormEditor, NTAFormEditor) then begin
        LC_UpdateProjectLangSource(NTAFormEditor.FormDesigner.Root);
        Break;
      end;
  end;

   //===================================================================================================================
   // TDKLang_OTAIDENotifier
   //===================================================================================================================

  procedure TDKLang_OTAIDENotifier.AfterCompile(Succeeded: Boolean);
  begin
    { stub }
  end;

  procedure TDKLang_OTAIDENotifier.BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
  begin
    { stub }
  end;

  constructor TDKLang_OTAIDENotifier.Create(AExpert: TDKLang_Expert);
  begin
    inherited Create;
    FExpert := AExpert;
  end;

  procedure TDKLang_OTAIDENotifier.FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
  var
    Module: IOTAModule;
    OTAFormEditor: IOTAFormEditor;
    i: Integer;
  begin
    if NotifyCode=ofnFileOpened then begin
       // Find the module by file name and install the notifier on IOTAFormEditor interface
      Module := FExpert.FModServices.FindModule(FileName);
      if Module<>nil then
        for i := 0 to Module.ModuleFileCount-1 do
          if Supports(Module.ModuleFileEditors[i], IOTAFormEditor, OTAFormEditor) then
            OTAFormEditor.AddNotifier(TDKLang_FormNotifier.Create(Module));
    end;
  end;

   //===================================================================================================================
   // TDKLang_Expert
   //===================================================================================================================

  constructor TDKLang_Expert.Create;
  var mi: TMenuItem;
  begin
    inherited Create;
     // Obtain needed IDE interfaces
    if not Supports(BorlandIDEServices, INTAServices,       FNTAServices) then DKLangError(SDKLExptErr_CannotObtainNTAIntf);
    if not Supports(BorlandIDEServices, IOTAServices,       FOTAServices) then DKLangError(SDKLExptErr_CannotObtainOTAIntf);
    if not Supports(BorlandIDEServices, IOTAModuleServices, FModServices) then DKLangError(SDKLExptErr_CannotObtainModSvcIntf);
     // Register OTA services notifier
    FOTANotifierIndex := FOTAServices.AddNotifier(TDKLang_OTAIDENotifier.Create(Self));
     // Find 'Project' menu
    mi := FNTAServices.MainMenu.Items.Find('Project');
    if mi=nil then DKLangError(SDKLExptErr_CannotFindProjectMenu);
     // Create a dummy menu item owner component
    FMenuOwner := TComponent.Create(nil);
     // Insert a separator
    NewMenuItem('-', mi, nil);
     // Create menu items
    FItem_EditConstants    := NewMenuItem(SDKLExptMenuItem_EditConstants,    mi, ItemClick_EditConstants);
    FItem_UpdateLangSource := NewMenuItem(SDKLExptMenuItem_UpdateLangSource, mi, ItemClick_UpdateLangSource);
     // Set the designtime flag
    IsDesignTime := True;
  end;

  destructor TDKLang_Expert.Destroy;
  begin
     // Clear the designtime flag
    IsDesignTime := False;
     // Remove menu items
    FMenuOwner.Free;
     // Release the OTA notifier
    if FOTAServices<>nil then FOTAServices.RemoveNotifier(FOTANotifierIndex);
    inherited Destroy;
  end;

  function TDKLang_Expert.EditConstantsResource: Boolean;
  var
    ProjResource: IOTAProjectResource;
    ConstResource: IOTAResourceEntry;
    Consts: TDKLang_Constants;
    sBuf: String;
    bErase: Boolean;

     // Returns project resource interface or nil if none available
    function GetProjectResource: IOTAProjectResource;
    var
      Proj: IOTAProject;
      i: Integer;
    begin
       // Iterate through project files to find the resource editor
      Proj := GetActualProject;
      for i := 0 to Proj.ModuleFileCount-1 do
        if Supports(Proj.ModuleFileEditors[i], IOTAProjectResource, Result) then Exit;
      Result := nil;
    end;

  begin
     // Get the project resource interface
    ProjResource := GetProjectResource;
    if ProjResource=nil then DKLangError(SDKLExptErr_CannotObtainResources);
     // Create constant list object
    Consts := TDKLang_Constants.Create;
    try
       // Try to find the constant resource
      ConstResource := ProjResource.FindEntry(RT_RCDATA, SDKLang_ConstResourceName);
       // If constant resource exists, load the constant list from it
      if ConstResource<>nil then begin
        SetString(sBuf, PChar(ConstResource.GetData), ConstResource.DataSize);
        Consts.AsString := sBuf;
      end;
      bErase := ConstResource<>nil;
      Result := EditConstants(Consts, bErase);
       // If changes made
      if Result then
        if ConstResource<>nil then begin
          ProjResource.DeleteEntry(ConstResource.GetEntryHandle);
          ConstResource := nil;
        end;
         // If user didn't click 'Erase', save the constants back to the resources
        if not bErase then begin
          ConstResource := ProjResource.CreateEntry(RT_RCDATA, SDKLang_ConstResourceName, 0, 0, 0, 0, 0);
          sBuf := Consts.AsString;
          ConstResource.DataSize := Length(sBuf);
          Move(sBuf[1], ConstResource.GetData^, Length(sBuf));
           // Update the project language source file if needed
          if Consts.AutoSaveLangSource and not UpdateProjectLangSource(Consts) then DKLangError(SDKLExptErr_CannotSaveLangSource);
        end;
    finally
      Consts.Free;
    end;
  end;

  procedure TDKLang_Expert.Execute;
  begin
    { stub }
  end;

  function TDKLang_Expert.GetIDString: string;
  begin
    Result := 'DKSoftware.DKLang_IDE_Expert';
  end;

  function TDKLang_Expert.GetName: string;
  begin
    Result := 'DKLang IDE Expert';
  end;

  function TDKLang_Expert.GetState: TWizardState;
  begin
    Result := [wsEnabled];
  end;

  procedure TDKLang_Expert.ItemClick_EditConstants(Sender: TObject);
  begin
    EditConstantsResource;
  end;

  procedure TDKLang_Expert.ItemClick_UpdateLangSource(Sender: TObject);
  var
    Proj: IOTAProject;
    i, iMod, iLCUpdated: Integer;
    ModuleInfo: IOTAModuleInfo;
    Module: IOTAModule;
    NTAFormEditor: INTAFormEditor;
  begin
    iLCUpdated := 0;
     // Iterate through project modules to discover form editors
    Proj := GetActualProject;
    for iMod := 0 to Proj.GetModuleCount-1 do begin
      ModuleInfo := Proj.GetModule(iMod);
      if (ModuleInfo.ModuleType=omtForm) and (ModuleInfo.FormName<>'') then begin
        Module := ModuleInfo.OpenModule;
        if Module<>nil then
          for i := 0 to Module.ModuleFileCount-1 do
            if Supports(Module.ModuleFileEditors[i], INTAFormEditor, NTAFormEditor) then begin
              if LC_UpdateProjectLangSource(NTAFormEditor.FormDesigner.Root) then Inc(iLCUpdated);
              Break;
            end;
      end;
    end;
     // Show info
    ShowMessage(Format(SDKLExptMsg_LCsUpdated, [iLCUpdated]));
  end;

  function TDKLang_Expert.NewMenuItem(const sCaption: String; Menu: TMenuItem; AOnClick: TNotifyEvent): TMenuItem;
  begin
    Result := TMenuItem.Create(FMenuOwner);
    with Result do begin
      Caption      := sCaption;
      OnClick      := AOnClick;
    end;
    Menu.Add(Result);
  end;

   //===================================================================================================================
   // TDKLangControllerEditor
   //===================================================================================================================

  procedure TDKLangControllerEditor.ExecuteVerb(Index: Integer);
  var LC: TDKLanguageController;
  begin
    LC := Component as TDKLanguageController;
    case Index of
       // Save the controller's data into project language source file
      0: if not UpdateProjectLangSource(LC) then DKLangError(SDKLExptErr_CannotSaveLangSource);
       // Save the controller's data into selected language source file
      1: 
        with TSaveDialog.Create(nil) do
          try
            DefaultExt := SDKLang_LangSourceExtension;
            Filter     := 'Language source files (*.'+SDKLang_LangSourceExtension+')|*.'+SDKLang_LangSourceExtension+'|All files (*.*)|*.*';
            Options    := [ofHideReadOnly, ofEnableSizing, ofOverwritePrompt, ofPathMustExist];
            Title      := 'Select a language source file';
            if Execute then UpdateLangSourceFile(FileName, LC, []);
          finally
            Free;
          end;
    end;
  end;

  function TDKLangControllerEditor.GetVerb(Index: Integer): string;
  begin
    case Index of
      0:   Result := 'Save data to pro&ject language source';
      1:   Result := 'Save data as lan&guage source...';
      else Result := '';
    end;
  end;

  function TDKLangControllerEditor.GetVerbCount: Integer;
  begin
    Result := 2;
  end;

   //===================================================================================================================

  function DKLang_CreateExpert: IOTAWizard;
  begin
    Result := TDKLang_Expert.Create;
  end;

end.
