rem change parameter to reflect the version of Delphi you are installing to
rem XE5 = 12.0

set BDSVersion=12.0

rem prepares for msbuild
call rsvars.bat

rem build runtime for each platform
msbuild dklang.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild dklang.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild dklang.dproj /t:Rebuild /p:Config=Debug;Platform=OSX32
msbuild dklang.dproj /t:Rebuild /p:Config=Debug;Platform=iOSSimulator
msbuild dklang.dproj /t:Rebuild /p:Config=Debug;Platform=iOSDevice
msbuild dklang.dproj /t:Rebuild /p:Config=Debug;Platform=Android

rem build design time package for only win32
msbuild dcldklang.dproj /t:Rebuild /p:Config=Debug;Platform=Win32

rem install design time package
reg add "HKEY_CURRENT_USER\Software\Embarcadero\BDS\%BDSVersion%\Known Packages" /v "C:\Users\Public\Documents\RAD Studio\%BDSVersion%\Bpl\dcldklang.bpl" /d "DKLang Localization Package - IDE Tools" /f

rem cleanup
del *.local
del *.identcache
del *.mes
del *.res
del *.stat
del *.dklang

rem keep window open
pause
