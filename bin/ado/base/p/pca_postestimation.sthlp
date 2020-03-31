{smcl}
{* *! version 1.3.7  04jun2018}{...}
{viewerdialog predict "dialog pca_p"}{...}
{viewerdialog estat "dialog pca_estat"}{...}
{viewerdialog loadingplot "dialog loadingplot"}{...}
{viewerdialog rotate "dialog rotate"}{...}
{viewerdialog scoreplot "dialog scoreplot"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] pca postestimation" "mansection MV pcapostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] rotate" "help rotate"}{...}
{vieweralsosee "[MV] scoreplot" "help scoreplot"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "pca postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "pca_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "pca postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "pca postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "pca postestimation##examples"}{...}
{viewerjumpto "Stored results" "pca postestimation##results"}{...}
{viewerjumpto "Reference" "pca postestimation##reference"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[MV] pca postestimation} {hline 2}}Postestimation tools for pca and
pcamat
{p_end}
{p2col:}({mansection MV pcapostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:pca} and {cmd:pcamat}:

{synoptset 22 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb pca postestimation##anti:estat anti}}anti-image correlation and
	covariance matrices{p_end}
{synopt:{helpb pca postestimation##kmo:estat kmo}}Kaiser-Meyer-Olkin measure
	of sampling adequacy{p_end}
{synopt:{helpb pca postestimation##loadings:estat loadings}}component-loading
	matrix in one of several normalizations{p_end}
{synopt:{helpb pca postestimation##residuals:estat residuals}}matrix of
	correlation or covariance residuals{p_end}
{synopt:{helpb pca postestimation##rotatecomp:estat rotatecompare}}compare
	rotated and unrotated components{p_end}
{synopt:{helpb pca postestimation##smc:estat smc}}squared multiple
	correlations between each variable and the rest{p_end}
{p2coldent:+ {helpb pca postestimation##summarize:estat summarize}}display
	summary statistics over the estimation sample{p_end}
{synopt:{helpb scoreplot:loadingplot}}plot component loadings{p_end}
{synopt:{helpb rotate}}rotate component loadings{p_end}
{synopt:{helpb scoreplot}}plot score variables{p_end}
{synopt:{helpb screeplot}}plot eigenvalues{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
+ {cmd:estat summarize} is not available after {cmd:pcamat}.
{p_end}

{pstd}
The following standard postestimation commands are also available:

{synoptset 22 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:+ {bf:{help estat vce}}}variance-covariance matrix of the estimators (VCE){p_end}
INCLUDE help post_estimates
{p2coldent:* {helpb lincom}}point estimates, standard errors, testing, and
	inference for linear combinations of coefficients{p_end}
{p2coldent:* {helpb nlcom}}point estimates, standard errors, testing, and
	inference for nonlinear combinations of coefficients{p_end}
{synopt:{helpb pca postestimation##predict:predict}}score variables,
	predictions, and residuals{p_end}
{p2coldent:* {helpb predictnl}}point estimates, standard errors, testing, and
	inference for generalized predictions{p_end}
{p2coldent:* {helpb test}}Wald tests of simple and composite linear
	hypotheses{p_end}
{p2coldent:* {helpb testnl}}Wald tests of nonlinear hypotheses{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
+ {cmd:estat} {cmd:vce} is available after {cmd:pca} and {cmd:pcamat} with the
{cmd:vce(normal)} option.
{p_end}
{p 4 6 2}
* {cmd:lincom}, {cmd:nlcom}, {cmd:predictnl}, {cmd:test}, and {cmd:testnl} are 
available only after {cmd:pca} with the {cmd:vce(normal)} option.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV pcapostestimationRemarksandexamples:Remarks and examples}

        {mansection MV pcapostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}} {ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 21 tabbed}{...}
{p2coldent:{it:statistic}{space 2}{sf:# of vars.}}Description
	({it:k} = # of orig. vars.; {it:f} = # of components){p_end}
{synoptline}
{syntab:Main}
{synopt:{opt sc:ore} {space 5} 1,...,{it:f}}scores based on the components; the
	default{p_end}
{synopt:{opt f:it} {space 7} {it:k}}fitted values using the retained
	components{p_end}
{synopt:{opt res:idual} {space 2} {it:k}}raw residuals from the fit using the
	retained components{p_end}
{synopt:{opt q} {space 9} 1}residual sums of squares{p_end}
{synoptline}

{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt norot:ated}}use unrotated results, even when rotated results
are available{p_end}
{synopt:{opt cen:ter}}base scores on centered variables{p_end}
{synopt:{opt notab:le}}suppress table of scoring coefficients{p_end}
{synopt:{opth for:mat(%fmt)}}format for displaying the scoring
	coefficients{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates new variables containing predictions such as
scores, fitted values, raw residuals, and residual sums of squares.


{marker options_predict}{...}
{title:Options for predict}

{pstd}
Note on {cmd:pcamat}: {cmd:predict} requires that variables with the correct
names be available in memory.  Apart from centered scores, {opt means()}
should have been specified with {cmd:pcamat}.  If you used {cmd:pcamat}
because you have access only to the correlation or covariance matrix, you
cannot use {cmd:predict}.

{dlgtab:Main}

{phang}
{opt score} calculates the scores for components 1, ..., {it:#}, where
{it:#} is the number of variables in {it:{help varlist:newvarlist}}.

{phang}
{opt fit} calculates the fitted values, using the retained components, for
each variable.  The number of variables in {it:{help varlist:newvarlist}}
should equal the number of variables in the {varlist} of {helpb pca}.

{phang}
{opt residual} calculates for each variable the raw residuals
(residual = observed - fitted), with the fitted values computed using the
retained components.

{phang}
{opt q} calculates the Rao statistics (that is, the sums of squares of the
omitted components) weighted by the respective eigenvalues.  This equals the
residual sums of squares between the original variables and the fitted values.

{phang}
{opt norotated}
uses unrotated results, even when rotated results are available.

{phang}
{opt center}
bases scores on centered variables.  This option is relevant only for a PCA of
a covariance matrix, in which the scores are based on uncentered variables
by default.  Scores for a PCA of a correlation matrix are always based on the
standardized variables.

{phang}
{opt notable}
suppresses the table of scoring coefficients.

{phang}
{opth format(%fmt)}
specifies the display format for scoring coefficients. The default is
{cmd:format(%8.4f)}.


{marker syntax_estat}{...}
{title:Syntax for estat}

{marker anti}{...}
{pstd}
Display the anti-image correlation and covariance matrices

{p 8 14 2}
{cmd:estat} {cmd:anti}
[{cmd:,} {opt nocorr} {opt nocov} {opth for:mat(%fmt)}]


{marker kmo}{...}
{pstd}
Display the Kaiser-Meyer-Olkin measure of sampling adequacy

{p 8 14 2}
{cmd:estat} {cmd:kmo}
[{cmd:,} {opt nov:ar} {opth for:mat(%fmt)}]


{marker loadings}{...}
{pstd}
Display the component-loading matrix

{p 8 14 2}
{cmd:estat} {cmdab:loa:dings}
[{cmd:,} {cmdab:cn:orm(}{cmdab:u:nit}|{cmdab:e:igen}|{cmdab:i:nveigen}{cmd:)}
{opth for:mat(%fmt)}]


{marker residuals}{...}
{pstd}
Display the differences in matrices

{p 8 14 2}
{cmd:estat} {cmdab:res:iduals}
[{cmd:,} {opt o:bs} {opt f:itted} {opth for:mat(%fmt)}]


{marker rotatecomp}{...}
{pstd}
Display the unrotated and rotated components

{p 8 14 2}
{cmd:estat} {cmdab:rot:atecompare} [{cmd:,} {opth for:mat(%fmt)}]


{marker smc}{...}
{pstd}
Display the squared multiple correlations

{p 8 14 2}
{cmd:estat} {cmd:smc} [{cmd:,} {opth for:mat(%fmt)}]


{marker summarize}{...}
{pstd}
Display the summary statistics

{p 8 14 2}
{cmd:estat} {cmdab:su:mmarize}
[{cmd:,} {opt lab:els} {opt nohea:der}  {opt nowei:ghts}]


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat anti}
displays the anti-image correlation and anti-image covariance matrices.  These
are minus the partial covariance and minus the partial correlation of all
pairs of variables, holding all other variables constant.

{pstd}
{cmd:estat kmo}
displays the Kaiser-Meyer-Olkin (KMO) measure of sampling adequacy.  KMO takes
values between 0 and 1, with small values indicating that overall the
variables have too little in common to warrant a PCA analysis.
Historically, the following labels are often given to values of KMO
({help pca_postestimation##K1974:Kaiser 1974}):

	    0.00 to 0.49    unacceptable
	    0.50 to 0.59    miserable
	    0.60 to 0.69    mediocre
            0.70 to 0.79    middling
            0.80 to 0.89    meritorious
            0.90 to 1.00    marvelous

{pstd}
{cmd:estat loadings}
displays the component-loading matrix in one of several normalizations of the
columns (eigenvectors).

{pstd}
{cmd:estat residuals}
displays the difference between the observed correlation or covariance matrix
and the fitted (reproduced) matrix using the retained factors.

{pstd}
{cmd:estat rotatecompare}
displays the unrotated (principal) components next to the most recent rotated
components.

{pstd}
{cmd:estat smc}
displays the squared multiple correlations between each variable and all other
variables.  SMC is a theoretical lower bound for communality and thus an upper
bound for the unexplained variance.

{pstd}
{cmd:estat summarize}
displays summary statistics of the variables in the principal component
analysis over the estimation sample.  This subcommand is not available after
{cmd:pcamat}.


{marker options_estat}{...}
{title:Options for estat}

{phang}
{opt nocorr},
an option used with {cmd:estat anti}, suppresses the display of the anti-image
correlation matrix, that is, minus the partial correlation matrix of all pairs
of variables, holding constant all other variables.

{phang}
{opt nocov},
an option used with {cmd:estat anti}, suppresses the display of the anti-image
covariance matrix, that is, minus the partial covariance matrix of all pairs of
variables, holding constant all other variables.

{phang}
{opth format(%fmt)}
specifies the display format.  The defaults differ between the subcommands.

{phang}
{opt novar},
an option used with {cmd:estat kmo},
suppresses the Kaiser-Meyer-Olkin measures of sampling adequacy for the
variables in the principal component analysis, displaying the overall KMO
measure only.

{phang}
{cmd:cnorm(unit}|{cmd:eigen}|{cmd:inveigen)},
an option used with {cmd:estat loadings}, selects the normalization of the
eigenvectors, the columns of the principal-component loading matrix.  The
following normalizations are available

{p 12 24 2}{cmd:unit} {space 6} ssq(column) = 1; the default{p_end}
{p 12 24 2}{cmd:eigen} {space 5} ssq(column) = eigenvalue{p_end}
{p 12 24 2}{cmd:inveigen} {space 2} ssq(column) = 1/eigenvalue

{pmore}
with ssq(column) being the sum of squares of the elements in a column and
eigenvalue, the eigenvalue associated with the column (eigenvector).

{phang}
{opt obs},
an option used with {cmd:estat residuals}, displays the observed correlation or
covariance matrix for which the PCA was performed.

{phang}
{opt fitted},
an option used with {cmd:estat residuals}, displays the fitted (reconstructed)
correlation or covariance matrix based on the retained components.

{phang}
{opt labels}, {opt noheader}, and {opt noweights}
are the same as for the generic {cmd:estat summarize} command; see
{helpb estat summarize:[R] estat summarize}.


{marker examples}{...}
{title:Examples}

    Setup
        {cmd:. sysuse auto}
	{cmd:. pca trunk weight length headroom}
    
    Statistics
    	{cmd:. estat residuals, fitted}
    	{cmd:. estat loadings, cnorm(eigen)}

    Scree plot
        {cmd:. screeplot}

    Plots of component loadings and scores
        {cmd:. loadingplot, component(3)}
        {cmd:. scoreplot, component(3)}

    Rotation of loadings
	{cmd:. rotate}
        {cmd:. rotate, varimax}

    Individual scores for the components are obtained via {cmd:predict}
        {cmd:. predict f1}
        {cmd:. drop f1}
        {cmd:. predict f1 f2}
        {cmd:. drop f1 f2}
        {cmd:. predict f1-f4}

    Residual sums of squares
        {cmd:. predict t, q}


{marker results}{...}
{title:Stored results}

{pstd}
Let {it:p} be the number of variables and {it:f}, the number of factors.

{pstd}
{cmd:predict}, in addition to generating variables, also stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(scoef)}}p x f matrix of scoring coefficients{p_end}

{pstd}
{cmd:estat anti} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(acov)}}p x p anti-image covariance matrix {p_end}
{synopt:{cmd:r(acorr)}}p x p anti-image correlation matrix {p_end}

{pstd}
{cmd:estat kmo} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(kmo)}}the Kaiser-Meyer-Olkin measure of sampling adequacy {p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(kmow)}}column vector of KMO measures for each variable{p_end}

{pstd}
{cmd:estat loadings} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cnorm)}}component normalization: {cmd:eigen}, {cmd:inveigen},
or {cmd:unit} {p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(A)}}p x f matrix of normalized component loadings{p_end}

{pstd}
{cmd:estat residuals} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(fit)}}p x p matrix of fitted values{p_end}
{synopt:{cmd:r(residual)}}p x p matrix of residuals{p_end}

{pstd}
{cmd:estat smc} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(smc)}}vector of squared multiple correlations of variables with
all other variables{p_end}

{pstd}
See the returned results of {cmd:estat summarize} in
{helpb estat summarize:[R] estat summarize} and
of {cmd:estat vce} in {helpb estat vce:[R] estat vce} (available when
{cmd:vce(normal)} is specified with {cmd:pca} or {cmd:pcamat}).

{pstd}
{cmd:rotate} after {cmd:pca} and {cmd:pcamat} add to the existing {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(r_f)}}number of components in rotated solution{p_end}
{synopt:{cmd:e(r_fmin)}}rotation criterion value{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(r_class)}}{cmd:orthogonal} or {cmd:oblique}{p_end}
{synopt:{cmd:e(r_criterion)}}rotation criterion{p_end}
{synopt:{cmd:e(r_ctitle)}}title for rotation{p_end}
{synopt:{cmd:e(r_normalization)}}{cmd:kaiser} or {cmd:none}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(r_L)}}rotated loadings{p_end}
{synopt:{cmd:e(r_T)}}rotation{p_end}
{synopt:{cmd:e(r_Ev)}}explained variance by rotated components{p_end}
{p2colreset}{...}

{pstd}
The components in the rotated solution are in decreasing order of 
{cmd:e(r_Ev)}.


{marker reference}{...}
{title:Reference}

{marker K1974}{...}
{phang}
Kaiser, H. F. 1974. An index of factor simplicity.
  {it:Psychometrika} 39: 31-36.
{p_end}
