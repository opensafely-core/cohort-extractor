{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog stem "dialog stem"}{...}
{vieweralsosee "[R] stem" "mansection R stem"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{vieweralsosee "[R] lv" "help lv"}{...}
{viewerjumpto "Syntax" "stem##syntax"}{...}
{viewerjumpto "Menu" "stem##menu"}{...}
{viewerjumpto "Description" "stem##description"}{...}
{viewerjumpto "Links to PDF documentation" "stem##linkspdf"}{...}
{viewerjumpto "Options" "stem##options"}{...}
{viewerjumpto "Examples" "stem##examples"}{...}
{viewerjumpto "Stored results" "stem##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] stem} {hline 2}}Stem-and-leaf displays{p_end}
{p2col:}({mansection R stem:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:stem}
{varname}
{ifin}
[{cmd:,} {it:options}]

{synoptset 14 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt p:rune}}do not print stems that have no leaves{p_end}
{synopt:{opt r:ound(#)}}round data to this value; default is {cmd:round(1)}{p_end}
{synopt:{opt t:runcate(#)}}truncate data to this value{p_end}
{synopt:{opt d:igits(#)}}digits per leaf; default is {cmd:digits(1)}{p_end}
{synopt:{opt l:ines(#)}}number of stems per interval of 10^{cmd:digits}{p_end}
{synopt:{opt w:idth(#)}}stem width; equal to (10^{cmd:digits})/{opt width}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Distributional plots and tests > Stem-and-leaf display}


{marker description}{...}
{title:Description}

{pstd}
{opt stem} displays stem-and-leaf plots.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R stemQuickstart:Quick start}

        {mansection R stemRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt prune} prevents printing any stems that have no leaves.

{phang}
{opt round(#)} rounds the data to this value and displays the
plot in these units.  If {opt round()} is not specified,
noninteger data will be rounded automatically.

{phang}
{opt truncate(#)} truncates the data to this value and displays the
plot in these units.

{phang}
{opt digits(#)} sets the number of digits per leaf.  The default is 1.

{phang}
{opt lines(#)} sets the number of stems per every data
interval of 10^{cmd:digits}.  The value of {opt lines()} must divide
10^{cmd:digits}; that is, if {cmd:digits(1)} is specified, then {opt lines()}
must divide 10.  If {cmd:digits(2)} is specified, then {opt lines()}
must divide 100, etc.  Only one of {opt lines()} or {opt width()} may be specified.
If neither is specified, an appropriate value will be set automatically.

{phang}
{opt width(#)} sets the width of a stem.  {opt lines()} is equal to 
(10^{cmd:digits})/{opt width}, and this option is merely an alternative way of
setting {opt lines()}.  The value of {opt width()} must divide 10^{cmd:digits}.
Only one of {opt width()} or {opt lines()} may be specified.
If neither is specified, an appropriate value will be set automatically.

{pstd}
Note:  If {opt lines()} or {opt width()} is not specified, {opt digits()} may be
decreased in some circumstances to make a better-looking plot.  If {opt lines()}
or {opt width()} is set, the user-specified value of {opt digits()} will not be
altered.


{marker examples}{...}
{title:Examples}

	{cmd:. webuse stemxmpl}
	{cmd:. stem x}

	{txt}Stem-and-leaf plot for x

	  {res}2* | 11111
	  2t | 22222333
	  2f | 444455555
	  2s | 666
	  2. | 8889
	  3* | 001{txt}

{pstd}
Note:  the above plot is a five-line plot ({hi:lines} = 5 and {hi:width} = 2).

	{cmd:. stem x, lines(2)}

	{txt}Stem-and-leaf plot for x

	  {res}2* | 11111222223334444
	  2. | 555556668889
	  3* | 001{txt}

{pstd}
Note:  {hi:stem x, width(5)} will produce the same plot as above.

	{cmd:. sysuse auto}
	{cmd:. stem weight, lines(1) digits(2)}
	{cmd:. stem weight, lines(1) digits(2) prune}
	{cmd:. stem weight, round(100)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stem} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(width)}}width of a stem{p_end}
{synopt:{cmd:r(digits)}}number of digits per leaf; default is 1{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(round)}}number specified in {cmd:round()}{p_end}
{synopt:{cmd:r(truncate)}}number specified in {cmd:truncate()}{p_end}
{p2colreset}{...}
