$Id: readme.txt,v 1.14 2006-06-17 05:50:46 dale Exp $
--------------------------------------------------------------------------------

DKLang Localization Package
Version 3.0 beta

LEGAL INFO
--------------------------------------------------------------------------------

The contents of this package are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this package except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Alternatively, you may redistribute this library, use and/or modify it under the
terms of the GNU Lesser General Public License as published by the Free Software
Foundation; either version 2.1 of the License, or (at your option) any later
version. You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
specific language governing rights and limitations under the License.

The initial developer of the original code is Dmitry Kann,
http://www.dk-soft.org/


GENERAL DESCRIPTION
--------------------------------------------------------------------------------

DKLang Localization Package is a set of classes intended to simplify the
localization of applications written in Delphi.

What are the benefits of DKLang compared to Borland's ITE (Integrated
Translation Environment)?

* First, DKLang is completely free while ITE is only supplied with Delphi
  Enterprise Edition. Moreover, DKLang is open-source so you always can see 'how
  the wind blows'.
* Second, DKLang is very lightweight and runtime-optimized. You always get
  predictable results as the implemented technology is obvious and transparent.
* Third, DKLang allows language switching at any time while ITE relies on a
  resource DLL with predefined extension when loading the program and you cannot
  change the language further.
* Fourth, Application using DKLang can consist of the only executable which
  includes any number of languages in its resource; it allows you to decide
  yourself which language should be included 'statically' and which ones are
  linked when program runs. In contrast, ITE always requires that a DLL with
  predefined extension for each language resides in the program directory: this
  means you should redistribute all the language DLLs with each copy of the
  program.
* And finally, language files are plain-text files so one can edit them with any
  text editor supporting Unicode. ITE uses only compiled resource DLLs prepared
  with using special Translation Manager.


PACKAGE FEATURES
--------------------------------------------------------------------------------

* Ease of use. Put a TDKLanguageController on the form, save the project (this
  will automatically create a language source file) and add a couple of lines to
  program code: you get a functional multilanguage application! See the provided
  demos to learn the details.
* Full integration with Delphi VCL component library. A possibility of automated
  change tracking in structure or properties of forms, frames, data modules
  etc., and owned components. 
* Storing property values for String (AnsiString), ShortString and WideString
  properties (complete Unicode support is implemented). Storing property values
  of class TStrings, TWideStrings, TCollection item properties and property
  values of TPersistent descendants. Only the properties recognized by Delphi
  streaming mechanism as stored are processed. For the time being no support
  implemented for VFI (visual form inheritance) and custom-defined properties
  (ones specified with DefineProperties() call). 
* A possibility for defining a set of string constants for a project. A constant
  is referred to by its name (binary name search is implemented). 
* Storing translations in plain-text files, which can be edited with any text
  editor. However, there's a much more convenient tool available for creating
  the translations: the DKLang Translation Editor. 
* Synchronous language switching in all displayed forms by changing the current
  language of global TDKLanguageManager instance. 
* Events fired in a non-visual component just before and after the language
  change. 
* A possibility for ignoring any properties, as well as a list of forcibly
  stored properties recognized as not stored. Both lists are formed using name
  masks (eg, *.Font.Name). 
* Automated saving the localization data for the whole project into a so-called
  language source file (a file having .dklang extension). 
* A possibility of using the localization mechanism when no visual forms
  instantiated (for localizing constants only). A possibility of building the
  project with DKLang runtime package. 
* A thread-safe design allowing for proper functioning in multithreaded
  environment. This allows non-blocking data read access with a number of
  threads at once. 


TECHNOLOGY AND BACKGROUND
--------------------------------------------------------------------------------

The package introduces a non-visual VCL component called TDKLanguageController,
which is to be placed on each form you wish to localize. Language controller
automatically maintains an internal list of all components and their properties
of type String (also known as AnsiString or long string), ShortString and
WideString (complete Unicode support is implemented). There's a little chance
you will ever need another type of data to be changed in synch with language
change.

So, the language controller holds a list of component properties, each having
assigned a form-wide unique integer ID (starting with 1). This is done
transparently by the controller so you don't need to bother when you add or
remove components to/from the form, or change their property values.

Additionally, if a controller's options include dklcoAutoSaveLangSource (this is
the default), the controller saves its data in a plain text file into the
so-called project language source, each time you save modifications to the form
the controller is on. The project language source is a file named the same as
the project (.dpr) file, but having .dklang extension. Each controller replaces
the corresponding section in that file when it saves its data. If autosave is
off you are still able to save the controller data by right-clicking the
component on the form and selecting the 'Save data to project language source'
item. You may also select the 'Project | Update project language source' main
menu item, this will force all the contollers available for the project to
update their language source in project's .dklang file.

The package also introduces the TDKLanguageManager class the instance of which
is accessible via global function LangManager. The manager is instantiated first
time the function is called. This will happen once a form having a controller
will be instantiated, or when you invoke the LangManager eg to scan for language
files (see the provided examples). Language manager performs all tasks of
maintaining the list of available languages or switching between them.

There's also a possibility of having a number of string constants for the
project. The constants and their values are stored within the project resources;
you edit them using the 'Project | Edit project constants...' main menu item.
To obtain a constant value for the current language use the syntax:
LangManager.ConstantValue['MyConstant'].

Afterwards you may use the supplied DKLang Translation Editor application to
open the language source files (.dklang), and to create new translations based
on them.

NB: DO NOT edit .dklang files directly since the contents of these files is
    controlled automatically by language controllers and constant editor. Any
    changes to property mappings or constant values will be lost once the file
    is updated!
    Nevertheless, you can add your custom comments (each line starting with a
    semicolon) at the top of the file. The package leaves such comments intact.


ISSUES/DRAWBACKS
--------------------------------------------------------------------------------

- The implemented localization mechanism doesn't support VFI (visual form
  inheritance). It is recommended to put language controller onto a final,
  derived form, and not onto the common ancestor form, since there's no means to
  track the origin of a property value.
- No support for custom-defined properties implemented (ie. ones defined with
  DefineProperties() method). Implementing such a feature would require knowing
  and analyzing all the form (visual) ancestors, which is a somewhat hard task.
- You cannot properly handle the forms open in the IDE as standalone files.
  DKLang package requires that you have an active project open.
- The packages were designed for Delphi 6, 7 and 2005 (with latest updates
  applied). But it's very likely it will run on Delphi 5. You may use the
  supplied package files, or derive the corresponding package files from them.


INSTALLATION
--------------------------------------------------------------------------------

1. Unpack the package files into a directory.
2. Start Delphi IDE.
3. Open Packages\dklangN.dpk (where N is your Delphi version: 6 for Delphi 6, 7
   for Delphi 7, 9 for Delphi 2005) and click Compile.
4. Open Packages\dcldklangN.dpk (where N is again your Delphi version), click
   Compile, then click Install.
5. Close the files (don't save the changes if any).
6. Add the path to DKLang.pas to IDE library path.

Notice that both compiled packages (dklangN.bpl and dcldklangN.bpl) must reside
in a directory listed in system PATH (usually packages are compiled to
...\Borland\DelphiN\Projects\Bpl (Delphi 6 and 7) or 
<personal folder>\Borland Studio Projects\Bpl (Delphi 8+)).


PACKAGE CONTENT
--------------------------------------------------------------------------------

DKLang.pas                      A package source file
DKLangReg.dcr                   A package source file
DKLangReg.pas                   A package source file
DKL_ConstEditor.dfm             A package source file
DKL_ConstEditor.pas             A package source file
DKL_Expt.pas                    A package source file
readme.txt                      This file
+ Examples                      Demo projects
+ Packages\*.*                  Package files

REVISION HISTORY
--------------------------------------------------------------------------------

DKLang 3.0 beta [xxx xx, xxxx]
  [+] Unicode support, initially developed by Bruce J. Miller
      <bjmiller-at-gmail.com>

DKLang 2.4 [Jun 23, 2005]
  [+] Added property TDKLanguageController.SectionName which allows customizing
      section which stores language data 
  [+] Added properties TDKLanguageManager.LanguageIndex,
      TDKLanguageManager.LanguageResources[]
  [-] Bugfix: TDKLanguageManager.IndexOfLanguageID() returned value less by 1 
      than correct value for non-default languages
  [+] New demos: Frames, MDI, Resource

DKLang 2.3 [Dec 21, 2004]
  [+] DKLang now uses a double licensing system. You may use, modify or
      redistribute it either under Mozilla Public License 1.1, or under GNU
      Lesser General Public License 2.1 terms. In particular, this means the
      library can be used in any GPL-licensed application or library.
  [+] Fixed dcldklang* installation problem under non-English versions of
      Delphi.

DKLang 2.2 [Nov 27, 2004]
  [+] Added support for Delphi 2005.
  [+] Changed the order of applying a language: first constants are updated,
      then controllers. This allows to read correct constants' values in
      controllers' OnLanguageChanged event handlers.

DKLang 2.1 [Sep 26, 2004]
  The first public release (all prior versions were only for individual use).
