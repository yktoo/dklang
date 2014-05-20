// Library suffix defines to simplify upgrading to new versions of Delphi
//   (at least until EMB gives us "{$LIBSUFFIX AUTO}"!)

// XE5
{$IFDEF VER260}
{$LIBSUFFIX '190'}
{$ENDIF}

// XE6
{$IFDEF VER270}
{$LIBSUFFIX '200'}
{$ENDIF}

// these are purely speculative!!!!!
{$IFDEF VER280}
{$LIBSUFFIX '210'}
{$ENDIF}

{$IFDEF VER290}
{$LIBSUFFIX '220'}
{$ENDIF}
