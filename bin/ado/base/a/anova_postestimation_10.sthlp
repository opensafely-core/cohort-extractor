{smcl}
{* *! version 1.0.14  29mar2013}{...}
{* based on version 1.0.10  15oct2008 of anova_postestimation.sthlp}{...}
{* this help file does not appear in the manual}{...}
{cmd:help anova_postestimation_10}{right:also see:  {help anova_10}{space 13}}
{right:{help previously documented}}
{hline}

{title:Title}

{p2colset 5 33 35 2}{...}
{p2col:{hi:[R] anova postestimation} {hline 2}}{cmd:anova} postestimation
	prior to version 11
{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[{bf:anova} syntax was changed as of version 11.  This help file documents
old {cmd:anova}'s postestimation features and as such is probably of no
interest to you.  If you have set {helpb version} to less than 11 in your old
do-files, you do not have to translate {cmd:anova}s postestimation commands to
modern syntax.  This help file is provided for those wishing to debug or
understand old code.  Click {help anova:here} for the help file of the modern
{cmd:anova} command and click {help anova_postestimation:here} for help with
postestimation after modern {cmd:anova}.]{rm}


{title:Description}

{pstd}
The following postestimation commands are of special interest after {opt anova}:

{synoptset 17}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb regress_postestimation##estathett:estat hettest}}tests for heteroskedasticity{p_end}
{synopt:{helpb regress_postestimation##estatovt:estat ovtest}}Ramsey regression specification-error test for omitted variables{p_end}
{synopt :{helpb regress postestimation##acprplot:acprplot}}augmented component-plus-residual plot{p_end}
{synopt :{helpb regress postestimation##avplot:avplot}}added-variable plot{p_end}
{synopt :{helpb regress postestimation##avplots:avplots}}all added-variable plots in one image{p_end}
{synopt :{helpb regress postestimation##cprplot:cprplot}}component-plus-residual plot{p_end}
{synopt :{helpb regress postestimation##lvr2plot:lvr2plot}}leverage-versus-squared-residual plot{p_end}
{synopt :{helpb regress postestimation##rvfplot:rvfplot}}residual-versus-fitted plot{p_end}
{synopt :{helpb regress postestimation##rvpplot:rvpplot}}residual-versus-predictor plot{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_adjust2
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_linktest
{synopt:{helpb regress postestimation##predict:predict}}predictions,
	residuals, influence statistics, and other diagnostic measures{p_end}
{synopt:{helpb anova postestimation 10##test:test}}Wald tests for simple and
	composite linear hypotheses{p_end}
{synoptline}
{p2colreset}{...}


{title:Special-interest postestimation commands}

{pstd}
In addition to the common {helpb estat} commands, {opt estat hettest} and
{opt estat ovtest} are also available.  The syntax is the same as after
{opt regress}, except that {opt estat hettest} does not allow the {opt rhs}
option; see {manhelp regress_postestimation R:regress postestimation}.


{title:Syntax for predict}

{pstd}
{helpb predict} after {opt anova} follows the same syntax as {opt predict}
after {opt regress} and can provide predictions, residuals, standardized
residuals, studentized residuals, the standard error of the residuals, the
standard error of the prediction, the diagonal elements of the projection (hat)
matrix, and Cook's D.  See
{manhelp regress_postestimation R:regress postestimation} for details.


{marker test}{...}
{title:Syntax for test after anova}

    {opt te:st,} {opt test(matname)} [{opt m:test}[{opt (opt)}] {opt matvlc(matname)}] {right:syntax 1  }

    {opt te:st} [{it:exp} {cmd:=} {it:exp}] [{cmd:,} {opt a:ccumulate} {opt not:est} {opt matvlc(matname)}] {right:syntax 2  }

    {opt te:st} [{it:term} [{it:term ...}]] [{cmd:/} {it:term} [{it:term ...}]] [{cmd:,} {opt s:ymbolic}] {right:syntax 3  }

    {opt te:st,} {opt showord:er} {right:syntax 4  }

{p 4 6 2}
where {it:exp} must have references to coefficients enclosed in {opt _coeff[]}
(or synonym {opt _b[]}) and where {it:term} is as defined for {opt anova}.

{p2colset 5 17 19 2}{...}
{p2col :syntax 1}test expression involving the coefficients of the underlying regression model; you provide information as a matrix{p_end}
{p2col :syntax 2}test expression involving the coefficients of the underlying regression model; you provide information as an equation{p_end}
{p2col :syntax 3}test effects and show symbolic forms{p_end}
{p2col :syntax 4}show underlying order of design matrix, which is useful when
constructing {it:matname} argument of the {cmd:test()} option{p_end}
{p2colreset}{...}


{title:Options for test after anova}

{phang}
{opt test(matname)} is required with the first syntax of {opt test}.  The
rows of {it:matname} specify linear combinations of the underlying design
matrix of the ANOVA that are to be jointly tested.  The columns correspond to
the underlying design matrix (including the constant if it has not been
suppressed).  The column and row names of {it:matname} are ignored.

{pmore}
A listing of the constraints imposed by the {opt test()} option is presented
before the table containing the tests.  You should examine this table to verify
that you have applied the linear combinations you desired.  Typing
{cmd:test, showorder} allows  you to examine the ordering of the columns for
the design matrix from the ANOVA.

{phang}
{opt mtest}[{opt (opt)}] specifies that tests are performed for each condition
separately.  {it:opt} specifies the method for adjusting p-values for multiple
testing.  Valid values for {it:opt} are

{p2colset 20 34 37 2}{...}
{p2col :{opt b:onferroni}}Bonferroni's method{p_end}
{p2col :{opt h:olm}}Holm's method{p_end}
{p2col :{opt s:idak}}Sidak's method{p_end}
{p2col :{opt noadj:ust}}no adjustment is to be made{p_end}
{p2colreset}{...}

{pmore}
Specifying {opt mtest} without an argument is equivalent to
{cmd:mtest(noadjust)}.

{phang}
{opt matvlc(matname)}, a programmer's option, saves the variance{c -}covariance
matrix of the linear combinations involved in the suite of tests.  For the
test Lb = c, what is returned in {it:matname} is LVL', where V 
is the estimated variance{c -}covariance matrix of b.

{phang}
{opt accumulate} allows a hypothesis to be tested jointly with the previously
tested hypotheses.

{phang}
{opt notest} suppresses the output.  This option is useful when you are
interested only in the joint test with additional hypotheses specified in a
subsequent call of {opt test, accumulate}.

{phang}
{opt symbolic} request the symbolic form of the test rather than the test
statistic.  When this option is specified with no terms
({opt test, statistic}), the symbolic form of the estimable functions is
displayed.

{phang}
{opt showorder} causes {opt test} to list the definition of each column in the
design matrix.  {opt showorder} is not allowed with any other option.


{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/rash}{p_end}
{phang2}{cmd:. version 10.1: anova response t / c|t / d|c|t / p|d|c|t /}{p_end}

{pstd}Test {cmd:t} with pooled {cmd:c|t} and {cmd:d|c|t} terms{p_end}
{phang2}{cmd:. test t / c|t d|c|t}

{pstd}Test pooled {cmd:c|t} and {cmd:d|c|t} terms with {cmd:p|d|c|t}{p_end}
{phang2}{cmd:. test c|t d|c|t / p|d|c|t}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/systolic}{p_end}
{phang2}{cmd:. version 10.1: anova systolic drug disease drug*disease}{p_end}

{pstd}Symbolic form for the test of the main effect of {cmd:drug}{p_end}
{phang2}{cmd:. test drug, symbolic}

{pstd}Test whether coefficient on first drug is equal to the coefficient on
second drug{p_end}
{phang2}{cmd:. test _coef[drug[1]]=_coef[drug[2]]}

{pstd}Calculate linear prediction{p_end}
{phang2}{cmd:. predict yhat}


{title:Also see}

{psee}
Manual:  {help previously documented}

{psee}
{space 2}Help:
{manhelp anova_postestimation R:anova postestimation}
{p_end}
