{smcl}
{* *! version 1.0.11  15jun2010}{...}
{* based on version 1.0.8  22may2007 of manova_postestimation.sthlp}{...}
{* this help file does not appear in the manual}{...}
{cmd:help manova_postestimation_10}{right:also see:  {help manova_10}{space 12}}
{right:{help previously documented}}
{hline}

{title:Title}

{p 4 36 2}
{hi:[MV] manova postestimation} {hline 2} {cmd:manova} postestimation prior
	to version 11

{p 12 12 8}
{it}[{bf:manova} syntax was changed as of version 11.  This help file
documents old {cmd:manova}'s postestimation features and as such is probably
of no interest to you.  If you have set {helpb version} to less than 11 in
your old do-files, you do not have to translate {cmd:manova}s postestimation
commands to modern syntax.  This help file is provided for those wishing to
debug or understand old code.  Click {help manova:here} for the help file of
the modern {cmd:manova} command and click {help manova_postestimation:here}
for help with postestimation after modern {cmd:manova}.]{rm}


{title:Description}

{pstd}
The following postestimation commands are of special interest after {cmd:manova}:

{synoptset 14 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb manova_postestimation_10##manovatest:manovatest}}multivariate
	tests after {cmd:manova}{p_end}
{synopt:{helpb screeplot}}plot eigenvalues{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb adjust}}adjusted predictions of xb{p_end}
{p2coldent:* {helpb estat}}VCE and estimation sample summary{p_end}
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt:{helpb manova_postestimation_10##predict:predict}}predictions,
	residuals, and standard errors{p_end}
{synopt:{helpb manova_postestimation_10##test:test}}Wald tests for simple and
	composite linear hypotheses{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic} is not available after {cmd:manova}.
{p_end}


{title:Special-interest postestimation commands}

{pstd}
{cmd:manovatest} provides multivariate tests involving {it:term}s
or linear combinations of the underlying design matrix
from the most recently fitted {cmd:manova}.  The four multivariate test
statistics are Wilks' lambda, Pillai's trace, Lawley-Hotelling trace, and
Roy's largest root.  The format of the output is similar to that shown by
{help manova_10}.

{pstd}
{cmd:test} has specialized syntax for use after {cmd:manova}; see below.
{cmd:test} performs Wald tests of expressions involving the coefficients of
the underlying regression model.  Simple and composite linear hypotheses are
possible.


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}{cmd:predict} {dtype} {newvar:name} {ifin}
[{cmd:,} {opt eq:uation(eqno[, eqno])}
{it:statistic}]

{synoptset 14 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}xb fitted values; the default{p_end}
{synopt:{opt stdp}}standard error of the fitted value{p_end}
{synopt:{opt r:esiduals}}residuals{p_end}
{synopt:{opt d:ifference}}difference between the linear predictions of two
	equations{p_end}
{synopt:{opt stdd:p}}standard error of the fitted values for differences{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


{title:Options for predict}

{dlgtab:Main}

{phang}
{opt equation(eqno [, eqno])} specifies the equation to which you are
referring.

{pmore}
{opt equation()} is filled in with one {it:eqno} for options
    {cmd:xb}, {cmd:stdp}, and {cmd:residuals}.  {cmd:equation(#1)} would mean
    that 
    the calculation is to be made for the first equation, {cmd:equation(#2)}
    would mean the second, and so on.  You could also refer to the
    equations by their names.  {cmd:equation(income)} would refer to the
    equation named income and {cmd:equation(hours)} to the equation
    named hours.

{pmore}
If you do not specify {cmd:equation()}, results are the same as if you
    specified {cmd:equation(#1)}.

{pmore}
{opt difference} and {opt stddp} refer to between-equation
    concepts.  To use these options, you must specify two equations, for
    example, {cmd:equation(#1,#2)} or {cmd:equation(income,hours)}.  When two
    equations must be specified, {cmd:equation()} is required.  With
    {cmd:equation(#1,#2)}, {opt difference} computes the prediction of
    {cmd:equation(#1)} minus the prediction of {cmd:equation(#2)}.

{phang}
{cmd:xb}, the default, calculates the fitted values--the prediction of xb for
the specified equation.

{phang}
{cmd:stdp} calculates the standard error of the prediction for the specified
equation (the standard error of the estimated expected value or mean for the
observation's covariate pattern).  The standard error of the prediction is
also referred to as the standard error of the fitted values.

{phang}
{cmd:residuals} calculates the residuals.

{phang}
{cmd:difference} calculates the difference between the linear
predictions of two equations in the system.

{phang}
{cmd:stddp} calculates the standard error of the difference in linear
predictions (x_{1j}b - x_{2j}b) between equations 1 and 2.

{pstd}
For more information on using {cmd:predict} after multiple-equation commands,
see {manhelp predict R}.


{marker manovatest}{...}
{title:Syntax for manovatest}

{p 8 19 2}
{cmd:manovatest} {it:term} [{it:term ...}] [{cmd:/} {it:term} [{it:term ...}]]
[{cmd:,} {opt ytr:ansform(matname)}]

{p 8 19 2}
{cmd:manovatest} {cmd:,} {opt test(matname)}
[{opt ytr:ansform(matname)}]

{p 8 19 2}
{cmd:manovatest} {cmd:,} {opt showord:er}

{pstd}
where {it:term} is of the form
{it:varname}[{c -(}{cmd:*}|{cmd:|}{c )-}{it:varname}[{it:...}]]


{title:Options for manovatest}

{phang}
{cmd:ytransform(}{it:matname}{cmd:)} specifies a matrix for transforming the y
variables (the {it:depvarlist} from {help manova_10}) as part of the test.  The
multivariate tests are based on inv(A*E*A')*(A*H*A').  By default, A is the
identity matrix.  {cmd:ytransform()} is how you specify an A matrix to be used
in the multivariate tests.  Specifying {cmd:ytransform()} provides the same
results as first transforming the y variables with Y*A', where Y is the matrix
formed by binding the y variables by column and A is the matrix stored in
{it:matname}; performing the {cmd:manova} on the transformed y's; and then
running {cmd:manovatest} without {cmd:ytransform()}.

{pmore}
The number of columns of {it:matname} must equal the number of variables in
the {it:depvarlist} from {cmd:manova}.  The number of rows must be less than
or equal to the number of variables in the {it:depvarlist} from {cmd:manova}.
{it:matname} should have columns in the same order as the {it:depvarlist} from
{cmd:manova}.  The column and row names of {it:matname} are ignored.

{pmore}
When {cmd:ytransform()} is specified, a listing of the transformations is
presented before the table containing the multivariate tests.  You should
examine this table to verify that you have applied the transformation you
desired.

{phang}
{cmd:test(}{it:matname}{cmd:)} is required with the second syntax of
{cmd:manovatest}.  The rows of {it:matname} specify linear combinations of the
underlying design matrix of the MANOVA that are to be jointly tested.  The
columns correspond to the underlying design matrix (including the constant if
it has not been suppressed).  The column and row names of {it:matname} are
ignored.

{pmore}
A listing of the constraints imposed by the {cmd:test()} option is presented
before the table containing the multivariate tests.  You should examine this
table to verify that you have applied the linear combinations you desired.
Typing {cmd:manovatest , showorder} allows you to examine the ordering of the
columns for the design matrix from the MANOVA.

{phang}
{cmd:showorder} causes {cmd:manovatest} to list the definition of each column
in the design matrix.  {cmd:showorder} is not allowed with any other option
or when {it:term}s are specified.


{marker test}{...}
{title:Syntax for test following manova}

{p 8 13 2}
{cmdab:te:st}
{cmd:,}
{opt test(matname)}
[{cmdab:m:test}[{cmd:(}{it:opt}{cmd:)}]
{opt matvlc(matname2)}]

{p 8 13 2}
{cmdab:te:st} [{it:exp} {cmd:=} {it:exp}]
[{cmd:,} {opt a:ccumulate}
{opt not:est}
{opt matvlc(matname2)}]

{p 8 13 2}
{cmdab:te:st} {cmd:,} {opt showord:er}

{p 4 6 2}
where {it:exp} must have references to coefficients enclosed in
{cmd:[}{it:eqno}{cmd:]_coef[]} (or synonym {cmd:[}{it:eqno}{cmd:]_b[]}).
{it:eqno} is either {cmd:#}{it:#} or {it:name}.  Omitting
{cmd:[}{it:eqno}{cmd:]} is equivalent to specifying {cmd:[#1]}.


{title:Options for test after manova}

{p 4 8 2}
{cmd:test(}{it:matname}{cmd:)} is required with the first syntax of
{cmd:test}.  The rows of {it:matname} specify linear combinations of the
underlying design matrix of the MANOVA that are to be jointly tested.  The
columns correspond to the underlying design matrix (including the constant if
it has not been suppressed).  The column and row names of {it:matname} are
ignored.

{p 8 8 2}
A listing of the constraints imposed by the {cmd:test()} option is presented
before the table containing the tests.  You should examine this
table to verify that you have applied the linear combinations you desired.
Typing {cmd:test , showorder} allows you to examine the ordering of the
columns for the design matrix from the MANOVA.

{p 8 8 2}
{it:matname} should have as many columns as the number of dependent variables
times the number of columns in the basic design matrix.  The design matrix is
repeated for each dependent variable.

{p 4 8 2}{cmd:mtest}[{cmd:(}{it:opt}{cmd:)}]
specifies that tests be performed for each condition separately.  {it:opt}
specifies the method for adjusting p-values for multiple testing.  Valid
values for {it:opt} are

{p 12 12 2}{cmdab:b:onferroni}{space 4}Bonferroni's method{p_end}
{p 12 12 2}{cmdab:h:olm}{space      10}Holm's method{p_end}
{p 12 12 2}{cmdab:s:idak}{space      9}Sidak's method{p_end}
{p 12 12 2}{cmdab:noadj:ust}{space   6}no adjustment is to be made{p_end}

{p 8 8 2}
Specifying {cmd:mtest} without an argument is equivalent to specifying
{cmd:mtest(noadjust)}.

{p 4 8 2}
{cmd:accumulate} allows a hypothesis to be tested jointly with the
previously tested hypotheses.

{p 4 8 2}
{cmd:notest} suppresses the output.  This option is useful when you are
interested only in the joint test with additional hypotheses specified
in a subsequent call of {cmd:test, accumulate}.

{p 4 8 2}
{cmd:matvlc(}{it:matname}{cmd:)}, a programmer's option, saves the
variance-covariance matrix of the linear combinations involved in the suite
of tests.  For the test of H_0: L*b = c, what is returned in
{it:matname} is L*V*L', where V is the estimated variance-covariance matrix of
b.

{p 4 8 2}
{cmd:showorder} causes {cmd:test} to list the definition of each column
in the design matrix.  {cmd:showorder} is not allowed with any other option.


{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/metabolic}{p_end}
{phang2}{cmd:. version 10.1: manova y1 y2 = group}

{pstd}Test group 1 versus groups 2, 3, and 4{p_end}
{phang2}{cmd:. manovatest, showorder}{p_end}
{phang2}{cmd:. matrix c1 = (0,3,-1,-1,-1)}{p_end}
{phang2}{cmd:. manovatest, test(c1)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/sorghum}{p_end}
{phang2}{cmd:. version 10.1: manova time1 time2 time3 time4 time5 = variety block}{p_end}
{phang2}{cmd:. matrix m1 = J(1,5,1)}{p_end}
{phang2}{cmd:. matrix m2 = (1,-1,0,0,0 \ 1,0,-1,0,0 \ 1,0,0,-1,0 \}
           {cmd:1,0,0,0,-1)}{p_end}
{phang2}{cmd:. manovatest, showorder}{p_end}
{phang2}{cmd:. mat c1 = (0,1,-1,0,0,0,0,0,0,0\0,1,0,-1,0,0,0,0,0,0\0,1,0,0,-1,0,0,0,0,0)}{p_end}
{phang2}{cmd:. matrix c2 = (1,.25,.25,.25,.25,.2,.2,.2,.2,.2)}{p_end}

{pstd}Test for equal variety marginal means{p_end}
{phang2}{cmd:. manovatest, test(c1) ytransform(m1)}{p_end}

{pstd}Test for equal time marginal means{p_end}
{phang2}{cmd:. manovatest, test(c2) ytransform(m2)}{p_end}

{pstd}Test variety by time interaction{p_end}
{phang2}{cmd:. manovatest, test(c1) ytransform(m2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/biochemical}{p_end}
{phang2}{cmd:. version 10.1: manova y1 y2 y3 = group x1 x2, continuous(x1 x2)}{p_end}

{pstd}Test that the continuous covariates are jointly equal to zero{p_end}
{phang2}{cmd:. manovatest x1 x2}{p_end}
 
     {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/biochemical}{p_end}
{phang2}{cmd:. version 10.1: manova y1 y2 y3 = group x1 x2 group*x1 group*x2,}
         {cmd:continuous(x1 x2)}{p_end}

{pstd}Test that the continuous covariates are jointly equal to zero across
groups{p_end}
{phang2}{cmd:. manovatest group*x1 group*x2}{p_end}
    {hline}


{title:Saved results}

{pstd}
{cmd:manovatest} saves the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}hypothesis degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(H)}}hypothesis SSCP matrix{p_end}
{synopt:{cmd:r(E)}}residual error SSCP matrix{p_end}
{synopt:{cmd:r(stat)}}multivariate statistics{p_end}
{synopt:{cmd:r(eigvals)}}eigenvalues of {cmd:E^-1H}{p_end}
{synopt:{cmd:r(aux)}}s, m, and n values{p_end}

{pstd}
{cmd:test} after {cmd:manova} saves the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two sided p-value{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df)}}hypothesis degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(drop)}}0 if no constraints dropped, 1 otherwise{p_end}
{synopt:{cmd:r(dropped_#)}}index of #th constraint dropped{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(mtmethod)}}method of adjustment for multiple testing{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(mtest)}}multiple test results{p_end}
{p2colreset}{...}


{title:Also see}

{psee}
Manual:  {help previously documented}

{psee}
{space 2}Help:  {manhelp manova_postestimation MV:manova postestimation}
{p_end}
