{smcl}
{* *! version 1.2.10  12dec2018}{...}
{vieweralsosee "[R] vce_option" "mansection R vce_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "[XT] vce_options" "help xt_vce_options"}{...}
{viewerjumpto "Syntax" "vce_option##syntax"}{...}
{viewerjumpto "Description" "vce_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "vce_option##linkspdf"}{...}
{viewerjumpto "Options" "vce_option##options"}{...}
{viewerjumpto "Remarks" "vce_option##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R]} {it:vce_option} {hline 2}}Variance estimators
{p_end}
{p2col:}({mansection R vce_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{it:estimation_cmd}
... [{cmd:,} {opt vce(vcetype)} ...]

{synoptset 32}{...}
{synopt :{it:vcetype}}Description{p_end}
{synoptline}
{synopt :Likelihood based}{p_end}
{synopt :{cmd:oim}}observed information matrix (OIM){p_end}
{synopt :{cmd:opg}}outer product of the gradient (OPG) vectors{p_end}

{synopt :Sandwich estimators}{p_end}
{synopt :{cmdab:r:obust}}Huber/White/sandwich estimator{p_end}
{synopt :{cmdab:cl:uster} {it:clustvar}}clustered sandwich estimator{p_end}

{synopt :Replication based}{p_end}
{synopt :{cmdab:boot:strap} [{cmd:,} {it:{help bootstrap:bootstrap_options}}]}bootstrap estimation{p_end}
{synopt :{cmdab:jack:knife} [{cmd:,} {it:{help jackknife:jackknife_options}}]}jackknife estimation{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry describes the {opt vce()} option, which is common to most
estimation commands.  {cmd:vce()} specifies how to estimate the
variance-covariance matrix (VCE) corresponding to the parameter estimates.
The standard errors reported in the table of parameter estimates are the
square root of the variances (diagonal elements) of the VCE.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R vce_optionRemarksandexamples:Remarks and examples}

        {mansection R vce_optionMethodsandformulas:Methods and formulas}

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
{cmd:technique(bhhh)} option is specified; see {helpb maximize:[R] Maximize}.

{phang}
{cmd:vce(robust)} uses the robust or sandwich estimator of variance.
This estimator is robust to some types of misspecification so long as the
observations are independent; see {findalias frrobust}.

{pmore}
If the command allows {cmd:pweight}s and you specify them, {cmd:vce(robust)}
is implied; see {findalias frwestp}.

{phang}
{cmd:vce(cluster} {it:clustvar}{cmd:)} specifies that the standard errors
allow for intragroup correlation, relaxing the usual requirement that the
observations be independent.  That is, the observations are independent
across groups (clusters) but not necessarily within groups.  {it:clustvar}
specifies to which group each observation belongs, for example,
{cmd:vce(cluster personid)} in data with repeated observations on individuals.
{cmd:vce(cluster} {it:clustvar}{cmd:)} affects the standard errors
and variance-covariance matrix of the estimators but not the estimated
coefficients; see {findalias frrobust}.

{phang}
{cmd:vce(bootstrap} [{cmd:,} {it:bootstrap_options}]{cmd:)} uses a 
bootstrap; see {manhelp bootstrap R}.  After estimation with
{cmd:vce(bootstrap)}, see
{manhelp bootstrap_postestimation R:bootstrap postestimation} to obtain
percentile-based or bias-corrected confidence intervals.

{phang}
{cmd:vce(jackknife} [{cmd:,} {it:jackknife_options}]{cmd:)} uses the
delete-one jackknife; see {manhelp jackknife R}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{pmore}
{help vce_option##Prefix_commands:Prefix commands}{break}
{help vce_option##Passing_options:Passing options in vce()}


{marker Prefix_commands}{...}
{title:Prefix commands}

{pstd}
Specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is often
equivalent to using the respective prefix command.
Here is an example using {opt jackknife} with {cmd:regress}.

	{cmd:. sysuse auto}
        {cmd:. regress mpg turn trunk, vce(jackknife)}
        {cmd:. jackknife: regress mpg turn trunk}

{pstd}
Here it does not matter whether we specify option {cmd:vce(jackknife)} or
instead use the {cmd:jackknife} prefix.

{pstd}
However, {cmd:vce(jackknife)} should be used in place of the {cmd:jackknife}
prefix whenever available because they are not always equivalent.  For
example, to use the {cmd:jackknife} prefix with {cmd:clogit} properly,
you must tell {cmd:jackknife} to omit whole groups rather than individual
observations.  Specifying {cmd:vce(jackknife)} does this automatically.

	{cmd:. webuse clogitid}
        {cmd:. jackknife, cluster(id): clogit y x1 x2, group(id)}

{pstd}
This extra information is automatically communicated to {cmd:jackknife} by
{cmd:clogit} when the {opt vce()} option is specified.

        {cmd:. clogit y x1 x2, group(id) vce(jackknife)}


{marker Passing_options}{...}
{title:Passing options in vce()}

{pstd}
If you wish to specify more options to the bootstrap or jackknife estimation,
you can include them within the {opt vce()} option.  Below we request 300
bootstrap replications and save the replications in {cmd:bsreg.dta}.

        {cmd:. sysuse auto}
        {cmd:. regress mpg turn trunk, vce(bootstrap, rep(300) saving(bsreg))}
	{cmd:. bstat using bsreg}
