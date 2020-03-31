{smcl}
{* *! version 1.1.19  03apr2019}{...}
{viewerdialog "svy: tabulate oneway" "dialog svy_tabulate_oneway"}{...}
{vieweralsosee "[SVY] svy tabulate oneway" "mansection SVY svytabulateoneway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy: tabulate twoway" "help svy_tabulate_twoway"}{...}
{vieweralsosee "[SVY] svydescribe" "help svydescribe"}{...}
{viewerjumpto "Syntax" "svy_tabulate_oneway##syntax"}{...}
{viewerjumpto "Menu" "svy_tabulate_oneway##menu"}{...}
{viewerjumpto "Description" "svy_tabulate_oneway##description"}{...}
{viewerjumpto "Options" "svy_tabulate_oneway##options"}{...}
{viewerjumpto "Examples" "svy_tabulate_oneway##examples"}{...}
{viewerjumpto "Stored results" "svy_tabulate_oneway##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col :{bf:[SVY] svy: tabulate oneway} {hline 2}}One-way tables
for survey data{p_end}
{p2col:}({mansection SVY svytabulateoneway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{phang2}
{cmd:svy}{cmd::} {cmdab:tab:ulate} {varname}


{pstd}
Full syntax

{phang2}
{cmd:svy} [{it:vcetype}] [{cmd:,} {it:{help svy_tabulate_oneway##svy_options:svy_options}}]
{cmd::} {cmdab:tab:ulate} {varname} {ifin}
[{cmd:,}
{it:{help "svy: tabulate oneway##tabulate_options":tabulate_options}}
{it:{help "svy: tabulate oneway##display_items":display_items}}
{it:{help "svy: tabulate oneway##display_options":display_options}}]


{pstd}
Syntax to report results

{phang2}
{cmd:svy} [{cmd:,}
{it:{help "svy: tabulate oneway##display_items":display_items}}
{it:{help "svy: tabulate oneway##display_options":display_options}}]


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
specified, only one of {opt cell} or {opt count} can be specified.  If none of
{opt se}, {opt ci}, {opt deff}, {opt deft}, {opt cv}, or {opt srssubpop} is
specified,
both {opt cell} and {opt count} can be specified.


{marker display_options}{...}
{synopthdr:display_options}
{synoptline}
{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt prop:ortion}}display proportions; the default{p_end}
{synopt :{opt per:cent}}display percentages instead of proportions{p_end}
{synopt :{opt nomarg:inal}}suppress column marginal{p_end}
{synopt :{opt nolab:el}}suppress displaying value labels{p_end}
{synopt :{opt cellw:idth(#)}}cell width{p_end}
{synopt :{opt csepw:idth(#)}}column-separation width{p_end}
{synopt :{opt stubw:idth(#)}}stub width{p_end}
{synopt :{opth for:mat(%fmt)}}cell format; default is {cmd:format(%6.0g)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt proportion} is not shown in the dialog box.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survey data analysis > Tables > One-way tables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy: tabulate} produces one-way tabulations for complex survey data.
See {manhelp svy_tabulate_twoway SVY:svy: tabulate twoway} for two-way
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
cell totals of this variable and that proportions (or percentages) be relative
to (that is, weighted by) this variable.  For example, if this variable
denotes income, then the cell "counts" are instead totals of income for each
cell, and the cell proportions are proportions of income for each cell.

{phang}
{opt missing} specifies that missing values of {varname} be treated
as another row category rather than be omitted from the analysis
(the default).

{dlgtab:Table items}

{phang}
{opt cell} requests that cell proportions (or percentages) be displayed.  This
is the default if {opt count} is not specified.

{phang}
{opt count} requests that weighted cell counts be displayed.

{phang}
{opt se} requests that the standard errors of cell proportions
(the default) or weighted counts be displayed.
When {opt se} (or {opt ci}, {opt deff}, {opt deft}, or {opt cv}) is specified,
only one
of {opt cell} or {opt count} can be selected.  The standard error computed is
the standard error of the one selected.

{phang}
{opt ci} requests confidence intervals for cell proportions or 
weighted counts.

{phang}
{opt deff} and {opt deft} request that the design-effect measure DEFF and DEFT
be displayed for each cell proportion or weighted count.  See
{mansection SVY estat:{bf:[SVY] estat}} for details.

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
{opt nomarginal} requests that column marginal not be displayed.

{phang}
{opt nolabel} requests that variable labels and value labels be ignored.

{phang}
{opt cellwidth(#)}, {opt csepwidth(#)}, and
{opt stubwidth(#)} specify widths of table elements in the
output; see {manhelp tabdisp P}.  Acceptable values for the {opt stubwidth()}
option range from 4 to 32.

{phang}
{opth format(%fmt)} specifies a format for the items in the
table.  The default is {cmd:format(%6.0g)}.  See {findalias frformats}.

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
{cmd:. svyset psuid [pweight=finalwgt], strata(stratid)}
{p_end}
{phang}
{cmd:. svy: tabulate race}
{p_end}
{phang}
{cmd:. svy: tabulate race, format(%11.3g) count ci deff deft}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results documented in {helpb svy:[SVY] svy},
{cmd:svy: tabulate} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(r)}}number of rows{p_end}
{synopt:{cmd:e(total)}}weighted sum of {cmd:tab()} variable{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:tabulate}{p_end}
{synopt:{cmd:e(tab)}}{cmd:tab()} variable{p_end}
{synopt:{cmd:e(rowlab)}}{cmd:label} or empty{p_end}
{synopt:{cmd:e(rowvlab)}}row variable label{p_end}
{synopt:{cmd:e(rowvar)}}{it:varname}, the row variable{p_end}
{synopt:{cmd:e(setype)}}{cmd:cell} or {cmd:count}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(Prop)}}matrix of cell proportions{p_end}
{synopt:{cmd:e(Obs)}}matrix of observation counts{p_end}
{synopt:{cmd:e(Deff)}}DEFF vector for {cmd:e(setype)} items{p_end}
{synopt:{cmd:e(Deft)}}DEFT vector for {cmd:e(setype)} items{p_end}
{synopt:{cmd:e(Row)}}values for row variable{p_end}
{synopt:{cmd:e(V_row)}}variance for row totals{p_end}
{synopt:{cmd:e(V_srs_row)}}V_srs for row totals{p_end}
{synopt:{cmd:e(Deff_row)}}DEFF for row totals{p_end}
{synopt:{cmd:e(Deft_row)}}DEFT for row totals{p_end}
