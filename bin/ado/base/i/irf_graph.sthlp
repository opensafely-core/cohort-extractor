{smcl}
{* *! version 1.1.17  12feb2019}{...}
{viewerdialog "irf graph" "dialog irf_graph"}{...}
{vieweralsosee "[TS] irf graph" "mansection TS irfgraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_graph##syntax"}{...}
{viewerjumpto "Menu" "irf_graph##menu"}{...}
{viewerjumpto "Description" "irf_graph##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_graph##linkspdf"}{...}
{viewerjumpto "Options" "irf_graph##options"}{...}
{viewerjumpto "Examples" "irf_graph##examples"}{...}
{viewerjumpto "Stored results" "irf_graph##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] irf graph} {hline 2}}Graphs of IRFs, dynamic-multiplier
functions, and FEVDs{p_end}
{p2col:}({mansection TS irfgraph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irf} {opt g:raph} {it:{help irf_graph##stat:stat}}
[{cmd:,}
{it:{help irf_graph##options_table:options}}]

{marker stat}{...}
INCLUDE help _irf_stats
INCLUDE help _irf_stats_notes

{marker options_table}{...}
{synoptset 34 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth set(filename)}}make {it:filename} active{p_end}
{synopt:{cmdab:ir:f(}{it:irfnames}{cmd:)}}use {it:irfnames} IRF result sets{p_end}
{synopt:{opt i:mpulse(impulsevar)}}use {it:impulsevar} as impulse variables{p_end}
{synopt:{cmdab:r:esponse:(}{it:endogvars}{cmd:)}}use endogenous variables as response
variables{p_end}
{synopt:{opt noci}}suppress confidence bands{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt lst:ep(#)}}use {it:#} for first step{p_end}
{synopt:{opt ust:ep(#)}}use {it:#} for maximum step{p_end}

{syntab:Advanced}
{synopt:{opt in:dividual}}graph each combination individually{p_end}
{synopt:{cmd:iname(}{it:namestub} [{cmd:,} {opt replace}]{cmd:)}}stub
for naming the individual graphs{p_end}
{synopt:{cmdab:isa:ving(}{it:{help filename:filename}stub} [{cmd:,} {opt replace}]{cmd:)}}stub
for saving the individual graphs to files{p_end}

{syntab:Plots}
{synopt:{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect
        rendition of the line plotting the {it:#} {it:stat}{p_end}

{syntab:CI plots}
{synopt:{cmdab:ci:}{ul:{it:#}}{cmd:opts(}{it:{help area_options}}{cmd:)}}affect rendition
        of the confidence interval for the {it:#} {it:stat}{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in
{manhelpi twoway_options G-3}{p_end}
{synopt:{opth byop:ts(by_option)}}how subgraphs are combined, labeled,
etc. {p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > IRF and FEVD analysis >}
    {bf:Graphs by impulse or response}


{marker description}{...}
{title:Description}

{pstd}
{opt irf graph} graphs impulse-response functions (IRFs), dynamic-multiplier
functions, and forecast-error variance decompositions (FEVDs) over time.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfgraphQuickstart:Quick start}

        {mansection TS irfgraphRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

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
{opt impulse(impulsevars)} and 
    {cmd:response(}{it:endogvars}{cmd:)} specify the impulse and
    response variables.  Usually one of each is specified, and one graph is
    drawn.  If multiple variables are specified, a separate subgraph is drawn
    for each impulse-response combination.  If {opt impulse()} and
    {opt response()} are not specified, subgraphs are drawn for all
    combinations of impulse and response variables.

{pmore}
    {it:impulsevar} should be specified as an endogenous variable for all
    statistics except {cmd:dm} or {cmd:cdm}; for those, specify as an
    exogenous variable.

{phang}
{opt noci} suppresses graphing the confidence interval for each statistic.
    {opt noci} is assumed when the model was fit by {cmd:vec}
    because no confidence intervals were estimated.

{phang}
{opt level(#)} specifies the default confidence level, as a
    percentage, for confidence intervals, when they are reported.  The default
    is {cmd:level(95)} or as set by {helpb set level}.
    Also see {manhelp irf_cgraph TS:irf cgraph} for a graph command that
    allows the confidence level to vary over the graphs.

{phang}
{opt lstep(#)} specifies the first step, or period, to be included in the
    graphs.  {cmd:lstep(0)} is the default.

{phang}
{opt ustep(#)}, {it:#} {ul:>} 1, specifies the maximum step, or
    period, to be included in the graphs.

{dlgtab:Advanced}

{phang}
{opt individual} specifies that each graph be displayed individually.  By
    default, {opt irf graph} combines the subgraphs into one image.
    When {opt individual} is specified, {opt byopts()} may not be specified, 
    but the {opt isaving()} and {opt iname()} options may be specified.

{phang}
{cmd:iname(}{it:namestub} [{opt , replace}]{cmd:)} specifies that
    the ith individual graph be stored in memory under the name 
    {it:namestub}{it:i}, which must be a valid Stata name of 24
    characters or fewer.  {opt iname()} may be specified only with the
    {opt individual} option.

{phang}
{cmd:isaving(}{it:{help filename:filename}stub} [{cmd:, replace}]{cmd:)}
    specifies
    that the ith individual graph should be saved to disk in the current
    working directory under the name {it:filenamestub}{it:i}{cmd:.gph}.
    {opt isaving()} may be specified only when the {opt individual} option is
    also specified.

{dlgtab:Plots}

{phang}
{opt plot1opts(cline_options)}, ..., {opt plot4opts(cline_options)}
    affect the rendition of the plotted statistics (the {it:stat}).
    {opt plot1opts()} affects the rendition of the first statistic; 
    {opt plot2opts()}, the second; and so on.  {it:cline_options} are as
    described in {manhelpi cline_options G-3}.

{dlgtab:CI plots}

{phang}
{opt ci1opts(area_options)} and {opt ci2opts(area_options)} affect the
    affect the rendition of the
    confidence intervals for the first ({opt ci1opts()}) and second
    ({opt ci2opts()}) statistics in {it:stat}.  {it:area_options} are as
    described in {manhelpi area_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
    {manhelpi twoway_options G-3}, excluding {opt by()}.  These include options
    for titling the graph (see {manhelpi title_options G-3}) and for
    saving the graph to disk (see {manhelpi saving_option G-3}).  The
    {opt saving()} and {opt name()} options may not be combined with the
    {opt individual} option.

{phang}
{opt byopts(by_option)} is as documented in
{manhelpi by_option G-3} and may not be specified when {opt individual} is
specified.  {opt byopts()} affects how the subgraphs are combined,
labeled, etc.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}

{pstd}Fit vector error-correction model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
              {cmd:lags(1/2) dfk}{p_end}

{pstd}Estimate IRFs and FEVDs and save under {cmd:order1} in
{cmd:myirf1}{p_end}
{phang2}{cmd:. irf create order1, step(10) set(myirf1, replace)}{p_end}

{pstd}Graph the orthogonalized impulse-response function, using 
{cmd:dln_inc} as the impulse variable and {cmd:dln_consump} as the response
variable{p_end}
{phang2}{cmd:. irf graph oirf, impulse(dln_inc) response(dln_consump)}

{pstd}Same as above, but use 1 for the first step{p_end}
{phang2}{cmd:. irf graph oirf, impulse(dln_inc) response(dln_consump)}
             {cmd:lstep(1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf graph} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of graphs{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(stats)}}{it:statlist}{p_end}
{synopt:{cmd:r(irfname)}}{it:resultslist}{p_end}
{synopt:{cmd:r(impulse)}}{it:impulselist}{p_end}
{synopt:{cmd:r(response)}}{it:responselist}{p_end}
{synopt:{cmd:r(plot}{it:#}{cmd:)}}contents of {cmd:plot}{it:#}{cmd:opts()}{p_end}
{synopt:{cmd:r(ci)}}level applied to confidence intervals or {cmd:noci}{p_end}
{synopt:{cmd:r(ciopts}{it:#}{cmd:)}}contents of {cmd:ci}{it:#}{cmd:opts()}
{p_end}
{synopt:{cmd:r(byopts)}}contents of {cmd:byopts()}{p_end}
{synopt:{cmd:r(saving)}}supplied {cmd:saving()} option{p_end}
{synopt:{cmd:r(name)}}supplied {cmd:name()} option{p_end}
{synopt:{cmd:r(individual)}}{cmd:individual} or blank{p_end}
{synopt:{cmd:r(isaving)}}contents of {cmd:isaving()}{p_end}
{synopt:{cmd:r(iname)}}contents of {cmd:name()}{p_end}
{synopt:{cmd:r(subtitle}{it:#}{cmd:)}}subtitle for individual graph {it:#}{p_end}
{p2colreset}{...}
