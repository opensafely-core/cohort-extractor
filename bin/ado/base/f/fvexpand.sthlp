{smcl}
{* *! version 1.0.10  02aug2018}{...}
{vieweralsosee "[P] fvexpand" "mansection P fvexpand"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fvrevar" "help fvrevar"}{...}
{vieweralsosee "[U] 11.4.3 Factor variables" "help fvvarlist"}{...}
{viewerjumpto "Syntax" "fvexpand##syntax"}{...}
{viewerjumpto "Description" "fvexpand##description"}{...}
{viewerjumpto "Links to PDF documentation" "fvexpand##linkspdf"}{...}
{viewerjumpto "Remarks" "fvexpand##remarks"}{...}
{viewerjumpto "Stored results" "fvexpand##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] fvexpand} {hline 2}}Expand factor varlists{p_end}
{p2col:}({mansection P fvexpand:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:fvexpand} [{varlist}] {ifin}

{phang}
{it:varlist} may contain factor variables and time-series operators; see
{help fvvarlist} and {help tsvarlist}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:fvexpand} expands a factor varlist to the corresponding expanded,
specific varlist.  {varlist} may be general or specific and even may
already be expanded.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P fvexpandRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
An example of a general factor varlist is {cmd:mpg} {cmd:i.foreign}.  The
corresponding specific factor varlist would be {cmd:mpg}
{cmd:i(0 1)b0.foreign} if {cmd:foreign} took on the values 0 and 1 in the
data.

{pstd}
A specific factor varlist is specific with respect to a given problem, which
is to say, a given dataset and subsample.  The specific varlist identifies the
values taken on by factor variables and the base.

{pstd}
Factor varlist {cmd:mpg} {cmd:i(0 1)b0.foreign} is specific.  The
same varlist could be written as {cmd:mpg} {cmd:i0b.foreign} {cmd:i1.foreign},
so that is specific, too.  The first is unexpanded and specific.  The second
is expanded and specific.

{pstd}
{cmd:fvexpand} takes a general or specific (expanded or unexpanded) factor
varlist, along with an optional {cmd:if} or {cmd:in}, and returns a fully
expanded, specific varlist.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:fvexpand} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}the expanded, specific varlist{p_end}
{synopt:{cmd:r(fvops)}}{cmd:true} if {it:varlist} contains factor variables{p_end}
{synopt:{cmd:r(tsops)}}{cmd:true} if {it:varlist} contains time-series
operators{p_end}
