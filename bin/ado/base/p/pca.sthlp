{smcl}
{* *! version 1.2.22  19oct2017}{...}
{viewerdialog pca "dialog pca"}{...}
{viewerdialog pcamat "dialog pcamat"}{...}
{vieweralsosee "[MV] pca" "mansection MV pca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] pca postestimation" "help pca postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] alpha" "help alpha"}{...}
{vieweralsosee "[MV] biplot" "help biplot"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "[D] corr2data" "help corr2data"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[R] tetrachoric" "help tetrachoric"}{...}
{viewerjumpto "Syntax" "pca##syntax"}{...}
{viewerjumpto "Menu" "pca##menu"}{...}
{viewerjumpto "Description" "pca##description"}{...}
{viewerjumpto "Links to PDF documentation" "pca##linkspdf"}{...}
{viewerjumpto "Options" "pca##options"}{...}
{viewerjumpto "Options unique to pcamat" "pca##options_pcamat"}{...}
{viewerjumpto "Technical note" "pca##technote"}{...}
{viewerjumpto "Examples" "pca##examples"}{...}
{viewerjumpto "Stored results" "pca##results"}{...}
{viewerjumpto "References" "pca##references"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[MV] pca} {hline 2}}Principal component analysis
{p_end}
{p2col:}({mansection MV pca:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Principal component analysis of data

{p 8 12 2}
{cmd:pca} {varlist} {ifin}
[{it:{help pca##weight:weight}}]
[{cmd:,} {it:{help pca##pcaopts:options}}]


{pstd} 
Principal component analysis of a correlation or covariance matrix

{p 8 15 2}
{cmd:pcamat} {it:matname} {cmd:,} {opt n(#)}
[{it:{help pca##pcaopts:options}}
{it:{help pca##pcamatopts:pcamat_options}}]


{phang}
{it:matname} is a k x k symmetric matrix or a k(k+1)/2 long row or column
vector containing the upper or lower triangle of the correlation or covariance
matrix.

{synoptset 19 tabbed}{...}
{marker pcaopts}{...}
{synopthdr}
{synoptline}
{syntab:Model 2}
{synopt:{opt com:ponents(#)}}retain maximum of {it:#} principal components;
	{opt fa:ctors()} is a synonym{p_end}
{synopt:{opt mine:igen(#)}}retain eigenvalues larger than {it:#}; default is
	{cmd:1e-5}{p_end}
{synopt:{opt cor:relation}}perform PCA of the correlation matrix; the
	default{p_end}
{synopt:{opt cov:ariance}}perform PCA of the covariance matrix{p_end}
{synopt:{cmd:vce(}{cmdab:non:e}{cmd:)}}do not compute VCE of the eigenvalues and
	vectors; the default{p_end}
{synopt:{cmd:vce(}{cmdab:nor:mal}{cmd:)}}compute VCE of the eigenvalues and
	vectors assuming multivariate normality{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt bl:anks(#)}}display loadings as blank when
	|loadings| < {it:#}{p_end}
{synopt:{opt novce}}suppress display of SEs even though calculated{p_end}
{p2coldent:# {opt me:ans}}display summary statistics of variables{p_end}

{syntab:Advanced}
{synopt:{opt tol(#)}}advanced option; see {help pca##options_advanced:{it:Options}} for details{p_end}
{synopt:{opt ignore}}advanced option; see {help pca##options_advanced:{it:Options}} for details{p_end}

{synopt:{opt norot:ated}}display unrotated results, even if rotated
	results are available (replay only){p_end}
{synoptline}
{p 4 6 2}
# {opt means} is not allowed with {cmd:pcamat}.{p_end}
{p 4 6 2}
{opt norotated} is not available in the dialog box.{p_end}

{marker pcamatopts}{...}
{synopthdr:pcamat_options}
{synoptline}
{syntab:Model}
{synopt:{cmdab:sh:ape:(}{cmdab:f:ull}{cmd:)}}{it:matname} is a square symmetric
	matrix; the default{p_end}
{synopt:{cmdab:sh:ape:(}{cmdab:l:ower}{cmd:)}}{it:matname} is a vector with
	the rowwise lower triangle (with diagonal){p_end}
{synopt:{cmdab:sh:ape:(}{cmdab:u:pper}{cmd:)}}{it:matname} is a vector with
	the rowwise upper triangle (with diagonal){p_end}
{synopt:{opt nam:es(namelist)}}variable names; required if {it:matname}
	is triangular{p_end}
{synopt:{opt forcepsd}}modifies {it:matname} to be positive semidefinite{p_end}
{p2coldent:* {opt n(#)}}number of observations{p_end}
{synopt:{opt sds(matname2)}}vector with standard deviations of
	variables{p_end}
{synopt:{opt means(matname3)}}vector with means of variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:n()} is required for {cmd:pcamat}.{p_end}

{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, {cmd:statsby}, and
{cmd:xi} are allowed with {cmd:pca}; see {help prefix}.  However,
{cmd:bootstrap} and {cmd:jackknife} results should be interpreted with
caution; identification of the {cmd:pca} parameters involves data-dependent
restrictions, possibly leading to badly biased and overdispersed estimates
({help pca##MW1995:Milan and Whittaker 1995}).
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed with {cmd:pca}; see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp pca_postestimation MV:pca postestimation} for features available
after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

    {title:pca}

{phang2}
{bf:Statistics > Multivariate analysis >}
    {bf:Factor and principal component analysis >}
    {bf:Principal component analysis (PCA)}

    {title:pcamat}

{phang2}
{bf:Statistics > Multivariate analysis >}
    {bf:Factor and principal component analysis >}
    {bf:PCA of a correlation or covariance matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pca} and {cmd:pcamat} display the eigenvalues and eigenvectors from the
principal component analysis (PCA) eigen decomposition.  The
eigenvectors are returned in orthonormal form, that is, uncorrelated and
normalized.

{pstd}
{cmd:pca} can be used to reduce the number of variables or to learn about the
underlying structure of the data.  {cmd:pcamat} provides the correlation or
covariance matrix directly.  For {cmd:pca}, the correlation or covariance
matrix is computed from the variables in {varlist}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV pcaQuickstart:Quick start}

        {mansection MV pcaRemarksandexamples:Remarks and examples}

        {mansection MV pcaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model 2}

{phang}{opt components(#)} and {opt mineigen(#)}
specify the maximum number of components (eigenvectors or factors) to be
retained.  {cmd:components()} specifies the number directly, and
{cmd:mineigen()} specifies it indirectly, keeping all components with
eigenvalues greater than the indicated value.  The options can be specified
individually, together, or not at all.  {cmd:factors()} is a synonym for
{cmd:components()}.

{pmore}{opt components(#)}
sets the maximum number of components (factors) to be retained.  {cmd:pca} and
{cmd:pcamat} always display the full set of eigenvalues but display
eigenvectors only for retained components.  Specifying a number larger than
the number of variables in {varlist} is equivalent to specifying the number
of variables in {it:varlist} and is the default.

{pmore}
{opt mineigen(#)}
sets the minimum value of eigenvalues to be retained.  The default is
{cmd:1e-5} or the value of {cmd:tol()} if specified.

{pmore}
Specifying {cmd:components()} and {cmd:mineigen()} affects only the number of
components to be displayed and stored in {cmd:e()}; it does not enforce the
assumption that the other eigenvalues are 0.  In particular, the standard
errors reported when {cmd:vce(normal)} is specified do not depend on the number
of retained components.

{phang}{opt correlation} and {opt covariance}
specify that principal components be calculated for the correlation matrix and
covariance matrix, respectively.  The default is {cmd:correlation}.  Unlike
factor analysis, PCA is not scale invariant; the eigenvalues and eigenvectors
of a covariance matrix differ from those of the associated correlation matrix.
Usually, a PCA of a covariance matrix is meaningful only if the variables are
expressed in the same units.

{pmore}
For {cmd:pcamat}, do not confuse the type of the matrix to be
analyzed with the type of {it:matname}.  Obviously, if {it:matname} is
a correlation matrix and the option {cmd:sds()} is not specified, it
is not possible to perform a PCA of the covariance matrix.

{phang}{cmd:vce(}{cmd:none}|{cmd:normal}{cmd:)}
specifies whether standard errors are to be computed for the eigenvalues, the
eigenvectors, and the (cumulative) percentage of explained variance
(confirmatory PCA). These standard errors are obtained assuming
multivariate normality of the data and are valid only for a PCA of a
covariance matrix.  Be cautious if applying these to correlation matrices.

{dlgtab:Reporting}

{phang}{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.  {cmd:level()}
is allowed only with {cmd:vce(normal)}.

{phang}{opt blanks(#)}
shows blanks for loadings with absolute value smaller than {it:#}.  This
option is ignored when specified with {cmd:vce(normal)}.

{phang}{opt novce}
suppresses the display of standard errors, even though they are computed, and
displays the PCA results in a matrix/table style.  You can specify {cmd:novce}
during estimation in combination with {cmd:vce(normal)}.  More likely, you
will want to use {cmd:novce} during replay.

{phang}{opt means}
displays summary statistics of the variables over the estimation sample.
This option is not available with {cmd:pcamat}.

{marker options_advanced}{...}
{dlgtab:Advanced}

{phang}{opt tol(#)}
is an advanced, rarely used option and is available only with
{cmd:vce(normal)}.  An eigenvalue, {it:ev_i}, is classified as being
close to zero if {bind:{it:ev_i} < {it:tol} * max({it:ev})}.  Two eigenvalues,
{it:ev_1} and {it:ev_2}, are "close" if
{bind:abs({it:ev_1}-{it:ev_2}) < tol*max({it:ev})}.
The default is {cmd:tol(1e-5)}. See option {cmd:ignore}
and {it:{help pca##technote:Technical note}} below.

{phang}{opt ignore}
is an advanced, rarely used option and is available only with
{cmd:vce(normal)}.  It continues the computation of standard errors and tests,
even if some eigenvalues are suspiciously close to zero or suspiciously close to
other eigenvalues, violating crucial assumptions of the asymptotic theory used
to estimate standard errors and tests.  See
{it:{help pca##technote:Technical note}} below.

{pstd}
The following option is available with {cmd:pca} and {cmd:pcamat} but is not
shown in the dialog box:

{phang}{opt norotated}
displays the unrotated principal components, even if rotated components are
available.  This option may be specified only when replaying results.


{marker options_pcamat}{...}
{title:Options unique to pcamat}

{dlgtab:Model}

{marker shape()}{...}
{phang}{opt shape(shape_arg)}
specifies the shape (storage mode) for the covariance or correlation
matrix {it:matname}.  The following shapes are supported:

{p 8 12 2}{cmd:full} specifies that the correlation or covariance structure
of k variables is stored as a symmetric k x k matrix.  Specifying
{cmd:shape(full)} is optional in this case.

{p 8 12 2}{cmd:lower} specifies that the correlation or covariance
structure of k variables is stored as a vector with k(k+1)/2 elements
in rowwise lower-triangular order:

{p 16 20 2}
C(11) C(21) C(22) C(31) C(32) C(33) ... C(k1) C(k2) ... C(kk)

{p 8 12 2}{cmd:upper} specifies that the correlation or covariance
structure of k variables is stored as a vector with k(k+1)/2 elements
in rowwise upper-triangular order:

{p 16 20 2}
C(11) C(12) C(13) ... C(1k) C(22) C(23) ... C(2k) ...
C(k-1 k-1) C(k-1 k) C(kk)

{phang}{opt names(namelist)}
specifies a list of k different names, which are used to document output and
to label estimation results and are used as variable names by {cmd:predict}.
By default, {cmd:pcamat} verifies that the row and column names of
{it:matname} and the column or row names of {it:matname2} and {it:matname3}
from the {opt sds()} and {opt means()} options are in agreement.  Using the
{opt names()} option turns off this check.

{phang}
{opt forcepsd} modifies the matrix {it:matname} to be positive semidefinite 
(psd) and so to be a proper covariance matrix.  If {it:matname} is not
positive semidefinite, it will have negative eigenvalues.  By setting
negative eigenvalues to 0 and reconstructing, we obtain the least-squares
positive-semidefinite approximation to {it:matname}.  This approximation
is a singular covariance matrix.

{phang}{opt n(#)}
is required and specifies the number of observations.

{phang}{opt sds(matname2)}
specifies a k x 1 or 1 x k matrix with the standard deviations of the
variables.  The row or column names should match the variable names, unless
the {opt names()} option is specified.  {cmd:sds()} may be specified only if
{it:matname} is a correlation matrix.

{phang}{opt means(matname3)}
specifies a k x 1 or 1 x k matrix with the means of the variables.  The row or
column names should match the variable names, unless the {opt names()} option
is specified.  Specify {cmd:means()} if you have variables in your dataset and
want to use {cmd:predict} after {cmd:pcamat}.


{marker technote}{...}
{title:Technical note}

{pstd}
{cmd:pca} and {cmd:pcamat} with the {cmd:vce(normal)} option assume that

{p 8 13 2}
(A1) the variables are multivariate normal distributed and

{p 8 13 2}
(A2) the variance-covariance matrix of the observations has all distinct
and strictly positive eigenvalues.

{pstd}
Under assumptions A1 and A2, the eigenvalues and eigenvectors of the sample
covariance matrix can be seen as maximum likelihood estimates for the
population analogues that are asymptotically (multivariate) normally
distributed ({help pca##A1963:Anderson 1963}; {help pca##J2003:Jackson 2003}).
See {help pca##T1981:Tyler (1981)} for related results for elliptic
distributions.  Be cautious when interpreting because the asymptotic variances
are rather sensitive to violations of assumption A1 (and A2).  Wald tests of
hypotheses that are in conflict with assumption A2 (for example, testing that
the first and second eigenvalue are the same) produce incorrect p-values.

{pstd}
Because the statistical theory for a PCA of a correlation matrix is much more
complicated, {cmd:pca} and {cmd:pcamat} compute standard errors and tests of a
correlation matrix as if it were a covariance matrix.  This practice is in
line with the application of asymptotic theory in
{help pca##J2003:Jackson (2003)}.  This will usually lead to some
underestimation of standard errors, but we believe that this problem is smaller
than the consequences of deviations from normality.

{pstd}
You may conduct tests for multivariate normality using the 
{cmd:mvtest} {cmd:normality} command (see
{manhelp mvtest_normality MV:mvtest normality}).


{marker examples}{...}
{title:Examples}

    Standard PCA for descriptive use
        {cmd:. sysuse auto}
        {cmd:. pca trunk weight length headroom}
        {cmd:. pca trunk weight length headroom, comp(2) covariance}

    PCA assuming multivariate normality of the data
        {cmd:. webuse bg2}
	{cmd:. pca bg2cost*, vce(normal)}

    PCA of a covariance or correlation matrix
        {cmd:. matrix S = ( 10.167, 22.690,  2.040  \ ///}
        {cmd:               22.690, 56.949,  3.788  \ ///}
        {cmd:                2.040,  3.788,  0.688  ) }
        {cmd:. matrix rownames S = visual hearing taste}
        {cmd:. matrix colnames S = visual hearing taste}
        {cmd:. pcamat S, n(979) comp(2)}

    Same as above
        {cmd:. matrix S = ( 10.167, 22.690, 2.040, ///}
        {cmd:                       56.949, 3.788, ///}
        {cmd:                               0.688 )}
{phang2}{cmd:. pcamat S, n(979) shape(upper) comp(2)}
       {cmd:names(visual hearing taste)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pca} and {cmd:pcamat} without the {cmd:vce(normal)} option store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(f)}}number of retained components{p_end}
{synopt:{cmd:e(rho)}}fraction of explained variance{p_end}
{synopt:{cmd:e(trace)}}trace of {cmd:e(C)}{p_end}
{synopt:{cmd:e(lndet)}}ln of the determinant of {cmd:e(C)}{p_end}
{synopt:{cmd:e(cond)}}condition number of {cmd:e(C)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:pca} (even for {cmd:pcamat}){p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(Ctype)}}{cmd:correlation} or {cmd:covariance}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV eigen}{p_end}
{synopt:{cmd:e(rotate_cmd)}}program used to implement {cmd:rotate}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(C)}}p x p correlation or covariance matrix{p_end}
{synopt:{cmd:e(means)}}1 x p matrix of means{p_end}
{synopt:{cmd:e(sds)}}1 x p matrix of standard deviations{p_end}
{synopt:{cmd:e(Ev)}}1 x p matrix of eigenvalues (sorted){p_end}
{synopt:{cmd:e(L)}}p x f matrix of eigenvectors = components{p_end}
{synopt:{cmd:e(Psi)}}1 x p matrix of unexplained variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:pca} and {cmd:pcamat} with the {cmd:vce(normal)} option store the above,
as well as the following:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(v_rho)}}variance of {cmd:e(rho)}{p_end}
{synopt:{cmd:e(chi2_i)}}chi-squared statistic for test of independence{p_end}
{synopt:{cmd:e(df_i)}}degrees of freedom for test of independence{p_end}
{synopt:{cmd:e(p_i)}}p-value for test of independence{p_end}
{synopt:{cmd:e(chi2_s)}}chi-squared statistic for test of sphericity{p_end}
{synopt:{cmd:e(df_s)}}degrees of freedom for test of sphericity{p_end}
{synopt:{cmd:e(p_s)}}p-value for test of sphericity{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(vce)}}{cmd:multivariate normality}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V eigen}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}1 x p+fp coefficient vector (all eigenvalues and retained
	eigenvectors){p_end}
{synopt:{cmd:e(Ev_bias)}}1 x p matrix: bias of eigenvalues{p_end}
{synopt:{cmd:e(Ev_stats)}}p x 5 matrix with statistics on explained
	variance{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates {cmd:e(b)}{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker A1963}{...}
{phang}
Anderson, T. W. 1963. Asymptotic theory for principal component analysis.
{it:Annals of Mathematical Statistics} 34: 122-148.

{marker J2003}{...}
{phang}
Jackson, J. E. 2003. {it:A User's Guide to Principal Components}.
New York: Wiley.

{marker MW1995}{...}
{phang}
Milan, L., and J. Whittaker. 1995. Application of the parametric bootstrap to
models that incorporate a singular value decomposition.
{it:Applied Statistics} 44: 31-49.

{marker T1981}{...}
{phang}
Tyler, D. E. 1981. Asymptotic inference for eigenvectors.
{it:Annals of Statistics} 9: 725-736.
{p_end}
