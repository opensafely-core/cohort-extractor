{smcl}
{* *! version 1.2.13  08mar2018}{...}
{viewerdialog hausman "dialog hausman"}{...}
{vieweralsosee "[R] hausman" "mansection R hausman"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lrtest" "help lrtest"}{...}
{vieweralsosee "[R] suest" "help suest"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{viewerjumpto "Syntax" "hausman##syntax"}{...}
{viewerjumpto "Menu" "hausman##menu"}{...}
{viewerjumpto "Description" "hausman##description"}{...}
{viewerjumpto "Links to PDF documentation" "hausman##linkspdf"}{...}
{viewerjumpto "Options" "hausman##options"}{...}
{viewerjumpto "Remarks" "hausman##remarks"}{...}
{viewerjumpto "Examples" "hausman##examples"}{...}
{viewerjumpto "Stored results" "hausman##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] hausman} {hline 2}}Hausman specification test{p_end}
{p2col:}({mansection R hausman:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:hausman} {it:name-consistent} [{it:name-efficient}]
[{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt c:onstant}}include estimated intercepts in comparison; default is to exclude{p_end}
{synopt :{opt a:lleqs}}use all equations to perform test; default is first equation only{p_end}
{synopt :{opth sk:ipeqs(hausman##eqlist:eqlist)}}skip specified equations when performing test{p_end}
{synopt :{opth eq:uations(hausman##matchlist:matchlist)}}associate/compare the specified (by number) pairs of equations{p_end}
{synopt :{opt force}}force performance of test, even though assumptions are not met{p_end}
{synopt :{opt df(#)}}use {it:#} degrees of freedom{p_end}
{synopt :{opt sig:mamore}}base both (co)variance matrices on disturbance 
	variance estimate from efficient estimator {p_end}
{synopt :{opt sigmal:ess}}base both (co)variance matrices on disturbance 
	variance estimate from consistent estimator {p_end}

{syntab :Advanced}
{synopt :{opth tcon:sistent(strings:string)}}consistent estimator column header{p_end}
{synopt :{opth teff:icient(strings:string)}}efficient estimator column header{p_end}
{synoptline}
{p2colreset}{...}

{phang} where {it:name-consistent} and {it:name-efficient} are names under
which estimation results were stored via {helpb estimates store}.{p_end}
{phang}A period ({cmd:.}) may be used to refer to the last estimation results,
even if these were not already stored.{p_end}
{phang}Not specifying {it:name-efficient} is equivalent to specifying the last
estimation results as "{cmd:.}".


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:hausman} performs Hausman's specification test.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R hausmanQuickstart:Quick start}

        {mansection R hausmanRemarksandexamples:Remarks and examples}

        {mansection R hausmanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt constant} specifies that the estimated intercept(s) be included in
the model comparison; by default, they are excluded.  The default behavior is
appropriate for models in which the constant does not have a common
interpretation across the two models.

{phang}
{opt alleqs} specifies that all the equations in the models be used to
perform the Hausman test; by default, only the first equation is used.

{marker eqlist}{...}
{phang}
{opt skipeqs(eqlist)} specifies in {it:eqlist} the names of equations to be
excluded from the test.  Equation numbers are not allowed in this context,
because the equation names, along with the variable names, are used to identify
common coefficients.

{marker matchlist}{...}
{phang}
{opt equations(matchlist)} specifies, by number, the pairs of equations that
are to be compared.

{pmore}
The {it:matchlist} in {opt equations()} should follow the syntax

{pmore2}
{it:#c}{cmd::}{it:#e} [{cmd:,}{it:#c}{cmd::}{it:#e}[{cmd:,} {it:...}]]

{pmore}
where {it:#c}({it:#e}) is an equation number of the always-consistent
(efficient under H0) estimator.  For instance {cmd:equations(1:1)},
{cmd:equations(1:1, 2:2)}, or {cmd:equations(1:2)}.

{pmore}
If {opt equations()} is not specified, then equations are matched on equation
names.

{pmore}
{opt equations()} handles the situation in which one estimator uses equation
names and the other does not.  For instance, {cmd:equations(1:2)} means that
equation 1 of the always-consistent estimator is to be tested against equation
2 of the efficient estimator.  {cmd:equations(1:1, 2:2)} means that equation 1
is to be tested against equation 1 and that equation 2 is to be tested against
equation 2.  If {opt equations()} is specified, the {opt alleqs} and 
{opt skipeqs} options are ignored.

{phang}
{opt force} specifies that the Hausman test be performed, even though the
assumptions of the Hausman test seem not to be met, for example, because the
estimators were {cmd:pweight}ed or the data were clustered.

{phang}
{opt df(#)} specifies the degrees of freedom for the Hausman test.  The
default is the matrix rank of the variance of the difference between the
coefficients of the two estimators.

{phang}
{opt sigmamore} and {opt sigmaless} specify that the two covariance matrices
        used in the test be based on a common estimate of disturbance variance
        (sigma2).

{phang2}
{opt sigmamore} specifies that the covariance matrices be based on the estimated
        disturbance variance from the efficient estimator.  This option
        provides a proper estimate of the contrast variance for so-called tests
        of exogeneity and overidentification in instrumental-variables
        regression.

{phang2}
{opt sigmaless} specifies that the covariance matrices be based on the estimated
	disturbance variance from the consistent estimator.

{pmore}
These options can be specified only when both estimators store {cmd:e(sigma)}
or {cmd:e(rmse)}, or with the {cmd:xtreg} command.  {cmd:e(sigma_e)} is stored
after the {cmd:xtreg} command with the {cmd:fe} or {cmd:mle} option.
{cmd:e(rmse)} is stored after the {cmd:xtreg} command with the {cmd:re} option.

{pmore}
{cmd:sigmamore} or {cmd:sigmaless} are recommended when comparing
fixed-effects and random-effects linear regression because they are much less
likely to produce a non-positive-definite-differenced covariance matrix
(although the tests are asymptotically equivalent whether or not one of the
options is specified).

{dlgtab:Advanced}

{phang}
{opth tconsistent:(strings:string)} and {opt tefficient(string)} are formatting
options.  They allow you to specify the headers of the columns of coefficients
that default to the names of the models.  These options will be of interest
primarily to programmers.


{marker remarks}{...}
{title:Remarks}

{pstd}
The assumption that one of the estimators is efficient (that is, has minimal
asymptotic variance) is a demanding one.  It is violated, for instance, if
your observations are clustered or pweighted, or if your model is somehow
misspecified.  Moreover, even if the assumption is satisfied, there may be a
"small sample" problem with the Hausman test.  Hausman's test is based on
estimating the variance var(b-B) of the difference of the estimators by the
difference var(b)-var(B) of the variances.  Under the assumptions (1) and (3),
var(b)-var(B) is a consistent estimator of var(b-B), but it is not necessarily
positive definite "in finite samples", that is, in your application.  If this is
the case, the Hausman test is undefined.  Unfortunately, this is not a rare
event.  Stata supports a generalized Hausman test that overcomes both of these
problems.  See {manhelp suest R} for details.

{pstd}
To use {cmd:hausman}, perform the following steps.

{p 6 10 2}(1) obtain an estimator that is consistent whether or not the
              hypothesis is true;
{p_end}
{p 6 10 2}(2) store the estimation results under {it:name-consistent} by using
              {helpb estimates store};
{p_end}
{p 6 10 2}(3) obtain an estimator that is {hi:efficient} (and {hi:consistent})
              under the hypothesis that you are testing, but {hi:inconsistent}
              otherwise;
{p_end}
{p 6 10 2}(4) store the estimation results under {it:name-efficient} by using
              {helpb estimates store};
{p_end}
{p 6 10 2}(5) use {cmd:hausman} to perform the test

{p 14 14 2}{cmd:hausman} {it:name-consistent} {it:name-efficient} [{cmd:,} {it:options}]

{pstd}
The order of computing the two estimators may be reversed. You have to be
careful, though, to specify to {cmd:hausman} the models in the order
"always consistent" first and "efficient under H0" second. It is possible
to skip storing the second model and refer to the last estimation results
by a period ({cmd:.}).

{pstd}
{cmd:hausman} may be used in any context.  The order in which you specify
the regressors in each model does not matter, but you must ensure that the
estimators and models are comparable and that they satisfy the theoretical
conditions (see (1) and (3) above).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork4}{p_end}
{phang2}{cmd:. xtreg ln_wage age msp ttl_exp, fe}{p_end}
{phang2}{cmd:. estimates store fixed}{p_end}
{phang2}{cmd:. xtreg ln_wage age msp ttl_exp, re}{p_end}

{pstd}Test the appropriateness of the random-effects estimator
({cmd:xtreg, re}){p_end}
{phang2}{cmd:. hausman fixed ., sigmamore}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn3}{p_end}
{phang2}{cmd:. mlogit insure age male}{p_end}
{phang2}{cmd:. estimates store all}{p_end}
{phang2}{cmd:. mlogit insure age male if insure != "Uninsure":insure}{p_end}
{phang2}{cmd:. estimates store partial}{p_end}

{pstd}Perform Hausman test for independence of irrelevant alternatives{p_end}
{phang2}{cmd:. hausman partial all, alleqs constant}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg price}{p_end}
{phang2}{cmd:. estimates store reg}{p_end}
{phang2}{cmd:. heckman mpg price, select(foreign=weight)}{p_end}

{pstd}Specify {cmd:equations()} option to force comparison when one estimator
 uses equation names and the other does not{p_end}
{phang2}{cmd:. hausman reg ., equation(1:1)}

{pstd}Setup{p_end}
{phang2}{cmd:. probit foreign weight}{p_end}
{phang2}{cmd:. estimates store probit_for}{p_end}
{phang2}{cmd:. heckman mpg price, select(foreign=weight)}{p_end}

{pstd}Compare probit model and selection equation of heckman model{p_end}
{phang2}{cmd:. hausman probit_for ., equation(1:2)}

    {hline}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:hausman} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom for the statistic{p_end}
{synopt:{cmd:r(p)}}p-value for the chi-squared{p_end}
{synopt:{cmd:r(rank)}}rank of {cmd:(V_b-V_B)^(-1)}{p_end}
{p2colreset}{...}
