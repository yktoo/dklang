@echo off
rem ********************************************************************************************************************
rem $Id: make_distrib.bat,v 1.11 2006-08-05 21:42:34 dale Exp $
rem --------------------------------------------------------------------------------------------------------------------
rem DKLang Localization Package
rem Copyright 2002-2006 DK Software, http://www.dk-soft.org/
rem ********************************************************************************************************************
rem ** Making bundle of the package files 

rem --------------------------------------------------------------------------------------------------------------------
rem  Variable declaration
rem --------------------------------------------------------------------------------------------------------------------

set VERSION=3.0

set BASE_DIR=C:\Delphi\CVS projects\dale\DKLang
set INSTALL_DIR=%BASE_DIR%\Install
set HELP_DIR=%BASE_DIR%\Help

set ARCHIVE_FILE=%INSTALL_DIR%\dklang-package-%VERSION%.zip
set CHM_FILE=dklang.chm

set HELP_COMPILER=C:\Program Files\HTML Help Workshop\hhc.exe
set CHM_API_MAKER=%HELP_DIR%\ChmDoc.pl
set CHM_API_FILE_PREFIX=__chmdoc__
set ARCHIVER=C:\Program Files\WinRAR\rar.exe

rem --------------------------------------------------------------------------------------------------------------------
rem  Let's start here
rem --------------------------------------------------------------------------------------------------------------------

echo [1] Cleaning up...
if exist "%ARCHIVE_FILE%" del "%ARCHIVE_FILE%"
if exist "%BASE_DIR%\%CHM_FILE%" del "%BASE_DIR%\%CHM_FILE%"

echo [2] Generating and compiling CHM docs...
cd "%HELP_DIR%"
"%CHM_API_MAKER%"
if errorlevel 1 goto err
move "%HELP_DIR%\%CHM_FILE%" "%BASE_DIR%\"
if errorlevel 1 goto err

echo [3] Archiving the files...
cd "%INSTALL_DIR%"
rem -m3    = compression normal
rem -afzip = create zip archive
"%ARCHIVER%" a -m3 -afzip "%ARCHIVE_FILE%" @include_list.txt -x@exclude_list.txt >nul
if errorlevel 1 goto err

goto ok

:err
pause
:ok