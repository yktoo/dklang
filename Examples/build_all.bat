echo off

rem prepares for msbuild
call rsvars.bat

rem VCL
msbuild Constants_VCL\DKLang_Constants_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild Embedded_VCL\DKLang_Embedded_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild Frames_VCL\DKLang_Frames_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild MDI_VCL\DKLang_MDI_VCL_Demo\.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild Notepad_VCL\DKLang_Notepad_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild Resource_VCL\DKLang_Resource_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild Simple_VCL\DKLang_Simple_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32

msbuild Constants_VCL\DKLang_Constants_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild Embedded_VCL\DKLang_Embedded_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild Frames_VCL\DKLang_Frames_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild MDI_VCL\DKLang_MDI_VCL_Demo\.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild Notepad_VCL\DKLang_Notepad_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild Resource_VCL\DKLang_Resource_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild Simple_VCL\DKLang_Simple_VCL_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64

rem FMX Desktop
msbuild Constants_FireMonkey_Desktop\DKLang_Constants_FMX_Desktop_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win32
msbuild Constants_FireMonkey_Desktop\DKLang_Constants_FMX_Desktop_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Win64
msbuild Constants_FireMonkey_Desktop\DKLang_Constants_FMX_Desktop_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=OSX32

rem FMX Mobile
msbuild Constants_FireMonkey_Mobile\DKLang_Constants_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Android
msbuild Embedded_FireMonkey_Mobile\DKLang_Embedded_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Android
msbuild LocalFileStorage_FireMonkey_Mobile\DKLang_LocalFileStorage_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Android
msbuild Resource_FireMonkey_Mobile\DKLang_Resource_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=Android

msbuild Constants_FireMonkey_Mobile\DKLang_Constants_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSSimulator
msbuild Embedded_FireMonkey_Mobile\DKLang_Embedded_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSSimulator
msbuild LocalFileStorage_FireMonkey_Mobile\DKLang_LocalFileStorage_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSSimulator
msbuild Resource_FireMonkey_Mobile\DKLang_Resource_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSSimulator

msbuild Constants_FireMonkey_Mobile\DKLang_Constants_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSDevice
msbuild Embedded_FireMonkey_Mobile\DKLang_Embedded_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSDevice
msbuild LocalFileStorage_FireMonkey_Mobile\DKLang_LocalFileStorage_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSDevice
msbuild Resource_FireMonkey_Mobile\DKLang_Resource_FMX_Mobile_Demo.dproj /t:Rebuild /p:Config=Debug;Platform=iOSDevice

rem keep window open
pause
