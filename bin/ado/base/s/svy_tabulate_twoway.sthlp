{smcl}
{* *! version 1.1.23  03apr2019}{...}
{viewerdialog "svy: tabulate twoway" "dialog svy_tabulate_twoway"}{...}
{vieweralsosee "[SVY] svy tabulate twoway" "mansection SVY svytabulatetwoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy: tabulate oneway" "help svy_tabulate_oneway"}{...}
{vieweralsosee "[SVY] svydescribe" "help svydescribe"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "svy_tabulate_twoway##syntax"}{...}
{viewerjumpto "Menu" "svy_tabulate_twoway##menu"}{...}
{viewerjumpto "Description" "svy_tabulate_twoway##description"}{...}
{viewerjumpto "Options" "svy_tabulate_twoway##options"}{...}
{viewerjumpto "Examples" "svy_tabulate_twoway##examples"}{...}
{viewerjumpto "Stored results" "svy_tabulate_twoway##results"}{...}
{viewerjumpto "References" "svy_tabulate_twoway##references"}{...}
{p2colset 1 31 33 2}{...}
{p2col :{bf:[SVY] svy: tabulate twoway} {hline 2}}Two-way tables
for survey data{p_end}
{p2col:}({mansection SVY svytabulatetwoway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{phang2}
{cmd:svy}{cmd::} {cmdab:tab:ulate} {varname:1} {varname:2}


{pstd}
Full syntax

{phang2}
{cmd:svy} [{it:vcetype}] [{cmd:,} {it:{help svy_tabulate_twoway##svy_options:svy_options}}]
{cmd::} {cmdab:tab:ulate} {varname:1} {varname:2} {ifin}
[{cmd:,}
{it:{help "svy: tabulate twoway##tabulate_options":tabulate_options}}
{it:{help "svy: tabulate twoway##display_items":display_items}}
{it:{help "svy: tabulate twoway##display_options":display_options}}
{it:{help "svy: tabulate twoway##statistic_options":statistic_options}}]


{pstd}
Syntax to report results

{phang2}
{cmd:svy} [{cmd:,}
{it:{help "svy: tabulate twoway##display_items":display_items}}
{it:{help "svy: tabulate twoway##display_options":display_options}}
{it:{help "svy: tabulate twoway##statistic_options":statistic_options}}]


INCLUDE help vcetype


INCLUDE help svy_tab_optable


{marker tabulate_options}{...}
{synopthdr:tabulate_options}
{synoptline}
{syntab:Model}
{synopt :{opth std:ize(varname)}}variable
	identifying strata for standardization{p_end}
{synopt :{opth stdw:eight(varname)}}weight variable
	for standardization{p_end}
{synopt :{opth tab(varname)}}variable for which
	to compute cell totals/proportions{p_end}
{synopt :{opt miss:ing}}treat missing values like other values{p_end}
{synoptline}


{marker display_items}{...}
{synopthdr:display_items}
{synoptline}
{syntab:Table items}
{synopt :{opt cel:l}}cell proportions{p_end}
{synopt :{opt cou:nt}}weighted cell counts{p_end}
{synopt :{opt col:umn}}within-column proportions{p_end}
{synopt :{opt row}}within-row proportions{p_end}
{synopt :{opt se}}standard errors{p_end}
{synopt :{opt ci}}confidence intervals{p_end}
{synopt :{opt deff}}display the DEFF design effects{p_end}
{synopt :{opt deft}}display the DEFT design effects{p_end}
{synopt :{opt cv}}display the coefficient of variation{p_end}
{synopt :{opt srs:subpop}}report
	design effects assuming SRS within subpopulation{p_end}
{synopt :{opt obs}}cell observations{p_end}
{synoptline}
{p 4 6 2}
When any of {opt se}, {opt ci}, {opt deff}, {opt deft}, {opt cv}, or
{opt srssubpop} is
specified, only one of {opt cell}, {opt count}, {opt column}, or {opt row} can
be specified.  If none of {opt se}, {opt ci}, {opt deff}, {opt deft}, {opt cv},
or
{opt srssubpop} is specified, any of or all {opt cell}, {opt count},
{opt column}, and {opt row} can be specified.


{marker display_options}{...}
{synopthdr:display_options}
{synoptline}
{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt prop:ortion}}display proportions; the default{p_end}
{synopt :{opt per:cent}}display percentages instead of proportions{p_end}
{synopt :{opt vert:ical}}stack confidence interval endpoints vertically{p_end}
{synopt :{opt nomarg:inals}}suppress row and column marginals{p_end}
{synopt :{opt nolab:el}}suppress displaying value labels{p_end}
{synopt :{opt notab:le}}suppress displaying the table{p_end}
{synopt :{opt cellw:idth(#)}}cell width{p_end}
{synopt :{opt csepw:idth(#)}}column-separation width{p_end}
{synopt :{opt stubw:idth(#)}}stub width{p_end}
{synopt :{opth for:mat(%fmt)}}cell format; default is {cmd:format(%6.0g)}{p_end}
{synoptline}
{p 4 6 2}
{opt proportion} and {opt notable} are not shown in the dialog box.


{marker statistic_options}{...}
{synopthdr:statistic_options}
{synoptline}
{syntab:Test statistics}
{synopt :{opt pea:rson}}Pearson's chi-squared{p_end}
{synopt :{opt lr}}likelihood ratio{p_end}
{synopt :{opt nul:l}}display null-based statistics{p_end}
{synopt :{opt wald}}adjusted Wald{p_end}
{synopt :{opt llwald}}adjusted log-linear Wald{p_end}
{synopt :{opt noadj:ust}}report unadjusted Wald statistics{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survey data analysis > Tables > Two-way tables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy: tabulate} produces two-way tabulations with tests of independence
for complex survey data.  See
{manhelp svy_tabulate_oneway SVY:svy: tabulate oneway} for one-way
tabulations for complex survey data.


{marker options}{...}
{title:Options}

{phang}
{it:svy_options}; see {manhelp svy SVY}.

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
{opth tab(varname)} specifies that counts be
cell totals of this variable and proportions (or percentages) be
relative to (that is, weighted by) this variable.  For example, if this
variable denotes income, the cell "counts" are instead totals of income
for each cell, and the cell proportions are proportions of income for each
cell.

{phang}
{opt missing} specifies that missing values of {varname:1} and
{it:varname2} be treated as another row or column category rather than
be omitted from the analysis (the default).

{dlgtab:Table items}

{phang}
{opt cell} requests that cell proportions (or percentages) be
displayed.  This is the default if none of {opt count}, {opt row}, or
{opt column} are specified.

{phang}
{opt count} requests that weighted cell counts be displayed.

{phang}
{opt column} or {opt row} requests that column or row proportions (or
percentages) be displayed.

{phang}
{opt se} requests that the standard errors of cell proportions
(the default), weighted counts, or row or column proportions be displayed.
When {opt se} (or {opt ci}, {opt deff}, {opt deft}, or {opt cv}) is specified,
only one
of {opt cell}, {opt count}, {opt row}, or {opt column} can be selected.  The
standard error computed is the standard error of the one selected.

{phang}
{opt ci} requests confidence intervals for cell proportions,
weighted counts, or row or column proportions.  The confidence intervals are
constructed using a logit transform so that their endpoints always lie between
0 and 1.

{phang}
{opt deff} and {opt deft} request that the design-effect measures DEFF and DEFT
be displayed for each cell proportion, count, or row or column proportion.  See
{mansection SVY estat:{bf:[SVY] estat}} for details.  The mean generalized
DEFF is also displayed when {cmd:deff}, {cmd:deft}, or {cmd:subpop} is
requested; see
{mansection SVY svytabulatetwowayMethodsandformulas:{it:Methods and formulas}}
in {bf:[SVY] svy: tabulate twoway} for an explanation.

{pmore}
The {opt deff} and {opt deft} options are not allowed with estimation
results that used direct standardization of poststratification.

{phang}
{opt cv} requests that the coefficient of variation be displayed for each cell
proportion, count, or row or column proportion.  See
{mansection SVY estat:{bf:[SVY] estat}} for details.

{phang}
{opt srssubpop} requests that DEFF and DEFT be computed using an estimate of
SRS (simple random sampling) variance for sampling within a subpopulation.  By
default, DEFF and DEFT are computed using an estimate of the SRS variance for
sampling from the entire population.  Typically, {opt srssubpop} would be
given when computing subpopulation estimates by strata or by groups of strata.

{phang}
{opt obs} requests that the number of observations for each cell be
displayed.

{dlgtab:Reporting}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt proportion}, the default, requests that proportions be displayed.

{phang}
{opt percent} requests that percentages be displayed instead of proportions.

{phang}
{opt vertical} requests that the endpoints of the confidence intervals
be stacked vertically on display.

{phang}
{opt nomarginals} requests that row and column marginals not be
displayed.

{phang}
{opt nolabel} requests that variable labels and value labels be
ignored.

{phang}
{opt notable} prevents the header and table from being displayed in the
output.  When specified, only the results of the requested test statistics are
displayed.  This option may not be specified with any other option in
{it:display_options} except the {opt level()} option.

{phang}
{opt cellwidth(#)}, {opt csepwidth(#)}, and
{opt stubwidth(#)} specify widths of table elements in the
output; see {manhelp tabdisp P}.  Acceptable values for the {opt stubwidth()}
option range from 4 to 32.

{phang}
{opth format(%fmt)} specifies a format for the items in the
table.  The default is {cmd:format(%6.0g)}.  See {findalias frformats}.

{dlgtab:Test statistics}

{phang}
{opt pearson} requests that the Pearson chi-squared statistic be
computed.  By default, this is the test of independence that is displayed.
The Pearson chi-squared statistic is corrected for the survey design with the
second-order correction of 
{help svy tabulate twoway##RS1984:Rao and Scott (1984)} and is converted into
an F statistic.  One term in the correction formula can be calculated using
either observed cell proportions or proportions under the null hypothesis
(that is, the product of the marginals).  By default, observed cell proportions
are used.  If the {opt null} option is selected, then a statistic corrected
using proportions under the null hypothesis is displayed as well.

{phang}
{opt lr} requests that the likelihood-ratio test statistic for
proportions be computed.  This statistic is not defined when there
are one or more zero cells in the table.  The statistic is corrected for the
survey design by using the same correction procedure that is used with the
{opt pearson} statistic.  Again either observed cell proportions or
proportions under the null hypothesis can be used in the correction formula.
By default, the former is used; specifying the {opt null} option gives both
the former and the latter.  Neither variant of this statistic is recommended
for sparse tables.  For nonsparse tables, the {opt lr} statistics are similar
to the corresponding {opt pearson} statistics.

{phang}
{opt null} modifies the {opt pearson} and {opt lr} options only.  If
{cmd:null} is specified, two corrected statistics are displayed.  The
statistic labeled "D-B (null)" ("D-B" stands for design-based) uses
proportions under the null hypothesis (that is, the product of the marginals)
in the {help svy tabulate twoway##RS1984:Rao and Scott (1984)} correction.
The statistic labeled merely
"Design-based" uses observed cell proportions.  If {opt null} is not specified,
only the correction that uses observed proportions is displayed.

{phang}
{opt wald} requests a Wald test of whether observed weighted counts
equal the product of the marginals
({help svy tabulate twoway##KFF1975:Koch, Freeman, and Freeman 1975}).  By
default, an adjusted F statistic is produced; an unadjusted statistic can be
produced by specifying {opt noadjust}.  The unadjusted F statistic can yield
extremely anticonservative p-values (that is, p-values that are too small) when
the degrees of freedom of the variance estimates (the number of sampled PSUs
minus the number of strata) are small relative to the (R-1)(C-1) degrees of
freedom of the table (where R is the number of rows and C is the number of
columns).  Hence, the statistic produced by {opt wald} and {opt noadjust}
should not be used for inference unless it is essentially identical to the
adjusted statistic.

{pmore}
This option must be specified at run time in order to be used on subsequent
calls to {cmd:svy} to report results.

{phang}
{opt llwald} requests a Wald test of the log-linear model of independence
({help svy tabulate twoway##KFF1975:Koch, Freeman, and Freeman 1975}).
The statistic is not defined
when there are one or more zero cells in the table.  The adjusted statistic
(the default) can produce anticonservative p-values, especially for sparse
tables, when the degrees of freedom of the variance estimates are small
relative to the degrees of freedom of the table.  Specifying {opt noadjust}
yields a statistic with more severe problems.  Neither the adjusted nor the
unadjusted statistic is recommended for inference; the statistics are made
available only for pedagogical purposes.

{phang}
{opt noadjust} modifies the {opt wald} and {opt llwald} options only.
It requests that an unadjusted F statistic be displayed in addition to the
adjusted statistic.

{pstd}
{cmd:svy:} {cmd:tabulate} uses the {cmd:tabdisp} command (see
{manhelp tabdisp P})
to produce the table.  Only five items can be displayed in the table at one
time. The {opt ci} option implies two items.  If too many items are
selected, a warning will appear immediately.  To view more items, redisplay
the table while specifying different options.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. webuse nhanes2b}
{p_end}
{phang}
{cmd:. svy: tabulate race diabetes}
{p_end}
{phang}
{cmd:. svy: tabulate, row}
{p_end}
{phang}
{cmd:. svy: tabulate race diabetes, row se ci format(%7.4f)}
{p_end}

{phang}
{cmd:. webuse svy_tabopt}
{p_end}
{phang}
{cmd:. svyset psuid [pweight=finalwgt], strata(stratid)}
{p_end}
{phang}
{cmd:. svy: tabulate gender race, tab(income) row}
{p_end}

{phang}
{cmd:. webuse nhanes2b}
{p_end}
{phang}
{cmd:. gen male = (sex==1) if !missing(sex)}
{p_end}
{phang}
{cmd:. svy, subpop(male):}
{cmd: tabulate highbp sizplace, col obs pearson lr null wald}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results documented in {helpb svy:[SVY] svy},
{cmd:svy: tabulate} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(r)}}number of rows{p_end}
{synopt:{cmd:e(c)}}number of columns{p_end}
{synopt:{cmd:e(cvgdeff)}}coefficient of variation of generalized DEFF eigenvalues{p_end}
{synopt:{cmd:e(mgdeff)}}mean generalized DEFF{p_end}
{synopt:{cmd:e(total)}}weighted sum of {cmd:tab()} variable{p_end}

{synopt:{cmd:e(F_Pear)}}default-corrected Pearson F{p_end}
{synopt:{cmd:e(F_Penl)}}null-corrected Pearson F{p_end}
{synopt:{cmd:e(df1_Pear)}}numerator d.f. for {cmd:e(F_Pear)}{p_end}
{synopt:{cmd:e(df2_Pear)}}denominator d.f. for {cmd:e(F_Pear)}{p_end}
{synopt:{cmd:e(df1_Penl)}}numerator d.f. for {cmd:e(F_Penl)}{p_end}
{synopt:{cmd:e(df2_Penl)}}denominator d.f. for {cmd:e(F_Penl)}{p_end}
{synopt:{cmd:e(p_Pear)}}p-value for {cmd:e(F_Pear)}{p_end}
{synopt:{cmd:e(p_Penl)}}p-value for {cmd:e(F_Penl)}{p_end}
{synopt:{cmd:e(cun_Pear)}}uncorrected Pearson chi-squared{p_end}
{synopt:{cmd:e(cun_Penl)}}null variant uncorrected Pearson chi-squared{p_end}

{synopt:{cmd:e(F_LR)}}default-corrected likelihood-ratio F{p_end}
{synopt:{cmd:e(F_LRnl)}}null-corrected likelihood-ratio F{p_end}
{synopt:{cmd:e(df1_LR)}}numerator d.f. for {cmd:e(F_LR)}{p_end}
{synopt:{cmd:e(df2_LR)}}denominator d.f. for {cmd:e(F_LR)}{p_end}
{synopt:{cmd:e(df1_LRnl)}}numerator d.f. for {cmd:e(F_LRnl)}{p_end}
{synopt:{cmd:e(df2_LRnl)}}denominator d.f. for {cmd:e(F_LRnl)}{p_end}
{synopt:{cmd:e(p_LR)}}p-value for {cmd:e(F_LR)}{p_end}
{synopt:{cmd:e(p_LRnl)}}p-value for {cmd:e(F_LRnl)}{p_end}
{synopt:{cmd:e(cun_LR)}}uncorrected likelihood-ratio chi-squared{p_end}
{synopt:{cmd:e(cun_LRnl)}}null variant uncorrected likelihood-ratio chi-squared
{p_end}

{synopt:{cmd:e(F_Wald)}}adjusted "Pearson" Wald F{p_end}
{synopt:{cmd:e(F_LLW)}}adjusted log-linear Wald F{p_end}
{synopt:{cmd:e(p_Wald)}}p-value for {cmd:e(F_Wald)}{p_end}
{synopt:{cmd:e(p_LLW)}}p-value for {cmd:e(F_LLW)}{p_end}
{synopt:{cmd:e(Fun_Wald)}}unadjusted "Pearson" Wald F{p_end}
{synopt:{cmd:e(Fun_LLW)}}unadjusted log-linear Wald F{p_end}
{synopt:{cmd:e(pun_Wald)}}p-value for {cmd:e(Fun_Wald)}{p_end}
{synopt:{cmd:e(pun_LLW)}}p-value for {cmd:e(Fun_LLW)}{p_end}
{synopt:{cmd:e(cun_Wald)}}unadjusted "Pearson" Wald chi-squared{p_end}
{synopt:{cmd:e(cun_LLW)}}unadjusted log-linear Wald chi-squared{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:tabulate}{p_end}
{synopt:{cmd:e(tab)}}{cmd:tab()} variable{p_end}
{synopt:{cmd:e(rowlab)}}label or empty{p_end}
{synopt:{cmd:e(collab)}}label or empty{p_end}
{synopt:{cmd:e(rowvlab)}}row variable label{p_end}
{synopt:{cmd:e(colvlab)}}column variable label{p_end}
{synopt:{cmd:e(rowvar)}}{it:varname}1, the row variable{p_end}
{synopt:{cmd:e(colvar)}}{it:varname}2, the column variable{p_end}
{synopt:{cmd:e(setype)}}{cmd:cell}, {cmd:count}, {cmd:column}, or
           {cmd:row}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(Prop)}}matrix of cell proportions{p_end}
{synopt:{cmd:e(Obs)}}matrix of observation counts{p_end}
{synopt:{cmd:e(Deff)}}DEFF vector for {cmd:e(setype)} items{p_end}
{synopt:{cmd:e(Deft)}}DEFT vector for {cmd:e(setype)} items{p_end}
{synopt:{cmd:e(Row)}}values for row variable{p_end}
{synopt:{cmd:e(Col)}}values for column variable{p_end}
{synopt:{cmd:e(V_row)}}variance for row totals{p_end}
{synopt:{cmd:e(V_col)}}variance for column totals{p_end}
{synopt:{cmd:e(V_srs_row)}}V_srs for row totals{p_end}
{synopt:{cmd:e(V_srs_col)}}V_srs for column totals{p_end}
{synopt:{cmd:e(Deff_row)}}DEFF for row totals{p_end}
{synopt:{cmd:e(Deff_col)}}DEFF for column totals{p_end}
{synopt:{cmd:e(Deft_row)}}DEFT for row totals{p_end}
{synopt:{cmd:e(Deft_col)}}DEFT for column totals{p_end}


{marker references}{...}
{title:References}

{marker KFF1975}{...}
{phang}
Koch, G. G., D. H. Freeman Jr., and J. L. Freeman. 1975. Strategies in the
multivariate analysis of data from complex surveys. 
{it:International Statistical Review} 43: 59-78.

{marker RS1984}{...}
{phang}
Rao, J. N. K., and A. J. Scott. 1984. On chi-squared tests for multiway
contingency tables with cell proportions estimated from survey data.
{it:Annals of Statistics} 12: 46-60.
{p_end}
