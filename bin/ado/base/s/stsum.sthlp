{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog stsum "dialog stsum"}{...}
{vieweralsosee "[ST] stsum" "mansection ST stsum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stci" "help stci"}{...}
{vieweralsosee "[ST] stdescribe" "help stdescribe"}{...}
{vieweralsosee "[ST] stgen" "help stgen"}{...}
{vieweralsosee "[ST] stir" "help stir"}{...}
{vieweralsosee "[ST] stptime" "help stptime"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stvary" "help stvary"}{...}
{viewerjumpto "Syntax" "stsum##syntax"}{...}
{viewerjumpto "Menu" "stsum##menu"}{...}
{viewerjumpto "Description" "stsum##description"}{...}
{viewerjumpto "Links to PDF documentation" "stsum##linkspdf"}{...}
{viewerjumpto "Options" "stsum##options"}{...}
{viewerjumpto "Examples" "stsum##examples"}{...}
{viewerjumpto "Video example" "stsum##video"}{...}
{viewerjumpto "Stored results" "stsum##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ST] stsum} {hline 2}}Summarize survival-time data{p_end}
{p2col:}({mansection ST stsum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:stsum} {ifin} [{cmd:,} {opth by(varlist)} {opt nosh:ow}]

{pstd}
You must {cmd:stset} your data before using {cmd:stsum}; see
{manhelp stset ST}.{p_end}
{pstd}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{pstd}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using
{cmd:stset}; see {manhelp stset ST}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
      {bf:Summarize survival-time data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stsum} presents summary statistics: time at risk; incidence rate;
number of subjects; and the 25th, 50th, and 75th percentiles of survival time.

{pstd}
{cmd:stsum} can be used with single- or multiple-record or single- or
multiple-failure st date.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stsumQuickstart:Quick start}

        {mansection ST stsumRemarksandexamples:Remarks and examples}

        {mansection ST stsumMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by(varlist)} requests separate summaries for each group along with an
overall total.  Observations are in the same group if they have equal values
of the variables in {it:varlist}.  {it:varlist} may contain any number of
string or numeric variables.

{phang}
{opt noshow} prevents {cmd:stsum} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.


{marker examples}{...}
{title:Examples using single-failure data}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse page2}

{pstd}Summarize single-record survival data{p_end}
{phang2}{cmd:. stsum}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Summarize multiple-record survival data{p_end}
{phang2}{cmd:. stsum}

{pstd}Summarize multiple-record survival data for different categories of
{cmd:posttran}{p_end}
{phang2}{cmd:. stsum, by(posttran)}

{pstd}Report whether values of {cmd:posttran} within subject vary over
time{p_end}
{phang2}{cmd:. stvary posttran}{p_end}
    {hline}


{title:Example using multiple-failure data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfail2}

{pstd}Show st settings{p_end}
{phang2}{cmd:. st}

{pstd}Create {cmd:nf} containing the cumulative number of failures for each
subject as of the entry time for the observation{p_end}
{phang2}{cmd:. stgen nf = nfailures()}

{pstd}Summarize data by categories of {cmd:nf}{p_end}
{phang2}{cmd:. stsum, by(nf)}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=zw8UvYdI8y8":How to describe and summarize survival data}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stsum} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p25)}}25th percentile{p_end}
{synopt:{cmd:r(p50)}}50th percentile{p_end}
{synopt:{cmd:r(p75)}}75th percentile{p_end}
{synopt:{cmd:r(risk)}}time at risk{p_end}
{synopt:{cmd:r(ir)}}incidence rate{p_end}
{synopt:{cmd:r(N_sub)}}number of subjects{p_end}
{p2colreset}{...}
