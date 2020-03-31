{smcl}
{* *! version 1.1.16  22mar2018}{...}
{viewerdialog "infile (free format)" "dialog infile_free"}{...}
{vieweralsosee "[D] infile (free format)" "mansection D infile(freeformat)"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] infile (fixed format)" "help infile2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "infile1##syntax"}{...}
{viewerjumpto "Menu" "infile1##menu"}{...}
{viewerjumpto "Description" "infile1##description"}{...}
{viewerjumpto "Links to PDF documentation" "infile1##linkspdf"}{...}
{viewerjumpto "Options" "infile1##options"}{...}
{viewerjumpto "Examples" "infile1##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[D] infile (free format)} {hline 2}}Import unformatted text
data{p_end}
{p2col:}({mansection D infile(freeformat):View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{opt inf:ile}
{varlist}
[{cmd:_skip}[{opt (#)}]
[{varlist} [{cmd:_skip}[{opt (#)}] {it:...}]]]
{cmd:using} {it:{help filename}}
{ifin}
[{cmd:,} {it:options}]

{phang}
If {it:{help filename}} is specified without an extension, {opt .raw} is
assumed.  If {it:filename} contains embedded spaces, remember to enclose
it in double quotes.

{synoptset 17 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt clear}}replace data in memory{p_end}

{syntab :Options}
{synopt :{opt a:utomatic}}create value labels from nonnumeric data{p_end}
{synopt :{opt by:variable(#)}}organize external file by variables; {it:#} is
number of observations{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Unformatted text data} 


{marker description}{...}
{title:Description}

{pstd}
{opt infile} reads into memory from a disk a dataset that is not in Stata
format.

{pstd}
Here we discuss using {opt infile} to read free-format data, meaning datasets
in which Stata does not need  to know the formatting information.  Another
variation on {opt infile} allows reading fixed-format data; see
{help infile2}.
Yet another alternative is {helpb import delimited}, which is easier to
use if your data are tab- or comma-separated and contain 1 observation per
line.  Stata has other commands for reading data, too.  If you are not certain
that {opt infile} will do what you are looking for, see
{manhelp import D} and {findalias frdatain}.

{pstd}
After the data are read into Stata, they can be saved in a Stata-format
dataset; see {manhelp save D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D infile(freeformat)Quickstart:Quick start}

        {mansection D infile(freeformat)Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt clear} specifies that it is okay for the new data to replace the
data that are currently in memory.
To ensure that you do not lose something important, {opt infile} will
refuse to read new data if data are already in memory.  {opt clear}
allows {opt infile} to replace the data in memory.  You can also drop
the data yourself by typing {cmd:drop _all} before reading new data.

{dlgtab:Options}

{phang}{opt automatic} causes Stata to create value labels from the nonnumeric
data it reads.
It also automatically widens the display format to fit the longest label.

{phang}{opt byvariable(#)} specifies that the external data file is
organized by variables rather than by observations.  All the observations on the
first variable appear, followed by all observations on the second variable,
and so on.  Time-series datasets sometimes come in this format.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep price mpg rep78}{p_end}
{phang2}{cmd:. keep in 1/10}

{pstd}Write data in text format to {cmd:myout.raw}{p_end}
{phang2}{cmd:. outfile using myout}

{pstd}Display contents of {cmd:myout.raw}{p_end}
{phang2}{cmd:. type myout.raw}

{pstd}Clear data and value labels from memory{p_end}
{phang2}{cmd:. clear}

{pstd}Read data in {cmd:myout.raw} into memory{p_end}
{phang2}{cmd:. infile price mpg rep78 using myout}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}Clear data and value labels from memory{p_end}
{phang2}{cmd:. clear}

{pstd}Read data in {cmd:myout.raw} into memory, but store {cmd:mpg} and
{cmd:rep78} as {cmd:int} variables{p_end}
{phang2}{cmd:. infile price int (mpg rep78) using myout}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. sort price}{p_end}
{phang2}{cmd:. keep make price mpg rep78 foreign}{p_end}
{phang2}{cmd:. keep in 1/10}

{pstd}Write data in text format to {cmd:myout.raw}{p_end}
{phang2}{cmd:. outfile using myout, replace}

{pstd}Display contents of {cmd:myout.raw}{p_end}
{phang2}{cmd:. type myout.raw}

{pstd}Clear data and value labels from memory{p_end}
{phang2}{cmd:. clear}

{pstd}Read data in {cmd:myout.raw} into memory{p_end}
{phang2}{cmd:. infile str18 make price mpg rep78 str8 foreign using myout}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Clear data from memory{p_end}
{phang2}{cmd:. clear}

{pstd}Read data in {cmd:myout.raw} into memory, automatically creating a value
label for {cmd:foreign} and storing it as a {cmd:byte} rather than a
{cmd:str8}{p_end}
{phang2}{cmd:. infile str18 make price mpg rep78 byte foreign:origin using}
            {cmd:myout, automatic}

{pstd}Describe {cmd:foreign}{p_end}
{phang2}{cmd:. describe foreign}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}List the value label{p_end}
{phang2}{cmd:. label list}

{pstd}Clear data and value labels from memory{p_end}
{phang2}{cmd:. clear}

{pstd}Define value label {cmd:myorigin}{p_end}
{phang2}{cmd:. label define myorigin 0 "Domestic" 1 "Foreign"}

{pstd}Read data in {cmd:myout.raw} into memory using {cmd:myorigin} value
label for {cmd:foreign}{p_end}
{phang2}{cmd:. infile str18 make price mpg rep78 byte foreign:myorigin using}
          {cmd:myout}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}List the value label{p_end}
{phang2}{cmd:. label list}{p_end}
    {hline}
