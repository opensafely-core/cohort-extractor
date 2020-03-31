{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog tsfill "dialog tsfill"}{...}
{vieweralsosee "[TS] tsfill" "mansection TS tsfill"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsappend" "help tsappend"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "tsfill##syntax"}{...}
{viewerjumpto "Menu" "tsfill##menu"}{...}
{viewerjumpto "Description" "tsfill##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsfill##linkspdf"}{...}
{viewerjumpto "Option" "tsfill##option"}{...}
{viewerjumpto "Examples" "tsfill##examples"}{...}
{viewerjumpto "Video example" "tsfill##video"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[TS] tsfill} {hline 2}}Fill in gaps in time variable{p_end}
{p2col:}({mansection TS tsfill:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:tsfill} [{cmd:,} {opt f:ull}]

{phang}
You must {cmd:tsset} or {cmd:xtset} your data before using {cmd:tsfill}; see
{helpb tsset:[TS] tsset} and {helpb xtset:[XT] xtset}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Setup and utilities >}
   {bf:Fill in gaps in time variable}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsfill} is used to fill in gaps in time-series data and gaps in panel
data with new observations, which contain missing values.  {cmd:tsfill} is not
needed to obtain correct lags, leads, and differences when gaps exist in a
series because Stata's time-series operators handle gaps automatically.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tsfillQuickstart:Quick start}

        {mansection TS tsfillRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:full} is for use with panel data only.  With panel data, {cmd:tsfill} by
default fills in observations for each panel according to the minimum and
maximum values of {it:timevar} for the panel.  Thus if the first panel
spanned the times 5-20 and the second panel the times 1-15, after {cmd:tsfill}
they would still span the same periods; observations would be created to
fill in any missing times from 5-20 in the first panel and from 1-15 in the
second.

{pmore}
If {cmd:full} is specified, observations are created so that both panels span
the time 1-20, the overall minimum and maximum of {it:timevar} across panels.


{marker examples}{...}
{title:Examples}

{pstd}Using {cmd:tsfill} with time-series data{p_end}
{phang2}{cmd:. webuse tsfillxmpl}{p_end}
{phang2}{cmd:. list mdate income}{p_end}
{phang2}{cmd:. tsfill}{p_end}
{phang2}{cmd:. list mdate income}

{pstd}Using {cmd:tsfill} with panel data{p_end}
{phang2}{cmd:. webuse tsfillxmpl2, clear}{p_end}
{phang2}{cmd:. list edlevel year income}{p_end}
{phang2}{cmd:. tsfill}{p_end}
{phang2}{cmd:. list edlevel year income}{p_end}
{phang2}{cmd:. tsfill, full}{p_end}
{phang2}{cmd:. list edlevel year income}{p_end}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=SOQvXICIRNY":Formatting and managing dates}
{p_end}
