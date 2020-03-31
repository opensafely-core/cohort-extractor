{smcl}
{* *! version 1.1.12  19dec2012}{...}
{viewerdialog insheet "dialog insheet"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{viewerjumpto "Syntax" "insheet##syntax"}{...}
{viewerjumpto "Menu" "insheet##menu"}{...}
{viewerjumpto "Description" "insheet##description"}{...}
{viewerjumpto "Options" "insheet##options"}{...}
{viewerjumpto "Examples" "insheet##examples"}{...}
{pstd}
{cmd:insheet} has been superseded by {helpb import delimited}.  {cmd:insheet}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.


{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{bf:[D] insheet} {hline 2}}Read text data created by a
spreadsheet{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:insheet}
[{varlist}]
{cmd:using}
{it:{help filename}}
[{cmd:,} {it:options}]

{synoptset 21}{...}
{synopthdr}
{synoptline}
{synopt :[{cmdab:no:}]{opt d:ouble}}override default storage type{p_end}
{synopt :{opt t:ab}}tab-delimited data{p_end}
{synopt :{opt c:omma}}comma-delimited data{p_end}
{synopt :{cmdab:delim:iter("}{it:char}{cmd:")}}use {it:char} as delimiter{p_end}
{synopt :{opt clear}}replace data in memory{p_end}
{synopt :{opt case}}preserve variable name's case{p_end}

{synopt :[{cmd:{ul:no}}]{opt n:ames}}variable names are included on
the first line of the file{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}[{opt no}]{opt names} does not appear in the dialog box{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Text data created by a spreadsheet}


{marker description}{...}
{title:Description}

{pstd}
{opt insheet} reads into memory from a disk a dataset that is not in Stata
format.  {opt insheet} is intended for reading files created by a spreadsheet
or database program.  Regardless of the creator of the file, {opt insheet}
reads text (ASCII) files in which there is 1 observation per line and the
values are separated by tabs or commas.  Also the first line of the
file can contain the variable names.  If you type

{phang2}{cmd:. insheet using} {it:filename}

{pstd}
{opt insheet} reads your data; that is all there is to it.

{pstd}
If {it:{help filename}} is specified without an extension, {cmd:.raw} is
assumed.  If your {it:filename} contains embedded spaces, remember to enclose
it in double quotes.

{pstd}
Stata has other commands for reading data.  If you are not sure that
{opt insheet} will do what you are looking for, see {manhelp import D} and
{findalias frdatain}.  If you want to save your data in spreadsheet-style text
format, see {manhelp outsheet D}.  However, {cmd:export} {cmd:excel} may be a
better option; see {helpb import excel:[D] import excel}. 


{marker options}{...}
{title:Options}

{phang}
[{opt no}]{opt double} affects the way Stata handles the storage
    of floating-point variables.  If the default storage type (see
    {manhelp generate D}) is set to {opt float}, specifying the
    {opt double} option forces Stata to store floating-point variables as
    {opt double}s rather than {opt float}s.  If the default storage type has
    been set to {opt double}, you must specify {opt nodouble} to have
    floating-point variables stored as {opt float}s rather than {opt double}s;
    see {manhelp data_types D:data types}.

{phang}
{opt tab} tells Stata that the values are tab-separated.
    Specifying this option will
    speed {opt insheet}'s processing, assuming that you are right.
    {opt insheet} can determine for itself whether the separation character is
    a tab or a comma.

{phang}
{opt comma} tells Stata that the values are comma-separated.
    Specifying this option will
    speed {opt insheet}'s processing, assuming that you are right.
    {opt insheet} can determine for itself whether the separation character is
    a comma or a tab.

{phang}
{cmd:delimiter("}{it:char}{cmd:")} allows you to specify other separation
    characters.  For instance, if values in the file are separated by
    a semicolon, specify {cmd:delimiter(";")}.

{phang}
{opt clear} specifies that it is okay for the new data to replace the data that
    are currently in memory.  To ensure that you do not lose something
    important, {opt insheet} will refuse to read new data if data are
    already in memory.  {opt clear} allows {opt insheet} to replace the data
    in memory.  You can also drop the data yourself by typing {cmd:drop _all}
    before reading new data.

{phang}
{opt case} preserves the variable name's case.  By default, all variable names
   are imported as lowercase.

{pstd}
The following option is available with {opt insheet} but is not shown in
the dialog box: 

{phang}
[{opt no}]{opt names} informs Stata whether variable names
    are included on the first line of the file.  Specifying this option will
    speed {opt insheet}'s processing, assuming that you are right.
    {opt insheet} can determine for itself whether the file
    includes variable names.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. insheet using auto.raw}{p_end}

{phang}{cmd:. insheet using auto.raw, clear}{p_end}

{phang}{cmd:. insheet using auto.raw, clear double}{p_end}
