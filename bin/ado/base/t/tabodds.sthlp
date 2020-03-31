{smcl}
{* *! version 1.2.5  15may2018}{...}
{viewerdialog tabodds "dialog tabodds"}{...}
{vieweralsosee "[R] Epitab" "mansection R Epitab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "tabodds##syntax"}{...}
{viewerjumpto "Menu" "tabodds##menu"}{...}
{viewerjumpto "Description" "tabodds##description"}{...}
{viewerjumpto "Links to PDF documentation" "tabodds##linkspdf"}{...}
{viewerjumpto "Options" "tabodds##options"}{...}
{viewerjumpto "Examples" "tabodds##examples"}{...}
{viewerjumpto "Stored results" "tabodds##results"}{...}
{viewerjumpto "References" "tabodds##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] Epitab} {hline 2}}Tables for epidemiologists (tabodds)
{p_end}
{p2col:}({mansection R Epitab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:tabodds} {it:var_case} [{it:expvar}] {ifin}
[{it:{help tabodds##weight:weight}}]
[{cmd:,} {it:{help tabodds##tabodds_options:tabodds_options}}]

{synoptset 21 tabbed}{...}
{marker tabodds_options}{...}
{synopthdr :tabodds_options}
{synoptline}
{syntab:Main}
{synopt :{opth b:inomial(varname)}}number of subjects variable{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratio{p_end}
{synopt :{opth adj:ust(varlist)}}report odds ratios adjusted for the variables in {it:varlist}{p_end}
{synopt :{opt base(#)}}reference group of control variable for odds ratio{p_end}
{synopt :{opt co:rnfield}}use Cornfield approximation to calculate CI of the odds ratio{p_end}
{synopt :{opt w:oolf}}use Woolf approximation to calculate SE and CI of the odds ratio{p_end}
{synopt :{opt g:raph}}graph odds against categories{p_end}
{synopt :{opt ci:plot}}same as {opt graph} option, except include confidence intervals{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(rcap_options)}}affect rendition of the confidence bands{p_end}

{syntab:Plot}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt :{it:{help marker_label_options}}}add marker labels; change look or position{p_end}
{synopt :{it:{help cline_options}}}affect rendition of the plotted points{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
    {bf:Tabulate odds of failure by category}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tabodds} is used with case-control and cross-sectional data. It
tabulates the odds of failure against a categorical explanatory variable
{it:expvar}.  If {it:expvar} is specified, {cmd:tabodds} performs an
approximate chi-squared test of homogeneity of odds and a test for linear trend
of the log odds against the numerical code used for the categories of
{it:expvar}.  Both tests are based on the score statistic and its variance;
see {mansection R EpitabMethodsandformulas:{it:Methods and formulas}}.
When {it:expvar} is absent, the overall odds are reported.  The variable
{it:var_case} is coded 0/1 for individual and simple frequency records and
equals the number of cases for binomial frequency records.

{pstd}
Optionally, {cmd:tabodds} tabulates adjusted or unadjusted odds ratios,
using either the lowest levels of {it:expvar} or a user-defined level as the
reference group.  If {opth adjust(varlist)} is specified, it produces odds 
ratios adjusted for the variables in {it:varlist} along with a (score) test 
for trend.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R EpitabQuickstart:Quick start}

        {mansection R EpitabRemarksandexamples:Remarks and examples}

        {mansection R EpitabMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth binomial(varname)} supplies the 
number of subjects (cases plus controls) for binomial frequency records.  For 
individual and simple frequency records, this option is not used.

{phang}
{opt level(#)} specifies the confidence level, as a 
percentage, for confidence intervals.  The default is {cmd:level(95)} or as 
set by {helpb set level}.

{phang}
{opt or} specifies that odds ratios be produced; see {opt base()}
for details about selecting a reference category.  By default, {cmd:tabodds} 
will calculate odds.

{phang}
{opth adjust(varlist)} specifies that odds ratios adjusted for 
the variables in {it:varlist} be calculated.

{phang}
{opt base(#)} specifies that the {it:#}th category of 
{it:expvar} be used as the reference group for calculating odds ratios.  If 
{opt base()} is not specified, the first category, corresponding to the 
minimum value of {it:expvar}, is used as the reference group.

{phang}
{opt cornfield} requests that the 
{help tabodds##C1956:Cornfield (1956)} approximation be used to calculate the
confidence interval of the odds ratio.  By default, {cmd:tabodds} reports a
standard-error-based interval, with the standard error coming from the square
root of the variance of the score statistic.

{phang}
{opt woolf} requests that the
{help tabodds##W1955:Woolf (1955)} approximation, also known as the Taylor
expansion, be used for calculating the standard error and confidence interval
for the odds ratio.  By default, {cmd:tabodds} reports a standard-error-based
interval, with the standard error coming from the square root of the variance
of the score statistic.

{phang}
{opt graph} produces a graph of
the odds against the numerical code used for the categories of {it:expvar}.
All graph options except {opt connect()} are allowed.  This option is not 
allowed with either the {opt or} option or the {opt adjust()} option.

{phang}
{opt ciplot} produces the same
plot as the {opt graph} option, except that it also includes the confidence
intervals.  This option may not be used with either the {opt or} option or the
{opt adjust()} option.

{dlgtab:CI plot}

{marker ciopts()}{...}
{phang}
{opt ciopts(rcap_options)} is allowed only with the 
{opt ciplot} option.  It affects the rendition of the confidence bands;
see {manhelpi rcap_options G-3}.

{dlgtab:Plot}

{phang}
{it:marker_options} affect the rendition of markers drawn at
the plotted points, including their shape, size, color, and outline; see 
{manhelpi marker_options G-3}.

{phang}
{it:marker_label_options} specify if and how the markers are
to be labeled; see {manhelpi marker_label_options G-3}.

{phang}
{it:cline_options} affect whether lines connect the
plotted points and the rendition of those lines; see
{manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the 
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bdesop}

{pstd}Tabulate the odds of cancer against alcohol consumption{p_end}
{phang2}{cmd:. tabodds case alcohol [fw=freq]}

{pstd}Same as above, but report odds ratios rather than odds{p_end}
{phang2}{cmd:. tabodds case alcohol [fw=freq], or}

{pstd}Tabulate Mantel-Haenszel age-adjusted odds ratios{p_end}
{phang2}{cmd:. tabodds case alcohol [fw=freq], adjust(age)}

{pstd}Same as above, but adjust for tobacco use instead of age{p_end}
{phang2}{cmd:. tabodds case alcohol [fw=freq], adjust(tobacco)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tabodds} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(odds)}}odds{p_end}
{synopt:{cmd:r(lb_odds)}}lower bound for {cmd:odds}{p_end}
{synopt:{cmd:r(ub_odds)}}upper bound for {cmd:odds}{p_end}
{synopt:{cmd:r(chi2_hom)}}chi-squared test of homogeneity{p_end}
{synopt:{cmd:r(p_hom)}}p-value for test of homogeneity{p_end}
{synopt:{cmd:r(df_hom)}}degrees of freedom for chi-squared test of
	homogeneity{p_end}
{synopt:{cmd:r(chi2_tr)}}chi-squared for score test for trend{p_end}
{synopt:{cmd:r(p_trend)}}p-value for score test for trend{p_end}


{marker references}{...}
{title:References}

{marker C1956}{...}
{phang}
Cornfield, J. 1956. A statistical problem arising from retrospective studies.
In Vol. 4 of {it:Proceedings of the Third Berkeley Symposium}, ed.
J. Neyman, 135-148. Berkeley, CA: University of California Press.

{marker W1955}{...}
{phang}
Woolf, B. 1955. On estimating the relation between blood group disease.
{it:Annals of Human Genetics} 19: 251-253.
Reprinted in
{it:Evolution of Epidemiologic Ideas: Annotated Readings on Concepts and Methods},
ed. S. Greenland, pp. 108-110. Newton Lower Falls, MA: Epidemiology Resources.
{p_end}
