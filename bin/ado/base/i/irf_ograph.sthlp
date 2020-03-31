{smcl}
{* *! version 1.1.13  19oct2017}{...}
{viewerdialog "irf ograph" "dialog irf_ograph"}{...}
{vieweralsosee "[TS] irf ograph" "mansection TS irfograph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_ograph##syntax"}{...}
{viewerjumpto "Menu" "irf_ograph##menu"}{...}
{viewerjumpto "Description" "irf_ograph##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_ograph##linkspdf"}{...}
{viewerjumpto "Options" "irf_ograph##options"}{...}
{viewerjumpto "Examples" "irf_ograph##examples"}{...}
{viewerjumpto "Stored results" "irf_ograph##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[TS] irf ograph} {hline 2}}Overlaid graphs of IRFs,
dynamic-multiplier functions, and FEVDs{p_end}
{p2col:}({mansection TS irfograph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
{cmd:irf} {opt og:raph}
{opt (spec_1)}
[{opt (spec_2)}
... [{opt (spec_15)}]]
[{cmd:,}
{it:{help irf_ograph##options_tbl:options}}]

{pstd}
where {opt (spec_k)} is

{p 8 12 2}
{cmd:(}{it:irfname} {it:impulsevar} {it:responsevar}
	{it:{help irf_ograph##stat:stat}}
	[{cmd:,}
	{it:{help irf_ograph##spec_options:spec_options}}]{cmd:)}

{pstd}
{it:irfname} is the name of a set of IRF results in the active IRF file
or "{cmd:.}", which means the first named result in the active IRF file.
{it:impulsevar} should be specified as an endogenous variable for all
statistics except {cmd:dm} and {cmd:cdm}; for those, specify as an exogenous
variable.
{it:responsevar} is an endogenous variable name. 
{it:stat} is one or more statistics from the list below:

{marker stat}{...}
INCLUDE help _irf_stats

{marker options_tbl}{...}
{synoptset 24 tabbed}
{synopthdr:options}
{synoptline}
{syntab:Plots}
{synopt:{it:{help irf_ograph##plot_options:plot_options}}}define the IRF plots{p_end}
{synopt:{opth set(filename)}}make {it:filename} active{p_end}

{syntab:Options}
{synopt:{it:{help irf_ograph##common_options:common_options}}}level and
          steps{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}

{marker plot_options}{...}
{synopthdr:plot_options}
{synoptline}
{syntab:Main}
{synopt:{opth set(filename)}}make {it:filename} active{p_end}
{synopt:{cmdab:ir:f(}{it:irfnames}{cmd:)}}use {it:irfnames} IRF result sets{p_end}
{synopt:{opt i:mpulse(impulsevar)}}use {it:impulsevar} as impulse variables{p_end}
{synopt:{cmdab:r:esponse:(}{it:endogvars}{cmd:)}}use endogenous variables as
         response variables{p_end}
{synopt:{opt ci}}add confidence bands to the graph{p_end}
{synoptline}

{marker spec_options}{...}
{synopthdr:spec_options}
{synoptline}
{syntab:Options}
{synopt:{it:{help irf_ograph##common_options:common_options}}}level and
          steps{p_end}

{syntab:Plot}
{synopt:{it:{help cline_options}}}affect rendition of the plotted lines{p_end}

{syntab:CI plot}
{synopt:{opth ciop:ts(area_options)}}affect rendition of the confidence 
	intervals{p_end}
{synoptline}

{marker common_options}{...}
{synopthdr:common_options}
{synoptline}
{syntab:Options}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt lst:ep(#)}}use {it:#} for first step{p_end}
{synopt:{opt ust:ep(#)}}use {it:#} for maximum step{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:common_options} may be specified within a plot specification, globally, or
in both.  When specified in a plot specification, the {it:common_options}
affect only the specification in which they are used.  When supplied globally,
the {it:common_options} affect all plot specifications.  When supplied in both
places, options in the plot specification take precedence.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > IRF and FEVD analysis >}
    {bf:Overlaid graph}


{marker description}{...}
{title:Description}

{pstd}
{opt irf ograph} displays plots of {opt irf} results on one graph (one pair of
axes).

{pstd}
To become familiar with this command, type {bf:{stata db irf ograph}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfographQuickstart:Quick start}

        {mansection TS irfographRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Plots}

{phang}
{it:plot_options} defines the IRF plots and are found under the
   {bf:Main}, {bf:Plot}, and {bf:CI plot} tabs.

{phang}
{opth set(filename)} specifies the file to be made active; see
   {manhelp irf_set TS:irf set}.  If {opt set()} is not specified, the active
   file is used.

{dlgtab:Main}

{phang}
{opth set(filename)} specifies the file to be made active; see
   {manhelp irf_set TS:irf set}.  If {opt set()} is not specified, the active
   file is used.

{phang}
{cmd:irf(}{it:irfnames}{cmd:)} specifies the IRF result sets
    to be used.  If {opt irf()} is not specified, each of the results
    in the active IRF file is used.  (Files often contain
    just one set of IRF results saved under one 
    {it:irfname}; in that case, those results are used.)

{phang}
{cmd:impulse(}{varlist}{cmd:)} and 
    {cmd:response(}{it:endogvars}{cmd:)} specify the impulse and
    response variables.  Usually one of each is specified, and one graph is
    drawn.  If multiple variables are specified, a separate subgraph is drawn
    for each impulse-response combination.  If {opt impulse()} and
    {opt response()} are not specified, subgraphs are drawn for all
    combinations of impulse and response variables.

{phang}
    {opt ci} adds confidence bands to the graph.  The {opt noci} option may be
    used within a plot specification to suppress its confidence bands when the
    {opt ci} option is supplied globally.  

{dlgtab:Plot}

{phang}
{it:cline_options} affect the rendition of the plotted lines; see
    {manhelpi cline_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(area_options)} affects the
    rendition of the confidence bands for the plotted statistic; see
    {manhelpi area_options G-3}.  {cmd:ciopts()} implies {cmd:ci}.

{dlgtab:Options}

{phang}
    {opt level(#)} specifies the confidence level, as a
    percentage, for confidence bands; see {manhelp level R}.

{phang}
    {opt lstep(#)} specifies the first step, or period, to be
    included in the graph.  {cmd:lstep(0)} is the default.

{phang}
    {opt ustep(#)}, {it:#} {ul:>} 1, specifies the maximum step, or
    period, to be included.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
    {manhelpi twoway_options G-3}, excluding {opt by()}.  These include options
    for titling the graph (see {manhelpi title_options G-3}) and for
    saving the graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
               {cmd:lags(1/2) dfk}{p_end}
{phang2}{cmd:. irf create order1, step(10) set(myirf1, replace)}{p_end}
{phang2}{cmd:. irf create order2, step(10) order(dln_inc dln_inv dln_consump)}

{pstd}Graph the orthogonalized impulse-response functions for two different
Cholesky orderings{p_end}
{phang2}{cmd:. irf ograph (order1 dln_inc dln_consump oirf)}
             {cmd:(order2 dln_inc dln_consump oirf)}{p_end}

{pstd}Same as above, but add a title{p_end}
{phang2}{cmd:. irf ograph (order1 dln_inc dln_consump oirf)}
       {cmd:(order2 dln_inc dln_consump oirf),}
       {cmd:title("Comparison of Orthogonalized Impulse-Response Functions")}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf ograph} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(plots)}}number of plot specifications{p_end}
{synopt:{cmd:r(ciplots)}}number of plotted confidence bands{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(irfname}{it:#}{cmd:)}}{it:irfname} from
      {cmd:(}{it:spec#}{cmd:)}{p_end}
{synopt:{cmd:r(impulse}{it:#}{cmd:)}}impulse from
      {cmd:(}{it:spec#}{cmd:)}{p_end}
{synopt:{cmd:r(response}{it:#}{cmd:)}}response from
      {cmd:(}{it:spec#}{cmd:)}{p_end}
{synopt:{cmd:r(stat}{it:#}{cmd:)}}statistics from
      {cmd:(}{it:spec#}{cmd:)}{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}level from
      {cmd:(}{it:spec#}{cmd:)} or {cmd:noci}{p_end}
{p2colreset}{...}
