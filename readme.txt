$Id: readme.txt,v 1.3 2004-09-26 15:46:04 dale Exp $
------------------------------------------------------------------------------------------------------------------------


LEGAL INFO
------------------------------------------------------------------------------------------------------------------------

The contents of this package are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this package except in compliance
with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
specific language governing rights and limitations under the License.

The initial developer of the original code is Dmitry Kann, http://www.dk-soft.org/


GENERAL DESCRIPTION
------------------------------------------------------------------------------------------------------------------------

DKLang Localization Package is a set of classes intended to simplify the localization
of applications written in Delphi.

The package introduces a non-visual VCL component called TDKLanguageController, which
is to be placed on each form you wish to localize. Language controller automatically
maintains an internal list of all components and their properties of type String (also
known as AnsiString or long string), ShortString and WideString (although Unicode
support is not implemented). There's a little chance you will ever require another type
of data to be changed in synch with language change.

So, the language controller holds a list of component properties, each having assigned
a form-wide unique integer ID (starting with 1). This is done transparently by the
controller so you don't need to bother when you add or remove components to/from the
form, or change their property values.

Additionally, if a controller's options include dklcoAutoSaveLangSource (this is the
default), the controller saves its data in a plain text file into the so-called project
language source, each time you save modifications to the form the controller is on.
The project language source is a file named the same as the project (.dpr) file, but
having .dklang extension. Each controller replaces the corresponding section in that
file when it saves its data. If autosave is off you are still able to save the
controller data by right-clicking the component on the form and selecting the 'Save
data to project language source' item. You may also select the 'Project | Update
project language source' main menu item, this will force all the contollers available
for the project to update their language source in project's .dklang file.

The package also introduces the TDKLanguageManager class the instance of which is
accessible via global function LangManager. The manager is instantiated first time
the function is called. This will happen once a form having a controller will be
instantiated, or when you invoke the LangManager eg to scan for language files (see
the provided demo). Language manager performs all tasks of maintaining the list of
available languages or switching between them.

There's also a possibility of having a number of string constants for the project.
The constants and their values are stored within the project resources; you edit them
using the 'Project | Edit project constants...' main menu item.
To obtain a constant value for the current language use the syntax:
LangManager.ConstantValue['MyConstant'].

Afterwards you may use the supplied DKLang Translation Editor application to open
the language source files (.dklang), and to create new translations based on them.

NB: DO NOT edit .dklang files directly since the contents of these files is
    controlled automatically by language controllers and constant editor. Any
    changes to property mappings or constant values will be lost once the file is
    updated!
    Nevertheless, you can add your custom comments (each line starting with a
    semicolon) at the top of the file. The package leaves such comments intact.

ISSUES/DRAWBACKS
------------------------------------------------------------------------------------------------------------------------

- The package is not proven to be stable yet (although no problems were found for the
  moment).
- The implemented localization mechanism doesn't support VFI (visual form inheritance).
  It is recommended to put language controller onto a final, derived form, and not
  onto the common ancestor form, since there's no means to track the origin of a
  property value.
- No support for custom-defined properties implemented (ie. ones defined with
  DefineProperties() method). Implementing such a feature would require knowing and
  analyzing all the form (visual) ancestors, which is a somewhat hard task.
- You cannot properly handle the forms open in the IDE as standalone files. DKLang
  package requires that you have an active project open.
- I'm using Delphi 7 for all my projects so the package was designed for Delphi 7. But
  I believe it will work under Delphi 6, and very likely under Delphi 5. You may use
  the supplied package files, or derive the corresponding package files from them.


INSTALLATION
------------------------------------------------------------------------------------------------------------------------

1. Unpack the package files into a directory.
2. Start Delphi IDE.
3. Open Packages\dklang7.dpk and click Compile.
4. Open Packages\dcldklang7.dpk, click Compile, then click Install.
5. Close the files (don't save the changes if any).
6. Add the path to DKLang.pas to IDE library path.

Notice that both compiled packages (dklang7.bpl and dcldklang7.bpl) must reside in a
directory listed in system PATH (usually packages are compiled to ...\Delphi7\Projects\Bpl).


PACKAGE CONTENTS
------------------------------------------------------------------------------------------------------------------------

DKLang.pas                      A package source file
DKLangReg.dcr                   A package source file
DKLangReg.pas                   A package source file
DKL_ConstEditor.dfm             A package source file
DKL_ConstEditor.pas             A package source file
DKL_Expt.pas                    A package source file
MPL-1.1.txt                     Mozilla Public License, Version 1.1
readme.txt                      This file
+ TranEditor
  DKTranEd.exe                  DKLang Translation Editor application
  + Language
    Russian.lng                 DKLang Translation Editor Russian interface localization 
+ Examples
  + Simple                      A simple package usage example
  + Constants                   A demo of localizable constants usage
+ Packages                      Package files
  dcldklang7.cfg
  dcldklang7.dof
  dcldklang7.dpk
  dcldklang7.res
  dklang7.cfg
  dklang7.dof
  dklang7.dpk
  dklang7.res
