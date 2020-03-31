{smcl}
{* *! version 1.1.11  18feb2020}{...}
{viewerdialog spearman "dialog spearman"}{...}
{viewerdialog "ktau" "dialog ktau"}{...}
{vieweralsosee "[R] spearman" "mansection R spearman"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[R] nptrend" "help nptrend"}{...}
{viewerjumpto "Syntax" "spearman##syntax"}{...}
{viewerjumpto "Menu" "spearman##menu"}{...}
{viewerjumpto "Description" "spearman##description"}{...}
{viewerjumpto "Links to PDF documentation" "spearman##linkspdf"}{...}
{viewerjumpto "Options for spearman" "spearman##options_spearman"}{...}
{viewerjumpto "Options for ktau" "spearman##options_ktau"}{...}
{viewerjumpto "Examples" "spearman##examples"}{...}
{viewerjumpto "Stored results" "spearman##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] spearman} {hline 2}}Spearman's and Kendall's
correlations{p_end}
{p2col:}({mansection R spearman:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Spearman's rank correlation coefficients

{p 8 17 2}
{cmd:spearman}
[{varlist}]
{ifin}
[{cmd:,} {it:{help spearman##spearman_options:spearman_options}}]


{phang}
Kendall's rank correlation coefficients

{p 8 13 2}
{cmd:ktau}
[{varlist}]
{ifin}
[{cmd:,} {it:{help spearman##ktau_options:ktau_options}}]


{marker spearman_options}{...}
{synoptset 24 tabbed}{...}
{synopthdr:spearman_options}
{synoptline}
{syntab:Main}
{synopt:{cmd:stats(}{it:{help spearman##spearman_list:spearman_list}}{cmd:)}}list
of statistics; select up to three statistics; default is {cmd:stats(rho)}{p_end}
{synopt:{opt p:rint(#)}}significance level for displaying coefficients{p_end}
{synopt:{opt st:ar(#)}}significance level for displaying with a star{p_end}
{synopt:{opt b:onferroni}}use Bonferroni-adjusted significance level{p_end}
{synopt:{opt sid:ak}}use Sidak-adjusted significance level{p_end}
{synopt:{opt pw}}calculate all pairwise correlation coefficients by using
all available data{p_end}
{synopt:{opt mat:rix}}display output in matrix form{p_end}
{synoptline}

{marker ktau_options}{...}
{synopthdr:ktau_options}
{synoptline}
{syntab:Main}
{synopt:{cmd:stats(}{it:{help spearman##ktau_list:ktau_list}}{cmd:)}}list
of statistics; select up to six statistics; default is {cmd:stats(taua)}{p_end}
{synopt:{opt p:rint(#)}}significance level for displaying coefficients{p_end}
{synopt:{opt st:ar(#)}}significance level for displaying with a star{p_end}
{synopt:{opt b:onferroni}}use Bonferroni-adjusted significance level{p_end}
{synopt:{opt sid:ak}}use Sidak-adjusted significance level{p_end}
{synopt:{opt pw}}calculate all pairwise correlation coefficients by using
all available data{p_end}
{synopt:{opt mat:rix}}display output in matrix form{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed with {opt spearman} and {opt ktau};
see {manhelp by D}.{p_end}

{p 4 6 2}
{marker spearman_list}{...}
where the elements of {it:spearman_list} may be

{p 8 25 2}{cmd:rho}{space 5} correlation coefficient{p_end}
{p 8 25 2}{cmd:obs}{space 5} number of observations{p_end}
{p 8 25 2}{cmd:p}{space 7} significance level

{p 6 6 2}
{marker ktau_list}{...}
and the elements of {it:ktau_list} may be

{p 8 25 2}{cmd:taua}{space 4} correlation coefficient tau_a{p_end}
{p 8 25 2}{cmd:taub}{space 4} correlation coefficient tau_b{p_end}
{p 8 25 2}{cmd:score}{space 3} score{p_end}
{p 8 25 2}{cmd:se}{space 6} standard error of score{p_end}
{p 8 25 2}{cmd:obs}{space 5} number of observations{p_end}
{p 8 25 2}{cmd:p}{space 7} significance level 


{marker menu}{...}
{title:Menu}

    {title:spearman}

{phang2}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
        {bf:Spearman's rank correlation}

    {title:ktau}

{phang2}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
        {bf:Kendall's rank correlation}


{marker description}{...}
{title:Description}

{pstd}
{opt spearman} displays Spearman's rank correlation coefficients for all pairs
  of variables in {varlist} or, if {it:varlist} is not specified, for all the
  variables in the dataset.

{pstd}
{opt ktau} displays Kendall's rank correlation coefficients between
  the variables in {it:varlist} or, if {it:varlist} is not specified, for all
  the variables in the dataset.  {opt ktau} is intended for use on small- and
  moderate-sized datasets; it requires considerable computation time for
  larger datasets.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R spearmanQuickstart:Quick start}

        {mansection R spearmanRemarksandexamples:Remarks and examples}

        {mansection R spearmanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_spearman}{...}
{title:Options for spearman}

{dlgtab:Main}

{phang}
{cmd:stats(}{it:{help spearman##spearman_list:spearman_list}}{cmd:)}
  specifies the statistics to be displayed in the matrix of output.
  {cmd:stats(rho)} is the default.  Up to three statistics may be specified;
  {cmd:stats(rho obs p)} would display the correlation coefficient, 
  number of observations, and significance level.  If {varlist} contains
  only two variables, all statistics are shown in tabular form, and 
  {cmd:stats()}, {cmd:print()}, and {cmd:star()} have no effect unless the
  {cmd:matrix} option is specified.

{phang}
{opt print(#)} specifies the significance level of correlation coefficients to
  be printed.  Correlation coefficients with larger significance levels are left
  blank in the matrix.  Typing {cmd:spearman, print(.10)} would list only those
  correlation coefficients that are significant at the 10% level or lower.

{phang}
{opt star(#)} specifies the significance level of correlation coefficients to
  be marked with a star.  Typing {cmd:spearman, star(.05)} would "star" all
  correlation coefficients significant at the 5% level or lower.

{phang}
{opt bonferroni} makes the Bonferroni adjustment to calculated significance
  levels.  This adjustment affects printed significance levels and the
  {opt print()} and {opt star()} options.  Thus,
  {cmd:spearman, print(.05) bonferroni} prints coefficients with
  Bonferroni-adjusted significance levels of 0.05 or less.

{phang}
{opt sidak} makes the Sidak adjustment to calculated significance
  levels.  This adjustment affects printed significance levels and the
  {opt print()} and {opt star()} options.  Thus,
  {cmd:spearman, print(.05) sidak} prints coefficients with Sidak-adjusted
  significance levels of 0.05 or less.

{phang}
{opt pw} specifies that correlations be calculated using pairwise
  deletion of observations with missing values.  By default, {opt spearman}
  uses casewise deletion, where observations are ignored if any of
  the variables in {varlist} are missing.

{phang}
{opt matrix} forces {cmd:spearman} to display the statistics as a matrix, 
even if {varlist} contains only two variables.  {cmd:matrix} is 
implied if more than two variables are specified.


{marker options_ktau}{...}
{title:Options for ktau}

{dlgtab:Main}

{phang}
{cmd:stats(}{it:{help spearman##ktau_list:ktau_list}}{cmd:)}
specifies the statistics to be displayed in the matrix of output.  
{cmd:stats(tau)} is the default.  Up to six statistics may be specified;
{cmd:stats(taua taub score se obs p)} would display the correlation
coefficients tau_a, tau_b, score, standard error of score, number of
observations, and significance level.  If {varlist} contains only two
variables, all statistics are shown in tabular form and {cmd:stats()},
{cmd:print()}, and {cmd:star()} have no effect unless the {cmd:matrix} option
is specified.

{phang}
{opt print(#)} specifies the significance level of correlation coefficients to
  be printed.  Correlation coefficients with larger significance levels are left
  blank in the matrix.  Typing {cmd:ktau, print(.10)} would list only those
  correlation coefficients that are significant at the 10% level or lower.

{phang}
{opt star(#)} specifies the significance level of correlation coefficients to
  be marked with a star.  Typing {cmd:ktau, star(.05)} would "star" all
  correlation coefficients significant at the 5% level or lower.

{phang}
{opt bonferroni} makes the Bonferroni adjustment to calculated significance
  levels.  This adjustment affects printed significance levels and the
  {opt print()} and {opt star()} options.  Thus,
  {cmd:ktau, print(.05) bonferroni} prints coefficients with
  Bonferroni-adjusted significance levels of 0.05 or less.

{phang}
{opt sidak} makes the Sidak adjustment to calculated significance levels.
This adjustment affects printed significance levels and the {opt print()} and
{opt star()} options.  Thus, {cmd:ktau, print(.05) sidak} prints coefficients
with Sidak-adjusted significance levels of 0.05 or less.

{phang}
{opt pw} specifies that correlations be calculated using pairwise
  deletion of observations with missing values.  By default, {opt ktau}
  uses casewise deletion, where observations are ignored if any of
  the variables in {varlist} are missing.

{phang}
{opt matrix} forces {cmd:ktau} to display the statistics as a matrix, even if
{varlist} contains only two variables.  {cmd:matrix} is implied
if more than two variables are specified.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse states2}{p_end}

{pstd}Spearman's rank correlation coefficients; correlation coefficients
displayed by default{p_end}
{phang2}{cmd:. spearman mrgrate divorce_rate medage}{p_end}

{pstd}Spearman's rank correlation coefficients; correlation coefficients
and significance levels displayed{p_end}
{phang2}{cmd:. spearman mrgrate divorce_rate medage, stats(rho p)}{p_end}

{pstd}Kendall's rank correlations; tau_a, tau_b, and significance levels
displayed{p_end}
{phang2}{cmd:. ktau mrgrate divorce_rate medage, stats(taua taub p)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Two variables; output displayed in tabular form by default{p_end}
{phang2}{cmd:. spearman mpg rep78}{p_end}

{pstd}Two variables; output displayed in matrix form{p_end}
{phang2}{cmd:. spearman mpg rep78, matrix}{p_end}

{pstd}Use all nonmissing observations between a pair of variables{p_end}
{phang2}{cmd:. spearman mpg price rep78, pw}{p_end}

{pstd}Star all correlation coefficients significant at the 5% level or lower
{p_end}
{phang2}{cmd:. spearman mpg price rep78, pw star(.05)}{p_end}

{pstd}Kendall's rank correlations; tau_a, tau_b, score, standard error of
score, and Bonferroni-adjusted significance level displayed{p_end}
{phang2}{cmd:. ktau mpg price rep78, stats(taua taub score se p) bonferroni}
{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spearman} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations (last variable pair){p_end}
{synopt:{cmd:r(rho)}}rho (last variable pair){p_end}
{synopt:{cmd:r(p)}}two-sided p-value (last variable pair){p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Nobs)}}number of observations{p_end}
{synopt:{cmd:r(Rho)}}rho{p_end}
{synopt:{cmd:r(P)}}two-sided p-value{p_end}

{pstd}
{cmd:ktau} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations (last variable pair){p_end}
{synopt:{cmd:r(tau_a)}}tau_a (last variable pair){p_end}
{synopt:{cmd:r(tau_b)}}tau_b (last variable pair){p_end}
{synopt:{cmd:r(score)}}Kendall's score (last variable pair){p_end}
{synopt:{cmd:r(se_score)}}standard error of score (last variable pair){p_end}
{synopt:{cmd:r(p)}}two-sided p-value (last variable pair){p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Nobs)}}number of observations{p_end}
{synopt:{cmd:r(Tau_a)}}tau_a{p_end}
{synopt:{cmd:r(Tau_b)}}tau_b{p_end}
{synopt:{cmd:r(Score)}}Kendall's score{p_end}
{synopt:{cmd:r(Se_Score)}}standard error of score{p_end}
{synopt:{cmd:r(P)}}two-sided p-value{p_end}
{p2colreset}{...}
