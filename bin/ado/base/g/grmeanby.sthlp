{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog grmeanby "dialog grmeanby"}{...}
{vieweralsosee "[R] grmeanby" "mansection R grmeanby"}{...}
{viewerjumpto "Syntax" "grmeanby##syntax"}{...}
{viewerjumpto "Menu" "grmeanby##menu"}{...}
{viewerjumpto "Description" "grmeanby##description"}{...}
{viewerjumpto "Links to PDF documentation" "grmeanby##linkspdf"}{...}
{viewerjumpto "Options" "grmeanby##options"}{...}
{viewerjumpto "Examples" "grmeanby##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] grmeanby} {hline 2}}Graph means and medians by categorical
variables{p_end}
{p2col:}({mansection R grmeanby:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:grmeanby}
{varlist}
{ifin}
[{it:{help grmeanby##weight:weight}}]
{cmd:,} {opth su:mmarize(varname)}
[{it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent:* {opth su:mmarize(varname)}}graph mean (or median) of
{it:varname}{p_end}
{synopt :{opt med:ian}}graph medians; default is to graph means{p_end}

{syntab :Plot}
{p2col:{it:{help cline_options}}}change look of the lines{p_end}
INCLUDE help gr_markopt2

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
*{opt summarize(varname)} is required.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Summary and descriptive statistics > Graph means/medians by groups}


{marker description}{...}
{title:Description}

{pstd}
{opt grmeanby} graphs the (optionally weighted) means or medians of
{varname} according to the values of the variables in {varlist}.  The
variables in {it:varlist} may be string or numeric and, if numeric, may be
labeled.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R grmeanbyQuickstart:Quick start}

        {mansection R grmeanbyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth summarize(varname)} is required; it specifies the
name of the variable whose mean or median is to be graphed.

{phang}
{opt median} specifies that the graph is to be of medians, not means.

{dlgtab:Plot}

{phang}
{it:cline_options}
     affect the rendition of the lines through the markers, including their
     color, pattern, and width; 
     see {manhelpi cline_options G-3}.

INCLUDE help gr_markoptf

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Graph means of {cmd:mpg} according to values of {cmd:foreign},
{cmd:rep78}, and {cmd:turn}{p_end}
{phang2}{cmd:. grmeanby foreign rep78 turn, sum(mpg)}{p_end}

{pstd}Same as above, but graph medians rather than means{p_end}
{phang2}{cmd:. grmeanby foreign rep78 turn, sum(mpg) median}{p_end}
