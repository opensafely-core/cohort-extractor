{smcl}
{* *! version 1.2.16  18feb2020}{...}
{viewerdialog tetrachoric "dialog tetrachoric"}{...}
{vieweralsosee "[R] tetrachoric" "mansection R tetrachoric"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] biprobit" "help biprobit"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "[R] spearman" "help ktau"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "tetrachoric##syntax"}{...}
{viewerjumpto "Menu" "tetrachoric##menu"}{...}
{viewerjumpto "Description" "tetrachoric##description"}{...}
{viewerjumpto "Links to PDF documentation" "tetrachoric##linkspdf"}{...}
{viewerjumpto "Options" "tetrachoric##options"}{...}
{viewerjumpto "Examples" "tetrachoric##examples"}{...}
{viewerjumpto "Stored results" "tetrachoric##results"}{...}
{viewerjumpto "Reference" "tetrachoric##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[R] tetrachoric} {hline 2}}Tetrachoric correlations for binary 
variables{p_end}
{p2col:}({mansection R tetrachoric:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:tetrachoric} {varlist} {ifin}
[{it:{help tetrachoric##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{cmd:stats(}{it:{help tetrachoric##statlist:statlist}}{cmd:)}}list
of statistics; select up to 4 statistics; default is {cmd:stats(rho)}{p_end}
{synopt:{opt ed:wards}}use the noniterative Edwards and Edwards estimator; 
default is the maximum likelihood estimator{p_end}
{synopt:{opt p:rint(#)}}significance level for displaying coefficients{p_end}
{synopt:{opt st:ar(#)}}significance level for displaying with a star{p_end}
{synopt:{opt b:onferroni}}use Bonferroni-adjusted significance level{p_end}
{synopt:{opt sid:ak}}use Sidak-adjusted significance level{p_end}
{synopt:{opt pw:}}calculate all the pairwise correlation coefficients by using
all available data (pairwise deletion){p_end}
{synopt:{opt ze:roadjust}}adjust frequencies when one cell has a zero
count{p_end}
{synopt:{opt mat:rix}}display output in matrix form{p_end}
{synopt:{opt notab:le}}suppress display of correlations{p_end}
{synopt:{opt pos:def}}modify correlation matrix to be positive 
semidefinite{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 10}{...}
{marker statlist}{...}
{synopthdr :statlist}
{synoptline}
{synopt:{cmd:rho}}tetrachoric correlation coefficient{p_end}
{synopt:{cmd:se}}standard error of rho{p_end}
{synopt:{cmd:obs}}number of observations{p_end}
{synopt:{cmd:p}}exact two-sided significance level{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Summary and descriptive statistics > Tetrachoric correlations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tetrachoric} computes estimates of the tetrachoric correlation coefficients
of the binary variables in {varlist}.  All of these variables should be 0, 1,
or {help missing} values.

{pstd}
Tetrachoric correlations assume a latent bivariate normal distribution 
({it:X1}, {it:X2}) for each pair of variables ({it:v1}, {it:v2}), with a
threshold model for the manifest variables, {bind:{it:vi} = 1} if and only 
if {bind:{it:Xi} > 0}.  The means and variances of the latent variables are 
not identified, but the correlation, {it:r}, of {it:X1} and {it:X2} can be 
estimated from the joint distribution of {it:v1} and {it:v2} and is called 
the tetrachoric correlation coefficient.

{pstd}
{cmd:tetrachoric} computes pairwise estimates of the tetrachoric correlations
by the (iterative) maximum likelihood estimator obtained from bivariate probit
without explanatory variables (see {manhelp biprobit R}) by using the 
{help tetrachoric##EE1984:Edwards and Edwards (1984)}
noniterative estimator as the initial value.

{pstd}
The pairwise correlation matrix is returned as {cmd:r(Rho)} and can be used to
perform a factor analysis or a principal component analysis of binary
variables by using the {cmd:factormat} or {cmd:pcamat} commands; see
{manhelp factor MV} and {manhelp pca MV}.



{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tetrachoricQuickstart:Quick start}

        {mansection R tetrachoricRemarksandexamples:Remarks and examples}

        {mansection R tetrachoricMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:stats(}{it:{help tetrachoric##statlist:statlist}}{cmd:)} specifies the 
statistics to be displayed in the matrix of output.  {cmd:stats(rho)} is the 
default.  Up to four statistics may be specified.  {cmd:stats(rho se p obs)} 
would display the tetrachoric correlation coefficient, its standard error, 
the significance level, and the number of observations.  If {varlist} 
contains only two variables, all statistics are shown in tabular form. 
{cmd:stats()}, {cmd:print()}, and {cmd:star()} have no effect unless the 
{cmd:matrix} option is also specified.

{phang}
{opt edwards} specifies that the noniterative Edwards and Edwards 
estimator be used.  The default is the maximum likelihood estimator.  If you
analyze many binary variables, you may want to use the fast noniterative
estimator proposed by 
{help tetrachoric##EE1984:Edwards and Edwards (1984)}.
However, if you have skewed
variables, the approximation does not perform well.

{phang}
{opt print(#)} specifies the maximum significance level of correlation
coefficients to be printed.  Correlation coefficients with larger significance
levels are left blank in the matrix.
Typing {cmd:tetrachoric} ...{cmd:, print(.10)} would list only those
correlation coefficients that are significant at the 10% level or lower.

{phang}
{opt star(#)} specifies the maximum significance level of correlation
coefficients to be marked with a star.  Typing
{cmd:tetrachoric} ...{cmd:, star(.05)} would "star" all correlation
coefficients significant at the 5% level or lower.

{phang}
{opt bonferroni} makes the Bonferroni adjustment to calculated significance
levels.  This option affects printed significance levels and the {opt print()}
and {opt star()} options.  Thus,
{cmd:tetrachoric} ...{cmd:, print(.05) bonferroni} prints coefficients with
Bonferroni-adjusted significance levels of 0.05 or less.

{phang}
{opt sidak} makes the Sidak adjustment to calculated significance
levels.  This option affects printed significance levels and the {opt print()}
and {opt star()} options.  Thus,
{cmd:tetrachoric} ...{cmd:, print(.05) sidak} prints coefficients with
Sidak-adjusted significance levels of 0.05 or less.

{phang}{opt pw}
specifies that the tetrachoric correlation be calculated by using all
available data.
By default,
{cmd:tetrachoric} uses casewise deletion, where observations are
ignored if any of the specified variables in {varlist} are missing.

{phang}
{opt zeroadjust} specifies that when one of the cells has a zero count, 
a frequency adjustment be applied in such a way as to increase the zero 
to one-half and maintain row and column totals.  

{phang}
{opt matrix} forces {cmd:tetrachoric} to display the statistics as a matrix,
even if {varlist} contains only two variables.  {cmd:matrix} is implied if
more than two variables are specified.

{phang}{opt notable}
suppresses the output. 

{phang}{opt posdef}
modifies the correlation matrix so that it is positive semidefinite, that is,
a proper correlation matrix.  The modified result is the correlation matrix
associated with the least-squares approximation of the tetrachoric
correlation matrix by a positive-semidefinite matrix.  If the correlation
matrix is modified, the standard errors and significance levels are not 
displayed and are not returned in {cmd:r()}. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse familyvalues}

{pstd}Pearson correlations{p_end}
{phang2}{cmd:. correlate RS074 RS075 RS076}

{pstd}Correlations produced by tetrachoric{p_end}
{phang2}{cmd:. tetrachoric RS074 RS075 RS076}

{pstd}Pearson correlations{p_end}
{phang2}{cmd:. correlate RS056-RS063}

{pstd}Correlations produced by tetrachoric{p_end}
{phang2}{cmd:. tetrachoric RS056-RS063}

{pstd}Adjust correlation matrix, if need be, to be positive
semidefinite{p_end}
{phang2}{cmd:. tetrachoric RS056-RS063 in 1/20, posdef}



{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tetrachoric} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(rho)}}tetrachoric correlation coefficient between variables 1
and 2{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(nneg)}}number of negative eigenvalues ({cmd:posdef} only){p_end}
{synopt:{cmd:r(se_rho)}}standard error of {cmd:r(rho)}{p_end}
{synopt:{cmd:r(p)}}p-value for two-sided Fisher's exact test (for the first two variables){p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}estimator used{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Rho)}}tetrachoric correlation matrix{p_end}
{synopt:{cmd:r(Se_Rho)}}standard errors of {cmd:r(Rho)}{p_end}
{synopt:{cmd:r(Nobs)}}number of observations used in computing correlation{p_end}
{synopt:{cmd:r(P)}}matrix of p-values for two-sided Fisher's exact test{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker EE1984}{...}
{phang}
Edwards, J. H., and A. W. F. Edwards. 1984.
Approximating the tetrachoric correlation coefficient.
{it:Biometrics} 40: 563.
{p_end}
