{smcl}
{* *! version 1.1.0  19aug2019}{...}
{viewerdialog threshold "dialog threshold"}{...}
{vieweralsosee "[TS] threshold" "mansection TS threshold"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] threshold postestimation" "help threshold postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] mswitch" "help mswitch"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "threshold##syntax"}{...}
{viewerjumpto "Menu" "threshold##menu"}{...}
{viewerjumpto "Description" "threshold##description"}{...}
{viewerjumpto "Links to PDF documentation" "threshold##linkspdf"}{...}
{viewerjumpto "Options" "threshold##options"}{...}
{viewerjumpto "Examples" "threshold##examples"}{...}
{viewerjumpto "Stored results" "threshold##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] threshold} {hline 2}}Threshold regression{p_end}
{p2col:}({mansection TS threshold:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:threshold}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{opth threshvar(varname)}
[{it:options}]

{phang}
{it:indepvars} is a list of variables with region-invariant coefficients.

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opth threshvar(varname)}}threshold variable{p_end}
{synopt:{opth regionvars(varlist)}}include region-varying
	coefficients for specified covariates{p_end}
{synopt:{opt consinv:ariant}}replace region-varying constant with a
	region-invariant constant{p_end}
{synopt:{opt nocons:tant}}suppress region-varying constant terms{p_end}
{synopt:{opt trim(#)}}trimming percentage; default is {cmd:trim(10)}{p_end}
{synopt:{opt nthresh:olds(#)}}number of thresholds;
	    default is {cmd:nthresholds(1)}; not allowed with 
	    {cmd:optthresh()}{p_end}
{synopt:{cmd:optthresh(}{it:#}[{cmd:,} {help threshold##ictype:{it:ictype}}]{cmd:)}}select optimal number of thresholds less than or equal to {it:#}; not allowed with {opt nthresholds()}{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim} or
	{opt r:obust}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt nocnsr:eport}}do not display constraints{p_end}
{synopt:{it:{help threshold##display_options:display_options}}}control
INCLUDE help shortdes-displayopt
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}

{syntab:Advanced}
{synopt:{cmd:ssrs(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}{cmd:)}}}create variable with sum of squared residuals (SSRs) for each tentative threshold{p_end}
{synopt:{opth const:raints(numlist)}}apply specified linear constraints; not
	allowed with {cmd:optthresh()}{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}*{opt threshvar()} is required.{p_end}
{p 4 6 2}You must {cmd:tsset} your data before using {cmd:threshold}; see
{manhelp tsset TS}.{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:indepvars}, {it:varlist}, and {it:varname} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:by}, {cmd:rolling}, and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp threshold_postestimation TS:threshold postestimation}
   for features available after estimation.

{marker ictype}{...}
{synoptset 25}{...}
{synopthdr:ictype}
{synoptline}
{synopt:{opt bic}}Bayesian information criterion (BIC); the default{p_end}
{synopt:{opt aic}}Akaike information criterion (AIC){p_end}
{synopt:{opt hqic}}Hannan-Quinn information criterion (HQIC){p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Threshold regression model}


{marker description}{...}
{title:Description}

{pstd}
{opt threshold} extends linear regression to allow coefficients to differ
across regions. Those regions are identified by a threshold variable being
above or below a threshold value. The model may have multiple thresholds, and
you can either specify a known number of thresholds or let {cmd:threshold}
find that number for you through the Bayesian information criterion (BIC),
Akaike information criterion (AIC), or Hannan-Quinn information criterion
(HQIC).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS thresholdQuickstart:Quick start}

        {mansection TS thresholdRemarksandexamples:Remarks and examples}

        {mansection TS thresholdMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth threshvar(varname)} specifies the variable from which values are to be
selected as thresholds.  {opt threshvar()} is required.

{phang}
{opth regionvars(varlist)} specifies additional
variables whose coefficients vary over the regions defined by the estimated
thresholds.  By default, only the constant term varies over regions.

{phang}
{opt consinvariant} specifies that the constant term should be
region invariant instead of region varying.

{phang}
{opt noconstant} suppresses the region-varying constant terms (intercepts) in
the model.

{phang}
{opt trim(#)} specifies that {opt threshold} treat the value at the {it:#}th
percentile of the threshold variable as the first possible threshold and the
value at the (100-{it:#})th percentile as the last possible
threshold.  {it:#} must be an integer between 1 and 49.  The default is
{cmd:trim(10)}.

{phang}
{opt nthresholds(#)} specifies the number of thresholds.  Specifying the
number of thresholds is equivalent to specifying the number of regions because
the number of regions is equal to {it:#}+1 thresholds.  The default is
{cmd:nthresholds(1)}, equivalent to 2 regions.

{phang}
{cmd:optthresh(}{it:#} [{cmd:,} {help threshold##ictype:{it:ictype}}{cmd:)}
specifies that {opt threshold} choose the optimal number of thresholds, up to a
possible {it:#}.  By default, the optimal number of thresholds is based on the
BIC, but you may specify the information criterion ({it:ictype}) to be
used.  {it:ictype} may be {cmd:bic} (the default), {cmd:aic}, or {cmd:hqic}.
{opt optthresh()} may not be specified with {opt nthresholds()}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim})
and that are robust to some kinds of misspecification ({cmd:robust});
see {manhelpi vce_option R}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {cmd:nocnsreport}; see
{manhelp estimation_options R:Estimation options}.

INCLUDE help displayopts_list

{phang}
{opt nodots} and {opt dots(#)} specify whether to display replication
dots.  By default, one dot character is displayed for each successful
replication.  A red `x' is displayed if {it:command} returns an error.  
You can also control whether dots are displayed using {helpb set dots}.

{phang2}
{opt nodots} suppresses display of the replication dots.

{phang2}
{opt dots(#)} displays dots every {it:#} replications.
{cmd:dots(0)} is a synonym for {cmd:nodots}.

{dlgtab:Advanced}

{phang}
{cmd:ssrs(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvarlist}}{cmd:)} creates a variable
containing the sum of squared residuals (SSRs) that was computed for each
tentative threshold value during the search for the {it:k}th threshold.  For
observations where the value of the threshold variable specified in
{opt threshvar()} is not a tentative threshold, the corresponding value of the
variable created by {opt ssrs()} for that observation will be missing.

{pmore}
If you specify {it:stub}{cmd:*}, Stata will create {it:k} new variables with
the names {it:stub}{cmd:1}, ..., {it:stubk}, which will contain the SSRs for
the 1st, ..., {it:k}th thresholds, where {it:k} is the {it:#} specified in
{opt nthresholds()} or the optimal number of thresholds if {opt optthresh()}
is specified.

{pmore}
If you specify a list of new variable names, you may request SSRs for up to
the {it:#} specified in {opt nthresholds()}.  If you specify 
{opt optthresh(#)} and the optimal number of thresholds is less than
{it:#}, any additional variables will contain only missing values.

{phang}
{opth constraints(numlist)} specifies the constraints by number after they
have been defined by using the {opt constraint} command; see
{manhelp constraint R}.  {opt constraints()} may not be specified with 
{opt optthresh()}.

{pstd}
The following option is available with {opt threshold} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
{helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse usmacro}

{pstd}
Fit a threshold regression model that estimates one threshold for
{cmd:l2.ogap} and coefficients that vary across the two regions{p_end}
{phang2}{cmd:. threshold fedfunds, regionvars(l.fedfunds inflation ogap)}
        {cmd:threshvar(l2.ogap)}

{pstd}
Same as above, but select the optimal number of thresholds from a maximum 
of five{p_end}
{phang2}{cmd:. threshold fedfunds, regionvars(l.fedfunds inflation ogap)}
        {cmd:threshvar(l2.ogap) optthresh(5)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:threshold} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(nthresholds)}}number of thresholds{p_end}
{synopt:{cmd:e(optthresh)}}number of maximum thresholds; if specified{p_end}
{synopt:{cmd:e(ssr)}}sum of squared residuals of the model{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(aic)}}Akaike information criterion{p_end}
{synopt:{cmd:e(bic)}}Bayesian information criterion{p_end}
{synopt:{cmd:e(hqic)}}Hannan-Quinn information criterion{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:threshold}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(regionvars)}}list of region-specific variables{p_end}
{synopt:{cmd:e(indepvars)}}list of region-invariant variables{p_end}
{synopt:{cmd:e(threshvar)}}name of the threshold variable{p_end}
{synopt:{cmd:e(criteria)}}information criteria if 
    {cmd:optthresh(}{it:#}{cmd:,} {it:ictype}{cmd:)} is specified{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tsfmt)}}format for the current time variable{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(ssrmat)}}sum of squared residuals for each estimated
threshold{p_end}
{synopt:{cmd:e(thresholds)}}matrix of estimated thresholds{p_end}
{synopt:{cmd:e(nobs)}}number of observations in each region{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
