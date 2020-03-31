{smcl}
{* *! version 1.1.23  23jan2019}{...}
{viewerdialog mean "dialog mean"}{...}
{viewerdialog "svy: mean" "dialog mean, message(-svy-) name(svy_mean)"}{...}
{vieweralsosee "[R] mean" "mansection R mean"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mean postestimation" "help mean postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ameans" "help ameans"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "[R] ratio" "help ratio"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] total" "help total"}{...}
{viewerjumpto "Syntax" "mean##syntax"}{...}
{viewerjumpto "Menu" "mean##menu"}{...}
{viewerjumpto "Description" "mean##description"}{...}
{viewerjumpto "Links to PDF documentation" "mean##linkspdf"}{...}
{viewerjumpto "Options" "mean##options"}{...}
{viewerjumpto "Examples" "mean##examples"}{...}
{viewerjumpto "Video example" "mean##video"}{...}
{viewerjumpto "Stored results" "mean##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] mean} {hline 2}}Estimate means{p_end}
{p2col:}({mansection R mean:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:mean} {varlist} {ifin}
[{it:{help mean##weight:weight}}]
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
{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{it:{help mean##display_options:display_options}}}control
column formats, line width, display of omitted variables and base and empty
cells, and factor-variable labeling{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:jackknife}, {cmd:mi estimate}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp mean_postestimation R:mean postestimation} for features available
after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Summary and descriptive statistics > Means}


{marker description}{...}
{title:Description}

{pstd}
{opt mean} produces estimates of means, along with standard errors.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R meanQuickstart:Quick start}

        {mansection R meanRemarksandexamples:Remarks and examples}

        {mansection R meanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth stdize(varname)}
specifies that the point estimates be adjusted by direct standardization
across the strata identified by {it:varname}.  This option requires the
{opt stdweight()} option.

{phang}
{opth stdweight(varname)}
specifies the weight variable associated with the standard strata identified
in the {opt stdize()} option.  The standardization weights must be constant
within the standard strata.

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
estimator associated with the sample mean.

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
The following option is available with {opt mean} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fuel}{p_end}

{pstd}Estimate the average mileage of the cars without the fuel treatment
({cmd:mpg1}) and those with the fuel treatment ({cmd:mpg2}){p_end}
{phang2}{cmd:. mean mpg1 mpg2}{p_end}

{pstd}Stack {cmd:mpg1} on top of {cmd:mpg2}, creating {cmd:mpg}{p_end}
{phang2}{cmd:. stack mpg1 mpg2, into(mpg) clear}{p_end}

{pstd}Summarize {cmd:mpg} by type{p_end}
{phang2}{cmd:. mean mpg, over(_stack)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp, clear}{p_end}

{pstd}Stratify sample by {cmd:age}, {cmd:race}, and {cmd:sex}{p_end}
{phang2}{cmd:. egen strata = group(age race sex) if inlist(year, 1990, 1992)}
{p_end}

{pstd}Create standardization weight equal to sample size for each stratum{p_end}
{phang2}{cmd:. by strata, sort: gen stdw=_N}{p_end}

{pstd}Compute standardized mean using the observed distribution of {cmd:age},
{cmd:race}, and {cmd:sex} as the standard{p_end}
{phang2}{cmd:. mean hbp, over(city year) stdize(strata) stdweight(stdw)}{p_end}

    {hline}
    Setup
         {cmd:. webuse highschool, clear}

{pstd}Estimate a population mean using survey data{p_end}
{phang2}{cmd:. svy: mean weight}

{pstd}Estimate mean of {cmd:weight} for each subpopulation identified by
{cmd:sex}{p_end}
{phang2}{cmd:. svy: mean weight, over(sex)}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=kKFbnEWwa2s":Descriptive statistics in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mean} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(cmd)}}{cmd:mean}{p_end}
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
{synopt:{cmd:e(b)}}vector of mean estimates{p_end}
{synopt:{cmd:e(V)}}(co)variance estimates{p_end}
{synopt:{cmd:e(sd)}}vector of standard deviation estimates{p_end}
{synopt:{cmd:e(_N)}}vector of numbers of nonmissing observations{p_end}
{synopt:{cmd:e(_N_stdsum)}}number of nonmissing observations within the
standard strata{p_end}
{synopt:{cmd:e(_p_stdize)}}standardizing proportions{p_end}
{synopt:{cmd:e(error)}}error code corresponding to {cmd:e(b)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
