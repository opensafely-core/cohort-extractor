{smcl}
{* *! version 1.1.20  24sep2018}{...}
{viewerdialog stphplot "dialog stphplot"}{...}
{viewerdialog stcoxkm "dialog stcoxkm"}{...}
{viewerdialog estat "dialog stcox_estat"}{...}
{vieweralsosee "[ST] stcox PH-assumption tests" "mansection ST stcoxPH-assumptiontests"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "stcox_diagnostics##syntax"}{...}
{viewerjumpto "Menu" "stcox_diagnostics##menu"}{...}
{viewerjumpto "Description" "stcox_diagnostics##description"}{...}
{viewerjumpto "Links to PDF documentation" "stcox_diagnostics##linkspdf"}{...}
{viewerjumpto "Options for stphplot" "stcox_diagnostics##options_stphplot"}{...}
{viewerjumpto "Options for stcoxkm" "stcox_diagnostics##options_stcoxkm"}{...}
{viewerjumpto "Options for estat phtest" "stcox_diagnostics##options_estat_phtest"}{...}
{viewerjumpto "Examples" "stcox_diagnostics##examples"}{...}
{viewerjumpto "Video example" "stcox_diagnostics##video"}{...}
{viewerjumpto "Stored results" "stcox_diagnostics##results"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[ST] stcox PH-assumption tests} {hline 2}}Tests of proportional-hazards assumption{p_end}
{p2col:}({mansection ST stcoxPH-assumptiontests:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{phang}
Check proportional-hazards assumption:

{p 6 8 2}
Log-log plot of survival

{p 8 17 2}
{cmd:stphplot} [{it:{help if}}] {cmd:,} {c -(}{opth by(varname)} | 
{opth str:ata(varname)}{c )-} [{it:{help stcox_diagnostics##stphplot_options:stphplot_options}}]


{p 6 8 2}
Kaplan-Meier and predicted survival plot

{p 8 17 2}
{cmd:stcoxkm} [{it:{help if}}] {cmd:,} {opth by(varname)} [{it:{help stcox diagnostics##stcoxkm_options:stcoxkm_options}}]


{p 6 8 2}
Using Schoenfeld residuals

{p 8 17 2}
{cmd:estat} {opt phtest} [{cmd:,} {it:{help stcox diagnostics##phtest_options:phtest_options}}]


{synoptset 33 tabbed}{...}
{marker stphplot_options}{...}
{synopthdr :stphplot_options}
{synoptline}
{syntab :Main}
{p2coldent :* {opth by(varname)}}fit separate Cox models; the default{p_end}
{p2coldent :* {opth str:ata(varname)}}fit stratified Cox model{p_end}
{synopt :{opth adj:ust(varlist)}}adjust to average values of {it:varlist}{p_end}
{synopt :{opt z:ero}}adjust to zero values of {it:varlist}; use with {opt adjust()}{p_end}

{syntab :Options}
{synopt :{opt noneg:ative}}plot ln{c -(}-ln(survival){c )-}{p_end}
{synopt :{opt nolnt:ime}}plot curves against analysis time{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}

{syntab:Plot}
{synopt :{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{help stcox_diagnostics##stphplot_plot_options:{it:stphplot_plot_options}}{cmd:)}}affect rendition of the {it:#}th connected line and {it:#}th plotted points{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{pstd}
* Either {opt by(varname)} or {opt strata(varname)} is required with 
{cmd:stphplot}.{p_end}


{synoptset 33}{...}
{marker stphplot_plot_options}{...}
{synopthdr:stphplot_plot_options}
{synoptline}
{synopt:{it:{help cline_options}}}change look of lines or connecting method{p_end}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synoptline}
{p2colreset}{...}


{synoptset 33 tabbed}{...}
{marker stcoxkm_options}{...}
{synopthdr :stcoxkm_options}
{synoptline}
{syntab :Main}
{p2coldent :* {opth by(varname)}}report the nominal or ordinal covariate{p_end}
{synopt :{cmdab:tie:s(}{cmdab:bre:slow)}}use Breslow method to handle tied failures{p_end}
{synopt :{cmdab:tie:s(}{cmdab:efr:on)}}use Efron method to handle tied failures{p_end}
{synopt :{cmdab:tie:s(exactm)}}use exact marginal-likelihood method to handle tied failures{p_end}
{synopt :{cmdab:tie:s(exactp)}}use exact partial-likelihood method to handle tied failures{p_end}
{synopt :{opt sep:arate}}draw separate plot for predicted and observed curves{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}

{syntab:Observed plot}
{synopt :{opth obsop:ts(stcox_diagnostics##stcoxkm_plot_options:stcoxkm_plot_options)}}affect rendition of the observed curve{p_end}
{synopt :{cmdab:obs:}{ul:{it:#}}{cmd:opts(}{help stcox_diagnostics##stcoxkm_plot_options:{it:stcoxkm_plot_options}}{cmd:)}}affect rendition of the {it:#}th observed curve; not allowed with {opt separate}{p_end}

{syntab:Predicted plot}
{synopt :{opth predop:ts(stcox_diagnostics##stcoxkm_plot_options:stcoxkm_plot_options)}}affect rendition of the predicted
curve{p_end}
{synopt :{cmdab:pred:}{ul:{it:#}}{cmd:opts(}{help stcox_diagnostics##stcoxkm_plot_options:{it:stcoxkm_plot_options}}{cmd:)}}affect rendition of the {it:#}th predicted curve; not allowed with {opt separate}{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synopt :{opth byop:ts(by_option:byopts)}}how subgraphs are combined, labeled,
etc.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt by(varname)} is required with {cmd:stcoxkm}.{p_end}


{synoptset 33}{...}
{marker stcoxkm_plot_options}{...}
{synopthdr:stcoxkm_plot_options}
{synoptline}
{synopt:{it:{help connect_options}}}change look of connecting method{p_end}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stphplot} and {cmd:stcoxkm};
see {manhelp stset ST}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified
using {cmd:stset}; see {manhelp stset ST}.


{marker phtest_options}{...}
{synoptset 24 tabbed}{...}
{synopthdr :phtest_options}
{synoptline}
{syntab:Main}
{synopt :{opt log}}use natural logarithm time-scaling function{p_end}
{synopt :{opt km}}use 1-KM product-limit estimate as the time-scaling function{p_end}
{synopt :{opt rank}}use rank of analysis time as the time-scaling function{p_end}
{synopt :{opth time(varname)}}use {it:varname} containing a monotone
transformation of analysis time as the time-scaling function{p_end}
{synopt :{opth plot(varname)}}plot smoothed, scaled Schoenfeld residuals versus
time{p_end}
{synopt :{opt bw:idth(#)}}use bandwidth of {it:#}; default is {cmd:bwidth(0.8)}{p_end}
{synopt : {opt d:etail}}test proportional-hazards assumption separately for each
covariate{p_end}

{syntab:Scatterplot}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt :{it:{help marker_label_options}}}add marker labels; change look or position{p_end}

{syntab:Smoothed line}
{synopt :{opth lineop:ts(cline_options)}}affect rendition of the smoothed line{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p 4 6 2}
{cmd:estat} {cmd:phtest} is not appropriate after estimation with {cmd:svy}.
{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:stphplot}

{phang2}
{bf:Statistics > Survival analysis > Regression models >}
     {bf:Graphically assess proportional-hazards assumption}

    {title:stcoxkm}

{phang2}
{bf:Statistics > Survival analysis > Regression models >}
     {bf:Kaplan-Meier versus predicted survival}

    {title:estat phtest}

{phang2}
{bf:Statistics > Survival analysis > Regression models >}
    {bf:Test proportional-hazards assumption}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stphplot} plots -ln{c -(}-ln(survival){c )-} curves for each category of a
nominal or ordinal covariate versus ln(analysis time). These are often
referred to as "log-log" plots.  Optionally, these estimates can be adjusted
for covariates.  The proportional-hazards assumption is not violated when the
curves are parallel.

{pstd}
{cmd:stcoxkm} plots Kaplan-Meier observed survival curves and compares them
with the Cox predicted curves for the same variable.  The closer the observed
values are to the predicted, the less likely it is that the proportional-hazards
assumption has been violated.
 
{pstd}
{cmd:estat phtest} tests the proportional-hazards assumption 
on the basis of Schoenfeld residuals after fitting a model
with {cmd:stcox}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stcoxPH-assumptiontestsQuickstart:Quick start}

        {mansection ST stcoxPH-assumptiontestsRemarksandexamples:Remarks and examples}

        {mansection ST stcoxPH-assumptiontestsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_stphplot}{...}
{title:Options for stphplot}

{dlgtab:Main}

{phang}
{opth by(varname)} specifies the nominal or ordinal covariate.  Either
{opt by()} or {opt strata()} is required with {cmd:stphplot}.

{phang}
{opth strata(varname)} is an alternative to {opt by()}.  Rather than fitting
separate Cox models for each value of {it:varname}, {opt strata()} fits 
one stratified Cox model.  You must also specify {opth adjust(varlist)} 
with the {opt strata(varname)} option; see {manhelp sts_graph ST:sts graph}.

{phang}
{opth adjust(varlist)} adjusts the estimates to that for the average values of 
the {it:varlist} specified.  The estimates can also be
adjusted to zero values of {it:varlist} by specifying the {opt zero} option.
{opt adjust(varlist)} can be specified with {opt by()}; it is required with
{opt strata(varname)}.

{phang}
{opt zero} is used with {opt adjust()} to specify that the estimates be 
adjusted to the 0 values of the {it:varlist} rather than to the average 
values.

{dlgtab:Options}

{phang}
{opt nonegative} specifies that ln{c -(}-ln(survival){c )-} be plotted instead
of -ln{c -(}-ln(survival){c )-}.

{phang}
{opt nolntime} specifies that curves be plotted against analysis time instead
of against ln(analysis time).

{phang}
{opt noshow} prevents {cmd:stphplot} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.

{dlgtab:Plot}

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:stphplot_plot_options}{cmd:)} affects
the rendition of the {it:#}th connected line and
{it:#}th plotted points; see
{manhelpi cline_options G-3} and
{manhelpi marker_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).


{marker options_stcoxkm}{...}
{title:Options for stcoxkm}

{dlgtab:Main}

{phang}
{opth by(varname)} specifies the nominal or ordinal covariate.
{opt by()} is required.

{phang}
{cmd:ties(breslow} | {opt efron} | {opt exactm} | {opt exactp)} specifies
one of the methods available to {cmd:stcox} for handling tied failures.  If 
none is specified, {cmd:ties(breslow)} is assumed; see {manhelp stcox ST}.

{phang}
{opt separate} produces separate plots of predicted and observed values for 
each value of the variable specified with {opt by()}.

{phang}
{opt noshow} prevents {cmd:stcoxkm} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.

{dlgtab:Observed plot}

{phang}
{opt obsopts(stcoxkm_plot_options)} affects the rendition of the observed curve;
 see {manhelpi connect_options G-3} and {manhelpi marker_options G-3}.

{phang}
{cmd:obs}{it:#}{cmd:opts(}{it:stcoxkm_plot_options}{cmd:)} affects the
rendition of the {it:#}th observed curve; see
{manhelpi connect_options G-3} and {manhelpi marker_options G-3}.
This option is not allowed with {cmd:separate}. 

{dlgtab:Predicted plot}

{phang}
{opt predopts(stcoxkm_plot_options)} affects the rendition of the predicted
curve; see {manhelpi connect_options G-3} and {manhelpi marker_options G-3}.

{phang}
{cmd:pred}{it:#}{cmd:opts(}{it:stcoxkm_plot_options}{cmd:)} affects the
rendition of the {it:#}th predicted curve; see
{manhelpi connect_options G-3} and {manhelpi marker_options G-3}.
This option is not allowed with {opt separate}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).

{phang}
{opt byopts(byopts)} affects the appearance of the combined graph when
{cmd:by()} and {cmd:separate} are specified, including the overall graph title
and the organization of subgraphs.  See {manhelpi by_option G-3}.


{marker options_estat_phtest}{...}
{title:Options for estat phtest}

{dlgtab: Main}

{phang}
{opt log}, {opt km}, {opt rank}, and {opt time()} are used to specify the time 
scaling function.{p_end}

{pmore}
By default, {cmd:estat phtest} performs the tests using the identity
function, that is, analysis time itself.{p_end}

{pmore}
{opt log} specifies that the natural log of analysis time be used.{p_end}

{pmore}
{opt km} specifies that 1 minus the Kaplan-Meier product-limit estimate
be used.{p_end}

{pmore}
{opt rank} specifies that the rank of analysis time be used.{p_end}

{pmore}
{opth time(varname)} specifies a variable containing an arbitrary monotonic 
transformation of analysis time.  You must ensure that {it:varname} is a 
monotonic transform.

{phang}
{opth plot(varname)} specifies that a scatterplot and smoothed plot of scaled 
Schoenfeld residuals versus time be produced for the covariate specified by 
{it:varname}.  By default, the smoothing is performed using the running-mean
method implemented in {cmd:lowess, mean noweight}; see {manhelp lowess R}.

{phang}
{opt bwidth(#)} specifies the bandwidth.  Centered subsets of {opt bwidth()}*N
observations are used for calculating smoothed values for each point in the 
data except for endpoints, where smaller, uncentered subsets are used.  The 
greater the {opt bwidth()}, the greater the smoothing.  The default is 
{cmd:bwidth(0.8)}.

{phang}
{opt detail} specifies that a separate test of the proportional-hazards
assumption be produced for each covariate in the Cox model.  By default,
{cmd:estat phtest} produces only the global test.

{dlgtab: Scatterplot}

{phang}
{it:marker_options} affect the rendition of markers drawn at the plotted 
points, including their shape, size, color, and outline; see 
{manhelpi marker_options G-3}.

{phang}
{it:marker_label_options} specify if and how the markers are to be labeled; 
see {manhelpi marker_label_options G-3}.

{dlgtab:Smoothed line}

{phang}
{opt lineopts(cline_options)} affects the rendition of the smoothed line; see
{manhelpi cline_options G-3}.

{dlgtab: Y axis, X axis, Titles, Legend, Overall} 

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse leukemia}{p_end}
{phang2}{cmd:. stset weeks, failure(relapse) noshow}

{pstd}Check proportional-hazards assumption for {cmd:treatment1} using
{cmd:stphplot}{p_end}
{phang2}{cmd:. stphplot, by(treatment1)}

{pstd}Same as above, but adjust for white-blood-cell count{p_end}
{phang2}{cmd:. stphplot, by(treatment1) adj(wbc2 wbc3)}

{pstd}Check proportional-hazards assumption for {cmd:treatment1} using
{cmd:stcoxkm}{p_end}
{phang2}{cmd:. stcoxkm, by(treatment1)}

{pstd}Check proportional-hazards assumption for {cmd:treatment2} using
{cmd:stphplot}{p_end}
{phang2}{cmd:. stphplot, by(treatment2)}

{pstd}Check proportional-hazards assumption for {cmd:treatment2} using
{cmd:stcoxkm}{p_end}
{phang2}{cmd:. stcoxkm, by(treatment2) separate}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse leukemia}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset weeks, failure(relapse)}

{pstd}Fit Cox model{p_end}
{phang2}{cmd:. stcox treatment2 wbc2 wbc3}

{pstd}Test proportional-hazards assumption based on Schoenfeld residuals{p_end}
{phang2}{cmd:. estat phtest, rank detail}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=ime8BaLLXxw":How to fit a Cox proportional hazards model and check proportional-hazards assumption}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat phtest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}global test degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}global test chi-squared{p_end}
{synopt:{cmd:r(p)}}global test p-value{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(phtest)}}separate tests for each covariate{p_end}
{p2colreset}{...}
