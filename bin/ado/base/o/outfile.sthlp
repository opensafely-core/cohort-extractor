{smcl}
{* *! version 1.1.15  19oct2017}{...}
{viewerdialog outfile "dialog outfile"}{...}
{vieweralsosee "[D] outfile" "mansection D outfile"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "outfile##syntax"}{...}
{viewerjumpto "Menu" "outfile##menu"}{...}
{viewerjumpto "Description" "outfile##description"}{...}
{viewerjumpto "Links to PDF documentation" "outfile##linkspdf"}{...}
{viewerjumpto "Options" "outfile##options"}{...}
{viewerjumpto "Examples" "outfile##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] outfile} {hline 2}}Export dataset in text format{p_end}
{p2col:}({mansection D outfile:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:ou:tfile}
[{varlist}]
{cmd:using}
{it:{help filename}}
{ifin}
[{cmd:,} {it:options}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt d:ictionary}}write the file in Stata's dictionary format{p_end}
{synopt :{opt nol:abel}}output numeric values (not labels) of labeled
variables; the default is to write labels in double quotes{p_end}
{synopt :{opt noq:uote}}do not enclose strings in double quotes{p_end}
{synopt :{opt c:omma}}write file in comma-separated (instead of space-separated)
format{p_end}
{synopt :{opt w:ide}}force one observation per line (no matter how wide){p_end}

{syntab :Advanced}
{synopt :{opt rjs}}right-justify string variables; the default is to
left-justify{p_end}
{synopt :{opt fjs}}left-justify if format width < 0; right-justify if format
width > 0{p_end}
{synopt :{opt runtogether}}all on one line, no quotes, no space between, and
ignore formats{p_end}
{synopt :{opt m:issing}}retain missing values; use only with {opt comma}{p_end}

{synopt :{opt replace}}overwrite the existing file{p_end}
{synoptline}
{p 4 6 2}
{opt replace} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Export > Text data (fixed- or free-format)}


{marker description}{...}
{title:Description}

{pstd}
{opt outfile} writes data to a disk file in plain-text format, which can be
read by other programs.  The new file is not in Stata format; see 
{manhelp save D} for instructions on saving data for later use in Stata.

{pstd}
The data saved by {opt outfile} can be read back by {opt infile}; see
{manhelp import D}.  If {it:{help filename}} is specified without an extension,
{opt .raw} is assumed unless the {opt dictionary} option is specified, in
which case {opt .dct} is assumed.  If your {it:filename} contains embedded
spaces, remember to enclose it in double quotes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D outfileQuickstart:Quick start}

        {mansection D outfileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt dictionary} writes the file in Stata's data dictionary format.
See {help infile2} for a description of dictionaries.
{opt comma}, {opt missing}, and  {opt wide} are not
allowed with {opt dictionary}.

{phang}{opt nolabel} causes Stata to write the numeric values of labeled
variables.  The default is to write the labels enclosed in double quotes.

{phang}{opt noquote} prevents Stata from placing double quotes around the
contents of strings, meaning string variables and value labels.

{phang}{opt comma} causes Stata to write the file in
comma-separated-value format.  In this format, values are separated by
commas rather than by blanks.  Missing values are written as two consecutive
commas unless {opt missing} is specified.

{phang}{opt wide} causes Stata to write the data with 1 observation per
line.  The default is to split observations into lines of 80 characters or
fewer, but strings longer than 80 characters are never split across lines.

{dlgtab:Advanced}

{phang}{opt rjs} and {opt fjs} affect how strings are justified;  you probably
do not want to specify either of these options.  By default, {opt outfile}
outputs strings left-justified in their field.

{pmore}If {opt rjs} is specified, strings are output right-justified. {opt rjs}
stands for "right-justified strings".

{pmore}If {opt fjs} is specified, strings are output left- or right-justified
according to the variable's format:  left-justified if the format width is
negative and right-justified if the format width is positive.  {opt fjs} stands
for "format-justified strings".

{phang}{opt runtogether} is a programmer's option that is valid only when all
variables of the specified {varlist} are of type {cmd:string}.
{opt runtogether} specifies that the variables be output in the order
specified, without quotes, with no spaces between, and ignoring the display
format attached to each variable.  Each observation ends with a new line
character.

{phang}{opt missing}, valid only with {cmd:comma}, specifies that missing
values be retained.  When {opt comma} is specified without
{opt missing}, missing values are changed to null strings ({cmd:""}).

{pstd}The following option is available with {opt outfile} but is not shown in
the dialog box:

{phang}{opt replace} permits {opt outfile} to overwrite an existing dataset.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep make price mpg rep78 foreign}{p_end}
{phang2}{cmd:. keep in 1/10}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Write data in plain-text format to {cmd:myout.raw}{p_end}
{phang2}{cmd:. outfile using myout}

{pstd}Display contents of {cmd:myout.raw}{p_end}
{phang2}{cmd:. type myout.raw}

{pstd}Change the value of {cmd:mpg} in observations 1 to 20{p_end}
{phang2}{cmd:. replace mpg = 20 in 1}

{pstd}Write data in plain-text format to {cmd:myout.raw}, overwriting the
existing {cmd:myout.raw} file{p_end}
{phang2}{cmd:. outfile using myout, replace}

{pstd}Write data in plain-text format to {cmd:myout.raw} but write numeric
values for {cmd:foreign} rather than the labels{p_end}
{phang2}{cmd:. outfile using myout, nolabel replace}

{pstd}Display contents of {cmd:myout.raw}{p_end}
{phang2}{cmd:. type myout.raw}

{pstd}Write data in plain-text format to {cmd:myout.raw} in comma-separated
format{p_end}
{phang2}{cmd:. outfile using myout, comma replace}

{pstd}Display contents of {cmd:myout.raw}{p_end}
{phang2}{cmd:. type myout.raw}

{pstd}Write data to {cmd:myout.dct} in Stata's dictionary format{p_end}
{phang2}{cmd:. outfile using myout, dictionary}

{pstd}Display contents of {cmd:myout.dct}{p_end}
{phang2}{cmd:. type myout.dct}{p_end}
