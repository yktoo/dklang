@echo off
rem ********************************************************************************************************************
rem $Id: make_distrib.bat,v 1.2 2004-09-25 19:01:50 dale Exp $
rem --------------------------------------------------------------------------------------------------------------------
rem DKLang Localization Package
rem Copyright 2002-2004 DK Software, http://www.dk-soft.org/
rem ********************************************************************************************************************
rem ** Making bundle of the package files and the Translation Editor application

if exist dklang-package.zip del dklang-package.zip

rem Gererate chm docs
start /w ChmDoc.pl
copy c:\Tmp\dklang-docs\dklang-api.chm ..
rmdir /s /q c:\Tmp\dklang-docs

rem -m3    = compression normal
rem -afzip = create zip archive
start /w C:\Progra~1\WinRAR\WinRAR.exe a -m3 -afzip dklang-package.zip @include_list.txt -x@exclude_list.txt