{smcl}
{* *! version 1.1.11  05sep2018}{...}
{vieweralsosee "[P] levelsof" "mansection P levelsof"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[D] inspect" "help inspect"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{viewerjumpto "Syntax" "levelsof##syntax"}{...}
{viewerjumpto "Description" "levelsof##description"}{...}
{viewerjumpto "Links to PDF documentation" "levelsof##linkspdf"}{...}
{viewerjumpto "Options" "levelsof##options"}{...}
{viewerjumpto "Remarks" "levelsof##remarks"}{...}
{viewerjumpto "Examples" "levelsof##examples"}{...}
{viewerjumpto "Stored results" "levelsof##results"}{...}
{viewerjumpto "References" "levelsof##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] levelsof} {hline 2}}Distinct levels of a variable{p_end}
{p2col:}({mansection P levelsof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:levelsof}
{varname}
{ifin}
[{cmd:,} {it:options}]

{synoptset 21}{...}
{synopthdr}
{synoptline}
{synopt:{opt c:lean}}display string values without compound double quotes{p_end}
{synopt:{opt l:ocal(macname)}}insert the list of values in the local macro {it:macname}{p_end}
{synopt:{opt miss:ing}}include missing values of {varname} in calculation{p_end}
{synopt:{opt s:eparate(separator)}}separator to serve as punctuation for the values of returned list; default is a space{p_end}
{synopt:{opt matcell(matname)}}save frequencies of distinct values in {it:matname}{p_end}
{synopt:{opt matrow(matname)}}save distinct values of {varname} in {it:matname}{p_end}
{synopt:{opt hex:adecimal}}use hexadecimal format for numerical values{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:levelsof} displays a sorted list of the distinct values of {varname}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P levelsofRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:clean} displays string values without compound double quotes.
By default, each distinct string value is displayed within compound double
quotes, as these are the most general delimiters.  If you know that the
string values in {varname} do not include embedded spaces or embedded
quotes, this is an appropriate option.  {cmd:clean} 
does not affect the display of values from numeric variables.

{phang}
{cmd:local(}{it:macname}{cmd:)} inserts the list of values in
local macro {it:macname} within the calling program's space.  Hence,
that macro will be accessible after {cmd:levelsof} has finished.
This is helpful for subsequent use, especially with {helpb foreach}.

{phang}
{cmd:missing} specifies that missing values of {varname}
be included in the calculation.  The default is to exclude them.

{phang}
{cmd:separate(}{it:separator}{cmd:)} specifies a separator
to serve as punctuation for the values of the returned list.
The default is a space.  A useful alternative is a comma.

{phang}
{opt matcell(matname)} saves the frequencies of the distinct values in
{it:matname}.

{phang}
{opt matrow(matname)} saves the distinct values of {varname} in {it:matname}.
{opt matrow()} may not be specified if {it:varname} is a string.

{phang}
{opt hexadecimal} specifies that hexadecimal format {cmd:%21x} be used when
{it:varname} is numeric.  See {manhelp format D}.  This option guarantees that
the values in the macro that {opt levelsof} creates are exactly numerically
equal to their values in {it:varname}.  For integer data, except for extremely
large integers (absolute value {ul:>} 1e19), {opt levelsof} always produces
values that give equality without this option.  For noninteger data or
extremely large integers, exact numerical equality may not be true in all
cases by default.  Specifying {opt hexadecimal} guarantees equality in all
cases.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:levelsof} serves two different functions.  First, it gives a
compact display of the distinct values of {it:varname}.  More commonly, it is
useful when you desire to cycle through the distinct values of
{it:varname} with (say) {cmd:foreach}; see {helpb foreach:[P] foreach}.
{cmd:levelsof} leaves behind a list in {cmd:r(levels)} that may be used in a
subsequent command.  When wanting to get the levels of noninteger data,
one may use {opt matrow(matname)} to obtain the levels in full precision.

{pstd}
{cmd:levelsof} may hit the {help limits} imposed by your Stata.  However,
it is typically used when the number of distinct values of
{it:varname} is not extremely large.

{pstd}
The terminology of levels of a factor has long been standard in
experimental design.  See
{help levelsof##CC1957:Cochran and Cox (1957, 148)},
{help levelsof##F1942:Fisher (1942)}, or
{help levelsof##Y1937:Yates (1937, 5)}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}

{phang}{cmd:. levelsof rep78}{p_end}
{phang}{cmd:. display "`r(levels)'"}

{phang}{cmd:. levelsof rep78, miss local(mylevs)}{p_end}
{phang}{cmd:. display "`mylevs'"}

{phang}{cmd:. levelsof rep78, sep(,)}{p_end}
{phang}{cmd:. display "`r(levels)'"}

{pstd}Showing value labels when defined:{p_end}
{pstd}{cmd:. levelsof factor, local(levels)}{break}
{cmd:. foreach l of local levels {c -(}}{break}
{cmd:.{space 8}di "-> factor = `: label (factor) `l''"}{break}
{cmd:.}{space 8}{it:whatever}{cmd: if factor == `l'}{break}
{cmd:. {c )-}}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:levelsof} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(r)}}number of distinct values{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(levels)}}list of distinct values{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker CC1957}{...}
{phang}
Cochran, W. G., and G. M. Cox. 1957. {it:Experimental Designs}. 2nd ed.
New York: Wiley.

{marker F1942}{...}
{phang}
Fisher, R. A. 1942. The theory of confounding in factorial experiments in
relation to the theory of groups.
{it:Annals of Eugenics} 11: 341-353.

{marker Y1937}{...}
{phang}
Yates, F. 1937. {it:The Design and Analysis of Factorial Experiments}.
Harpenden, England: Technical Communication 35, Imperial Bureau of
Soil Science.
{p_end}
