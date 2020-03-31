{smcl}
{* *! version 1.1.25  23jan2019}{...}
{viewerdialog total "dialog total"}{...}
{viewerdialog "svy: total" "dialog total, message(-svy-) name(svy_total)"}{...}
{vieweralsosee "[R] total" "mansection R total"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] total postestimation" "help total postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "[R] ratio" "help ratio"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi_estimation"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "total##syntax"}{...}
{viewerjumpto "Menu" "total##menu"}{...}
{viewerjumpto "Description" "total##description"}{...}
{viewerjumpto "Links to PDF documentation" "total##linkspdf"}{...}
{viewerjumpto "Options" "total##options"}{...}
{viewerjumpto "Example" "total##example"}{...}
{viewerjumpto "Stored results" "total##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] total} {hline 2}}Estimate totals{p_end}
{p2col:}({mansection R total:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:total} {varlist} {ifin}
[{it:{help total##weight:weight}}]
[{cmd:,} {it:options}]


{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:if/in/over}
{synopt :{cmd:over(}{it:{help varlist:varlist_o}}{cmd:)}}group over
subpopulations defined by {it:varlist_o}{p_end}

{syntab:SE/Cluster}
{synopt :{opth vce(vcetype)}}{it:vcetype}
	may be {opt analytic}, {opt cl:uster} {it:clustvar}, {opt boot:strap},
	or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{it:{help total##display_options:display_options}}}control
column formats, line width, display of omitted variables and base and empty
cells, and factor-variable labeling{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:jackknife}, {cmd:mi estimate}, {cmd:rolling}, {cmd:statsby},
and {cmd:svy} are allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp total_postestimation R:total postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Summary and descriptive statistics > Totals}


{marker description}{...}
{title:Description}

{pstd}
{opt total} produces estimates of totals, along with standard errors.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R totalQuickstart:Quick start}

        {mansection R totalRemarksandexamples:Remarks and examples}

        {mansection R totalMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

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
{manhelpi vce_option R}.

{pmore}
{cmd:vce(analytic)}, the default, uses the analytically derived variance
estimator associated with the sample total.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

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
The following option is available with {opt total} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse total}{p_end}

{pstd}Estimate totals over values of {cmd:sex}, using {cmd:swgt} as
{cmd:pweight}s{p_end}
{phang2}{cmd:. total heartatk [pw=swgt], over(sex)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:total} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_over)}}number of subpopulations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(df_r)}}sample degrees of freedom{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:total}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(varlist)}}{it:varlist}{p_end}
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
{synopt:{cmd:e(b)}}vector of total estimates{p_end}
{synopt:{cmd:e(V)}}(co)variance estimates{p_end}
{synopt:{cmd:e(_N)}}vector of numbers of nonmissing observations{p_end}
{synopt:{cmd:e(error)}}error code corresponding to {cmd:e(b)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
