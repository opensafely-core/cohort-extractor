{smcl}
{* *! version 1.0.0  27feb2019}{...}
{viewerdialog predict "dialog npregress_series_p"}{...}
{vieweralsosee "[R] npregress series postestimation" "mansection R npregressseriespostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] npregress series" "help npregress series"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap postestimation" "help bootstrap postestimation"}{...}
{viewerjumpto "Postestimation commands" "npregress series_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "npregress_series_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "npregress_series_postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "npregress_series_postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "npregress_series_postestimation##examples"}{...}
{viewerjumpto "Reference" "npregress_series_postestimation##reference"}{...}
{p2colset 1 40 42 2}{...}
{p2col:{bf:[R] npregress series postestimation} {hline 2}}Postestimation tools
for npregress series{p_end}
{p2col:}({mansection R npregressseriespostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after
{cmd:npregress series}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt:{helpb npregress_series_postestimation##margins:margins}}marginal means, predictive margins, marginal effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb npregress_series_postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R npregressseriespostestimationRemarksandexamples:Remarks and examples}

        {mansection R npregressseriespostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict}
{dtype}
{newvar} {ifin}
[{cmd:,}
{it:statistic} {cmd:atsample} {opt tolerance(#)}]

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mean}}conditional mean of the outcome; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt sc:ore}}score; equivalent to {opt residuals}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These statistics are available for the estimation sample only.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{opt predict} creates a new variable containing predictions such as
conditional mean of the outcome, residuals, or score of the mean
function.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt mean}, the default, calculates the conditional mean of the
outcome variable.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt score} is a synonym for {opt residuals}.

{phang}
{opt atsample} restricts predictions to the range of covariates in the
data. If requested predictions extend beyond the range of the data,
{opt atsample} will compute predictions only for observations within the
range of the original data and will exclude those observations that are
beyond the range of the data.

{pmore}
By default, predictions will not be computed if any covariate is set to a
value outside the range of the data, unless {cmd:atsample} or
{cmd:tolerance()} is specified.

{phang}
{opt tolerance(#)} sets the tolerance for predictions outside the range of
the covariates.

{pmore}
By default, predictions will not be computed if any covariate is
set to a value outside the range of the data, unless {cmd:tolerance()} or
{cmd:atsample} is specified. 


{marker syntax_margins}{...}
{marker margins}{...}
{title:Syntax for margins}

{p 8 16 2}
{cmd:margins} [{it:{help margins##syntax:marginlist}}]
[{cmd:,} {it:options}]

{p 8 16 2}
{cmd:margins} [{it:{help margins##syntax:marginlist}}]
{cmd:,}
{opt pr:edict(statistic ...)}
[{it:options}]

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{cmd:mean}}conditional mean of the outcome; the default{p_end}
{synopt :{cmdab:r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 19 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:delta},
{cmd:unconditional}, or {cmdab:boot:strap}{p_end}
{synopt :{opt r:eps(#)}}equivalent to {cmd:vce(bootstrap, reps(}{it:#}{cmd:))}{p_end}
{synopt :{opt seed(#)}}set random-number seed to {it:#}; must also specify
{opt reps(#)}{p_end}
{synopt :{opt nose}}do not estimate standard errors{p_end}

{syntab:Reporting}
{synopt :{opth citype:(npregress_series_postestimation##citype:citype)}}method
to compute bootstrap  confidence intervals; default is
{cmd:citype(}{cmdab:p:ercentile}{cmd:)}{p_end}
{synoptline}
{p2colreset}{...}

{marker citype}{...}
{synoptset 19}{...}
{synopthdr:citype}
{synoptline}
{synopt :{opt p:ercentile}}percentile confidence intervals; the default{p_end}
{synopt :{opt bc}}bias-corrected confidence intervals{p_end}
{synopt :{opt nor:mal}}normal-based confidence intervals{p_end}
{synoptline}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{opt margins} estimates margins of the conditional mean.


{marker options_margins}{...}
{title:Options for margins}

{dlgtab:SE}

{phang}
{cmd:vce(delta)}, {cmd:vce(unconditional)}, and {cmd:vce(bootstrap)}
specify how the VCE and, correspondingly, standard errors are calculated.

{phang2}
{cmd:vce(delta)} is the default.  The delta method is applied to
the formula for the response and the VCE of the estimation command.
This method assumes that values of the covariates used to calculate the
response are given or, if all covariates are not fixed using {cmd:at()},
that the data are given.

{phang2}
{cmd:vce(unconditional)} specifies that the covariates that are not fixed be
treated in a way that accounts for their having been sampled.  The VCE is
estimated using the linearization method.  This method allows for
heteroskedasticity or other violations of distributional assumptions in the
same manner as {cmd:vce(robust)}, which is the default for
{cmd:npregress series}.

{phang2}
{cmd:vce(bootstrap)} specifies that bootstrap standard errors be reported;
see {manhelpi vce_option R}.  We recommend that you select the number of
replications using {opt reps(#)} instead of specifying {cmd:vce(bootstrap)},
which defaults to 50 replications. Be aware that the number of replications
needed to produce good estimates of the standard errors varies depending on
the problem.

{phang}
{opt reps(#)} specifies the
number of bootstrap replications to be performed.
Specifying this option is equivalent to
specifying {cmd:vce(bootstrap, reps(}{it:#}{cmd:))}.

{phang}
{opt seed(#)} sets the random-number seed.
You must specify {opt reps(#)} with {opt seed(#)}.

{phang}
{opt nose}
     suppresses calculation of the VCE and standard errors.

{dlgtab:Reporting}

{phang}
{opt citype(citype)} specifies the type of confidence interval to be computed.
By default, bootstrap percentile confidence intervals are reported as
recommended by
{help npregress series_postestimation##CJ2018:Cattaneo and Jansson (2018)}.
{it:citype} may be one of {cmd:percentile}, {cmd:bc}, or {cmd:normal}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dui}

{pstd}Nonparametric series regression of {cmd:citations} as a function of
{cmd:fines}, size of the jurisdiction, and {cmd:taxes}{p_end}
{phang2}{cmd:. npregress series citations fines i.csize i.taxes}

{pstd}Estimate the mean number of citations for different levels of fines{p_end}
{phang2}{cmd:. margins, at(fines=(8 9 10 11))}

{pstd}Plot the mean number of citations{p_end}
{phang2}{cmd:. marginsplot}

{pstd}Estimate the effect of increasing {cmd:fines} for different jurisdiction
sizes{p_end}
{phang2}{cmd:. margins csize, dydx(fines)}


{marker reference}{...}
{title:Reference}

{marker CJ2018}{...}
{phang}
Cattaneo, M. D., and M. Jansson. 2018. Kernel-based semiparametric estimators:
Small bandwidth asymptotics and bootstrap consistency.
{it:Econometrica} 86: 955-995.
{p_end}
