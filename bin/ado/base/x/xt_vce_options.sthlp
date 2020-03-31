{smcl}
{* *! version 1.1.8  12dec2018}{...}
{vieweralsosee "[XT] vce_options" "mansection XT vce_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "xt_vce_options##syntax"}{...}
{viewerjumpto "Description" "xt_vce_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "xt_vce_options##linkspdf"}{...}
{viewerjumpto "Options" "xt_vce_options##options"}{...}
{viewerjumpto "Remarks" "xt_vce_options##remarks"}{...}
{viewerjumpto "Reference" "xt_vce_options##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[XT]} {it:vce_options} {hline 2}}Variance estimators
{p_end}
{p2col:}({mansection XT vce_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{it:estimation_cmd}
... [{cmd:,} {it:vce_options} ...]

{synoptset 36}{...}
{synopt :{it:vce_options}}Description{p_end}
{synoptline}
{synopt :{cmd:vce(oim)}}observed information matrix (OIM){p_end}
{synopt :{cmd:vce(opg)}}outer product of the gradient (OPG) vectors{p_end}
{synopt :{cmd:vce(}{cmdab:r:obust}{cmd:)}}Huber/White/sandwich estimator{p_end}
{synopt :{cmd:vce(}{cmdab:cl:uster} {it:clustvar}{cmd:)}}clustered sandwich estimator{p_end}
{synopt :{cmd:vce(}{cmdab:boot:strap} [{cmd:,} {it:{help bootstrap:bootstrap_options}}]{cmd:)}}bootstrap estimation{p_end}
{synopt :{cmd:vce(}{cmdab:jack:knife} [{cmd:,} {it:{help jackknife:jackknife_options}}]{cmd:)}}jackknife estimation{p_end}

{synopt :{opt nmp}}use divisor N - P instead of the default N{p_end}
{synopt :{cmdab:s:cale(x2}|{cmd:dev}|{cmd:phi}|{it:#}{cmd:)}}override the default scale parameter; available only with population-averaged models{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry describes the {it:vce_options}, which are common to most xt
estimation commands. Not all the options documented below work with all xt
estimation commands; see the documentation for the particular estimation
command.  If an option is listed there, it is applicable. 

{pstd}
The {cmd:vce()} option specifies how to estimate the variance-covariance
matrix (VCE) corresponding to the parameter estimates.  The standard errors
reported in the table of parameter estimates are the square root of the
variances (diagonal elements) of the VCE.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT vce_optionsRemarksandexamples:Remarks and examples}

        {mansection XT vce_optionsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:SE/Robust}

{phang}
{cmd:vce(oim)} is usually the default for models fit using maximum
likelihood.  {cmd:vce(oim)} uses the observed information matrix (OIM); see
{manhelp ml R}.

{phang}
{cmd:vce(opg)} uses the sum of the outer product of the gradient (OPG)
vectors; see {manhelp ml R}.  This is the default VCE when the
{cmd:technique(bhhh)} option is specified;
see {helpb maximize:[R] Maximize}.

{phang}
{cmd:vce(robust)} uses the robust or sandwich estimator of variance.
This estimator is robust to some types of misspecification so long as the
observations are independent; see
{findalias frrobust}.

{pmore}
If the command allows {cmd:pweight}s and you specify them, {cmd:vce(robust)}
is implied; see {findalias frwestp}.

{phang}
{cmd:vce(cluster} {it:clustvar}{cmd:)} specifies that the standard errors
allow for intragroup correlation, relaxing the usual requirement that the
observations be independent.  That is to say, the observations are independent
across groups (clusters) but not necessarily within groups.  {it:clustvar}
specifies to which group each observation belongs, for examples,
{cmd:vce(cluster personid)} in data with repeated observations on individuals.
{cmd:vce(cluster} {it:clustvar}{cmd:)} affects the standard errors
and variance-covariance matrix of the estimators but not the estimated
coefficients; see {findalias frrobust}.

{phang}
{cmd:vce(bootstrap} [{cmd:,} {it:bootstrap_options}]{cmd:)} uses a 
nonparametric bootstrap; see {manhelp bootstrap R}.  After estimation with
{cmd:vce(bootstrap)}, see
{manhelp bootstrap_postestimation R:bootstrap postestimation} to obtain
percentile-based or bias-corrected confidence intervals.

{phang}
{cmd:vce(jackknife} [{cmd:,} {it:jackknife_options}]{cmd:)} uses the
delete-one jackknife; see {manhelp jackknife R}.

{phang}
{marker nmp}{...}
{opt nmp} specifies that the divisor N-P be used instead of the
default N, where N is the total number of observations and P is the
number of coefficients estimated.

{phang}
{marker scale()}{...}
{cmd:scale(x2}|{cmd:dev}|{cmd:phi}|{it:#}{cmd:)} overrides the default
scale parameter.  By default, {cmd:scale(1)} is assumed for the discrete
distributions (binomial, negative binomial, and Poisson), and {cmd:scale(x2)}
is assumed for the continuous distributions (gamma, Gaussian, and inverse
Gaussian).

{pmore}
{cmd:scale(x2)} specifies that the scale parameter be set to the Pearson
chi-squared (or generalized chi-squared) statistic divided by the residual
degrees of freedom, which is recommended by
{help xt_vce_options##MN1989:McCullagh and Nelder (1989)}
as a good general choice for continuous distributions.

{pmore}
{cmd:scale(dev)} sets the scale parameter to the deviance divided by the
residual degrees of freedom. This option provides an alternative to
{cmd:scale(x2)} for continuous distributions and for over- or underdispersed
discrete distributions.

{pmore}
{cmd:scale(phi)} specifies that the scale parameter be estimated from the data.
{cmd:xtgee}'s default scaling makes results agree with other estimators and
has been recommended by 
{help xt_vce_options##MN1989:McCullagh and Nelder (1989)}
in the context of GLM.  When comparing results with calculations made by other
software, you may find that the other packages do not offer this feature.  In
such cases, specifying {cmd:scale(phi)} should match their results.

{pmore}
{opt scale(#)} sets the scale parameter to {it:#}. For example,
using {cmd:scale(1)} in {cmd:family(gamma)} models results in
exponential-errors regression (if you assume independent correlation
structure).


{marker remarks}{...}
{title:Remarks}

{pstd}
When working with panel-data models, we strongly encourage you to use the
{cmd:vce(bootstrap)} or {cmd:vce(jackknife)} options instead of the
corresponding prefix command.  For example, to obtain jackknife standard
errors with {cmd:xtlogit}, type

{phang2}{cmd:. webuse clogitid}{p_end}
{phang2}{cmd:. xtlogit y x1 x2, fe vce(jackknife)}

{pstd}
If you wish to specify more options to the bootstrap or jackknife estimation,
you can include them within the {cmd:vce()} option.  Below we refit our
model requesting bootstrap standard errors based on 300 replications,
we set the random-number seed so that our results can be reproduced, and
we suppress the display of the replication dots.

{phang2}{cmd:. xtlogit y x1 x2, fe vce(bootstrap, reps(300) seed(123) nodots)}


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989. 
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
