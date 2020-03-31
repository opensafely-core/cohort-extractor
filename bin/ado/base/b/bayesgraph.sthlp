{smcl}
{* *! version 1.0.16  03apr2019}{...}
{viewerdialog bayesgraph "dialog bayesgraph"}{...}
{vieweralsosee "[BAYES] bayesgraph" "mansection BAYES bayesgraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats ess" "help bayesstats ess"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[G-2] graph matrix" "help graph matrix"}{...}
{vieweralsosee "[G-2] graph twoway kdensity" "help graph twoway kdensity"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[TS] tsline" "help tsline"}{...}
{viewerjumpto "Syntax" "bayesgraph##syntax"}{...}
{viewerjumpto "Menu" "bayesgraph##menu"}{...}
{viewerjumpto "Description" "bayesgraph##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayesgraph##linkspdf"}{...}
{viewerjumpto "Options" "bayesgraph##options"}{...}
{viewerjumpto "Remarks" "bayesgraph##remarks"}{...}
{viewerjumpto "Examples" "bayesgraph##examples"}{...}
{p2colset 1 23 23 2}{...}
{p2col:{bf:[BAYES] bayesgraph} {hline 2}}Graphical summaries and convergence diagnostics{p_end}
{p2col:}({mansection BAYES bayesgraph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax is presented under the following headings:

        {help bayesgraph##statparams:Graphical summaries for model parameters}
        {help bayesgraph##statpred:Graphical summaries for predictions}


{marker statparams}{...}
{title:Graphical summaries for model parameters}

{phang}
Graphical summaries and convergence diagnostics for single parameter

{p 8 11 2}
{opt bayesgraph} {it:{help bayesgraph##graph:graph}} {it:{help bayesgraph##scalar_param:scalar_param}} [{cmd:,} 
{it:{help bayesgraph##singleopts:singleopts}}] 


{phang}
Graphical summaries and convergence diagnostics for multiple parameters

{p 8 11 2}
{opt bayesgraph} {it:{help bayesgraph##graph:graph}} {it:{help bayesgraph##scalar_param:spec}} [{it:spec} ...] [{cmd:,} 
{it:{help bayesgraph##multiopts:multiopts}}] 

{p 8 11 2}
{opt bayesgraph matrix} {it:{help bayesgraph##scalar_param:spec}} {it:spec}
[{it:spec} ...] [{cmd:,} 
{it:{help bayesgraph##singleopts:singleopts}}] 


{phang}
Graphical summaries and convergence diagnostics for all parameters 

{p 8 11 2}
{opt bayesgraph} {it:{help bayesgraph##graph:graph}} {cmd:_all}
[{cmd:,} {it:{help bayesgraph##multiopts:multiopts}}
{opt showreffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]]


{marker scalar_param}{...}
{p 4 6 2}
{it:scalar_param} is a {help bayes_glossary##scalar_model_parameter:scalar model parameter} specified as 
{cmd:{c -(}}{cmd:param}{cmd:{c )-}} or 
{cmd:{c -(}}{cmd:eqname:param}{cmd:{c )-}} or an expression {it:exprspec} of
scalar model parameters.  Matrix model parameters are not allowed, but you may
refer to their individual elements.

{p 4 6 2}
{it:exprspec} is an optionally labeled expression of model parameters
specified in parentheses:

{p 12 15 2}
{cmd:(}[{it:exprlabel}{cmd::}]{it:expr}{cmd:)}

{p 6 6 2}
{it:exprlabel} is a valid Stata name, and {it:expr} is a scalar expression
which may not contain matrix model parameters.  See 
{it:{mansection BAYES BayesianpostestimationRemarksandexamplesSpecifyingfunctionsofmodelparameters:Specifying functions of model parameters}} in {bf:[BAYES] Bayesian postestimation} for
examples.

{p 4 6 2}
{it:spec} is either {it:scalar_param} or {it:exprspec}.


{marker statpred}{...}
{title:Graphical summaries for predictions}

{pstd}
Graphical summaries for an individual prediction

{p 8 11 2}
{cmd:bayesgraph}
{it:{help bayesgraph##graph:graph}}
{it:{help bayesgraph##predspecsc:predspecsc}}
{cmd:using} {it:{help bayesgraph##predfile:predfile}}
[{cmd:,} {it:{help bayesgraph##singleopts:singleopts}}] 


{pstd}
Graphical summaries for multiple predictions

{p 8 11 2}
{cmd:bayesgraph}
{it:{help bayesgraph##graph:graph}}
{it:{help bayesgraph##predspec:predspec}} [{it:predspec} ...] 
{cmd:using} {it:{help bayesgraph##predfile:predfile}}
[{cmd:,} {it:{help bayesgraph##multiopts:multiopts}}]


{p 8 11 2}
{cmd:bayesgraph} {cmd:matrix}
{it:{help bayesgraph##predspec:predspec}} {it:predspec} [{it:predspec} ...] 
{cmd:using} {it:{help bayesgraph##predfile:predfile}}
[{cmd:,} {it:{help bayesgraph##singleopts:singleopts}}] 


INCLUDE help bayesstats_predfile

{marker predspecsc}{...}
{p 4 6 2}
{it:predspecsc} may contain individual observations of simulated outcomes,
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; individual expected
outcome values, {cmd:{c -(}_mu}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; individual
simulated residuals, {cmd:{c -(}_resid}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; and
other scalar predictions, {cmd:{c -(}}{it:label}{cmd:{c )-}}.

{marker predspec}{...}
{p 4 6 2}
{it:predspec} is one of {it:{help bayesgraph##yspec:yspec}},
{cmd:(}{it:{help bayesgraph##yexprspec:yexprspec}}{cmd:)}, or
{cmd:(}{it:{help bayesgraph##funcspec:funcspec}}{cmd:)}.  See
{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingpredictionsandtheirfunctions:{it:Different ways of specifying predictions and their functions}}
in {bf:[BAYES] Bayesian postestimation}.

{marker yspec}{...}
{p 4 6 2}
{it:yspec} is {c -(}{it:{help bayesgraph##ysimspec:ysimspec}} {c |}
                    {it:{help bayesgraph##residspec:residspec}} {c |}
		    {it:{help bayesgraph##muspec:muspec}} {c |}
		    {it:{help bayesgraph##label:label}}{c )-}.{p_end}

{marker ysimspec}{...}
{p 4 6 2}
{it:ysimspec} is {cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:{help numlist}}{cmd:]{c )-}}, where
{cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} refers to all observations of the
{it:#}th simulated outcome and
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:numlist}{cmd:]{c )-}} refers to the selected
observations, {it:numlist}, of the {it:#}th simulated outcome.
{cmd:{c -(}_ysim{c )-}} is a synonym for {cmd:{c -(}_ysim1{c )-}}.{p_end}

{marker residspec}{...}
{p 4 6 2}
{it:residspec} is {cmd:{c -(}_resid}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_resid}{it:#}{cmd:[}{it:{help numlist}}{cmd:]{c )-}}, where
{cmd:{c -(}_resid}{it:#}{cmd:{c )-}} refers to all residuals of the {it:#}th
simulated outcome and {cmd:{c -(}_resid}{it:#}{cmd:[}{it:numlist}{cmd:]{c )-}}
refers to the selected residuals, {it:numlist}, of the {it:#}th simulated
outcome.  {cmd:{c -(}_resid{c )-}} is a synonym for {cmd:{c -(}_resid1{c )-}}.
{p_end}

INCLUDE help bayesstats_muspec.ihlp

INCLUDE help bayesstats_label.ihlp

INCLUDE help bayesstats_largedta.ihlp

{marker yexprspec}{...}
{p 4 6 2}
{it:yexprspec} is [{it:exprlabel}{cmd::}]{it:yexpr},
where {it:exprlabel} is a valid Stata name and {it:yexpr} is a scalar
expression that may contain
individual observations of simulated outcomes,
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; individual
expected outcome values, {cmd:{c -(}_mu}{it:#}{cmd:[}{it:#}{cmd:]{c )-}};
individual simulated residuals,
{cmd:{c -(}_resid}{it:#}{cmd:[}{it:#}{cmd:]{c )-}}; and other scalar
predictions, {cmd:{c -(}}{it:label}{cmd:{c )-}}.{p_end}

INCLUDE help bayesstats_funcspec.ihlp


{synoptset 25}{...}
{marker graph}{...}
{synopthdr:graph}
{synoptline}
{synopt :{opt diag:nostics}}multiple diagnostics in compact form{p_end}
{synopt :{opt trace}}trace plots{p_end}
{synopt :{opt ac}}autocorrelation plots{p_end}
{synopt :{opt hist:ogram}}histograms{p_end}
{synopt :{opt kdens:ity}}density plots{p_end}
{synopt :{opt cusum}}cumulative sum plots{p_end}
{synopt :{opt matrix}}scatterplot matrix{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:bayesgraph matrix} requires at least two parameters.
{cmd:diagnostics}, {cmd:trace}, {cmd:ac}, and {cmd:cusum} are not relevant for
predictions.{p_end}

{synoptset 25 tabbed}{...}
{marker singleopts}{...}
{synopthdr:singleopts}
{synoptline}
{syntab:Chains}
{synopt :{it:{help bayesgraph##chainopts:chainopts}}}options controlling
multiple chains{p_end}

{syntab:Options}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample; default is {cmd:skip(0)}{p_end}
{synopt :{cmd:name(}{it:name}{cmd:,} ...{cmd:)}}specify name of graph{p_end}
{synopt :{cmd:saving(}{it:{help filename}}{cmd:,} ...{cmd:)}}save graph in file{p_end}
{synopt :{it:{help bayesgraph##graphopts:graphopts}}}graph-specific
options{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{marker multiopts}{...}
{synopthdr:multiopts}
{synoptline}
{syntab:Chains}
{synopt :{it:{help bayesgraph##chainopts:chainopts}}}options controlling
multiple chains{p_end}

{syntab:Options}
{synopt :{opt byparm}[{cmd:(}{it:{help graph_by##byopts:grbyparmopts}}{cmd:)}]}specify the display of plots on one
graph; default is a separate graph for each plot; not allowed with graphs
{cmd:diagnostics} or {cmd:matrix} or with options {cmd:combine()} and
{cmd:bychain()}{p_end}
{synopt :{opt combine}[{cmd:(}{it:{help graph_combine##options:grcombineopts}}{cmd:)}]}specify the display of plots on one graph; recommended when the number of parameters is large; not allowed with graphs {cmd:diagnostics} or {cmd:matrix}
 or with options {cmd:byparm()} and {cmd:bychain()}{p_end}
{synopt :{opt sleep(#)}}pause for {it:#} seconds between multiple graphs; default
is {cmd:sleep(0)}{p_end}
{synopt :{opt wait}}pause until the {hline 2}{cmd:more}{hline 2} condition is cleared{p_end}
{synopt :[{opt no}]{opt close}}(do not) close Graph windows
when the next graph is displayed with multiple graphs;
default is {cmd:noclose}{p_end}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt name}{cmd:(}{it:{help bayesgraph##namespec:namespec}}{cmd:,} ...{cmd:)}}specify names of graphs{p_end}
{synopt :{opt saving}{cmd:(}{it:{help bayesgraph##filespec:filespec}}{cmd:,} ...{cmd:)}}save graphs in file{p_end}
{synopt :{cmd:graphopts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}}control the look of all graphs; not
allowed with {cmd:byparm()}{p_end}
{synopt :{opt graph}{it:#}{cmd:opts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}}control the look of {it:#}th graph;
not allowed with {cmd:byparm()}{p_end}
{synopt :{it:{help bayesgraph##graphopts:graphopts}}}equivalent to {opt graphopts(graphopts)}; only one may be specified{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25}{...}
{marker chainopts}{...}
{synopthdr:chainopts}
{synoptline}
{synopt :{cmd:chains(}{cmd:_all} | {it:{help numlist}}{cmd:)}}specify which chains to
plot; default is to plot the first 10 chains{p_end}
{synopt :{opt sepchains}}draw a separate graph for each chain; default is
to overlay chains{p_end}
{synopt :{opt chainsleg:end}}show legend keys corresponding to chain numbers;
        not allowed with graphs {opt diagnostics} and {opt matrix} or with
        options {opt combine()} and {opt byparm()}{p_end}
{synopt :{cmd:bychain}[{cmd:(}{it:{help bayesgraph##grbychainopts:grbychainopts}}{cmd:)}]}plot each chain as a subgraph on
        one graph; default is all chains overlayed on one graph;
        not allowed with graphs {opt diagnostics} and {opt matrix} or with
        options {opt combine()} and {opt byparm()}{p_end}
{synopt :{opth chainopts:(bayesgraph##graphopts:graphopts)}}control the look of all chains{p_end}
{synopt :{cmd:chain}{it:#}{cmd:opts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}}control the look of {it:#}th chain{p_end}
{synoptline}
{p2colreset}{...}
{phang}
Options {it:chainopts} are relevant only when option {opt nchains()} is used
with {helpb bayesmh} or the {helpb bayes} prefix.

{synoptset 25}{...}
{marker graphopts}{...}
{synopthdr:graphopts}
{synoptline}
{synopt :{it:{help bayesgraph##diagopts:diagnosticsopts}}}options for {cmd:bayesgraph diagnostics}{p_end}
{synopt :{it:{help tsline##tsline_options:tslineopts}}}options for {cmd:bayesgraph trace} and {cmd:bayesgraph cusum}{p_end}
{synopt :{it:{help ac##ac_options:acopts}}}options for {cmd:bayesgraph ac}{p_end}
{synopt :{it:{help hist##options:histopts}}}options for {cmd:bayesgraph histogram}{p_end}
{synopt :{it:{help bayesgraph##kdens_opts:kdensityopts}}}options for {cmd:bayesgraph kdensity}{p_end}
{synopt :{it:{help graph_matrix##options:grmatrixopts}}}options for {cmd:bayesgraph matrix}{p_end}
{synoptline}

{synoptset 25}{...}
{marker diagopts}{...}
{synopthdr:diagnosticsopts}
{synoptline}
{synopt :{cmd:traceopts(}{it:{help tsline##tsline_options:tslineopts}}{cmd:)}}affect rendition of all trace plots{p_end}
{synopt :{opt trace}{it:#}{cmd:opts(}{it:{help tsline##tsline_options:tslineopts}}{cmd:)}}affect rendition of {it:#}th trace plot{p_end}
{synopt :{cmd:acopts(}{it:{help ac##ac_options:acopts}}{cmd:)}}affect rendition of all autocorrelation plots{p_end}
{synopt :{opt ac}{it:#}{cmd:opts(}{it:{help ac##ac_options:acopts}}{cmd:)}}affect rendition of {it:#}th autocorrelation plot{p_end}
{synopt :{cmd:histopts(}{it:{help hist##options:histopts}}{cmd:)}}affect
rendition of all histogram plots{p_end}
{synopt :{opt hist}{it:#}{cmd:opts(}{it:{help hist##options:histopts}}{cmd:)}}affect rendition of {it:#}th histogram plot{p_end}
{synopt :{cmd:kdensopts(}{it:{help bayesgraph##kdens_opts:kdensityopts}}{cmd:)}}affect rendition of all density plots{p_end}
{synopt :{opt kdens}{it:#}{cmd:opts(}{it:{help bayesgraph##kdens_opts:kdensityopts}}{cmd:)}}affect rendition of {it:#}th density plot{p_end}
{synopt :{it:{help graph_combine##options:grcombineopts}}}any option
documented in {manhelp graph_combine G-2:graph combine}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25}{...}
{marker ac_options}{...}
{synopthdr:acopts}
{synoptline}
{synopt :{cmd:ci}}plot autocorrelations with confidence intervals; not allowed
with {cmd:byparm()}{p_end}
{synopt :{it:{help ac##ac_options:acopts}}}any options other than {cmd:generate()} documented for the {cmd:ac} command in {manhelp corrgram TS}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25}{...}
{marker kdens_opts}{...}
{synopthdr:kdensityopts}
{synoptline}
{synopt :{it:{help kdensity##options:kdensopts}}}options for the overall kernel density plot{p_end}
{synopt :{cmd:show(}{it:{help bayesgraph##showspec:showspec}}{cmd:)}}show
first-half density ({cmd:first}), second-half density ({cmd:second}),
{cmd:both}, or {cmd:none}; default varies{p_end}
{synopt :{opt kdensfirst}{cmd:(}{it:{help kdensity##options:kdens1opts}}{cmd:)}}affect rendition of the first-half density plot{p_end}
{synopt :{opt kdenssecond}{cmd:(}{it:{help kdensity##options:kdens2opts}}{cmd:)}}affect rendition of the second-half density plot{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Graphical summaries}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesgraph} provides graphical summaries and convergence diagnostics for
simulated posterior distributions (MCMC samples) of model parameters and
functions of model parameters obtained after Bayesian estimation.
Graphical summaries include trace plots, autocorrelation plots, and various
distributional plots.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesgraphQuickstart:Quick start}

        {mansection BAYES bayesgraphRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesgraphMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Chains}

{marker chainsspec}{...}
{phang}
{cmd:chains(}{cmd:_all} | {it:{help numlist}}{cmd:)} specifies which chains
from the MCMC sample to plot. The default is to plot the first 10 chains.
You can use {cmd:chains(_all)} to plot all chains.

{phang}
{cmd:sepchains} specifies that a separate graph be drawn for each chain. This
option is implied for {cmd:bayesgraph matrix} and may not be combined with
{cmd:bychain()}.

{phang}
{cmd:chainslegend} specifies that the graph be plotted with a legend showing
keys corresponding to chain numbers. This option is not allowed with graphs
{cmd:diagnostics} and {cmd:matrix} or with options {cmd:combine()} and
{cmd:byparm()}.

{marker grbychainopts}{...}
{phang}
{cmd:bychain}[{cmd:(}{it:grbychainopts}{cmd:)}] specifies that each chain be
plotted as a subgraph on one graph.  By default, all chains are displayed
overlayed on one graph.  This option is not allowed with graphs
{cmd:diagnostics} and {cmd:matrix} or with options {cmd:combine()},
{cmd:byparm()}, and {cmd:sepchains}.

{pmore}
{it:grbychainopts} is any of the
suboptions of {cmd:by()} documented in {manhelpi by_option G-3}.

{phang}
{opth chainopts:(bayesgraph##graphopts:graphopts)} and
{cmd:chain}{it:#}{cmd:opts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}
control the look of chains. {opt chainopts()} controls the look of all chains
but may be overridden for specific chains by using the
{cmd:chain}{it:#}{cmd:opts()} option.

{pstd}
Chain-specific options are ignored if option {cmd:nchains()} is not specified
with {helpb bayesmh} or the {helpb bayes} prefix.

{dlgtab:Options}

{phang}
{cmd:byparm}[{cmd:(}{it:grbyparmopts}{cmd:)}] specifies the display of all
plots of parameters as subgraphs on one graph.  By default, a separate graph
is produced for each plot when multiple parameters are specified.  This option
is not allowed with {cmd:bayesgraph diagnostics} or {cmd:bayesgraph}
{cmd:matrix} and may not be combined with options {cmd:combine()} and
{cmd:bychain()}.  When many parameters or expressions are specified, this
option may fail because of memory constraints.  In that case, you may use
option {cmd:combine()} instead.

{pmore}
{it:grbyparmopts} is any of the
suboptions of {cmd:by()} documented in {manlinki G-3 by_option}.

{pmore}
{cmd:byparm()} allows y scales to differ for all graph types and forces x
scales to be the same only for {cmd:bayesgraph trace} and {cmd:bayesgraph}
{cmd:cusum}.  Use {cmd:noyrescale} within {cmd:byparm()} to specify a common y
axis, and use {cmd:xrescale} or {cmd:noxrescale} to change the default
behavior for the x axis.

{pmore}
{cmd:byparm()} with {cmd:bayesgraph trace} and {cmd:bayesgraph cusum} defaults
to displaying multiple plots in one column to accommodate the x axis with many
iterations.  Use {cmd:norowcoldefault} within {cmd:byparm()} to switch back to
the default behavior of options {cmd:rows()} and {cmd:cols()} of the 
{manlinki G-3 by_option}.

{phang}
{cmd:combine}[{cmd:(}{it:grcombineopts}{cmd:)}] specifies the display of all
plots of parameters as subgraphs on one graph and is an alternative to
{cmd:byparm()} with a large number of parameters.  By default, a separate
graph is produced for each plot when multiple parameters are specified.  This
option is not allowed with {cmd:bayesgraph diagnostics} or {cmd:bayesgraph}
{cmd:matrix} and may not be combined with option {cmd:byparm()}.  It can be
used in cases where a large number of parameters or expressions are specified
and the {cmd:byparm()} option would cause an error because of memory
constraints.

{pmore}
{it:grcombineopts} is any of the options documented in
{manhelp graph_combine G-2:graph combine}.

{phang}
{opt sleep(#)} specifies pausing for {it:#} seconds before producing the next
graph.  This option is allowed only when multiple parameters are specified.
This option may not be combined with {cmd:wait}, {cmd:combine()}, or
{cmd:byparm()}.

{phang}
{cmd:wait} causes {cmd:bayesgraph} to display {hline 2}{cmd:more}{hline 2} and
pause until any key is pressed before producing the next graph.  This option
is allowed when multiple parameters are specified.  This option may not be
combined with {cmd:sleep()}, {cmd:combine()}, or {cmd:byparm()}.
{cmd:wait} temporarily ignores the global setting that is specified using
{cmd:set more off}.

{phang}
[{cmd:no}]{cmd:close} specifies that, for multiple graphs, the Graph window be
closed when the next graph is displayed.  The default is {cmd:noclose} or to
not close any Graph windows.

INCLUDE help bayespost_skipoptsdes

{marker namespec}{...}
{phang}
{cmd:name(}{it:namespec}[{cmd:, replace}]{cmd:)} specifies the name of the
graph or multiple graphs.  See {manlinki G-3 name_option} for a single graph.
If multiple graphs are produced, then the argument of {cmd:name()} is either a
list of names or a {it:stub}, in which case graphs are named {it:stub}{cmd:1},
{it:stub}{cmd:2}, and so on.  With multiple graphs, if {cmd:name()} is not
specified and neither {cmd:sleep()} nor {cmd:wait} is specified,
{cmd:name(Graph__{it:#}, replace)} is assumed, and thus the produced graphs
may be replaced by subsequent {cmd:bayesgraph} commands.

{pmore}
The {cmd:replace} suboption causes existing graphs with the specified name or
names to be replaced.

{marker filespec}{...}
{phang}
{cmd:saving(}{it:filespec}[{cmd:, replace}{cmd:)} specifies the filename or
filenames to use to save the graph or multiple graphs to disk.  See
{manhelpi saving_option G-3} for a single graph.  If multiple graphs are
produced, then the argument of {cmd:saving()} is either a list of filenames or
a {it:stub}, in which case graphs are saved with filenames {it:stub}{cmd:1},
{it:stub}{cmd:2}, and so on.

{pmore}
The {cmd:replace} suboption specifies that the file (or files) may be replaced
if it already exists.

INCLUDE help bayespost_showreoptdes

{phang}
{cmd:graphopts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)} and
{cmd:graph}{it:#}{cmd:opts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}
affect the rendition of graphs.  {cmd:graphopts()} affects the rendition of
all graphs but may be overridden for specific graphs by using the
{cmd:graph}{it:#}{cmd:opts()} option.  The options specified within
{cmd:graph}{it:#}{cmd:opts()} are specific for each type of graph.

{pmore}
The two specifications

{p 12 15 2}
{cmd:bayesgraph} ...{cmd:, graphopts(}{it:graphopts}{cmd:)}

{pmore}
and

{p 12 15 2}
{cmd:bayesgraph} ...{cmd:,} {it:graphopts}

{pmore}
are equivalent, but you may specify one or the other.

{phang2}
These options are not allowed with {cmd:byparm()} and when only one parameter
is specified.

{phang}
{it:graphopts} specifies options specific to each graph type.

{phang2}
{it:{help bayesgraph##diagopts:diagnosticsopts}} specifies options for use with {cmd:bayesgraph}
{cmd:diagnostics}.  See the corresponding table in the syntax diagram for a
list of options.

{marker tslineopts}{...}
{phang2}
{it:{help tsline##options:tslineopts}} specifies options for use with
{cmd:bayesgraph trace} and {cmd:bayesgraph cusum}.  See the options of 
{manhelp tsline TS} except {cmd:by()}.

{phang2}
{it:acopts} specifies options for use with
{cmd:bayesgraph ac}.

{phang3}
{cmd:ci} requests that the graph of autocorrelations with confidence intervals
be plotted.  By default, confidence intervals are not plotted.  This option is
not allowed with {cmd:byparm()}.

{phang3}
{it:{help corrgram##options_ac:acoptsts}} specifies any options except {cmd:generate()} of the
{cmd:ac} command in {manhelp corrgram TS}.

{marker histopts}{...}
{phang2}
{it:{help histogram##options_continuous:histopts}} specifies options for use
with {cmd:bayesgraph histogram}.  See options of {manhelp histogram R} except
{cmd:by()}.

{phang2}
{it:kdensityopts} specifies options for use with {cmd:bayesgraph kdensity}.

{phang3}
{it:{help kdensity##options:kdensopts}} specifies options for the overall
kernel density plot.  See the options documented in {manhelp kdensity R} except
{cmd:generate()} and {cmd:at()}.

{marker showspec}{...}
{phang3}
{opt show(showspec)} specifies which kernel density curves to plot.
{it:showspec} is one of {cmd:first}, {cmd:second}, {cmd:both}, or {cmd:none}.
If {cmd:show(first)} is specified, only the first-half density curve, obtained
from the first half of an MCMC sample, is plotted.  If {cmd:show(second)} is
specified, only the second-half density curve, obtained from the second half
of an MCMC sample, is plotted.  {cmd:show(both)}, the default with graph
{cmd:diagnostics}, overlays both the first-half density curve and the
second-half density curve with the overall kernel density curve.
{cmd:show(none)}, the default with graph {cmd:kdensity}, shows only the
overall kernel density curve.

{phang3}
{opt kdensfirst(kdens1opts)} specifies options of
{manhelp twoway_kdensity G-2:graph twoway kdensity} except {cmd:by()} to
affect rendition of the first-half kernel density plot.

{phang3}
{opt kdenssecond(kdens2opts)} specifies options of 
{manhelp twoway_kdensity G-2:graph twoway kdensity} except {cmd:by()} to
affect rendition of the second-half kernel density plot.

{phang2}
{it:{help graph matrix##options:grmatrixopts}} specifies options for use with
{cmd:bayesgraph matrix}.  See the options of
{manhelp graph_matrix G-2:graph matrix} except {cmd:by()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:bayesgraph} requires specifying at least one parameter with all graph
types, except {cmd:matrix} which requires at least two parameters.  To request
graphs for all parameters, use {cmd:_all}.

{pstd}
When multiple graphs are produced, they are automatically stored in
memory with names {cmd:Graph__}{it:#} and will all appear on the screen.
After you are done reviewing the graphs, you can type 
{help graph_drop:{cmd:graph drop Graph__*}} to close the graphs and drop
them from memory.

{pstd}
If you would like to see only one graph at a time, you can specify
option {opt close} to close the Graph window when the next graph is displayed.
You can also use option {opt sleep()} or option {opt wait} to pause between
the subsequent graphs.  The {opt sleep(#)} option causes each graph to
pause for {it:#} seconds.  The {opt wait} option causes {opt bayesgraph} to
wait until a key is pressed before producing the next graph.

{pstd}
You can also combine separate graphs into one by specifying one of
{cmd:byparm()} or {cmd:combine()}.  These options are not allowed with
diagnostics or matrix graphs.  The {opt byparm()} option produces more compact
graphs, but it may not be feasible with many parameters or expressions and
large sizes of MCMC samples.

{pstd}
With multiple graphs, you can control the look of each individual graph with
{cmd:graph}{it:#}{cmd:opts()}.  Options common to all graphs may be specified
in {cmd:graphopts()} or passed directly to the command as with single graphs.

{pstd}
With multiple chains, {opt bayesgraph} plots only the first 10 chains by
default.  If you have more than 10 chains, although only four chains are
commonly used in practice, you can use the {cmd:chains(_all)} option to plot
all the chains.  You can also use the {cmd:chains()} option to handpick the
chains you want to be plotted.  For example, {cmd:chains(1/3 5)} will plot
chains 1, 2, 3, and 5. If desired, you can see which plot corresponds to
which chain by using the {cmd:chainslegend} option.

{pstd}
By default, the chains will be plotted overlaid on one graph.  You can specify
the {cmd:sepchains} option to plot each chain on a separate graph, in which
case the graphs will be automatically stored in memory with names
{cmd:Graph__}{it:#} and will all appear on the screen.  Or, you can use the
{cmd:bychain} option to plot each chain separately but one graph.

{pstd}
To control the look of an individual chain, you can use the
{cmd:chain}{it:#}{cmd:opts()} options.  For example, to change the line color
to red for chain 2, you would specify the {cmd:chain2opts(lcolor(red))}
option. To control the look of all chains, you can use the {cmd:chainopts()}
option.

{pstd}
You can use {cmd:bayesgraph} to plot predicted quantities when you supply the
prediction dataset generated by {helpb bayespredict} in the {cmd:using}
specification. Also see
{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingpredictionsandtheirfunctions:{it:Different ways of specifying predictions and their functions}}
in {bf:[BAYES] Bayesian postestimation}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Diagnostic graphs for all parameters in the model{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}
	
{pstd}Autocorrelation plots for parameters {cmd:{change:age}} and {cmd:{change:_cons}}{p_end}
{phang2}{cmd:. bayesgraph ac {change:age} {change:_cons}}
	
{pstd}Trace plots for parameters {cmd:{c -(}var{c )-}} and {cmd:{change:age}} in a single graph{p_end}
{phang2}{cmd:. bayesgraph trace {c -(}var{c )-} {change:age}, byparm}

{pstd}Histogram of the marginal posterior distribution for parameter
{cmd:{change:age}} with normal distribution overlayed{p_end}
{phang2}{cmd:. bayesgraph histogram {change:age}, normal}
	
{pstd}Kernel density plot for parameter {cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesgraph kdensity {c -(}var{c )-}}
		
{pstd}Cumulative sum plot for parameter {cmd:{change:age}}{p_end}
{phang2}{cmd:. bayesgraph cusum {change:age}}
	
{pstd}Bivariate scatterplot of parameters {cmd:{change:age}} and {cmd:{change:_cons}}{p_end}
{phang2}{cmd:. bayesgraph matrix {change:age} {change:_cons}}{p_end}
