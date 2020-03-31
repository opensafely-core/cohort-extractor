{smcl}
{* *! version 1.2.3  19oct2017}{...}
{viewerdialog "irf cgraph" "dialog irf_cgraph"}{...}
{vieweralsosee "[TS] irf cgraph" "mansection TS irfcgraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "irf_cgraph##syntax"}{...}
{viewerjumpto "Menu" "irf_cgraph##menu"}{...}
{viewerjumpto "Description" "irf_cgraph##description"}{...}
{viewerjumpto "Links to PDF documentation" "irf_cgraph##linkspdf"}{...}
{viewerjumpto "Options" "irf_cgraph##options"}{...}
{viewerjumpto "Examples" "irf_cgraph##examples"}{...}
{viewerjumpto "Stored results" "irf_cgraph##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[TS] irf cgraph} {hline 2}}Combined graphs of IRFs, 
dynamic-multiplier functions, and FEVDs{p_end}
{p2col:}({mansection TS irfcgraph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irf}
{opt cg:raph}
{opt (spec_1)}
[{opt (spec_2)}
...
[{cmd:(}{it:spec_N}{cmd:)}]]
[{cmd:,}
{it:{help irf_cgraph##options_table:options}}]


{pstd}
where {cmd:(}{it:spec_k}{cmd:)} is

{p 8 12 2}
{cmd:(}{it:irfname}
{it:impulsevar}
{it:responsevar}
{it:{help irf_cgraph##stat:stat}}
[{cmd:,}
{it:{help irf_cgraph##spec_options:spec_options}}]{cmd:)}

{pstd}
{it:irfname} is the name of a set of IRF results in the active IRF file.
{it:impulsevar} should be specified as an endogenous variable for all
statistics except {cmd:dm} and {cmd:cdm}; for those, specify as an exogenous
variable.
{it:responsevar} is an endogenous variable name. 
{it:stat} is one or more statistics from the list below:

{marker stat}{...}
INCLUDE help _irf_stats
INCLUDE help _irf_stats_notes

{marker options_table}{...}
{synoptset 27 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opth set(filename)}}make {it:filename} active{p_end}

{syntab:Options}
{synopt:{it:{help irf_cgraph##combine_options:combine_options}}}affect 
	appearance of combined graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
documented in {manhelpi twoway_options G-3} {p_end}

{p2coldent:* {it:{help irf_cgraph##spec_options:spec_options}}}level, steps, and
	rendition of plots and their CIs{p_end}

{synopt :{opt in:dividual}}graph each combination individually{p_end}
{synoptline}
{p 4 6 2}* {it:spec_options} appear on multiple
	tabs in the dialog box.{p_end}
{p 4 6 2}{opt individual} does not appear in the dialog box.{p_end}

{marker spec_options}{...}
{synopthdr:spec_options}
{synoptline}
{syntab:Main}
{synopt:{opt noci}}suppress confidence bands{p_end}

{syntab:Options}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt lst:ep(#)}}use {it:#} for first step{p_end}
{synopt:{opt ust:ep(#)}}use {it:#} for maximum step{p_end}

{syntab:Plots}
{synopt:{cmdab:plot:}{it:{ul:#}}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect rendition of the line plotting
	the # {it:stat}{p_end}

{syntab:CI plots}
{synopt:{cmdab:ci:}{it:{ul:#}}{cmd:opts(}{it:{help area_options}}{cmd:)}}affect
        rendition of the 
	confidence interval for the {it:#} {it:stat}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:spec_options} may be specified within a graph specification, globally,
or in both.  When specified in a graph specification, the {it:spec_options}
affect only the specification in which they are used.  When supplied globally,
the {it:spec_options} affect all graph specifications.  When supplied in
both places, options in the graph specification take precedence.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > IRF and FEVD analysis > Combined graphs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:irf cgraph} makes a graph or a combined graph of IRF results.  A
graph is drawn for specified combinations of named IRF results,
impulse variables, response variables, and statistics.  {cmd:irf cgraph}
combines these graphs into one image, unless separate graphs are requested.

{pstd}
{cmd:irf cgraph} operates on the active IRF file; see
{manhelp irf_set TS:irf set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS irfcgraphQuickstart:Quick start}

        {mansection TS irfcgraphRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt noci} suppresses graphing the confidence interval for each statistic.
    {opt noci} is assumed when the model was fit by {opt vec}
    because no confidence intervals were estimated.

{phang}
{opth set(filename)} specifies the file to be made active;
   see {manhelp irf_set TS: irf set}.  If {opt set()} is not specified, the
   active file is used.

{dlgtab:Options}

{phang}
{opt level(#)} specifies the default confidence level, as a
    percentage, for confidence intervals, when they are reported. The
    default is {cmd:level(95)} or as set by {helpb set level}.
    The value set of an overall {opt level()} can be
    overridden by the {opt level()} inside a {opt (spec_k)}.

{phang}
{opt lstep(#)} specifies the first step, or period, to be included
    in the graph.  {cmd:lstep(0)} is the default.

{phang}
{opt ustep(#)}, {it:#} {ul:>} 1, specifies the maximum step, or
    period, to be included in the graph.

{phang}
{marker combine_options}{...}
{it:combine_options} affect the appearance of the combined graph;
   see {helpb graph combine:[G-2] graph combine}.

{dlgtab:Plots}

{phang}
{opt plot1opts(cline_options)}, ..., {opt plot4opts(cline_options)}
   affect the rendition of the plotted statistics.  {cmd:plot1opts()} affects
   the rendition of the first statistic; {cmd:plot2opts()}, the second; and so
   on.  See {manhelpi cline_options G-3}.

{dlgtab:CI plots}

{phang}
{opt ci1opts(area_options)} and {opt ci2opts(area_options)} affect the
   rendition of the confidence intervals for the first ({cmd:ci1opts()}) and
   second ({cmd:ci2opts()}) statistics.  See {manhelp irf_graph TS:irf graph}
   for a description of this option and {manhelpi area_options G-3} for the
   suboptions that change the look of the CI.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
    {manhelpi twoway_options G-3}, excluding {opt by()}.  These include options
    for titling the graph (see {manhelpi title_options G-3}) and for
    saving the graph to disk (see {manhelpi saving_option G-3}).

{pstd}
The following option is available with {opt irf cgraph} but is not shown in
the dialog box:

{phang}
{opt individual} specifies that each graph be displayed individually.  By
   default, {opt irf cgraph} combines the subgraphs into one image.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. matrix a = (., 0, 0\0,.,0\.,.,.)}{p_end}
{phang2}{cmd:. matrix b = I(3)}{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump, aeq(a) beq(b)}{p_end}
{phang2}{cmd:. irf create modela, set(results3) step(8)}{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump, aeq(a) beq(b)}{p_end}
{phang2}{cmd:. irf create modelb, step(8)}{p_end}

{pstd}Graph orthogonalized and structural impulse-response functions for
         {cmd:modela} and {cmd:modelb}{p_end}
{phang2}{cmd:. irf cgraph (modela dln_inv dln_consump oirf sirf)}
         {cmd:(modelb dln_inc dln_consump oirf sirf)}{p_end}

{pstd}Same as above, but show {cmd:modela} and {cmd:modelb} as individual
         graphs{p_end}
{phang2}{cmd:. irf cgraph (modela dln_inv dln_consump oirf sirf)}
         {cmd:(modelb dln_inc dln_consump oirf sirf), individual}{p_end}

{pstd}Graph Cholesky and structural FEVDs for {cmd:modela} and {cmd:modelb},
   using 1 for first step{p_end}
{phang2}{cmd:. irf cgraph (modela dln_inv dln_consump fevd sfevd, lstep(1))}
         {cmd:(modelb dln_inc dln_consump fevd sfevd, lstep(1))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irf cgraph} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of specific graph commands{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(individual)}}{cmd:individual}, if specified{p_end}
{synopt:{cmd:r(save)}}{it:filename}{cmd:, replace} from {cmd:saving()} option
for combined graph{p_end}
{synopt:{cmd:r(name)}}{it:name}{cmd:, replace} from {cmd:name()} option for
combined graph{p_end}
{synopt:{cmd:r(title)}}title of the combined graph{p_end}
{synopt:{cmd:r(save}{it:#}{cmd:)}}{it:filename}{cmd:, replace} from
{cmd:saving()} option for individual graphs{p_end}
{synopt:{cmd:r(name}{it:#}{cmd:)}}{it:name}{cmd:, replace} from {cmd:name()}
option for individual graphs{p_end}
{synopt:{cmd:r(title}{it:#}{cmd:)}}title for the {it:#}th graph{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}level applied to the {it:#}th confidence
interval or {cmd:noci}{p_end}
{synopt:{cmd:r(response}{it:#}{cmd:)}}response specified in the {it:#}th
command{p_end}
{synopt:{cmd:r(impulse}{it:#}{cmd:)}}impulse specified in the {it:#}th
command{p_end}
{synopt:{cmd:r(irfname}{it:#}{cmd:)}}IRF name specified in the {it:#}th
command{p_end}
{synopt:{cmd:r(stats}{it:#}{cmd:)}}statistics specified in the {it:#}th
command{p_end}
{p2colreset}{...}
