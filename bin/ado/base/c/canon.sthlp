{smcl}
{* *! version 1.1.18  19oct2017}{...}
{viewerdialog canon "dialog canon"}{...}
{vieweralsosee "[MV] canon" "mansection MV canon"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] canon postestimation" "help canon postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV factor" "help factor"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[R] pcorr" "help pcorr"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "canon##syntax"}{...}
{viewerjumpto "Menu" "canon##menu"}{...}
{viewerjumpto "Description" "canon##description"}{...}
{viewerjumpto "Links to PDF documentation" "canon##linkspdf"}{...}
{viewerjumpto "Options" "canon##options"}{...}
{viewerjumpto "Examples" "canon##examples"}{...}
{viewerjumpto "Stored results" "canon##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[MV] canon} {hline 2}}Canonical correlations{p_end}
{p2col:}({mansection MV canon:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmd:canon} {cmd:(}{it:{help varlist:varlist1}}{cmd:)}
{cmd:(}{it:{help varlist:varlist2}}{cmd:)}
{ifin}
[{it:{help canon##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 14 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt lc(#)}}calculate the linear combinations for canonical
correlation {it:#}{p_end}
{synopt :{opt fir:st(#)}}calculate the linear combinations for the first {it:#}
            canonical correlations{p_end}
{synopt :{opt nocons:tant}}do not subtract means when calculating
correlations{p_end}

{syntab :Reporting}
{synopt :{opt stdc:oef}}output matrices of standardized coefficients{p_end}
{synopt :{opt stde:rr}}display raw coefficients and conditionally estimated standard errors{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opth test(numlist)}}display significance tests for the specified
canonical correlations{p_end}
{synopt :{opt notest:s}}do not display tests{p_end}
{synopt :{opth f:ormat(%fmt)}}numerical format for coefficient
matrices; default is {cmd:format(%8.4f)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:by} and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}{opt aweight}s and {opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}See {manhelp canon_postestimation MV:canon postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis >}
     {bf:MANOVA, multivariate regression, and related > Canonical correlations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:canon} estimates canonical correlations and provides the coefficients
for calculating the appropriate linear combinations corresponding to those
correlations.

{pstd}
{cmd:canon} typed without arguments redisplays previous estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV canonQuickstart:Quick start}

        {mansection MV canonRemarksandexamples:Remarks and examples}

        {mansection MV canonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt lc(#)} specifies that linear combinations for
canonical correlation {it:#} be calculated.  By default,
all are calculated.

{phang}{opt first(#)} specifies that linear combinations for the
first {it:#} canonical correlations be calculated.  By default, all
are calculated.

{phang}{cmd:noconstant} specifies that means not be subtracted when
calculating correlations.

{dlgtab:Reporting}

{phang}{cmd:stdcoef} specifies that the first part of the output contain
the standard coefficients of the canonical correlations in matrix form.  The
default is to present the raw coefficients of the canonical correlations
in matrix form.

{phang}{cmd:stderr} specifies that the first part of the output contains
the raw coefficients of the canonical correlations, the conditionally estimated
standard errors, and the conditionally estimated confidence intervals in the
standard estimation table.  The default is to present the raw coefficients of
the canonical correlations in matrix form.

{phang}{opt level(#)} specifies the confidence level, as a
percentage, for confidence intervals of the coefficients.
The default is {cmd:level(95)} or as set by {helpb set level}.
These "confidence intervals" are the result of an approximate calculation; see
the {mansection MV canonRemarksandexamplestechnote:technical note} in
{bf:[MV] canon}.

{phang}{opth test(numlist)} specifies that significance tests
of the canonical correlations in the {it:numlist} be displayed.  Because of
the nature of significance testing, if there are three canonical correlations,
{cmd:test(1)} will test the significance of all three correlations,
{cmd:test(2)} will test the significance of canonical correlations
2 and 3, and {cmd:test(3)} will test the significance of the third
canonical correlation alone.

{phang}{cmd:notests} specifies that significance tests of the canonical
correlations not be displayed.

{phang}{opth format(%fmt)} specifies the display format for numbers in
coefficient matrices.  {cmd:format(%8.4f)} is the default.  {cmd:format()}
may not be specified with {cmd:stderr}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Estimate canonical correlations{p_end}
{phang2}{cmd:. canon (length weight headroom trunk) (displ mpg gear_ratio turn)}{p_end}

{pstd}Same as above, but display standardized coefficients{p_end}
{phang2}{cmd:. canon (length weight headroom trunk) (displ mpg gear_ratio turn), stdcoef}{p_end}

{pstd}Display raw coefficients and conditional standard errors in the standard
estimation table{p_end}
{phang2}{cmd:. canon (length weight headroom trunk) (displ mpg gear_ratio turn), stderr}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:canon} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(df)}}degrees of freedom{p_end}
{synopt:{cmd:e(df1)}}numerator degrees of freedom for significance tests{p_end}
{synopt:{cmd:e(df2)}}denominator degrees of freedom for significance tests{p_end}
{synopt:{cmd:e(n_lc)}}the linear combination calculated{p_end}
{synopt:{cmd:e(n_cc)}}number of canonical correlations calculated{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:canon}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(stat_}{it:#}{cmd:)}}statistics for canonical
        correlation {it:#}{p_end}
{synopt:{cmd:e(stat_m)}}statistics for overall model{p_end}
{synopt:{cmd:e(canload11)}}canonical loadings for {it:varlist_1}{p_end}
{synopt:{cmd:e(canload22)}}canonical loadings for {it:varlist_2}{p_end}
{synopt:{cmd:e(canload12)}}correlation between {it:varlist_1} and the canonical variates from {it:varlist_2}{p_end}
{synopt:{cmd:e(canload21)}}correlation between {it:varlist_2} and the canonical variates from {it:varlist_1}{p_end}
{synopt:{cmd:e(rawcoef_var1)}}raw coefficients for {it:varlist_1}{p_end}
{synopt:{cmd:e(rawcoef_var2)}}raw coefficients for {it:varlist_2}{p_end}
{synopt:{cmd:e(stdcoef_var1)}}standard coefficients for {it:varlist_1}{p_end}
{synopt:{cmd:e(stdcoef_var2)}}standard coefficients for {it:varlist_2}{p_end}
{synopt:{cmd:e(ccorr)}}canonical correlation coefficients{p_end}
{synopt:{cmd:e(ccorr_var1)}}correlation matrix for {it:varlist_1}{p_end}
{synopt:{cmd:e(ccorr_var2)}}correlation matrix for {it:varlist_2}{p_end}
{synopt:{cmd:e(ccorr_mixed)}}correlation matrix between {it:varlist_1} and {it:varlist_2}{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
