{smcl}
{* *! version 1.3.15  12dec2018}{...}
{viewerdialog factor "dialog factor"}{...}
{viewerdialog factormat "dialog factormat"}{...}
{vieweralsosee "[MV] factor" "mansection MV factor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] factor postestimation" "help factor_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] alpha" "help alpha"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{findalias assemsfmm}{...}
{findalias assemtfmm}{...}
{viewerjumpto "Syntax" "factor##syntax"}{...}
{viewerjumpto "Menu" "factor##menu"}{...}
{viewerjumpto "Description" "factor##description"}{...}
{viewerjumpto "Links to PDF documentation" "factor##linkspdf"}{...}
{viewerjumpto "Options for factor and factormat" "factor##options"}{...}
{viewerjumpto "Options unique to factormat" "factor##options_factormat"}{...}
{viewerjumpto "Examples of factor" "factor##examples_factor"}{...}
{viewerjumpto "Examples of factormat" "factor##examples_factormat"}{...}
{viewerjumpto "Stored results" "factor##results"}{...}
{viewerjumpto "Reference" "factor##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MV] factor} {hline 2}}Factor analysis{p_end}
{p2col:}({mansection MV factor:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Factor analysis of data

{p 8 15 2}
{cmdab:fac:tor} {varlist} {ifin}
[{it:{help factor##weight:weight}}]
[{cmd:,} {it:{help factor##method:method}}
{it:{help factor##options_table:options}}]


{pstd}
Factor analysis of a correlation matrix

{p 8 18 2}
{cmd:factormat} {it:matname}{cmd:,} {opt n(#)}
[ {it:{help factor##method:method}}
{it:{help factor##options_table:options}}
{it:{help factor##matoptions:factormat_options}}]


{phang}
{it:matname} is a square Stata matrix or a vector containing the rowwise
upper or lower triangle of the correlation or covariance matrix.  If a
covariance matrix is provided, it is transformed into a correlation matrix for
the factor analysis. 

{synoptset 20 tabbed}{...}
{marker method}{...}
{synopthdr:method}
{synoptline}
{syntab:Model 2}
{synopt:{opt pf}}principal factor; the default{p_end}
{synopt:{opt pcf}}principal-component  factor{p_end}
{synopt:{opt ip:f}}iterated principal factor{p_end}
{synopt:{opt ml}}maximum-likelihood factor{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model 2}
{synopt:{opt fa:ctors(#)}}maximum number of factors to be retained{p_end}
{synopt:{opt mine:igen(#)}}minimum value of eigenvalues to be retained{p_end}
{synopt:{opt cit:erate(#)}}communality reestimation iterations
	({cmd:ipf} only){p_end}

{syntab:Reporting}
{synopt:{opt bl:anks(#)}}display loadings as blanks when
	|loadings| < {it:#}{p_end}
{synopt:{opt altdiv:isor}}use trace of correlation matrix as the divisor for
	reported proportions{p_end}

{syntab:Maximization}
{synopt:{opt pr:otect(#)}}perform {it:#} optimizations and report the best
	solution ({cmd:ml} only){p_end}
{synopt:{opt r:andom}}use random starting values ({cmd:ml} only); seldom
	used{p_end}
{synopt:{opth "seed(set_seed:seed)"}}random-number seed ({cmd:ml} with
	{opt protect()} or {opt random} only){p_end}
{synopt:{it:{help factor##maximize:maximize_options}}}control the maximization process; seldom
	used ({cmd:ml} only){p_end}

{synopt:{opt norot:ated}}display unrotated solution, even if rotated
	results are available (replay only){p_end}
{synoptline}
{p 4 6 2}
{opt norotated} does not appear in the dialog box.
{p_end}

{marker matoptions}{...}
{synopthdr:factormat_options}
{synoptline}
{syntab:Model}
{synopt:{cmdab:sh:ape(}{cmdab:f:ull}{cmd:)}}{it:matname} is a square symmetric
	matrix; the default{p_end}
{synopt:{cmdab:sh:ape(}{cmdab:l:ower}{cmd:)}}{it:matname} is a vector with the
	rowwise lower triangle (with diagonal){p_end}
{synopt:{cmdab:sh:ape(}{cmdab:u:pper}{cmd:)}}{it:matname} is a vector with the
	rowwise upper triangle (with diagonal){p_end}
{synopt:{opt nam:es(namelist)}}variable names; required if {it:matname} is
	triangular{p_end}
{synopt:{opt forcepsd}}modifies {it:matname} to be positive semidefinite{p_end}
{p2coldent:* {opt n(#)}}number of observations{p_end}
{synopt:{opt sds(matname2)}}vector with standard deviations of variables{p_end}
{synopt:{opt means(matname3)}}vector with means of variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt n(#)} is required for {cmd:factormat}.
{p_end}

{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, and {cmd:statsby} 
are allowed with {cmd:factor}; see {help prefix}.  However, {cmd:bootstrap}
and {cmd:jackknife} results should be interpreted with caution; identification
of the {cmd:factor} parameters involves data-dependent restrictions, possibly
leading to badly biased and overdispersed estimates
({help factor##MW1995:Milan and Whittaker 1995}).
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed with {cmd:factor}; 
see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp factor_postestimation R:factor postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

    {title:factor}

{phang2}
{bf:Statistics > Multivariate analysis >}
   {bf:Factor and principal component analysis > Factor analysis}

    {title:factormat}

{phang2}
{bf:Statistics > Multivariate analysis >}
   {bf:Factor and principal component analysis >}
   {bf:Factor analysis of a correlation matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:factor} and {cmd:factormat} perform a factor analysis of a correlation
matrix.  The commands produce principal factor, iterated principal factor,
principal-component factor, and maximum-likelihood factor analyses.
{cmd:factor} and {cmd:factormat} display the eigenvalues of the correlation
matrix, the factor loadings, and the uniqueness of the variables.

{pstd}
{cmd:factor} expects data in the form of variables, allows weights, and can be
run for subgroups.  {cmd:factormat} is for use with a correlation or
covariance matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV factorQuickstart:Quick start}

        {mansection MV factorRemarksandexamples:Remarks and examples}

        {mansection MV factorMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options for factor and factormat}

{dlgtab:Model 2}

{phang}
{opt pf}, {opt pcf}, {opt ipf}, and {opt ml}
indicate the type of estimation to be performed.  The default is {opt pf}.

{phang2}
{opt pf}
specifies that the principal-factor method be used to analyze the correlation
matrix.  The factor loadings, sometimes called the factor patterns, are
computed using the squared multiple correlations as estimates of the
communality.  {opt pf} is the default.

{phang2}
{opt pcf}
specifies that the principal-component  factor method be used to analyze
the correlation matrix.  The communalities are assumed to be 1.

{phang2}
{opt ipf}
specifies that the iterated principal-factor method be used to analyze the
correlation matrix.  This reestimates the communalities iteratively.

{phang2}
{opt ml}
specifies the maximum-likelihood factor method, assuming multivariate normal
observations.  This estimation method is equivalent to Rao's canonical-factor
method and maximizes the determinant of the partial correlation matrix.
Hence, this solution is also meaningful as a descriptive method for nonnormal
data.  {opt ml} is not available for singular correlation matrices.  At least
three variables must be specified with method {opt ml}.

{phang}
{opt factors(#)} and {opt mineigen(#)} 
specify the maximum number of factors to be retained.  {opt factors()}
specifies the number directly, and {opt mineigen()} specifies it indirectly,
keeping all factors with eigenvalues greater than the indicated value.  The
options can be specified individually, together, or not at all.

{phang2}
{opt factors(#)}
sets the maximum number of factors to be retained for later use by the
postestimation commands.  {opt factor} always prints the full set of
eigenvalues but prints the corresponding eigenvectors only for retained
factors.  Specifying a number larger than the number of variables in the
{varlist} is equivalent to specifying the number of variables in the
{it:varlist} and is the default.

{phang2}
{opt mineigen(#)}
sets the minimum value of eigenvalues to be retained.  The default for all
methods except {opt pcf} is 0.000005 (effectively zero), meaning that factors
associated with negative eigenvalues will not be printed or retained.  The
default for {opt pcf} is 1.  Many sources recommend {cmd:mineigen(1)},
although the justification is complex and uncertain.  If {it:#} is less than
0.000005, it is reset to 0.000005.

{phang}
{opt citerate(#)}
is used only with {opt ipf} and sets the number of iterations for
reestimating the communalities.  If {opt citerate()} is not specified,
iterations continue until the change in the communalities is small.  {opt ipf}
with {cmd:citerate(0)} produces the same results that {opt pf} does.

{dlgtab:Reporting}

{phang}
{opt blanks(#)}
specifies that factor loadings smaller than {it:#} (in absolute value) be
displayed as blanks.

{phang}
{opt altdivisor}
specifies that reported proportions and cumulative proportions be
computed using the trace of the correlation matrix, {cmd:trace(e(C))}, as the
divisor.  The default is to use the sum of all eigenvalues (even those that
are negative) as the divisor.

{dlgtab:Maximization}

{phang}
{opt protect(#)} 
is used only with {opt ml} and requests that {it:#} optimizations with random
starting values be performed along with squared multiple correlation
coefficient starting values and that the best of the solutions be reported.
The output also indicates whether all starting values converged to the same
solution.  When specified with a large number, such as {cmd:protect(50)}, this
provides reasonable assurance that the solution found is global and is not
just a local maximum.  If {opt trace} is also specified (see
{helpb maximize:[R] Maximize}), the parameters and likelihoods of each maximization
will be printed.

{phang}
{opt random} 
is used only with {opt ml} and requests that random starting values be used.  
This option is rarely used and should be used only after {opt protect()} has 
shown the presence of multiple maximums.

{phang}
{opt seed(seed)}
is used only with {opt ml} when the {opt random} or {opt protect()} options
are also specified.  {opt seed()} specifies the random-number seed; see 
{manhelp set_seed R:set seed}.  If {opt seed()} is not specified, the
random-number generator starts in whatever state it was last in.

{marker maximize}{...}
{phang}
{it:maximize_options}:
{opt iter:ate(#)}, [{cmd:no}]{cmd:log}, {opt tr:ace},
{opt tol:erance(#)}, and {opt ltol:erance(#)}, see
{helpb maximize:[R] Maximize}.  These
options are seldom used.

{pstd}
The following option is available with {cmd:factor} but is not shown in
the dialog box:

{phang}
{opt norotated}
specifies that the unrotated factor solution be displayed, even if a rotated
factor solution is available.  {opt norotated} is for use only with replaying
results.


{marker options_factormat}{...}
{title:Options unique to factormat}

{dlgtab:Model}

{marker shape()}{...}
{phang}
{opt shape(shape)}
specifies the shape (storage method) for the covariance or correlation matrix
{it:matname}.  The following shapes are supported:

{phang2}
{cmd:full}
specifies that the correlation or covariance structure of k variables is
a symmetric k x k matrix.  This is the default.

{phang2}
{cmd:lower}
specifies that the correlation or covariance structure of k variables is
a vector with k(k+1)/2 elements in rowwise lower-triangular order,

{p 16 20 2}
C(11) C(21) C(22) C(31) C(32) C(33) ... C(k1) C(k2) ... C(kk)

{phang2}
{cmd:upper}
specifies that the correlation or covariance structure of k variables is
a vector with k(k+1)/2 elements in rowwise upper-triangular order,

{p 16 20 2}
C(11) C(12) C(13) ... C(1k) C(22) C(23) ... C(2k){...}
... {bind:C(k-1,k-1)} {bind:C(k-1,k)} C(kk)

{phang}
{opt names(namelist)}
specifies a list of k different names to be used to document
output and label estimation results and as variable names by {cmd:predict}.
{opt names()} is required if the correlation or covariance matrix is in
vectorized storage mode (that is, {cmd:shape(lower)} or {cmd:shape(upper)} is 
specified).  By default, {cmd:factormat} verifies that the row and column
names of {it:matname} and the column or row names of {it:matname2} and
{it:matname3} from the {opt sds()} and {opt means()} options are in agreement.
Using the {opt names()} option turns off this check.

{phang}
{opt forcepsd} modifies the matrix {it:matname} to be positive semidefinite 
(psd) and so be a proper covariance matrix.  If {it:matname} is not
positive semidefinite, it will have negative eigenvalues.  By setting
negative eigenvalues to 0 and reconstructing, we obtain the least-squares
positive-semidefinite approximation to {it:matname}.  This approximation
is a singular covariance matrix.

{phang}
{opt n(#)},
a required option, specifies the number of observations on which {it:matname}
is based.

{phang}
{opt sds(matname2)}
specifies a k x 1 or 1 x k matrix with the standard deviations of the
variables.  The row or column names should match the variable names,
unless the {opt names()} option is specified.
{opt sds()} may be specified only if {it:matname} is a correlation matrix.
Specify {opt sds()} if you have variables in your dataset and want to use
{cmd:predict} after {cmd:factormat}.  {opt sds()} does not affect the
computations of {cmd:factormat} but provides information so that
{cmd:predict} does not assume that the standard deviations are one.

{phang}
{opt means(matname3)}
specifies a k x 1 or 1 x k matrix with the means of the variables.  The row
or column names should match the variable names, unless the {opt names()}
option is specified.  Specify {opt means()} if you
have variables in your dataset and want to use {cmd:predict} after
{cmd:factormat}.  {opt means()} does not affect the computations of
{cmd:factormat} but provides information so that {cmd:predict} does
not assume the means are zero.


{marker examples_factor}{...}
{title:Examples of factor}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bg2}{p_end}

{pstd}Principal factors{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6}

{pstd}Principal factors, keep 2 factors{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6, factors(2)}

{pstd}Principal-component factors, keep 2{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6, factors(2) pcf}

{pstd}Iterated principal factors, keep 2{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6, factors(2) ipf}

{pstd}Maximum-likelihood factors, keep 2{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6, factors(2) ml}


{marker examples_factormat}{...}
{title:Examples of factormat}

{pstd}
First enter the correlation matrix and set the row and column names.

	{cmd:. matrix C = ( 1.000, 0.943,  0.771  \ ///}
	{cmd:               0.943, 1.000,  0.605  \ ///}
	{cmd:               0.771, 0.605,  1.000  ) }

{pstd}
Next invoke {cmd:factormat}, with the number of observations in {cmd:n()}.

{phang2}
{cmd:. factormat C, n(979) names(visual hearing taste) fac(1)}

{pstd}Same as above, but with {cmd:C} entered as a vector.{p_end}

{phang2}
{cmd:. matrix C = ( 1.000, 0.943, 0.771, 1.000, 0.605, 1.000)}

{pstd}
Next we use {cmd:factormat}, specifying the storage {cmd:shape(upper)} and
the variable names with the option {cmd:names()}.

{phang2}
{cmd:. factormat C, n(979) shape(upper) fac(1) names(visual hearing taste)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:factor} and {cmd:factormat} store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(f)}}number of retained factors{p_end}
{synopt:{cmd:e(evsum)}}sum of all eigenvalues{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(chi2_i)}}likelihood-ratio test of "independence vs. saturated"{p_end}
{synopt:{cmd:e(df_i)}}degrees of freedom of test of "independence vs. saturated"{p_end}
{synopt:{cmd:e(p_i)}}p-value of "independence vs. saturated"{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood of null model ({cmd:ml} only){p_end}
{synopt:{cmd:e(ll)}}log likelihood ({cmd:ml} only){p_end}
{synopt:{cmd:e(aic)}}Akaike's AIC ({cmd:ml} only){p_end}
{synopt:{cmd:e(bic)}}Schwarz's BIC ({cmd:ml} only){p_end}
{synopt:{cmd:e(chi2_1)}}likelihood-ratio test of "# factors vs. saturated" ({cmd:ml} only){p_end}
{synopt:{cmd:e(df_1)}}degrees of freedom of test of "# factors vs. saturated" ({cmd:ml} only){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:factor}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}{cmd:pf}, {cmd:pcf}, {cmd:ipf}, or {cmd:ml}{p_end}
{synopt:{cmd:e(wtype)}}weight type ({cmd:factor} only){p_end}
{synopt:{cmd:e(wexp)}}weight expression ({cmd:factor} only){p_end}
{synopt:{cmd:e(title)}}{cmd:Factor analysis}{p_end}
{synopt:{cmd:e(mtitle)}}description of method (e.g., {cmd:principal factors}){p_end}
{synopt:{cmd:e(heywood)}}{cmd:Heywood case} (when encountered){p_end}
{synopt:{cmd:e(matrixname)}}input matrix ({cmd:factormat} only){p_end}
{synopt:{cmd:e(mineigen)}}specified {cmd:mineigen()} option{p_end}
{synopt:{cmd:e(factors)}}specified {cmd:factors()} option{p_end}
{synopt:{cmd:e(rngstate)}}random-number state used ({cmd:seed()} option only){p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV eigen}{p_end}
{synopt:{cmd:e(rotate_cmd)}}{cmd:factor_rotate}{p_end}
{synopt:{cmd:e(estat_cmd)}}{cmd:factor_estat}{p_end}
{synopt:{cmd:e(predict)}}{cmd:factor_p}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(sds)}}standard deviations of analyzed variables{p_end}
{synopt:{cmd:e(means)}}means of analyzed variables{p_end}
{synopt:{cmd:e(C)}}analyzed correlation matrix{p_end}
{synopt:{cmd:e(Phi)}}variance matrix common factors{p_end}
{synopt:{cmd:e(L)}}factor loadings{p_end}
{synopt:{cmd:e(Psi)}}uniqueness (variance of specific factors){p_end}
{synopt:{cmd:e(Ev)}}eigenvalues{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample ({cmd:factor} only){p_end}
{p2colreset}{...}

{pstd}
{cmd:rotate} after {cmd:factor} and {cmd:factormat} stores items in {cmd:e()}
along with the estimation command.  See {it:Stored results} of
{manhelp factor_postestimation MV:factor postestimation} and
{manhelp rotate MV} for details.


{marker reference}{...}
{title:Reference}

{marker MW1995}{...}
{phang}
Milan, L., and J. Whittaker. 1995. Application of the parametric bootstrap
to models that incorporate a singular value decomposition.
{it:Applied Statistics} 44: 31-49.
{p_end}
