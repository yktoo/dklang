#!/usr/bin/perl
#****************************************************************
#  $Id: ChmDoc.pl,v 1.1 2004-09-25 19:01:19 dale Exp $
#****************************************************************

use strict;
use locale;
#use File::Find;

 # Declare constants
my $usr_short_name = 'DKLang API';
my $usr_long_name  = 'DKLang Localization Package. API Description';
my $usr_copyright  = 'Copyright &copy;2004 DK Software, <a href="http://www.dk-soft.org/" target=_blank>www.dk-soft.org</a>';
 
my $src_path     = 'C:/Delphi/CVSpro~1/dale/DKLang';
my $out_path     = 'C:/Tmp/dklang-docs';
my $css_file     = 'main.css';
my $toc_file     = 'index.html';
my $typeidx_file = 'types.html';
my $hhp_file     = 'dklang-api.hhp';
my $hhc_file     = 'dklang-api.hhc';
my $hhk_file     = 'dklang-api.hhk';
my $chm_file     = 'dklang-api.chm';
my $hh_compiler  = '"C:\Program Files\HTML Help Workshop\hhc.exe"';
my %units;     # Модули -> Объекты -> Атрибуты объектов
my %allobjs;   # Список ссылок на все объекты
my @htmlfiles; # Полный список HTML-файлов
 # Типы
my @types = (
    { CHAR    => 'I',
      NAME    => 'Interfaces',
      TITLE   => 'interface',
      PRINTER => sub { qq|$_[0]->{NAME} = interface(<span class=declaration>$_[0]->{DECL}</span>)|; }
    },
    { CHAR    => 'C', 
      NAME    => 'Classes',
      TITLE   => 'class',
      PRINTER => sub { qq|$_[0]->{NAME} = class(<span class=declaration>$_[0]->{DECL}</span>)|; }
    },
    { CHAR    => 'R',
      NAME    => 'Records',
      TITLE   => 'record',
      PRINTER => sub { qq|$_[0]->{NAME} = $_[0]->{DECL}|; }
    },
    { CHAR    => 'P',
      NAME    => 'Pointers',
      TITLE   => 'pointer',
      PRINTER => sub { qq|$_[0]->{NAME} = ^<span class=declaration>$_[0]->{DECL}</span>|; }
    },
    { CHAR    => 'E',
      NAME    => 'Enumerations',
      TITLE   => 'enumeration',
      PRINTER => sub { qq|$_[0]->{NAME} = <span class=declaration>$_[0]->{DECL}</span>|; }
    }
  );
 # Генерируем хэш ссылок на типы по typechar
my %typebychar;
foreach(@types) { $typebychar{$_->{CHAR}} = $_; }

 # Генерируем список ключевых слов Delphi
my %keywords;
foreach(
  split ' ',
    'and array as asm at automated begin case class const constructor destructor dispinterface div '.
    'do downto else end except exports file finalization finally for function goto if implementation '.
    'in inherited initialization inline interface is label library mod nil not object of on or out '.
    'packed private procedure program property protected public published raise read record repeat '.
    'resourcestring set shl shr string then threadvar to try type unit until uses var while with write xor'    
  ) { $keywords{$_} = 1; }

 # Обрабатываем файлы
#find(\&processFileCallback, $src_path);
foreach(glob "$src_path/*.pas") { processFileCallback($_); }
if (%units){
   # Создаём выходной каталог
  mkdir $out_path, 0777;  
   # Выводим таблицу стилей
  print "Writing CSS...\n";
  writeCSSFile();  
   # Генерируем файлы
  print "Writing HTML files...\n";
  writeHTML();
   # Выводим индекс типов
  print "Writing type index...\n";
  writeTypeIndex();
   # Создаём проект HTML Help
  print "Writing HTML Help Project...\n";
  writeHHP();
  print "Writing HTML Help Project Contents...\n";
  writeHHC();
  print "Writing HTML Help Project Keywords...\n";
  writeHHK();
  print "Generating HTML Help...\n";
  my $dos_hhp = "$out_path/$hhp_file";
  $dos_hhp =~ s|/|\\|;
  print join "\n", `$hh_compiler $dos_hhp`;
  print "Done\n";
  exit 0;
} else {
  print "No files found\n";
  exit 1;
}

######################################################################################################################

sub hiliteKeyword {
  my ($word, $pre) = @_;
  if ($pre !~ /.*<[^>]*$/) {
    if ($keywords{lc($word)}) {
      $word = "<span class=keywd>$word</span>";
    } elsif (my $refobj = $allobjs{$word}) {
      $word = qq|<a href="$refobj->{HTMLFILE}" title="$typebychar{$refobj->{TYPE}}->{TITLE} $refobj->{REFUNIT}->{NAME}.$word">$word</a>|;
    }
  }
  return $word;
}
sub hiliteSymbol {
  my ($sym, $pre) = @_;
  return ($pre !~ /.*<[^>]*$/)?"<span class=symbol>$sym</span>":$sym;
}

 # Расцвечивает синтаксис: (String): String
sub highlight($) {
  my $str = shift;
  $str =~ s|(\w+)|hiliteKeyword($1, $`)|ge;      # ключевые слова
  $str =~ s|([^\w<> ]+)|hiliteSymbol($1, $`)|ge; # символы
  return $str;
}

 # Регистрирует объект: (RefUnit, ObjName, ObjTypeChar, ObjDecl, ObjComment)
sub regObj {
  my $refobj = {
    REFUNIT  => $_[0],
    NAME     => $_[1],
    HTMLFILE => "$_[0]->{NAME}-$_[1].html",
    TYPE     => $_[2],
    DECL     => $_[3],
    COMMENT  => $_[4],
    ATTRS    => {}
  };
  $_[0]->{OBJECTS}->{$_[1]} = $refobj;
  $allobjs{$_[1]} = $refobj;
  return $refobj;
}

 # Callback-процедура, получающая имя файла. Обрабатывает исходный файл, разбирая код. Данные заносит в %units
sub processFileCallback {
  if (-s && /\.pas$/i) {
    my $file = shift; #$File::Find::name;
     # Parse the input file
    open(FI, $file) or die "Cannot open $file for reading: $!";
    my $intf_clause = 0;
    my $type_clause = 0;
    my $header_processed = 0;
    my $comment = '';
    my $refunit;
    my $refobject;
    while(<FI>){  
      chomp;
       # Если строка содержит только комментарий, запоминаем его
      if (m|^\s*//\s*(?:--)?\s*(.*[A-Za-zА-я].*)| && !m(\$Id:|///|Props|Prop handlers|Prop storage|Message handlers|Events)i) {
        $comment .= ($comment?' ':'').$1;
       # Заголовок модуля: unit XXXXX;
      } elsif (/^\s*unit\s+(\w+)\;/i) {
        $refunit = {
          NAME     => $1,
          HTMLFILE => "unit-$1.html",
          SIZE     => -s $file,
          COMMENT  => $comment,
          OBJECTS  => {}        
        };
        $units{$1} = $refunit;
       # 'interface' section
      } elsif ($refunit && /^\s*interface\s*$/i) {
        $intf_clause = 1;
       # 'type' section
      } elsif ($intf_clause && /^\s*type\s*$/i) {
        $type_clause = 1;
       # end of 'type' section
      } elsif ($type_clause && /^\s*(?:const|var|resourcestring|threadvar)\s*$/i) {
        $type_clause = 0;
       # 'implementation' section
      } elsif (/^\s*implementation\s*$/i) {
        last;
       # Декларация объекта
      } elsif ($type_clause && /\b(\w+)\s*=\s*(class|interface)\(\s*([\w, ]+)\s*\)/i) {
        $refobject = regObj($refunit, $1, uc(substr($2, 0, 1)), $3, $comment);
        $comment = '';
       # Декларация записи
      } elsif ($type_clause && /\b(\w+)\s*=\s*((?:packed\s*)?record)/i) {
        $refobject = regObj($refunit, $1, 'R', $2, $comment);
        $comment = '';
       # Декларация указателя
      } elsif ($type_clause && /\b(\w+)\s*=\s*\^\s*(\w+)/) {
        $refobject = regObj($refunit, $1, 'P', $2, $comment);
        $comment = '';
       # Декларация перечисления
      } elsif ($type_clause && /\b(\w+)\s*=\s*(\([\s\w.,]+\))/) {
        $refobject = regObj($refunit, $1, 'E', $2, $comment);
        $comment = '';
       # Атрибут объекта
      } elsif ($refobject && /^\s*(property|function|procedure)\s*(\w+)\s*(.*;)/i) {
        $refobject->{ATTRS}->{$2} = {
          NAME    => $2,
          KIND    => $1,
          DECL    => $3,
          COMMENT => $comment
        };
        $comment = '';
       # Поле записи
      } elsif ($refobject && $refobject->{TYPE} eq 'R' && /^\s*(\w+)\s*:\s*(\w+)\s*;\s*(?:\/\/\s*)?(.*)/) {
        $refobject->{ATTRS}->{$1} = {
          NAME    => $1,
          KIND    => '',
          DECL    => ': '.$2,
          COMMENT => $3
        };
        $comment = '';
       # Конец описания объекта
      } elsif ($refobject && /\bend\s*;/) {
        undef $refobject;
        $comment = '';
      } elsif (/\w+/ && !/^\s*type\s*$/i) {
        $comment = '';
      }
    }
    close(FI);
  }  
}

 # Выводит таблицу стилей в файл
sub writeCSSFile {
  open(FH, ">$out_path/$css_file") or die "Cannot open $out_path/$css_file for writing: $!\n";
  print FH <<ENDCSS;
  body             { font-family: Verdana,Arial; font-size: 8pt; margin: 0; padding: 10px; }
  p                { font-family: Verdana,Arial; font-size: 8pt; margin: 3px; }
  p.copyright      { color: gray; text-align: center; }
  li               { font-family: Verdana,Arial; font-size: 8pt; text-align: justify; }
  h1               { font-family: Verdana,Arial; font-size: 10pt; font-weight: bold; text-align: center; padding: 2px; margin: 0; }
  h2               { font-family: Verdana,Arial; font-size: 9pt; font-weight: bold; text-align: center; padding: 1px; margin: 0; }
  a:link           { color: #0000c0; text-decoration: none; }
  a:visited        { color: #0000c0; text-decoration: none; }
  a:active         { color: #0000ff; text-decoration: underline; }
  a:hover          { color: #0000ff; text-decoration: underline; }
  table.decl       { background-color: silver; }
  table.pagehdr    { margin: 5px 0; }
  th               { padding: 2px 4px; font-family: Verdana,Arial; font-size: 8pt; font-weight: bold; border: 1 gray solid; background-color: #f0f0f0; }
  td               { font-family: Verdana,Arial; font-size: 8pt; padding: 2px 4px; }
  td.comment       { color: #408040; }
  td.declmain      { width: 40%; }
  td.pagehdr       { padding: 5px; text-align: center; background-color: #f0e5ff; }
  span             { font-family: Verdana,Arial; font-size: 8pt; }
  span.declaration { color: gray; }
  span.keywd       { font-weight: bold; color: black; }
  span.framed      { font-weight: bold; border: 1 black solid; padding: 0 2px; background-color: #e0e0ff; }
  span.sub         { font-weight: normal; font-size: 5pt; }
  span.symbol      { font-weight: normal; color: #905000; }
ENDCSS
  close(FH);
}

 # Пишет завершение HTML-файла (FileHandle)
sub writeFileFooter($) {
  my $fh = shift;
  print $fh <<END;
  <hr width=50%>
  <p class=copyright>$usr_copyright
</body>
</html>
END
}

 # Пишет заголовок HTML-файла (FileHandle, Title, Header, Comment)
sub writeFileHeader {
  my ($fh, $title, $header, $comment) = @_;
  print $fh <<END;
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
  <title>$title</title>
  <link rel="stylesheet" type="text/css" href="$css_file">
</head>
<body bgcolor=white>
  <table class=pagehdr border=0 cellspacing=0 width=700 align=center>
    <tr><td class=pagehdr><h2>$header</h2></td></tr>
    <tr><td class=pagehdr>$comment</td></tr>
  </table>
END
}

 # Выводит HTML Help Project Contents
sub writeHHC {
  open(FHC, ">$out_path/$hhc_file") or die "Cannot open $out_path/$hhc_file for writing: $!\n";
   # Заголовок
  print FHC <<END;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head></head>
<body>
<object type="text/site properties"><param name="Window Styles" value="0x800627"></object>
<ul>
	<li><object type="text/sitemap"><param name="Name" value="Units"><param name="Local" value="$toc_file"></object>
	<ul>
END
   # Цикл по модулям
  foreach my $unitname(sort keys %units) {
    my $refunit = $units{$unitname};
    print FHC 
      qq|<li><object type="text/sitemap"><param name="Name" value="$unitname"><param name="Local" value="$refunit->{HTMLFILE}"></object>\n|.
      qq|<ul>\n|;
     # Цикл по объектам
    foreach my $objname(sort keys %{$refunit->{OBJECTS}}) {
      print FHC qq|<li><object type="text/sitemap"><param name="Name" value="$objname"><param name="Local" value="$unitname-$objname.html"></object>\n|;
    }
    print FHC qq|</ul>\n|;
  };  
   # Завершение
  print FHC
    qq|  </ul>|.
    qq|  <li><object type="text/sitemap"><param name="Name" value="Type Index"><param name="Local" value="$typeidx_file"></object>|.
    qq|</ul>\n|.
    qq|</body></html>\n|;
  close(FHC);
}

 # Выводит HTML Help Project Keywords
sub writeHHK {
  open(FHK, ">$out_path/$hhk_file") or die "Cannot open $out_path/$hhk_file for writing: $!\n";
   # Заголовок
  print FHK <<END;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head></head>
<body>
<ul>
END
   # Цикл по объектам и модулям
  foreach my $kw(sort (keys %units, keys %allobjs)) {    
    my $refobj = $allobjs{$kw};
    my $file = $refobj ? $refobj->{HTMLFILE} : $units{$kw}->{HTMLFILE};
    print FHK qq|  <li><object type="text/sitemap"><param name="Name" value="$kw"><param name="Local" value="$file"></object>\n|;
  };  
   # Завершение
  print FHK
    qq|</ul>\n|.
    qq|</body></html>\n|;
  close(FHK);
}

 # Выводит HTML Help Project
sub writeHHP {
  open(FHH, ">$out_path/$hhp_file") or die "Cannot open $out_path/$hhp_file for writing: $!\n";
  print FHH <<END, join "\n", @htmlfiles;
[OPTIONS]
Compatibility=1.1 or later
Compiled file=$chm_file
Contents file=$hhc_file
Default topic=$toc_file
Display compile notes=No
Display compile progress=No
Full-text search=Yes
Index file=$hhk_file
Language=0x419 Русский
Title=$usr_long_name

[FILES]
END
  close(FHH);
}

 # Выводит собранные данные в виде HTML-файлов
sub writeHTML{
   # Открываем файл TOC
  push @htmlfiles, $toc_file;
  open(FHTOC, ">$out_path/$toc_file") or die "Cannot open $out_path/$toc_file for writing: $!\n";
  writeFileHeader(
    \*FHTOC, 
    'Table of Contents', 
    "$usr_short_name Table of Contents",
    qq|List of <b>$usr_short_name</b> units in alphabetical order - <a href="$typeidx_file">Type Index</a>|);
   # Выводим заголовок таблицы модулей
  print FHTOC 
    "<table border=0 cellspacing=0 width=700 align=center>\n".
    "<tr><th>Unit</th><th>Size</th><th>Description</th></tr>\n";
  my $idx_unit = 0;
  foreach my $unitname(sort keys %units) {
    my $refunit = $units{$unitname};
     # Считаем количество типов объектов / формируем строку навигации типов
    my $type_nav_html = '';
    foreach my $reftype(@types) {
      my $typechar = $reftype->{CHAR};
       # Цикл по объектам модуля
      my $objcount = 0;
      foreach my $objname(keys %{$refunit->{OBJECTS}}) { $objcount++ if $refunit->{OBJECTS}->{$objname}->{TYPE} eq $typechar; }
       # Если есть объекты текущего типа - добавляем в строку навигации
      $type_nav_html .= 
        qq| <a href="$refunit->{HTMLFILE}#$typechar" title="$reftype->{NAME}: $objcount"><span class=framed>$typechar<span class=sub>$objcount</span></span></a>|
        if $objcount;
    }
     # Формируем запись в TOC
    my $unit_color = $idx_unit%2?' bgcolor=#f0f0f0':'';
    print FHTOC
      qq|<tr$unit_color>\n|.
      qq|  <td><a href="$refunit->{HTMLFILE}">$unitname</a><br>$type_nav_html</td>\n|.
      qq|  <td class=comment align=right>$refunit->{SIZE}</td>\n|.
      qq|  <td class=comment>$refunit->{COMMENT}</td>\n|.
      qq|</tr>\n|;
     # Создаём HTML-файл модуля
    writeUnit($refunit);
     # Приращиваем индекс модуля
    $idx_unit++;
  };
   # Выводим завершение таблицы модулей
  print FHTOC "</table>\n";
   # Закрываем файл TOC
  writeFileFooter(\*FHTOC);
  close(FHTOC);
}

 # Создаёт HTML-файл объекта: (RefUnit, RefObj)
sub writeObj {
  my ($refunit, $refobj) = @_;
   # Создаём HTML-файл объекта
  push @htmlfiles, $refobj->{HTMLFILE};
  open(FHO, ">$out_path/$refobj->{HTMLFILE}") or die "Cannot open $out_path/$refobj->{HTMLFILE} for writing: $!\n";
  writeFileHeader(
    \*FHO, 
    "$refunit->{NAME} / $refobj->{NAME}", 
    qq|<a href="$toc_file">$usr_short_name</a> / <a href="$refunit->{HTMLFILE}">$refunit->{NAME}</a> / $refobj->{NAME} $typebychar{$refobj->{TYPE}}->{TITLE}|,
    $refobj->{COMMENT});
#   # Цикл по типам объектов
#  foreach my $reftype(@types) {
#    my $typechar = $reftype->{CHAR};
     # Цикл по атрибутам объекта
    my $idx_attr = 0;
    print FHO "<table border=0 cellspacing=0 width=700 align=center>\n";
#    my $obj_html = '';
    foreach my $attrname(sort keys %{$refobj->{ATTRS}}) {
      my $refattr = $refobj->{ATTRS}->{$attrname};
#       # Если объект подходящего типа
#      if ($refobj->{TYPE} eq $typechar) {
        my $attr_color = $idx_attr%2?' bgcolor=#f0f0f0':'';
        my $attr_html = highlight("$refattr->{KIND} $attrname<span class=declaration>$refattr->{DECL}</span>");
        print FHO 
          qq|<tr$attr_color>\n|.
          qq|  <td class=declmain>\n|.
          qq|    $attr_html\n|.
          qq|  </td>\n|.
          qq|  <td class=comment>$refattr->{COMMENT}</td>\n|.
          qq|</tr>\n|;
        $idx_attr++;
#      }
    }
#     # Если есть объекты текущего типа - выводим
#    if ($obj_html) {
#      print FHU 
#        qq|<table border=0 cellspacing=0 width=700 align=center>\n|.
#        qq|<tr><th colspan=2><a name=$typechar>$reftype->{NAME}</a></th></tr>\n|.
#        qq|$obj_html|.
#        qq|</table>\n|;
#    }
#  }
  print FHO "</table>\n";
  print FHO qq|<p align=center><a href="$refunit->{HTMLFILE}">$refunit->{NAME} unit</a> - <a href="$toc_file">contents</a> - <a href="$typeidx_file">type index</a>|;
   # Закрываем HTML-файл объекта
  writeFileFooter(\*FHO);
  close(FHO);
}

 # Выводит индекс типов
sub writeTypeIndex {
  push @htmlfiles, $typeidx_file;
  open(FHTI, ">$out_path/$typeidx_file") or die "Cannot open $out_path/$typeidx_file for writing: $!\n";
  writeFileHeader(\*FHTI, 'Type Index', qq|<a href="$toc_file">$usr_short_name</a> / Type Index|, "List of all $usr_short_name types in alphabetical order");
   # Выводим заголовок таблицы типов
  print FHTI
    "<table border=0 cellspacing=0 width=700 align=center>\n".
    "<tr><th>Type</th><th>Object</th><th>Unit</th><th>Comments</th></tr>\n";
  my $idx_type = 0;
  foreach my $typename(sort keys %allobjs) {
    my $type_color = $idx_type%2?' bgcolor=#f0f0f0':'';
    my $refobj = $allobjs{$typename};
    print FHTI
      qq|<tr$type_color>\n|.
      qq|  <td>$typebychar{$refobj->{TYPE}}->{TITLE}</td>\n|.
      qq|  <td><a href="$refobj->{HTMLFILE}">$refobj->{NAME}</a></td>\n|.
      qq|  <td><a href="$refobj->{REFUNIT}->{HTMLFILE}">$refobj->{REFUNIT}->{NAME}</a></td>\n|.
      qq|  <td class=comment>$refobj->{COMMENT}</td>\n|.
      qq|</tr>\n|;
    $idx_type++;
  };
   # Выводим завершение таблицы типов
  print FHTI "</table>\n";
   # Закрываем файл 
  writeFileFooter(\*FHTI);
  close(FHTI);
}

 # Создаёт HTML-файл модуля: (RefUnit)
sub writeUnit {
  my ($refunit) = @_;
   # Создаём HTML-файл модуля
  push @htmlfiles, $refunit->{HTMLFILE};
  open(FHU, ">$out_path/$refunit->{HTMLFILE}") or die "Cannot open $out_path/$refunit->{HTMLFILE} for writing: $!\n";
  writeFileHeader(
    \*FHU, 
    "$refunit->{NAME}", 
    qq|<a href="$toc_file">$usr_short_name</a> / $refunit->{NAME} unit|, 
    "$refunit->{COMMENT}<br>Size: <b>$refunit->{SIZE}</b>");
   # Цикл по типам объектов
  foreach my $reftype(@types) {
    my $typechar = $reftype->{CHAR};
     # Цикл по объектам модуля
    my $idx_obj = 0;
    my $obj_html = '';
    foreach my $objname(sort keys %{$refunit->{OBJECTS}}) {
      my $refobj = $refunit->{OBJECTS}->{$objname};
       # Если объект подходящего типа
      if ($refobj->{TYPE} eq $typechar) {
        my $obj_color = $idx_obj%2?' bgcolor=#f0f0f0':'';
        my $obj_printed = highlight(&{sub{$typebychar{$refobj->{TYPE}}->{PRINTER}}}->($refobj));
        $obj_html .=
          qq|<tr$obj_color>\n|.
          qq|  <td class=declmain>\n|.
          qq|    $obj_printed\n|.
          qq|  </td>\n|.
          qq|  <td class=comment>$refobj->{COMMENT}</td>\n|.
          qq|</tr>\n|;
         # Создаём HTML-файл объекта
        writeObj($refunit, $refobj);
        $idx_obj++;
      }
    }
     # Если есть объекты текущего типа - выводим
    if ($obj_html) {
      print FHU 
        qq|<table border=0 cellspacing=0 width=700 align=center>\n|.
        qq|<tr><th colspan=2><a name=$typechar>$reftype->{NAME}</a></th></tr>\n|.
        qq|$obj_html|.
        qq|</table>\n|;
    }
  }
  print FHU qq|<p align=center><a href="$toc_file">contents</a> - <a href="$typeidx_file">type index</a>|;
   # Закрываем HTML-файл модуля
  writeFileFooter(\*FHU);
  close(FHU);
}
