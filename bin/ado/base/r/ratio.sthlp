{smcl}
{* *! version 1.2.14  23jan2019}{...}
{viewerdialog ratio "dialog ratio"}{...}
{viewerdialog "svy: ratio" "dialog ratio, message(-svy-) name(svy_ratio)"}{...}
{vieweralsosee "[R] ratio" "mansection R ratio"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ratio postestimation" "help ratio postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] total" "help total"}{...}
{viewerjumpto "Syntax" "ratio##syntax"}{...}
{viewerjumpto "Menu" "ratio##menu"}{...}
{viewerjumpto "Description" "ratio##description"}{...}
{viewerjumpto "Links to PDF documentation" "ratio##linkspdf"}{...}
{viewerjumpto "Options" "ratio##options"}{...}
{viewerjumpto "Examples" "ratio##examples"}{...}
{viewerjumpto "Stored results" "ratio##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] ratio} {hline 2}}Estimate ratios{p_end}
{p2col:}({mansection R ratio:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 17 2}
{cmd:ratio} [{it:name}{cmd::}] {varname} [{cmd:/}] {varname}


{phang}
Full syntax

{p 8 13 2}
{cmd:ratio} {cmd:(}[{it:name}{cmd::}] {varname} [{cmd:/}] 
   {varname}{cmd:)}{break}
      [{cmd:(}[{it:name}{cmd::}] {varname} [{cmd:/}] {varname}{cmd:)} ...]
 	{ifin} 
        [{it:{help ratio##weight:weight}}]
	[{cmd:,} {it:options}]


{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth std:ize(varname)}}variable identifying strata for standardization{p_end}
{synopt :{opth stdw:eight(varname)}}weight variable for standardization{p_end}
{synopt :{opt nostdr:escale}}do not rescale the standard weight variable{p_end}

{syntab:if/in/over}
{synopt :{opth over(varlist)}}group over subpopulations defined by {it:varlist}{p_end}

{syntab:SE/Cluster}
{synopt :{opth vce(vcetype)}}{it:vcetype}
	may be {opt linear:ized}, {opt cl:uster} {it:clustvar},
	{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{opt nol:egend}}suppress table legend{p_end}
{synopt :{it:{help ratio##display_options:display_options}}}control
column formats, line width, display of empty cells, and factor-variable labeling{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:bootstrap}, {cmd:jackknife}, {cmd:mi estimate}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp ratio_postestimation R:ratio postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Summary and descriptive statistics > Ratios}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ratio} produces estimates of ratios, along with standard errors.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ratioQuickstart:Quick start}

        {mansection R ratioRemarksandexamples:Remarks and examples}

        {mansection R ratioMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth stdize(varname)} specifies that the point estimates be adjusted by
direct standardization across the strata identified by {it:varname}.  This
option requires the {opt stdweight()} option.

{phang}
{opth stdweight(varname)} specifies the weight variable associated with the
standard strata identified in the {opt stdize()} option.  The standardization
weights must be constant within the standard strata.

{phang}
{opt nostdrescale} prevents the standardization weights from being rescaled
within the {opt over()} groups.  This option requires {opt stdize()} but is
ignored if the {opt over()} option is not specified.

{dlgtab:if/in/over}

{phang}
{opth over(varlist)}
specifies that estimates be computed for multiple subpopulations,
which are identified by the different values of the variables in 
{it:varlist}.  Only numeric, nonnegative, integer-valued variables are allowed
in {opt over(varlist)}.

{dlgtab:SE/Cluster}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which 
includes types that are derived from asymptotic theory ({cmd:linearized}),
that allow for intragroup correlation ({cmd:cluster} {it:clustvar}), and that
use bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{manhelpi vce_option R}.

{pmore}
{cmd:vce(linearized)}, the default, uses the linearized or sandwich estimator
of variance.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt noheader} prevents the table header from being displayed. This option
implies {opt nolegend}.

{phang}
{opt nolegend} prevents the table legend identifying the ratios from
being displayed.
{p_end}

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt noempty:cells},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{pstd}
The following option is available with {opt ratio} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fuel}{p_end}

{pstd}Estimate ratio of {cmd:mpg1} to {cmd:mpg2} and call it
{cmd:myratio}{p_end}
{phang2}{cmd:. ratio myratio: mpg1/mpg2}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse census2}{p_end}

{pstd}Estimate ratio of {cmd:death} to {cmd:pop} and ratio of {cmd:marriage}
to {cmd:pop} and call the ratios {cmd:deathrate} and {cmd:marrate},
respectively{p_end}
{phang2}{cmd:. ratio (deathrate: death/pop) (marrate: marriage/pop)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse highschool}{p_end}
{phang2}{cmd:. svyset}

{pstd}Estimate height-weight ratio{p_end}
{phang2}{cmd:. svy: ratio height/weight}

{pstd}Estimate race- and gender-specific height-weight ratios{p_end}
{phang2}{cmd:. svy: ratio height/weight, over(race sex)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ratio} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(cmd)}}{cmd:ratio}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(varlist)}}{it:varlist}{p_end}
{synopt:{cmd:e(stdize)}}{it:varname} from {cmd:stdize()}{p_end}
{synopt:{cmd:e(stdweight)}}{it:varname} from {cmd:stdweight()}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(over)}}{it:varlist} from {cmd:over()}{p_end}
{synopt:{cmd:e(namelist)}}ratio identifiers{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}vector of ratio estimates{p_end}
{synopt:{cmd:e(V)}}(co)variance estimates{p_end}
{synopt:{cmd:e(_N)}}vector of numbers of nonmissing observations{p_end}
{synopt:{cmd:e(_N_stdsum)}}number of nonmissing observations within the
standard strata{p_end}
{synopt:{cmd:e(_p_stdize)}}standardizing proportions{p_end}
{synopt:{cmd:e(error)}}error code corresponding to {cmd:e(b)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
