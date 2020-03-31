{smcl}
{* *! version 1.2.4  14may2018}{...}
{viewerdialog summarize "dialog summarize"}{...}
{vieweralsosee "[R] summarize" "mansection R summarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ameans" "help ameans"}{...}
{vieweralsosee "[R] centile" "help centile"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] inspect" "help inspect"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "[R] ratio" "help ratio"}{...}
{vieweralsosee "[ST] stsum" "help stsum"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabstat" "help tabstat"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{vieweralsosee "[R] total" "help total"}{...}
{vieweralsosee "[XT] xtsum" "help xtsum"}{...}
{viewerjumpto "Syntax" "summarize##syntax"}{...}
{viewerjumpto "Menu" "summarize##menu"}{...}
{viewerjumpto "Description" "summarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "summarize##linkspdf"}{...}
{viewerjumpto "Options" "summarize##options"}{...}
{viewerjumpto "Examples" "summarize##examples"}{...}
{viewerjumpto "Video example" "summarize##video"}{...}
{viewerjumpto "Stored results" "summarize##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] summarize} {hline 2}}Summary statistics{p_end}
{p2col:}({mansection R summarize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmdab:su:mmarize} [{varlist}]
{ifin}
[{it:{help summarize##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt d:etail}}display additional statistics{p_end}
{synopt:{opt mean:only}}suppress the display; calculate only the mean; programmer's option{p_end}
{synopt:{opt f:ormat}}use variable's display format{p_end}
{synopt:{opt sep:arator(#)}}draw separator line after every {it:#} variables; default is
{cmd:separator(5)}{p_end}
{synopt :{it:{help summarize##display_options:display_options}}}control
           spacing, line width, and base and empty cells{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}
  {it:varlist} may contain factor variables; see {help fvvarlist}.
  {p_end}
{p 4 6 2}
  {it:varlist} may contain time-series operators; see {help tsvarlist}.
  {p_end}
{p 4 6 2}
  {opt by}, {opt rolling}, and {opt statsby} are allowed; see {help prefix}.
  {p_end}
  {marker weight}{...}
{p 4 6 2}
  {opt aweight}s, {opt fweight}s, and {opt iweight}s are allowed.  However,
  {opt iweight}s may not be used with the {opt detail} option;
  see {help weight}.
  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Summary and descriptive statistics > Summary statistics}


{marker description}{...}
{title:Description}

{pstd}
{opt summarize} calculates and displays a variety of univariate summary
statistics.  If no {it:{help varlist}} is specified, summary statistics are
calculated for all the variables in the dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R summarizeQuickstart:Quick start}

        {mansection R summarizeRemarksandexamples:Remarks and examples}

        {mansection R summarizeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt detail} produces additional statistics, including skewness,
kurtosis, the four smallest and four largest values, and various
percentiles.

{phang}
{opt meanonly}, which is allowed only when {opt detail} is not specified,
suppresses the display of results and calculation of the variance.  Ado-file
writers will find this useful for fast calls.

{phang}
{opt format} requests that the summary statistics be displayed using
the display formats associated with the variables rather than the default
{opt g} display format; see {manhelp format D}.

{phang}
{opt separator(#)} specifies how often to insert separation lines
into the output.  The default is {cmd:separator(5)}, meaning that a
line is drawn after every five variables.  {cmd:separator(10)} would draw a
line after every 10 variables.  {cmd:separator(0)} suppresses the separation
line.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)}, and
{opt fvwrapon(style)};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. summarize}{p_end}
{phang}{cmd:. summarize mpg weight}{p_end}
{phang}{cmd:. summarize mpg weight if foreign}{p_end}
{phang}{cmd:. summarize mpg weight if foreign, detail}{p_end}
{phang}{cmd:. summarize i.rep78}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=kKFbnEWwa2s":Descriptive statistics in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:summarize} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(mean)}}mean{p_end}
{synopt:{cmd:r(skewness)}}skewness ({cmd:detail} only){p_end}
{synopt:{cmd:r(min)}}minimum{p_end}
{synopt:{cmd:r(max)}}maximum{p_end}
{synopt:{cmd:r(sum_w)}}sum of the weights{p_end}
{synopt:{cmd:r(p1)}}1st percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p5)}}5th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p10)}}10th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p25)}}25th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p50)}}50th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p75)}}75th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p90)}}90th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p95)}}95th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(p99)}}99th percentile ({cmd:detail} only){p_end}
{synopt:{cmd:r(Var)}}variance{p_end}
{synopt:{cmd:r(kurtosis)}}kurtosis ({cmd:detail} only){p_end}
{synopt:{cmd:r(sum)}}sum of variable{p_end}
{synopt:{cmd:r(sd)}}standard deviation{p_end}
{p2colreset}{...}
