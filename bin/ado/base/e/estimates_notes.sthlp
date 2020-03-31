{smcl}
{* *! version 2.1.3  19oct2017}{...}
{vieweralsosee "[R] estimates notes" "mansection R estimatesnotes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "estimates_notes##syntax"}{...}
{viewerjumpto "Description" "estimates_notes##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_notes##linkspdf"}{...}
{viewerjumpto "Examples" "estimates_notes##examples"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] estimates notes} {hline 2}}Add notes to estimation results{p_end}
{p2col:}({mansection R estimatesnotes:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {opt note:s}{cmd::}
{it:text}


{p 8 12 2}
{opt est:imates} {opt note:s}

{p 8 12 2}
{opt est:imates} {opt note:s} {opt l:ist}
[{cmd:in} {it:noterange}]


{p 8 12 2}
{opt est:imates} {opt note:s} {cmd:drop}
{cmd:in} {it:noterange}


{phang}
where {it:noterange} is {it:#} or {it:#}{cmd:/}{it:#}
and where {it:#} may be a number, the letter {cmd:f} (meaning first), 
or the letter {cmd:l} (meaning last).


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:notes:} {it:text}
adds a note to the current (active) estimation results.

{pstd}
{cmd:estimates} {cmd:notes} 
and 
{cmd:estimates} {cmd:notes} {cmd:list} 
list the current notes.

{pstd}
{cmd:estimates} {cmd:notes} {cmd:drop} {cmd:in} {it:noterange}
eliminates the specified notes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatesnotesQuickstart:Quick start}

        {mansection R estimatesnotesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg weight displ if foreign}{p_end}

{pstd}Add filename as a note{p_end}
{phang2}{cmd:. estimates notes: file `c(filename)'}

{pstd}Add data signature to results, too{p_end}
{phang2}{cmd:. datasignature}{p_end}
{phang2}{cmd:. estimates notes: datasignature report `r(datasignature)'}

{pstd}Save results to disk{p_end}
{phang2}{cmd:. estimates save foreign}

{pstd}List notes{p_end}
{phang2}{cmd:. estimates notes list in 1/2}

{pstd}Delete second note{p_end}
{phang2}{cmd:. estimates notes drop in 2}

{pstd}Show the current notes{p_end}
{phang2}{cmd:. estimates notes}{p_end}
