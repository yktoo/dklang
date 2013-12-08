// Library suffix defines to simplify upgrading to new versions of Delphi
//   (at least until EMB gives us "{$LIBSUFFIX AUTO}"!)

// XE5
{$IFDEF VER260}
{$LIBSUFFIX '190'}
{$ENDIF}

// these are purely speculative!!!!!
{$IFDEF VER270}
{$LIBSUFFIX '200'}
{$ENDIF}

{$IFDEF VER280}
{$LIBSUFFIX '210'}
{$ENDIF}
