{smcl}
{* *! version 1.0.3  27mar2017}{...}
{vieweralsosee "help prdocumented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{vieweralsosee "[P] keyfiles" "help keyfiles"}{...}
{vieweralsosee "[R] net search" "help net"}{...}
{vieweralsosee "[R] sj" "help sj"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "[U] 3.2.4 The Stata Forum" "help statalist"}{...}
{viewerjumpto "Syntax" "findit##syntax"}{...}
{viewerjumpto "Description" "findit##description"}{...}
{pstd}
The default behavior of {helpb search} is now synonymous with {cmd:findit}.
{cmd:findit} continues to work but, as of Stata 13, is superfluous.
This is the original help file, which we will no longer update, so some links
may no longer work.

{hline}

{title:Title}

{p2colset 5 19 21 2}{...}
{p2col:{bf:[R] findit} {hline 2}}Search Stata documentation{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:findit}
{it:word}
[{it:word} {it:...}]


{marker description}{...}
{title:Description}

{pstd}
{opt findit} is equivalent to
{opt search} {it:word} [{it:word} {it:...}]{opt , all}.
{opt findit} results are displayed in the Viewer.
{opt findit} is the best way to search for information on a topic across
all sources, including the system help, the FAQs at the Stata website,
the {it:Stata Journal}, and all Stata-related Internet sources
including user-written additions.  From {opt findit}, you can click to go to a
source or to install additions.
{p_end}
