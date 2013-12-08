rem cleanup
rem assumes we are starting in the "resources" folder

cd .\..
del /s /q *.identcache *.local *.mes *.map *.stat *.tvsconfig *.~* 1>nul 2>nul

for /d %%D in ("Examples\*")do (
  rmdir /s /q %%D\__history
  rmdir /s /q %%D\Android
  rmdir /s /q %%D\iOSDevice
  rmdir /s /q %%D\iOSSimulator
  rmdir /s /q %%D\OSX32
  rmdir /s /q %%D\Win32
  rmdir /s /q %%D\Win64
)

for /d %%D in ("Packages\*")do (
  rmdir /s /q %%D
)

for /d %%D in ("Resources\LanguageCodes\*")do (
  rmdir /s /q %%D\__history
  rmdir /s /q %%D\Android
  rmdir /s /q %%D\iOSDevice
  rmdir /s /q %%D\iOSSimulator
  rmdir /s /q %%D\OSX32
  rmdir /s /q %%D\Win32
  rmdir /s /q %%D\Win64
)
pause

