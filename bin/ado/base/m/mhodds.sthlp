{smcl}
{* *! version 1.2.5  18feb2020}{...}
{viewerdialog mhodds "dialog mhodds"}{...}
{vieweralsosee "[R] Epitab" "mansection R Epitab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "mhodds##syntax"}{...}
{viewerjumpto "Menu" "mhodds##menu"}{...}
{viewerjumpto "Description" "mhodds##description"}{...}
{viewerjumpto "Links to PDF documentation" "mhodds##linkspdf"}{...}
{viewerjumpto "Options" "mhodds##options"}{...}
{viewerjumpto "Examples" "mhodds##examples"}{...}
{viewerjumpto "Stored results" "mhodds##results"}{...}
{viewerjumpto "Reference" "mhodds##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] Epitab} {hline 2}}Tables for epidemiologists (mhodds){p_end}
{p2col:}({mansection R Epitab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:mhodds} {it:var_case} {it:expvar} [{it:vars_adjust}]
{ifin}
[{it:{help mhodds##weight:weight}}]
[{cmd:,} {it:{help mhodds##mhodds_options:mhodds_options}}]

{synoptset 24 tabbed}{...}
{marker mhodds_options}{...}
{synopthdr :mhodds_options}
{synoptline}
{syntab:Options}
{synopt :{cmd:by(}{varlist} [{cmd:,} {opt mis:sing}]{cmd:)}}stratify on {it:varlist}{p_end}
{synopt :{opth b:inomial(varname)}}number of subjects variable{p_end}
{synopt :{opt c:ompare(v_1, v_2)}}override categories of the control variable{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
      {bf:Ratio of odds of failure for two categories}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mhodds} is used with case-control and cross-sectional data. It estimates
the ratio of the odds of failure for two categories of {it:expvar}, controlled
for specified confounding variables, {it:vars_adjust}, and tests whether 
this odds ratio is equal to one.  When {it:expvar} has more than two categories
but none are specified with the {opt compare()} option, {cmd:mhodds} assumes
that {it:expvar} is a quantitative variable and calculates a
1-degree-of-freedom test for trend.  It also calculates an approximate
estimate of the log odds-ratio for a one-unit increase in {it:expvar}. This is a
one-step Newton-Raphson approximation to the maximum likelihood estimate
calculated as the ratio of the score statistic, {it:U}, to its variance,
{it:V} ({help mhodds##CH1993:Clayton and Hills 1993, 103}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R EpitabQuickstart:Quick start}

        {mansection R EpitabRemarksandexamples:Remarks and examples}

        {mansection R EpitabMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{cmd:by(}{varlist} [{cmd:,} {opt missing}]{cmd:)} specifies that the tables be
stratified on {it:varlist}.  Missing categories in {it:varlist} are omitted
from the stratified analysis, unless option {cmd:missing} is specified within
{cmd:by()}.  Within-stratum statistics are shown and then combined with
Mantel-Haenszel weights.

{phang}
{opth binomial(varname)} supplies the 
number of subjects (cases plus controls) for binomial frequency records.  For 
individual and simple frequency records, this option is not used.

{phang}
{opt compare(v_1,v_2)} indicates the categories of {it:expvar} to
be compared; {it:v_1} defines the numerator and {it:v_2}, the denominator.  
When {opt compare()} is not specified and there are only two categories, the
second is compared with the first; when there are more than two categories, an
approximate estimate of the odds ratio for a unit increase in {it:expvar},
controlled for specified confounding variables, is given.

{phang}
{opt level(#)} specifies the confidence level, as a 
percentage, for confidence intervals.  The default is {cmd:level(95)} or as 
set by {helpb set level}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bdesop}

{pstd}Calculate the odds ratio for the effect of alcohol controlled for
age{p_end}
{phang2}{cmd:. mhodds case alcohol agegrp [fw=freq]}

{pstd}Same as above, but perform the calculation by levels of tobacco
consumption{p_end}
{phang2}{cmd:. mhodds case alcohol agegrp [fw=freq], by(tobacco)}

{pstd}Calculate the odds ratio for the effect of tobacco controlled for age by
levels of alcohol consumption{p_end}
{phang2}{cmd:. mhodds case tobacco agegrp [fw=freq], by(alcohol)}

{pstd}Create a new variable with levels corresponding to all combinations of
alcohol and tobacco consumption{p_end}
{phang2}{cmd:. egen alctob = group(alcohol tobacco)}

{pstd}Calculate the odds ratio for the effect of the highest level of alcohol
and tobacco consumption versus the lowest{p_end}
{phang2}{cmd:. mhodds case alctob [fw=freq], compare(16,1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mhodds} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(or)}}odds ratio{p_end}
{synopt:{cmd:r(lb_or)}}lower bound of CI for {cmd:or}{p_end}
{synopt:{cmd:r(ub_or)}}upper bound of CI for {cmd:or}{p_end}
{synopt:{cmd:r(chi2_hom)}}chi-squared test of homogeneity{p_end}
{synopt:{cmd:r(df_hom)}}degrees of freedom for chi-squared test of
	homogeneity{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}


{marker reference}{...}
{title:Reference}

{marker CH1993}{...}
{phang}
Clayton, D. G., and M. Hills. 1993.
{browse "http://www.stata.com/bookstore/sme.html":{it:Statistical Models in Epidemiology}}.
Oxford: Oxford University Press.
{p_end}
