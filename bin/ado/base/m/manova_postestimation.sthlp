{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog manova_p"}{...}
{viewerdialog manovatest "dialog manovatest"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{viewerdialog test "dialog testmanova"}{...}
{vieweralsosee "[MV] manova postestimation" "mansection MV manovapostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "manova postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "manova_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "manova postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "manova postestimation##syntax_margins"}{...}
{viewerjumpto "manovatest" "manova postestimation##syntax_manovatest"}{...}
{viewerjumpto "test" "manova postestimation##syntax_test"}{...}
{viewerjumpto "Examples" "manova postestimation##examples"}{...}
{viewerjumpto "Stored results" "manova postestimation##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[MV] manova postestimation} {hline 2}}Postestimation tools for manova
{p_end}
{p2col:}({mansection MV manovapostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:manova}:

{synoptset 17}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb manova postestimation##manovatest:manovatest}}multivariate
	tests after {cmd:manova}{p_end}
{synopt:{helpb screeplot}}plot eigenvalues{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt:{helpb manova_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt:{helpb manova postestimation##predict:predict}}predictions, residuals,
	and standard errors{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
{synopt:{helpb manova postestimation##test:test}}Wald tests of simple and
	composite linear hypotheses{p_end}
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV manovapostestimationRemarksandexamples:Remarks and examples}

        {mansection MV manovapostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}{cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {opt eq:uation(eqno[, eqno])}
{it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}xb, fitted values; the default{p_end}
{synopt:{opt stdp}}standard error of the fitted value{p_end}
{synopt:{opt r:esiduals}}residuals{p_end}
{synopt:{opt d:ifference}}difference between the linear predictions of two
	equations{p_end}
{synopt:{opt stdd:p}}standard error of the fitted values for differences{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
fitted values, standard errors, residuals, and differences between the linear
predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt equation(eqno [, eqno])} specifies the equation to which you are
referring.

{pmore}
{opt equation()} is filled in with one {it:eqno} for the {cmd:xb}, {cmd:stdp},
    and {cmd:residuals} options.  {cmd:equation(#1)} would mean that 
    the calculation is to be made for the first equation (that is, for the first
    dependent variable), {cmd:equation(#2)}
    would mean the second, and so on.  You could also refer to the
    equations by their names.  {cmd:equation(income)} would refer to the
    equation named income and {cmd:equation(hours)}, to the equation
    named hours.

{pmore}
If you do not specify {cmd:equation()}, results are the same as if you
    had specified {cmd:equation(#1)}.

{pmore}
{opt difference} and {opt stddp} refer to between-equations
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
also referred to as the standard error of the fitted value.

{phang}
{cmd:residuals} calculates the residuals.

{phang}
{cmd:difference} calculates the difference between the linear
predictions of two equations in the system.

{phang}
{cmd:stddp} calculates the standard error of the difference in linear
predictions (x_{1j}b - x_{2j}b) between equations 1 and 2.

{pstd}
For more information on using {cmd:predict} after multiple-equation estimation
commands, see {manhelp predict R}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}linear predictions for each equation{p_end}
{synopt :{cmd:xb}}linear prediction for a specified equation{p_end}
{synopt :{opt d:ifference}}difference between the linear predictions of two equations{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdd:p}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt xb} defaults to the first equation.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker desc_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of responses for
linear predictions, fitted values, and differences between the linear
predictions.


{marker syntax_manovatest}{...}
{marker manovatest}{...}
{title:Syntax for manovatest}

{p 8 19 2}
{cmd:manovatest} {it:term} [{it:term ...}] [{cmd:/} {it:term} [{it:term ...}]]
[{cmd:,} {opt ytr:ansform(matname)}]

{p 8 19 2}
{cmd:manovatest}{cmd:,} {opt test(matname)}
[{opt ytr:ansform(matname)}]

{p 8 19 2}
{cmd:manovatest} {cmd:,} {opt showord:er}

{pstd}
where {it:term} is a term from the {it:termlist} in the previously run
{cmd:manova}.


{marker menu_manovatest}{...}
{title:Menu for manovatest}

{phang}
{bf:Statistics > Multivariate analysis >}
     {bf:MANOVA, multivariate regression, and related >}
     {bf:Multivariate tests after MANOVA}


{marker desc_manovatest}{...}
{title:Description for manovatest}

{pstd}
{cmd:manovatest} provides multivariate tests involving {it:term}s
or linear combinations of the underlying design matrix
from the most recently fit {cmd:manova}.  The four multivariate test
statistics are Wilks's lambda, Pillai's trace, Lawley-Hotelling trace, and
Roy's largest root.  The format of the output is similar to that shown by
{helpb manova}.


{marker options_manovatest}{...}
{title:Options for manovatest}

{phang}
{cmd:ytransform(}{it:matname}{cmd:)} specifies a matrix for transforming the y
variables (the {depvarlist} from {cmd:manova}) as part of the test.  The
multivariate tests are based on inv(A*E*A')*(A*H*A').  By default, A is the
identity matrix.  {cmd:ytransform()} is how you specify an A matrix to be used
in the multivariate tests.  Specifying {cmd:ytransform()} provides the same
results as first transforming the y variables with Y*A', where Y is the matrix
formed by binding the y variables by column and A is the matrix stored in
{it:matname}; then performing the {cmd:manova} on the transformed y's; and
finally running {cmd:manovatest} without {cmd:ytransform()}.

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
Typing {cmd:manovatest, showorder} allows you to examine the ordering of the
columns for the design matrix from the MANOVA.

{phang}
{cmd:showorder} causes {cmd:manovatest} to list the definition of each column
in the design matrix.  {cmd:showorder} is not allowed with any other option
or when {it:term}s are specified.


{marker syntax_test}{...}
{marker test}{...}
{title:Syntax for test}

{pstd}
In addition to the standard syntax of {helpb test}, {cmd:test} after
{cmd:manova} also allows the following.

    {opt te:st,} {opt test(matname)} [{opt m:test}[{opt (opt)}] {opt matvlc(matname)}] {right:syntax A  }

    {opt te:st,} {opt showord:er} {right:syntax B  }


{p2colset 5 17 19 2}{...}
{p2col :syntax A}test expression involving the coefficients of the underlying
multivariate regression model; you provide information as a matrix{p_end}
{p2col :syntax B}show underlying order of design matrix, which is useful when
constructing the {it:matname} argument of the {cmd:test()} option{p_end}
{p2colreset}{...}


{marker menu_test}{...}
{title:Menu for test}

{phang}
{bf:Statistics > Multivariate analysis >}
    {bf:MANOVA, multivariate regression, and related > Wald test after MANOVA}


{marker desc_test}{...}
{title:Description for test}

{pstd}
In addition to the standard syntax of {helpb test}, {cmd:test}
after {cmd:manova} has two additionally allowed syntaxes; see below.
{cmd:test} performs Wald tests of expressions involving the coefficients of
the underlying regression model.  Simple and composite linear hypotheses are
possible.


{marker options_test}{...}
{title:Options for test}

{dlgtab:Main}

{p 4 8 2}
{cmd:test(}{it:matname}{cmd:)} is required with syntax A of 
{cmd:test}.  The rows of {it:matname} specify linear combinations of the
underlying design matrix of the MANOVA that are to be jointly tested.  The
columns correspond to the underlying design matrix (including the constant if
it has not been suppressed).  The column and row names of {it:matname} are
ignored.

{p 8 8 2}
A listing of the constraints imposed by the {cmd:test()} option is presented
before the table containing the tests.  You should examine this
table to verify that you have applied the linear combinations you desired.
Typing {cmd:test, showorder} allows you to examine the ordering of the
columns for the design matrix from the MANOVA.

{p 8 8 2}
{it:matname} should have as many columns as the number of dependent variables
times the number of columns in the basic design matrix.  The design matrix is
repeated for each dependent variable.

{p 4 8 2}
{cmd:showorder} causes {cmd:test} to list the definition of each column
in the design matrix.  {cmd:showorder} is not allowed with any other option.

{dlgtab:Options}

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

{pstd}
The following option is available with {opt test} after {cmd:manova}
but is not shown in the dialog box:

{p 4 8 2}
{cmd:matvlc(}{it:matname}{cmd:)}, a programmer's option, saves the
variance-covariance matrix of the linear combinations involved in the suite
of tests.  For the test of H_0: L*b = c, what is returned in
{it:matname} is L*V*L', where V is the estimated variance-covariance matrix of
b.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse metabolic}{p_end}
{phang2}{cmd:. manova y1 y2 = group}

{pstd}Test group 1 versus groups 2, 3, and 4{p_end}
{phang2}{cmd:. manovatest, showorder}{p_end}
{phang2}{cmd:. matrix c1 = (3,-1,-1,-1,0)}{p_end}
{phang2}{cmd:. manovatest, test(c1)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sorghum}{p_end}
{phang2}{cmd:. manova time1 time2 time3 time4 time5 = variety block}{p_end}
{phang2}{cmd:. matrix m1 = J(1,5,1)}{p_end}
{phang2}{cmd:. matrix m2 = (1,-1,0,0,0 \ 1,0,-1,0,0 \ 1,0,0,-1,0 \}
           {cmd:1,0,0,0,-1)}{p_end}
{phang2}{cmd:. manovatest, showorder}{p_end}
{phang2}{cmd:. mat c1 = (1,-1,0,0,0,0,0,0,0,0\1,0,-1,0,0,0,0,0,0,0\1,0,0,-1,0,0,0,0,0,0)}{p_end}
{phang2}{cmd:. matrix c2 = (.25,.25,.25,.25,.2,.2,.2,.2,.2,1)}{p_end}

{pstd}Test for equal variety marginal means{p_end}
{phang2}{cmd:. manovatest, test(c1) ytransform(m1)}{p_end}

{pstd}Test for equal time marginal means{p_end}
{phang2}{cmd:. manovatest, test(c2) ytransform(m2)}{p_end}

{pstd}Test variety by time interaction{p_end}
{phang2}{cmd:. manovatest, test(c1) ytransform(m2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse biochemical}{p_end}
{phang2}{cmd:. manova y1 y2 y3 = group c.x1 c.x2}{p_end}

{pstd}Test that the continuous covariates are jointly equal to zero{p_end}
{phang2}{cmd:. manovatest c.x1 c.x2}{p_end}
 
     {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse biochemical}{p_end}
{phang2}{cmd:. manova y1 y2 y3 = group c.x1 c.x2 group#c.x1 group#c.x2}{p_end}

{pstd}Test that the continuous covariates are jointly equal to zero across
groups{p_end}
{phang2}{cmd:. manovatest group#c.x1 group#c.x2}{p_end}
    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse jaw}{p_end}
{phang2}{cmd:. manova y1 y2 y3 = gender fracture gender#fracture}{p_end}

{pstd}Compute the predicted mean (marginal mean), standard error, z statistic,
p-value, and confidence interval of {cmd:y1} for each
combination of {cmd:fracture} and {cmd:gender}{p_end}
{phang2}{cmd:. margins gender#fracture, predict(equation(y1))}{p_end}

{pstd}Contrast women with men for every fracture type and every dependent
variable{p_end}
{phang2}{cmd:. contrast gender@fracture#_eqns, mcompare(scheffe)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:manovatest} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}hypothesis degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(H)}}hypothesis SSCP matrix{p_end}
{synopt:{cmd:r(E)}}residual-error SSCP matrix{p_end}
{synopt:{cmd:r(stat)}}multivariate statistics{p_end}
{synopt:{cmd:r(eigvals)}}eigenvalues of {cmd:E^-1H}{p_end}
{synopt:{cmd:r(aux)}}{cmd:s}, {cmd:m}, and {cmd:n} values{p_end}

{pstd}
{cmd:test} after {cmd:manova} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df)}}hypothesis degrees of freedom{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:r(drop)}}{cmd:0} if no constraints dropped, {cmd:1} otherwise
{p_end}
{synopt:{cmd:r(dropped_}{it:#}{cmd:)}}index of {it:#}th constraint dropped{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(mtmethod)}}method of adjustment for multiple testing{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(mtest)}}multiple test results{p_end}
{p2colreset}{...}
