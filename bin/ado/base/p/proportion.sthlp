{smcl}
{* *! version 1.2.6  23jan2019}{...}
{viewerdialog proportion "dialog proportion"}{...}
{viewerdialog "svy: proportion" "dialog proportion, message(-svy-) name(svy_proportion)"}{...}
{vieweralsosee "[R] proportion" "mansection R proportion"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] proportion postestimation" "help proportion postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] ratio" "help ratio"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] total" "help total"}{...}
{viewerjumpto "Syntax" "proportion##syntax"}{...}
{viewerjumpto "Menu" "proportion##menu"}{...}
{viewerjumpto "Description" "proportion##description"}{...}
{viewerjumpto "Links to PDF documentation" "proportion##linkspdf"}{...}
{viewerjumpto "Options" "proportion##options"}{...}
{viewerjumpto "Examples" "proportion##examples"}{...}
{viewerjumpto "Stored results" "proportion##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] proportion} {hline 2}}Estimate proportions{p_end}
{p2col:}({mansection R proportion:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:proportion} {varlist} {ifin}
[{it:{help proportion##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth std:ize(varname)}}variable identifying strata for standardization{p_end}
{synopt :{opth stdw:eight(varname)}}weight variable for standardization{p_end}
{synopt :{opt nostdr:escale}}do not rescale the standard weight variable{p_end}

{syntab :if/in/over}
{synopt :{cmd:over(}{it:{help varlist:varlist_o}}{cmd:)}}group over
subpopulations defined by {it:varlist_o}{p_end}

{syntab :SE/Cluster}
{synopt :{opth vce(vcetype)}}{it:vcetype}
	may be {opt analytic}, {opt cl:uster} {it:clustvar}, {opt boot:strap},
	or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth citype:(proportion##citype:citype)}}method to compute limits of
confidence intervals; default is {cmd:citype(logit)}{p_end}
{synopt :{opt percent}}report estimated proportions as percentages{p_end}
{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{it:{help proportion##display_options:display_options}}}control
column formats, row spacing, line width, display of omitted variables and base
and empty cells, and factor-variable labeling{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
Only numeric, nonnegative, integer-valued variables are
allowed in {it:varlist}.{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:jackknife}, {cmd:mi estimate}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp proportion_postestimation R:proportion postestimation}
for features available after estimation.{p_end}

{marker citype}{...}
{synoptset 26}{...}
{synopthdr:citype}
{synoptline}
{synopt :{cmd:logit}}calculate logit-transformed confidence intervals; the
default{p_end}
{synopt :{opt agres:ti}}calculate Agresti-Coull confidence intervals{p_end}
{synopt :{cmd:exact}}calculate exact (Clopper-Pearson) confidence
intervals{p_end}
{synopt :{opt jeff:reys}}calculate Jeffreys confidence intervals{p_end}
{synopt :{opt norm:al}}calculate normal (Wald) confidence intervals{p_end}
{synopt :{cmd:wald}}synonym for normal{p_end}
{synopt :{cmd:wilson}}calculate Wilson confidence intervals{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
   {bf:Summary and descriptive statistics > Proportions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:proportion} produces estimates of proportions, along with standard
errors, for the categories identified by the values in each variable of
{varlist}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R proportionQuickstart:Quick start}

        {mansection R proportionRemarksandexamples:Remarks and examples}

        {mansection R proportionMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth stdize(varname)} specifies that the point estimates be adjusted by
direct standardization across the strata identified by {it:varname}.  
This option requires the {opt stdweight()} option.

{phang}
{opth stdweight(varname)} specifies the weight variable associated with the
standard strata identified in the {opt stdize()} option.  The standardization
weights must be constant within the standard strata.

{phang}
{opt nostdrescale}
prevents the standardization weights from being rescaled within the
{opt over()} groups.  This option requires {opt stdize()} but is ignored if
the {opt over()} option is not specified.

{dlgtab:if/in/over}

{phang}
{cmd:over(}{it:{help varlist:varlist_o}}{cmd:)}
specifies that estimates be computed for multiple subpopulations,
which are identified by the different values of the variables in 
{it:varlist_o}.  Only numeric, nonnegative, integer-valued variables are
allowed in {opt over(varlist_o)}.

{dlgtab:SE/Cluster}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which 
includes types that are derived from asymptotic theory ({cmd:analytic}),
that allow for intragroup correlation ({cmd:cluster} {it:clustvar}), and that
use bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(analytic)}, the default, uses the analytically derived variance
estimator associated with the sample proportion.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opth citype:(proportion##citype:citype)} specifies how to compute the limits
of confidence intervals.  {it:citype} may be one of
{cmd:logit} (default), {cmd:agresti}, {cmd:exact}, {cmd:jeffreys},
{cmd:normal}, {cmd:wald}, or {cmd:wilson}.

{phang}
{opt percent} specifies that the proportions be reported as percentages.

{phang}
{opt noheader} prevents the table header from being displayed.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{pstd}
The following option is available with {opt proportion} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Estimate proportions{p_end}
{phang2}{cmd:. proportion rep78}{p_end}

{phang}Estimate proportions over values of {cmd:foreign}{p_end}
{phang2}{cmd:. proportion rep78, over(foreign)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:proportion} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_over)}}number of subpopulations{p_end}
{synopt:{cmd:e(N_stdize)}}number of standard strata{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(df_r)}}sample degrees of freedom{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:proportion}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(varlist)}}{it:varlist}{p_end}
{synopt:{cmd:e(stdize)}}{it:varname} from {cmd:stdize()}{p_end}
{synopt:{cmd:e(stdweight)}}{it:varname} from {cmd:stdweight()}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(over)}}{it:varlist} from {cmd:over()}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}vector of proportion estimates{p_end}
{synopt:{cmd:e(V)}}(co)variance estimates{p_end}
{synopt:{cmd:e(_N)}}vector of numbers of nonmissing observations{p_end}
{synopt:{cmd:e(_N_stdsum)}}number of nonmissing observations within the
standard strata{p_end}
{synopt:{cmd:e(_p_stdize)}}standardizing proportions{p_end}
{synopt:{cmd:e(freq)}}vector of frequency estimates{p_end}
{synopt:{cmd:e(error)}}error code corresponding to {cmd:e(b)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
