$Id: readme.txt,v 1.1 2005-06-19 19:25:29 dale Exp $
------------------------------------------------------------------------------------------------------------------------
This is an example on using DKLang Package with language files built in
application's resources.

The supplied LangFiles.rc file is a source resource script. Being compiled
with Borland Resource Compiler, brcc32.exe (found in Delphi's Bin
directory), it produces a corresponding resource binary, LangFiles.res.

The latter is linked into the application using the $R directive located
at Main.pas.

Note that you can also keep using the conventional method of scanning for
.lng files in conjunction with having some language files residing in the
executable's resources.
