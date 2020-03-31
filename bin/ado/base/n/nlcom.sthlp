{smcl}
{* *! version 1.3.5  14may2018}{...}
{viewerdialog nlcom "dialog nlcom"}{...}
{vieweralsosee "[R] nlcom" "mansection R nlcom"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] predictnl" "help predictnl"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy postestimation"}{...}
{viewerjumpto "Syntax" "nlcom##syntax"}{...}
{viewerjumpto "Menu" "nlcom##menu"}{...}
{viewerjumpto "Description" "nlcom##description"}{...}
{viewerjumpto "Links to PDF documentation" "nlcom##linkspdf"}{...}
{viewerjumpto "Options" "nlcom##options"}{...}
{viewerjumpto "Comparison with lincom" "nlcom##compare"}{...}
{viewerjumpto "Remark on the manipulability of nonlinear Wald tests" "nlcom##remark"}{...}
{viewerjumpto "Examples" "nlcom##examples"}{...}
{viewerjumpto "Stored results" "nlcom##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] nlcom} {hline 2}}Nonlinear combinations of estimators{p_end}
{p2col:}({mansection R nlcom:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Nonlinear combination of estimators -- one expression

{p 8 15 2}
{cmd:nlcom} [{it:name}{cmd::}]{it:{help nlcom##exp:exp}} [{cmd:,} {it:options}]


{phang}
Nonlinear combinations of estimators -- more than one expression

{p 8 15 2}
{cmd:nlcom} {cmd:(}[{it:name}{cmd::}]{it:{help nlcom##exp:exp}}{cmd:)}
[{cmd:(}[{it:name}{cmd::}]{it:exp}{cmd:)} ...] 
[{cmd:,} {it:options}]


{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt iter:ate(#)}}maximum number of iterations{p_end}
{synopt :{opt post}}post estimation results{p_end}
{synopt :{it:{help nlcom##display_options:display_options}}}control column
       formats and line width{p_end}

{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt df(#)}}use t distribution with {it:#} degrees of freedom for
       computing p-values and confidence intervals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{opt noheader} and {opt df(#)} do not appear in the dialog box.
{p_end}

{pstd}
The second syntax means that if more than one expression is specified, each
must be surrounded by parentheses.  The optional {it:name} is any valid Stata
name and labels the transformations.

{marker exp}{...}
{pstd}
{it:exp} is a possibly nonlinear expression containing{p_end}
	    {cmd:_b[}{it:coef}{cmd:]}
	    {cmd:_b[}{it:eqno}{cmd::}{it:coef}{cmd:]}
	    {cmd:[}{it:eqno}{cmd:]}{it:coef}
            {cmd:[}{it:eqno}{cmd:]_b[}{it:coef}{cmd:]}

{marker eqno}{...}
{pstd}{it:eqno} is{p_end}
	    {cmd:#}{it:#}
	    {it:name}

{pstd}
{it:coef} identifies a coefficient in the model.
{it:coef} is typically a variable name, a level indicator, an interaction
indicator, or an interaction involving continuous variables.
Level indicators identify one level of a factor variable and interaction
indicators identify one combination of levels of an interaction; see
{help fvvarlist}.
{it:coef} may contain time-series operators; see {help tsvarlist}.

{pstd}
Distinguish between {cmd:[]}, which are to be typed, and [], which indicate
optional arguments.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nlcom} computes point estimates, standard errors, test statistics,
significance levels, and confidence intervals for (possibly) nonlinear
combinations of parameter estimates after any Stata estimation command,
including survey estimation.  Results are displayed in the usual table format
used for displaying estimation results.  Calculations are based on the "delta
method", an approximation appropriate in large samples.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nlcomQuickstart:Quick start}

        {mansection R nlcomRemarksandexamples:Remarks and examples}

        {mansection R nlcomMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{phang}
{opt iterate(#)} specifies the maximum number of
iterations used to find the optimal step size in calculating
numerical derivatives of the transformation(s) with respect to the original
parameters.  By default, the maximum number of iterations is 100,
but convergence is usually achieved after only a few iterations.  You should
rarely have to use this option.

{phang}
{opt post} causes {cmd:nlcom} to behave like a Stata estimation ({cmd:eclass})
command.  When {opt post} is specified, {cmd:nlcom} will post the vector of
transformed estimators and its estimated variance-covariance matrix to
{cmd:e()}. This option, in essence, makes the transformation permanent.  Thus
you could, after {opt post}ing, treat the transformed estimation results in
the same way as you would treat results from other Stata estimation commands.
For example, after posting, you could redisplay the results by typing
{cmd:nlcom} without any arguments, or use {helpb test} to perform simultaneous
tests of hypotheses on linear combinations of the transformed estimators.

{pmore}
Specifying {opt post} clears out the previous estimation results,
which can be recovered only by refitting the original model or by storing the
estimation results before running {cmd:nlcom} and then restoring them; see
{manhelp estimates_store R:estimates store}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{pstd}
The following options are available with {cmd:nlcom} but are not shown in the
dialog box:

{phang}
{opt noheader} suppresses the output header.  

{phang}
{opt df(#)} specifies that the t distribution with {it:#} degrees of
freedom be used for computing p-values and confidence intervals.


{marker compare}{...}
{title:Comparison with lincom}

{pstd}
{cmd:nlcom} is a generalization of {helpb lincom} that allows the estimation of
nonlinear transformations of model parameters.  In cases where you are
estimating one transformation and that transformation is linear, use
{cmd:lincom}; it is faster.  However, when estimating more than one linear
transformation or combinations of linear and nonlinear transformations, using
{cmd:nlcom} has the added benefit that you can obtain the variance-covariance
matrix (which is stored in {cmd:r(V)}) of the joint transformation.  
{cmd:lincom} does not allow the simultaneous estimation of multiple linear
combinations.


{marker remark}{...}
{title:Remark on the manipulability of nonlinear Wald tests}

{pstd}
In contrast to likelihood-ratio tests, different -- mathematically
equivalent -- formulations of a hypothesis may lead to different results
for a nonlinear Wald test (lack of "invariance"). For instance, the two
hypotheses

	H0: {it:coefficient} = 0

	H0: exp({it:coefficient}) - 1 = 0

{pstd}
are mathematically equivalent expressions but do not yield the same test
statistic and p-value. In extreme cases, under one formulation, one would
reject H0, whereas under an equivalent formulation one would not reject H0.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse regress}

{pstd}Fit linear regression model{p_end}
{phang2}{cmd:. regress y x1 x2 x3}

{pstd}Estimate the product of the coefficients on {cmd:x2} and {cmd:x3}{p_end}
{phang2}{cmd:. nlcom _b[x2]*_b[x3]}

{pstd}Estimate the ratios of the coefficients on {cmd:x1} and {cmd:x2} and on
{cmd:x2} and {cmd:x3} jointly and post results to {cmd:e()}{p_end}
{phang2}{cmd:. nlcom (ratio1: _b[x1]/_b[x2]) (ratio2: _b[x2]/_b[x3]), post}

{pstd}Test whether the two ratios from above are equal{p_end}
{phang2}{cmd:. test _b[ratio1] = _b[ratio2]}

    {hline}
    Setup
{phang2}{cmd:. webuse sysdsn3}

{pstd}Fit maximum-likelihood multinomial logit model{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite site2 site3}

{pstd}Estimate the ratio of the coefficients on the {cmd:male} dummy in the
{cmd:Prepaid} and {cmd:Uninsure} equations{p_end}
{phang2}{cmd:. nlcom [Prepaid]_b[male] / [Uninsure]_b[male]}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nlcom} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(df_r)}}residual degrees of freedom{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}vector of transformed coefficients{p_end}
{synopt:{cmd:r(V)}}estimated variance-covariance matrix of the transformed
coefficients{p_end}

{pstd}
If {cmd:post} is specified, {cmd:nlcom} also stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(N_strata)}}number of strata L, if used after {cmd:svy}{p_end}
{synopt:{cmd:e(N_psu)}}number of sampled PSUs n, if used after {cmd:svy}{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:nlcom}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}vector of transformed coefficients{p_end}
{synopt:{cmd:e(V)}}estimated variance-covariance matrix of the transformed
coefficients{p_end}
{synopt:{cmd:e(V_srs)}}simple-random-sampling-without-replacement (co)variance
hat V_srswor, if {cmd:svy}{p_end}
{synopt:{cmd:e(V_srswr)}}simple-random-sampling-with-replacement (co)variance
hat V_srswr, if {cmd:svy} and {cmd:fpc()}{p_end}
{synopt:{cmd:e(V_msp)}}misspecification (co)variance hat V_msp, if {cmd:svy}
and available{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
