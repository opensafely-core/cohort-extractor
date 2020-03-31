{smcl}
{* *! version 1.2.12  19dec2012}{...}
{viewerdialog outsheet "dialog outsheet"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "outsheet##syntax"}{...}
{viewerjumpto "Menu" "outsheet##menu"}{...}
{viewerjumpto "Description" "outsheet##description"}{...}
{viewerjumpto "Options" "outsheet##options"}{...}
{viewerjumpto "Examples" "outsheet##examples"}{...}
{pstd}
{cmd:outsheet} has been superseded by {helpb import delimited}.  {cmd:outsheet}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.


{title:Title}

{p2colset 5 21 23 2}{...}
{p2col :{bf:[D] outsheet} {hline 2}}Write spreadsheet-style dataset{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:outs:heet}
[{varlist}]
{cmd:using}
{it:{help filename}}
{ifin}
[{cmd:,} {it:options}]


{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt c:omma}}output in comma-separated (instead of tab-separated)
format{p_end}
{synopt :{cmdab:delim:iter("}{it:char}{cmd:")}}use {it:char} as
         delimiter{p_end}
{synopt :{opt non:ames}}do not write variable names on the first line{p_end}
{synopt :{opt nol:abel}}output numeric values (not labels) of labeled
variables{p_end}
{synopt :{opt noq:uote}}do not enclose strings in double quotes{p_end}

{synopt:{opt replace}}overwrite existing {it:{help filename}}{p_end}
{synoptline}
{p 4 6 2}
If {it:filename} is specified without a suffix, {opt .out} is assumed.{p_end}
{p 4 6 2}
If your {it:filename} contains embedded spaces, remember to enclose
it in double quotes.{p_end}
{p 4 6 2}
{opt replace} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Export > Comma- or tab-separated data}


{marker description}{...}
{title:Description}

{pstd}
{opt outsheet}, by default, writes data into a file in tab-separated
format.  {cmd:outsheet} also allows users to specify comma-separated format 
or any separation character that they prefer.  {cmd:export} {cmd: excel} may be
a better option if you are exporting data to a program that can read Excel
files; see {helpb import excel:[D] import excel}.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt comma} specifies comma-separated format rather than the default
tab-separated format.

{phang}
{cmd:delimiter("}{it:char}{cmd:")} allows you to specify other separation
    characters.  For instance, if you want the values in the file to be
    separated by a semicolon, specify {cmd:delimiter(";")}.

{phang}{opt nonames} specifies that variables name not be written in
the first line of the file; the file is to contain data values only.

{phang}{opt nolabel} specifies that the numeric values of labeled variables
be written into the file rather than the label associated with each
value.

{phang}{opt noquote} specifies that string variables not be enclosed in
double quotes.

{pstd}
The following option is available with {opt outsheet} but is not shown in the
dialog box:

{phang}{opt replace} specifies that {it:{help filename}} be replaced if it
already exists.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep make price mpg rep78 foreign}{p_end}
{phang2}{cmd:. keep in 1/10}

{pstd}Write date in memory to the file {cmd:myauto.out} in tab-separated text
format{p_end}
{phang2}{cmd:. outsheet using myauto}

{pstd}Display contents of {cmd:myauto.out}{p_end}
{phang2}{cmd:. type myauto.out}

{pstd}Same as above {cmd:outsheet} command, but do not put variable names in
the first line of the file and replace the existing {cmd:myauto.out}
file{p_end}
{phang2}{cmd:. outsheet using myauto, nonames replace}

{pstd}Display contents of {cmd:myauto.out}{p_end}
{phang2}{cmd:. type myauto.out}

{pstd}Same as above {cmd:outsheet} command, but do not enclose strings in
quotes{p_end}
{phang2}{cmd:. outsheet using myauto, nonames noquote replace}

{pstd}Display contents of {cmd:myauto.out}{p_end}
{phang2}{cmd:. type myauto.out}

{pstd}Same as above {cmd:outsheet} command, but output numeric values of
labeled variables{p_end}
{phang2}{cmd:. outsheet using myauto, nonames noquote nolabel replace}

{pstd}Display contents of {cmd:myauto.out}{p_end}
{phang2}{cmd:. type myauto.out}{p_end}
