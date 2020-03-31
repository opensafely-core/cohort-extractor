{smcl}
{* *! version 1.3.6  04jun2018}{...}
{viewerdialog predict "dialog factor_p"}{...}
{viewerdialog estat "dialog factor_estat"}{...}
{viewerdialog loadingplot "dialog loadingplot"}{...}
{viewerdialog rotate "dialog rotate"}{...}
{viewerdialog scoreplot "dialog scoreplot"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] factor postestimation" "mansection MV factorpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] rotate" "help rotate"}{...}
{vieweralsosee "[MV] scoreplot" "help scoreplot"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "factor postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "factor_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "factor postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "factor postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "factor postestimation##examples"}{...}
{viewerjumpto "Stored results" "factor postestimation##results"}{...}
{viewerjumpto "References" "factor postestimation##references"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[MV] factor postestimation} {hline 2}}Postestimation tools for
factor and factormat
{p_end}
{p2col:}({mansection MV factorpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:factor} and {cmd:factormat}:

{synoptset 21 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb factor postestimation##anti:estat anti}}anti-image correlation
	and covariance matrices{p_end}
{synopt:{helpb factor postestimation##common:estat common}}correlation matrix
	of the common factors{p_end}
{synopt:{helpb factor postestimation##factors:estat factors}}AIC and BIC 
	model-selection criteria for different numbers of factors{p_end}
{synopt:{helpb factor postestimation##kmo:estat kmo}}Kaiser-Meyer-Olkin
	measure of sampling adequacy{p_end}
{synopt:{helpb factor postestimation##residuals:estat residuals}}matrix of
        correlation residuals{p_end}
{synopt:{helpb factor postestimation##rotatecomp:estat rotatecompare}}compare
        rotated and unrotated loadings{p_end}
{synopt:{helpb factor postestimation##smc:estat smc}}squared multiple
        correlations between each variable and the rest{p_end}
{synopt:{helpb factor postestimation##structure:estat structure}}correlations
	between variables and common factors{p_end}
{p2coldent:+ {helpb factor postestimation##summarize:estat summarize}}estimation
	sample summary{p_end}
{synopt:{helpb scoreplot:loadingplot}}plot factor loadings{p_end}
{synopt:{helpb rotate}}rotate factor loadings{p_end}
{synopt:{helpb scoreplot}}plot score variables{p_end}
{synopt:{helpb screeplot}}plot eigenvalues{p_end}
{synoptline}
{p 4 6 2}
+ {cmd:estat summarize} is not available after {cmd:factormat}.
{p_end}

{pstd}
The following standard postestimation commands are also available:

{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{p2coldent:+ {helpb factor postestimation##predict:predict}}predict 
	regression or Bartlett scores{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estimates table} is not allowed, and {cmd:estimates stats} is 
allowed only with the {cmd:ml} factor method.
{p_end}

{p 4 6 2}
+ {cmd:predict} after {cmd:factormat} works only if you have variables in
memory that match the names specified in {cmd:factormat}.  {cmd:predict}
assumes mean zero and standard deviation one unless the {cmd:means()}
and {cmd:sds()} options of {cmd:factormat} were provided.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV factorpostestimationRemarksandexamples:Remarks and examples}

        {mansection MV factorpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}} {ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 16 tabbed}{...}
{p2coldent:statistic}Description{p_end}
{synoptline}
{syntab:Main}
{p2col:{opt r:egression}}regression scoring method; the default{p_end}
{p2col:{opt b:artlett}}Bartlett scoring method{p_end}
{synoptline}

{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt norot:ated}}use unrotated results, even when rotated results are
	available{p_end}
{synopt:{opt not:able}}suppress table of scoring coefficients{p_end}
{synopt:{opth for:mat(%fmt)}}format for displaying the scoring
	coefficients{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates new variables containing predictions such as
factors scored by the regression method or by the Bartlett method.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt regression}
produces factors scored by the regression method.  This is the default.

{phang}
{opt bartlett}
produces factors scored by the method suggested by Bartlett
({help factor postestimation##B1937:1937},
 {help factor postestimation##B1938:1938}).  This method
produces unbiased factors, but they may be less accurate than those produced
by the default regression method suggested by
{help factor postestimation##T1951:Thomson (1951)}.  Regression-scored
factors have the smallest mean squared error from the true factors but may be
biased.

{phang}
{opt norotated}
specifies that unrotated factors be scored even when you have previously
issued a {cmd:rotate} command.  The default is to use rotated factors if
they are available and unrotated factors otherwise.

{phang}
{opt notable}
suppresses the table of scoring coefficients.

{phang}
{opth format(%fmt)}
specifies the display format for scoring coefficients.


{marker syntax_estat}{...}
{title:Syntax for estat}

{marker anti}{...}
{pstd}
Anti-image correlation/covariance matrices

{p 8 12 2}
{cmd:estat anti}
[{cmd:,} {opt nocorr} {opt nocov} {opth for:mat(%fmt)}]


{marker common}{...}
{pstd}
Correlation of common factors

{p 8 12 2}
{cmd:estat} {cmdab:com:mon}
[{cmd:,} {opt norot:ated} {opth for:mat(%fmt)}]


{marker factors}{...}
{pstd}
Model-selection criteria

{p 8 12 2}
{cmd:estat} {cmdab:fac:tors}
[{cmd:,} {opt fac:tors(#)} {opt det:ail}]


{marker kmo}{...}
{pstd}
Sample adequacy measures

{p 8 12 2}
{cmd:estat kmo}
[{cmd:,} {opt nov:ar} {opth for:mat(%fmt)}]


{marker residuals}{...}
{pstd}
Residuals of correlation matrix

{p 8 12 2}
{cmd:estat} {cmdab:res:iduals}
[{cmd:,} {opt f:itted} {opt o:bs} {opt sr:esiduals} {opth for:mat(%fmt)}]


{marker rotatecomp}{...}
{pstd}
Comparison of rotated and unrotated loadings

{p 8 12 2}
{cmd:estat} {cmdab:rot:atecompare} [{cmd:,} {opth for:mat(%fmt)}]


{marker smc}{...}
{pstd}
Squared multiple correlations

{p 8 12 2}
{cmd:estat smc}
[{cmd:,} {opth for:mat(%fmt)}]


{marker structure}{...}
{pstd}
Correlations between variables and common factors

{p 8 12 2}
{cmd:estat} {cmdab:str:ucture}
[{cmd:,} {opt norot:ated} {opth for:mat(%fmt)}]


{marker summarize}{...}
{pstd}
Summarize variables for estimation sample

{p 8 12 2}
{cmd:estat} {cmdab:su:mmarize}
[{cmd:,} {opt lab:els} {opt nohea:der} {opt nowei:ghts}]


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat anti}
displays the anti-image correlation and anti-image covariance matrices.  These
are minus the partial covariance and minus the partial correlation matrices of
all pairs of variables, holding all other variables constant.

{pstd}
{cmd:estat common}
displays the correlation matrix of the common factors.  For orthogonal factor
loadings, the common factors are uncorrelated, and hence an identity matrix is
shown.  {cmd:estat common} is of more interest after oblique rotations.

{pstd}
{cmd:estat factors}
displays model-selection criteria (AIC and BIC) for models with 1, 2, ..., #
factors.  Each model is estimated using maximum likelihood (that is, using the
{cmd:ml} option of {cmd:factor}).

{pstd}
{cmd:estat kmo}
specifies that the Kaiser-Meyer-Olkin (KMO) measure of sampling adequacy be
displayed.  KMO takes values between 0 and 1, with small values meaning that
overall the variables have too little in common to warrant a factor analysis.
Historically, the following labels are given to values of KMO
({help factor_postestimation##K1974:Kaiser 1974}):

	    0.00 to 0.49    unacceptable
	    0.50 to 0.59    miserable
	    0.60 to 0.69    mediocre
	    0.70 to 0.79    middling
	    0.80 to 0.89    meritorious
	    0.90 to 1.00    marvelous

{pstd}
{cmd:estat residuals}
displays the raw or standardized residuals of the observed correlations with
respect to the fitted (reproduced) correlation matrix.

{pstd}
{cmd:estat rotatecompare}
displays the unrotated factor loadings and the most recent rotated factor
loadings.

{pstd}
{cmd:estat smc}
displays the squared multiple correlations between each variable and all other
variables.  SMC is a theoretical lower bound for communality, so it is an upper
bound for uniqueness.  The {cmd:pf} factor method estimates the
communalities by {cmd:smc}.

{pstd}
{cmd:estat structure}
displays the factor structure, that is, the correlations between the variables
and the common factors.

{pstd}
{cmd:estat summarize}
displays summary statistics of the variables in the factor analysis over the
estimation sample.  This subcommand is, of course, not available after
{cmd:factormat}.


{marker options_estat}{...}
{title:Options for estat}

{dlgtab:Main}

{phang}
{opt nocorr},
an option used with {cmd:estat anti},
suppresses the display of the anti-image correlation matrix.

{phang}
{opt nocov},
an option used with {cmd:estat anti},
suppresses the display of the anti-image covariance matrix.

{phang}
{opth format(%fmt)}
specifies the display format.  The defaults differ between the subcommands.

{phang}
{opt norotated},
an option used with {cmd:estat common} and {cmd:estat structure},
requests that the displayed and returned results be based on the unrotated
original factor solution rather than on the last rotation (orthogonal or
oblique).

{phang}
{opt factors(#)},
an option used with {cmd:estat factors},
specifies the maximum number of factors to include in the summary table.

{phang}
{opt detail},
an option used with {cmd:estat factors},
presents the output from each run of {cmd:factor} (or {cmd:factormat}) used in
the computations of the AIC and BIC values.

{phang}
{opt novar},
an option used with {cmd:estat kmo},
suppresses the KMO measures of sampling adequacy for the variables in the
factor analysis, displaying the overall KMO measure only.

{phang}
{opt fitted},
an option used with {cmd:estat residuals},
displays the fitted (reconstructed) correlation matrix on the basis of the
retained factors.

{phang}
{opt obs},
an option used with {cmd:estat residuals},
displays the observed correlation matrix.

{phang}
{opt sresiduals},
an option used with {cmd:estat residuals},
displays the matrix of standardized residuals of the correlations. 
Be careful when interpreting these residuals; see
{help factor postestimation##JS1988:J{c o:}reskog and S{c o:}rbom (1988)}.

{phang}
{opt labels}, {opt noheader}, and {opt noweights}
are the same as for the generic {cmd:estat summarize} command; see
{helpb estat summarize:[R] estat summarize}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bg2}{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6}

{pstd}Residuals of correlation matrix{p_end}
{phang2}{cmd:. estat residuals}

{pstd}Estimation sample{p_end}
{phang2}{cmd:. estat summ}

{pstd}Varimax rotation{p_end}
{phang2}{cmd:. rotate}

{pstd}Use 1st 2 factors if > 2 retained{p_end}
{phang2}{cmd:. rotate, factors(2)}

{pstd}Promax rotation{p_end}
{phang2}{cmd:. rotate, promax}

{pstd}Oblique oblimin rotation{p_end}
{phang2}{cmd:. rotate, oblimin(0.5) oblique}

{pstd}Score first two, rotated factors{p_end}
{phang2}{cmd:. predict f1 f2}

{pstd}Score first two, unrotated factors{p_end}
{phang2}{cmd:. predict raw1 raw2, norotate}

{pstd}Scree plot{p_end}
{phang2}{cmd:. screeplot}

{pstd}Factor score plot{p_end}
{phang2}{cmd:. scoreplot}

{pstd}Scatterplot of factor loadings{p_end}
{phang2}{cmd:. loadingplot}


{marker results}{...}
{title:Stored results}

{pstd}
Let {it:p} be the number of variables and {it:f}, the number of factors.

{pstd}
{cmd:predict}, in addition to generating variables, also stores the following
in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}{cmd:regression} or {cmd:Bartlett}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(scoef)}}p x f matrix of scoring coefficients{p_end}

{pstd}
{cmd:estat anti} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(acov)}}p x p anti-image covariance matrix{p_end}
{synopt:{cmd:r(acorr)}}p x p anti-image correlation matrix{p_end}

{pstd}
{cmd:estat common} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(Phi)}}f x f correlation matrix of common factors{p_end}

{pstd}
{cmd:estat factors} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(stats)}}k x 5 matrix with log likelihood, degrees of freedom,
AIC, and BIC for models with 1 to k factors estimated via maximum likelihood{p_end}

{pstd}
{cmd:estat kmo} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(kmo)}}the Kaiser-Meyer-Olkin measure of sampling adequacy{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(kmow)}}column vector of KMO measures for each variable{p_end}

{pstd}
{cmd:estat residuals} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(fit)}}fitted matrix for the correlations, hat C = hat Lambda
hat Phi hat Lambda' + hat Psi{p_end}
{synopt:{cmd:r(res)}}raw residual matrix C - hat C{p_end}
{synopt:{cmd:r(SR)}}standardized residuals ({cmd:sresiduals} option only){p_end}

{pstd}
{cmd:estat smc} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(smc)}}vector of squared multiple correlations of variables with
all other variables{p_end}

{pstd}
{cmd:estat structure} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(st)}}p x f matrix of correlations between variables and common
factors{p_end}

{pstd}
See {helpb estat summarize:[R] estat summarize} for the
{help estat_summarize##results:stored results} of
{cmd:estat summarize}.

{pstd}
{cmd:rotate} after {cmd:factor} and {cmd:factormat} add to the existing
{cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(r_f)}}number of factors in rotated solution{p_end}
{synopt:{cmd:e(r_fmin)}}rotation criterion value{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(r_class)}}{cmd:orthogonal} or {cmd:oblique}{p_end}
{synopt:{cmd:e(r_criterion)}}rotation criterion{p_end}
{synopt:{cmd:e(r_ctitle)}}title for rotation{p_end}
{synopt:{cmd:e(r_normalization)}}{cmd:kaiser} or {cmd:none}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(r_L)}}rotated loadings{p_end}
{synopt:{cmd:e(r_T)}}rotation{p_end}
{synopt:{cmd:e(r_Phi)}}correlations between common factors{p_end}
{synopt:{cmd:e(r_Ev)}}explained variance by common factors{p_end}

{pstd}
The factors in the rotated solution are in decreasing order of {cmd:e(r_Ev)}.
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker B1937}{...}
{phang}
Bartlett, M. S. 1937. The statistical conception of mental factors.
   {it:British Journal of Psychology} 28: 97-104.

{marker B1938}{...}
{phang}
------. 1938. Methods of estimating mental factors.
    {it:Nature, London} 141: 609-610.

{marker JS1988}{...}
{phang}
J{c o:}reskog, K. G., and D. S{c o:}rbom. 1988.
{it:PRELIS: A program for multivariate data screening and data summarization.}
{it:A preprocessor for LISREL}. 2nd ed. Mooresville, IN: Scientific Software.

{marker K1974}{...}
{phang}
Kaiser, H. F. 1974. An index of factor simplicity.
{it:Psychometrika} 39: 31-36.

{marker T1951}{...}
{phang}
Thomson, G. H. 1951. {it:The Factorial Analysis of Human Ability}.
    London: University of London Press.
{p_end}
