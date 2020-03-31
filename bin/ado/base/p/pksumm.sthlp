{smcl}
{* *! version 1.1.8  11may2019}{...}
{viewerdialog pksumm "dialog pksumm"}{...}
{vieweralsosee "[R] pksumm" "mansection R pksumm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pk" "help pk"}{...}
{viewerjumpto "Syntax" "pksumm##syntax"}{...}
{viewerjumpto "Menu" "pksumm##menu"}{...}
{viewerjumpto "Description" "pksumm##description"}{...}
{viewerjumpto "Links to PDF documentation" "pksumm##linkspdf"}{...}
{viewerjumpto "Options" "pksumm##options"}{...}
{viewerjumpto "Remarks" "pksumm##remarks"}{...}
{viewerjumpto "Examples" "pksumm##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] pksumm} {hline 2}}Summarize pharmacokinetic data{p_end}
{p2col:}({mansection R pksumm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:pksumm} {it:id time concentration} {ifin} [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt t:rapezoid}}use trapezoidal rule to calculate AUC_0,tmax; default is cubic splines{p_end}
{synopt :{opt fit(#)}}use {it:#} points to estimate AUC_0,inf; default is
{cmd:fit(3)}{p_end}
{synopt :{opt notime:chk}}do not check whether follow-up time for all subjects
is the same{p_end}
{synopt :{opt nod:ots}}suppress the dots during calculation{p_end}
{synopt :{opt g:raph}}graph the distribution of {it:statistic}{p_end}
{synopt :{opt stat(statistic)}}graph the specified statistic; default is
{cmd:stat(auc)}{p_end}

{syntab :Histogram, Density plots, Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:histogram_options}}any option other than {cmd:by()} documented in
{manhelp histogram R}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 20}{...}
{marker statistic}
{synopthdr :statistic}
{synoptline}
{synopt :{opt auc}}area under the concentration-time curve (AUC_0,tmax); the default{p_end}
{synopt :{opt aucline}}AUC_0,inf using a linear extension{p_end}
{synopt :{opt aucexp}}AUC_0,inf using an exponential extension{p_end}
{synopt :{opt auclog}}area under the concentration-time curve from 0 to infinity extended with a linear fit to log concentration{p_end}
{synopt :{opt half}}half-life of the drug{p_end}
{synopt :{opt ke}}elimination rate{p_end}
{synopt :{opt cmax}}maximum concentration{p_end}
{synopt :{opt tmax}}time at last concentration{p_end}
{synopt :{opt tomc}}time of maximum concentration{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Other >}
    {bf:Summarize pharmacokinetic data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pksumm} obtains summary measures based on the first four moments from the
empirical distribution of each pharmacokinetic measurement and tests the null
hypothesis that the distribution of that measurement is normally distributed.

{pstd}
{cmd:pksumm} is one of the pk commands.  Please read {helpb pk} before reading
this entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pksummQuickstart:Quick start}

        {mansection R pksummRemarksandexamples:Remarks and examples}

        {mansection R pksummMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt trapezoid} specifies that the trapezoidal rule be used to calculate the
AUC_0,tmax.  The default is cubic splines, which give better results for most
situations.  When the curve is irregular, the trapezoidal rule may give better
results.

{phang}
{opt fit(#)} specifies the number of points, counting back from the last time
measurement, to use in fitting the extension to estimate the AUC_0,inf.  The
default is {cmd:fit(3)}, the last three points.  This default should be viewed
as a minimum; the appropriate number of points will depend on the data.

{phang}
{opt notimechk} suppresses the check that the follow-up time for all subjects
is the same.  By default, {cmd:pksumm} expects the maximum follow-up time to
be equal for all subjects.

{phang}
{opt nodots} suppresses the progress dots during calculation.  By default, a
dot (a period) is displayed for every call to calculate the pharmacokinetic
measures.

{phang}
{opt graph} requests a graph of the distribution of the statistic specified
with {opt stat()}.

{phang}
{opth stat:(pksumm##statistic:statistic)} specifies the statistic that
{cmd:pksumm} should graph.  The default is {cmd:stat(auc)}.  If the
{cmd:graph} option is not also specified, then this option is ignored.

{dlgtab:Histogram, Density plots, Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:histogram_options} are any of the options documented in 
{manhelp histogram R}, excluding {cmd:by()}.  For {cmd:pksumm},
{cmd:fraction} is the default, not {cmd:density}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:pksumm} produces summary statistics for the distribution of nine
common pharmacokinetic measurements.  If there are more than eight subjects,
{cmd:pksumm} also computes a test for normality on each measurement.
The nine measurements summarized by {cmd:pksumm} are listed 
{help pksumm##statistic:above} and are described in
{mansection R pkexamineMethodsandformulas:{it:Methods and formulas}}
of {bf:[R] pkexamine}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse pksumm}{p_end}

{phang}Summary statistics for all pharmacokinetic measures{p_end}
{phang2}{cmd:. pksumm id time conc}{p_end}

{phang}Graph the distribution of the AUC{p_end}
{phang2}{cmd:. pksumm id time conc, graph bin(20)}{p_end}

{phang}Graph the distribution of the elimination rate{p_end}
{phang2}{cmd:. pksumm id time conc, stat(ke) graph bin(20)}{p_end}
