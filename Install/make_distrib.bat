@echo off
rem ********************************************************************************************************************
rem $Id: make_distrib.bat,v 1.6 2004-12-02 11:28:46 dale Exp $
rem --------------------------------------------------------------------------------------------------------------------
rem DKLang Localization Package
rem Copyright 2002-2004 DK Software, http://www.dk-soft.org/
rem ********************************************************************************************************************
rem ** Making bundle of the package files 

set VERSION=2.3
set OUT_FILE_NAME=dklang-package-%VERSION%.zip

if exist %OUT_FILE_NAME% del %OUT_FILE_NAME%

rem Gererate chm docs
start /w ChmDoc.pl
copy c:\Tmp\dklang-docs\dklang-api.chm ..
rmdir /s /q c:\Tmp\dklang-docs

rem -m3    = compression normal
rem -afzip = create zip archive
start /w C:\Progra~1\WinRAR\WinRAR.exe a -m3 -afzip %OUT_FILE_NAME% @include_list.txt -x@exclude_list.txt