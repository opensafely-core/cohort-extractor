{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog stvary "dialog stvary"}{...}
{vieweralsosee "[ST] stvary" "mansection ST stvary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stdescribe" "help stdescribe"}{...}
{vieweralsosee "[ST] stfill" "help stfill"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "stvary##syntax"}{...}
{viewerjumpto "Menu" "stvary##menu"}{...}
{viewerjumpto "Description" "stvary##description"}{...}
{viewerjumpto "Links to PDF documentation" "stvary##linkspdf"}{...}
{viewerjumpto "Option" "stvary##option"}{...}
{viewerjumpto "Examples" "stvary##examples"}{...}
{viewerjumpto "Video example" "stvary##video"}{...}
{viewerjumpto "Stored results" "stvary##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] stvary} {hline 2}}Report variables that vary over time{p_end}
{p2col:}({mansection ST stvary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:stvary} [{varlist}] {ifin} [{cmd:,} {opt nosh:ow}]


{pstd}
You must {cmd:stset} your data before using {cmd:stvary}; see
{manhelp stset ST}.{p_end}
{pstd}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{pstd}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using
{cmd:stset}; see {manhelp stset ST}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
       {bf:Report variables that vary over time}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stvary} is for use with multiple-record datasets, for which {opt id()}
has been {cmd:stset}.  It reports whether values of variables within subject
vary over time and reports their pattern of missing values.  Although 
{cmd:stvary} is intended for use with multiple-record st data, it may be used
with single-record data as well, but this produces little useful information.

{pstd}
{cmd:stvary} ignores weights, even if you have set them.  {cmd:stvary}
summarizes the variables in the computer or data sense of the word.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stvaryQuickstart:Quick start}

        {mansection ST stvaryRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{dlgtab:Main}

{phang}
{opt noshow} prevents {cmd:stvary} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Report whether variables vary over time and whether they have missing
values{p_end}
{phang2}{cmd:. stvary}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stvaryex}

{pstd}By categories of {cmd:sex}, report whether {cmd:drug} varies over time
and whether it has missing values{p_end}
{phang2}{cmd:. by sex, sort: stvary drug}

{pstd}Report whether {cmd:sex} and {cmd:drug} vary over time and whether they
have missing values{p_end}
{phang2}{cmd:. stvary sex drug}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=zw8UvYdI8y8":How to describe and summarize survival data}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stvary} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(cons)}}number of subjects for whom variable is constant when
not missing{p_end}
{synopt:{cmd:r(varies)}}number of subjects for whom nonmissing values
vary{p_end}
{synopt:{cmd:r(never)}}number of subjects for whom variable is never
missing{p_end}
{synopt:{cmd:r(always)}}number of subjects for whom variable is always
missing{p_end}
{synopt:{cmd:r(miss)}}number of subjects for whom variable is sometimes
missing{p_end}
{p2colreset}{...}
