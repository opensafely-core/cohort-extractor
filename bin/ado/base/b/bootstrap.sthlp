{smcl}
{* *! version 1.3.13  23jan2019}{...}
{viewerdialog bootstrap "dialog bootstrap"}{...}
{vieweralsosee "[R] bootstrap" "mansection R bootstrap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap postestimation" "help bootstrap postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "[R] permute" "help permute"}{...}
{vieweralsosee "[R] simulate" "help simulate"}{...}
{vieweralsosee "[R] set rngstream" "help set rngstream"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy bootstrap"}{...}
{viewerjumpto "Syntax" "bootstrap##syntax"}{...}
{viewerjumpto "Menu" "bootstrap##menu"}{...}
{viewerjumpto "Description" "bootstrap##description"}{...}
{viewerjumpto "Links to PDF documentation" "bootstrap##linkspdf"}{...}
{viewerjumpto "Options" "bootstrap##options"}{...}
{viewerjumpto "Remarks" "bootstrap##remarks"}{...}
{viewerjumpto "Examples" "bootstrap##examples"}{...}
{viewerjumpto "Stored results" "bootstrap##results"}{...}
{viewerjumpto "Reference" "bootstrap##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] bootstrap} {hline 2}}Bootstrap sampling and estimation{p_end}
{p2col:}({mansection R bootstrap:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:bootstrap}
	{it:{help exp_list}}
	[{cmd:,} {it:options} {it:{help eform_option}}]
	{cmd::} {help bootstrap##command:{it:command}}

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt r:eps(#)}}perform
	{it:#} bootstrap replications; default is {cmd:reps(50)}{p_end}

{syntab:Options}
{synopt :{opth str:ata(varlist)}}variables identifying strata{p_end}
{synopt :{opt si:ze(#)}}draw samples of size {it:#}; default is {help _N}{p_end}
{synopt :{opth cl:uster(varlist)}}variables
	identifying resampling clusters{p_end}
{synopt :{opth id:cluster(newvar)}}create new cluster ID variable{p_end}
{synopt :{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:, ...)}}}save
	results to {it:filename}; save statistics in double precision;
	save results to {it:filename} every {it:#} replications{p_end}
{synopt :{opt bca}}compute acceleration for BCa confidence intervals{p_end}
{synopt :{opt tie:s}}adjust BC/BCa confidence intervals for ties{p_end}
{synopt :{opt mse}}use MSE formula for variance estimation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt notable}}suppress table of results{p_end}
{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{opt nol:egend}}suppress table legend{p_end}
{synopt :{opt v:erbose}}display the full table legend{p_end}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}
{synopt :{opt noi:sily}}display any output from {it:command}{p_end}
{synopt :{opt tr:ace}}trace {it:command}{p_end}
{synopt :{opt ti:tle(text)}}use {it:text} as title for bootstrap results{p_end}
{synopt :{it:{help bootstrap##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synopt :{it:eform_option}}display coefficient table in
exponentiated form{p_end}

{syntab:Advanced}
{synopt :{opt nodrop}}do not drop observations{p_end}
{synopt :{opt nowarn}}do not warn when {cmd:e(sample)} is not set{p_end}
{synopt :{opt force}}do not check for {it:weights} or {cmd:svy} commands; seldom used{p_end}
{synopt :{opth reject(exp)}}identify invalid results{p_end}
{synopt :{opt seed(#)}}set random-number seed to {it:#}{p_end}

{synopt :{opth group(varname)}}ID variable for groups within {opt cluster()}{p_end}
{synopt :{opt jack:knifeopts(jkopts)}}options for {helpb jackknife}{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{marker command}{...}
{p 4 6 2}
{it:command} is any command that follows standard Stata syntax.
{it:weights} are not allowed in {it:command}.{p_end}
{p 4 6 2}
{opt group()}, {opt jackknifeopts()}, and {opt coeflegend} do not appear in
the dialog box.{p_end}
{p 4 6 2}See {manhelp bootstrap_postestimation R:bootstrap postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Resampling > Bootstrap estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bootstrap} performs nonparametric bootstrap estimation of specified
statistics (or expressions) for a Stata command or a user-written program.
Statistics are bootstrapped by resampling the data in memory with replacement.
{cmd:bootstrap} is designed for use with nonestimation commands, functions of
coefficients, or user-written programs.  To bootstrap coefficients, we
recommend using the {cmd:vce(bootstrap)} option when allowed by the estimation
command.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R bootstrapQuickstart:Quick start}

        {mansection R bootstrapRemarksandexamples:Remarks and examples}

        {mansection R bootstrapMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt reps(#)} specifies the number of bootstrap replications to be performed.
The default is 50.  A total of 50-200 replications are generally adequate for
estimates of standard error and thus are adequate for normal-approximation
confidence intervals; see 
{help bootstrap##MD1993:Mooney and Duval (1993, 11)}.  Estimates of confidence intervals using the percentile
or bias-corrected methods typically require 1,000 or more replications.

{dlgtab:Options}

{phang}
{opth strata(varlist)} specifies the variables that identify strata.  If this
option is specified, bootstrap samples are taken independently within each
stratum.

{phang}
{opt size(#)} specifies the size of the samples to be drawn.  The default is
{opt _N}, meaning to draw samples of the same size as the data.  If specified,
{it:#} must be less than or equal to the number of observations within 
{opt strata()}.

{pmore}
If {opt cluster()} is specified, the default size is the number of clusters in
the original dataset.  For unbalanced clusters, resulting sample sizes will
differ from replication to replication.  For cluster sampling, {it:#} must be
less than or equal to the number of clusters within {opt strata()}.

{phang}
{opth cluster(varlist)} specifies the variables that identify resampling
clusters.  If this option is specified, the sample drawn during each
replication is a bootstrap sample of clusters.

{phang}
{opth idcluster(newvar)} creates a new variable containing a unique
identifier for each resampled cluster.  This option requires that
{opt cluster()} also be specified.

INCLUDE help prefix_saving_option

{pmore}
See {help prefix_saving_option} for details about {it:suboptions}.

{phang}
{opt bca} specifies that {cmd:bootstrap} estimate the acceleration of each
statistic in {it:exp_list}.  This estimate is used to construct BCa
confidence intervals.  Type {cmd:estat bootstrap, bca} to display the BCa
confidence interval generated by the {cmd:bootstrap} command.

{phang}
{opt ties} specifies that {cmd:bootstrap} adjust for ties in the replicate
values when computing the median bias used to construct BC and BCa
confidence intervals.

{phang}
{opt mse} specifies that {cmd:bootstrap} compute the variance by using
deviations of the replicates from the observed value of the statistics based
on the entire dataset.  By default, {cmd:bootstrap} computes the variance
by using deviations from the average of the replicates.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt notable} suppresses the display of the table of results.

{phang}
{opt noheader} suppresses the display of the table header.  This option
implies {opt nolegend}.  This option may also be specified when replaying
estimation results.

{phang}
{opt nolegend} suppresses the display of the table legend.  This option may
also be specified when replaying estimation results.

{phang}
{opt verbose} specifies that the full table legend be displayed.  By default,
coefficients and standard errors are not displayed.  This option may also be
specified when replaying estimation results.

INCLUDE help dots

{phang}
{opt noisily} specifies that any output from {it:command} be displayed.
This option implies the {opt nodots} option.

{phang}
{opt trace} causes a trace of the execution of {it:command} to be displayed.
This option implies the {opt noisily} option.

{phang}
{opt title(text)} specifies a title to be displayed above the table of
bootstrap results.  The default title is the title stored in {cmd:e(title)}
by an estimation command, or if {cmd:e(title)} is not filled in,
{cmd:Bootstrap results} is used.  {opt title()} may also be specified when
replaying estimation results.

INCLUDE help displayopts_list

{phang}
{it:eform_option} causes the coefficient table to be displayed in
exponentiated form; see {manhelpi eform_option R}.  {it:command} determines
which {it:eform_option} is allowed ({opt eform(string)} and {opt eform} are
always allowed).

{dlgtab:Advanced}

{phang}
{opt nodrop} prevents observations outside {cmd:e(sample)} and the {cmd:if}
and {cmd:in} qualifiers from being dropped before the data are resampled.

{phang}
{opt nowarn} suppresses the display of a warning message when
{it:command} does not set {cmd:e(sample)}.

{phang}
{opt force} suppresses the restriction that {it:command} not specify
weights or be a {cmd:svy} command.  This is a rarely used option.  Use it only
if you know what you are doing.

{phang}
{opth reject(exp)} identifies an expression that indicates when results should
be rejected.  When {it:exp} is true, the resulting values are reset to missing
values.

{phang}
{opt seed(#)} sets the random-number seed.  Specifying this option is
equivalent to typing the following command prior to calling {cmd:bootstrap}:

{phang2}
{cmd:. set seed} {it:#}

{phang}
The following options are available with {cmd:bootstrap} but are not shown in
the dialog box:

{phang}
{opth group(varname)} re-creates {it:varname} containing a unique
identifier for each group across the resampled clusters.  This option requires
that {opt idcluster()} also be specified.

{pmore}
This option is useful for maintaining unique group identifiers when sampling
clusters with replacement.  Suppose that cluster 1 contains 3 groups.  If the
{cmd:idcluster(newclid)} option is specified and cluster 1 is sampled multiple
times, {cmd:newclid} uniquely identifies each copy of cluster 1.  If
{cmd:group(newgroupid)} is also specified, {cmd:newgroupid} uniquely
identifies each copy of each group.

{phang}
{opt jackknifeopts(jkopts)} identifies options that are to be passed to
{helpb jackknife} when it computes the acceleration values for the BCa
confidence intervals.  This option requires the {opt bca} option and is mostly
used for passing the {opt eclass}, {opt rclass}, or {opt n(#)} option to
{cmd:jackknife}.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Typing

{phang2}
{cmd:. bootstrap} {it:exp_list}{cmd:,} {opt reps(#)}{cmd::} {it:command}

{pstd}
executes {it:command} multiple times, bootstrapping the statistics in
{it:exp_list} by resampling observations (with replacement) from the data in
memory {it:#} times.  This method is commonly referred to as the nonparametric
bootstrap.

{pstd}
{it:command} defines the statistical command to be executed.
Most Stata commands and user-written programs can be used with
{cmd:bootstrap}, as long as they follow standard Stata syntax;
see {helpb language:[U] 11 Language syntax}.
If the {opt bca} option is supplied,
{it:command} must also work with {cmd:jackknife}; see
{manhelp jackknife R}.  The {cmd:by} prefix may not be part of {it:command}.

{pstd}
{it:{help exp_list}} specifies the statistics to be collected from the
execution of {it:command}.  If {it:command} changes the contents in
{cmd:e(b)}, {it:exp_list} is optional and defaults to {cmd:_b}.

{pstd}
Because bootstrapping is a random process, if you want to be able to
reproduce results, set the random-number seed by specifying
the {opt seed(#)} option or by typing

{phang2}
{cmd:. set seed} {it:#}

{pstd}
where {it:#} is a seed of your choosing, before running {cmd:bootstrap}; see
{manhelp set_seed R:set seed}.

{pstd}
Many estimation commands allow the {cmd:vce(bootstrap)} option.  For those
commands, we recommend using {cmd:vce(bootstrap)} over {cmd:bootstrap} because 
the estimation command already handles clustering and other model-specific
details for you.  The {cmd:bootstrap} prefix command is intended for use with
nonestimation commands, such as {cmd:summarize}, user-written programs, or
functions of coefficients.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Compute bootstrap estimates{p_end}
{phang2}{cmd:. bootstrap: regress mpg weight gear foreign}{p_end}

{pstd}Same as above command{p_end}
{phang2}{cmd:. bootstrap _b: regress mpg weight gear foreign}

{pstd}Change number of replications to 100{p_end}
{phang2}{cmd:. bootstrap, reps(100): regress mpg weight gear foreign}{p_end}

{pstd}Compute acceleration to obtain BCa confidence intervals{p_end}
{phang2}{cmd:. bootstrap, bca: regress mpg weight gear foreign}{p_end}

{pstd}Save results to {cmd:bsauto} file{p_end}
{phang2}{cmd:. bootstrap, saving(bsauto): regress mpg weight gear foreign}
{p_end}

{pstd}Run {cmd:bootstrap} on difference in coefficients of {cmd:weight} and
      {cmd:gear}{p_end}
{phang2}{cmd:. bootstrap diff=(_b[weight]-_b[gear]): regress mpg weight gear}
                  {cmd:foreign}{p_end}

{pstd}{cmd:bootstrap} {it:t} statistic using 1000 replications, stratifying on
            {cmd:foreign}, and saving results in {cmd:bsauto} file{p_end}
{phang2}{cmd:. bootstrap t=r(t), rep(1000) strata(foreign)}
          {cmd:saving(bsauto, replace): ttest mpg, by(foreign) unequal}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bootstrap} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}sample size{p_end}
{synopt:{cmd:e(N_reps)}}number of complete replications{p_end}
{synopt:{cmd:e(N_misreps)}}number of incomplete replications{p_end}
{synopt:{cmd:e(N_strata)}}number of strata{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_exp)}}number of standard expressions{p_end}
{synopt:{cmd:e(k_eexp)}}number of extended expressions (i.e., {cmd:_b}){p_end}
{synopt:{cmd:e(k_extra)}}number of extra equations beyond the original ones from {cmd:e(b)}{p_end}
{synopt:{cmd:e(level)}}confidence level for bootstrap CIs{p_end}
{synopt:{cmd:e(bs_version)}}version for {cmd:bootstrap} results{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(cmdname)}}command name from {it:command}{p_end}
{synopt:{cmd:e(cmd)}}same as {cmd:e(cmdname)} or {cmd:bootstrap}{p_end}
{synopt:{cmd:e(command)}}{it:command}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(prefix)}}{cmd:bootstrap}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(strata)}}strata variables{p_end}
{synopt:{cmd:e(cluster)}}cluster variables{p_end}
{synopt:{cmd:e(rngstate)}}random-number state used{p_end}
{synopt:{cmd:e(size)}}from the {cmd:size(}{it:#}{cmd:)} option{p_end}
{synopt:{cmd:e(exp}{it:#}{cmd:)}}expression for the {it:#}th statistic{p_end}
{synopt:{cmd:e(ties)}}{cmd:ties}, if specified{p_end}
{synopt:{cmd:e(mse)}}{cmd:mse}, if specified{p_end}
{synopt:{cmd:e(vce)}}{cmd:bootstrap}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}observed statistics{p_end}
{synopt:{cmd:e(b_bs)}}bootstrap estimates{p_end}
{synopt:{cmd:e(reps)}}number of nonmissing results{p_end}
{synopt:{cmd:e(bias)}}estimated biases{p_end}
{synopt:{cmd:e(se)}}estimated standard errors{p_end}
{synopt:{cmd:e(z0)}}median biases{p_end}
{synopt:{cmd:e(accel)}}estimated accelerations{p_end}
{synopt:{cmd:e(ci_normal)}}normal-approximation CIs{p_end}
{synopt:{cmd:e(ci_percentile)}}percentile CIs{p_end}
{synopt:{cmd:e(ci_bc)}}bias-corrected CIs{p_end}
{synopt:{cmd:e(ci_bca)}}bias-corrected and accelerated CIs{p_end}
{synopt:{cmd:e(V)}}bootstrap variance-covariance matrix{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{pstd}
When {it:exp_list} is {cmd:_b, bootstrap} will also carry forward most of the
results already in {cmd:e()} from {it:command}.
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker MD1993}{...}
{phang}
Mooney, C. Z., and R. D. Duval. 1993.
{browse "http://www.stata.com/bookstore/banasi.html":{it:Bootstrapping: A Nonparametric Approach to Statistical Inference}.}
Newbury Park, CA: Sage.
{p_end}
