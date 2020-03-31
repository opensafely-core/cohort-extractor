{smcl}
{* *! version 1.3.10  23jan2019}{...}
{viewerdialog jackknife "dialog jackknife"}{...}
{vieweralsosee "[R] jackknife" "mansection R jackknife"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] jackknife postestimation" "help jackknife postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[R] permute" "help permute"}{...}
{vieweralsosee "[R] simulate" "help simulate"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{viewerjumpto "Syntax" "jackknife##syntax"}{...}
{viewerjumpto "Menu" "jackknife##menu"}{...}
{viewerjumpto "Description" "jackknife##description"}{...}
{viewerjumpto "Links to PDF documentation" "jackknife##linkspdf"}{...}
{viewerjumpto "Options" "jackknife##options"}{...}
{viewerjumpto "Remarks" "jackknife##remarks"}{...}
{viewerjumpto "Examples" "jackknife##examples"}{...}
{viewerjumpto "Stored results" "jackknife##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] jackknife} {hline 2}}Jackknife estimation{p_end}
{p2col:}({mansection R jackknife:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:jackknife}
	{it:{help exp_list}}
	[{cmd:,} {it:options} {it:{help eform_option}}]
	{cmd::} {help jackknife##command:{it:command}}

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt e:class}}number of observations used is stored in {cmd:e(N)}{p_end}
{synopt :{opt r:class}}number of observations used is stored in {cmd:r(N)}{p_end}
{synopt :{opth n(exp)}}specify
	{it:exp} that evaluates to the number of observations used {p_end}

{syntab:Options}
{synopt :{opth cl:uster(varlist)}}variables identifying sample clusters{p_end}
{synopt :{opth id:cluster(newvar)}}create new cluster ID variable{p_end}
{synopt :{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:, ...)}}}save
	results to {it:filename}; save statistics in double precision; save
	results to {it:filename} every {it:#} replications{p_end}
{synopt :{opt keep}}keep pseudovalues{p_end}
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
{synopt :{opt ti:tle(text)}}use {it:text} as title for jackknife results{p_end}
{synopt :{it:{help jackknife##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synopt :{it:eform_option}}display coefficient table in
exponentiated form{p_end}

{syntab:Advanced}
{synopt :{opt nodrop}}do not drop observations{p_end}
{synopt :{opth reject(exp)}}identify invalid results{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt svy} is allowed; see {manhelp svy_jackknife SVY:svy jackknife}.{p_end}
{marker command}{...}
{p 4 6 2}
{it:command} is any command that follows standard Stata syntax.
All weight types supported by {it:command} are allowed except {cmd:aweight}s;
see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp jackknife_postestimation R:jackknife postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Resampling > Jackknife estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:jackknife} performs jackknife estimation of the specified statistics
(or expressions) for a Stata command or a user-written program.
Statistics are jackknifed by estimating the command once for each observation
or cluster in the dataset, leaving the associated observation or cluster out
of the calculations. {cmd:jackknife} is designed for use with nonestimation
commands, functions of coefficients, or user-written programs.
To jackknife coefficients, we recommend using the {cmd:vce(jackknife)} option
when allowed by the estimation command. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R jackknifeQuickstart:Quick start}

        {mansection R jackknifeRemarksandexamples:Remarks and examples}

        {mansection R jackknifeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt eclass}, {opt rclass}, and {opth n(exp)} specify where
{it:command} stores the number of observations on which it based the calculated
results.  We strongly advise you to specify one of these options.

{pmore}
{opt eclass} specifies that {it:command} store the number of observations
in {hi:e(N)}.

{pmore}
{opt rclass} specifies that {it:command} store the number of observations
in {hi:r(N)}.

{pmore}
{opt n(exp)} specifies an expression
that evaluates to the number of observations used.  Specifying
{cmd:n(r(N))} is equivalent to specifying the {opt rclass} option.  Specifying
{cmd:n(e(N))} is equivalent to specifying the {opt eclass} option.  If
{it:command} stores the number of observations in {cmd:r(N1)},
specify {cmd:n(r(N1))}.

{pmore}
If you specify no options, {opt jackknife} will assume
{opt eclass} or
{opt rclass}, depending on which of {hi:e(N)} and {hi:r(N)} is not missing
(in that order).
If both {hi:e(N)} and {hi:r(N)} are missing, {opt jackknife} assumes that all
observations in the dataset contribute to the calculated result.  If
that assumption is incorrect, the reported standard errors
will be incorrect.  For instance, say that you specify

{center:{cmd:. jackknife coef=_b[x2]: myreg y x1 x2 x3}}

{pmore}
where {opt myreg} uses {cmd:e(n)} instead of {cmd:e(N)} to identify the number
of observations used in calculations.  Further assume that observation 42 in
the dataset has {opt x3} equal to missing.  The 42nd observation plays no role
in obtaining the estimates, but {opt jackknife} has no way of knowing that and
will use the wrong {it:N}.  If, on the other hand, you specify

{center:{cmd:. jackknife coef=_b[x2], n(e(n)): myreg y x1 x2 x3}}

{pmore}
{opt jackknife} will notice that observation 42 plays no role.  The 
{cmd:n(e(n))} option is specified because {opt myreg} is an estimation command
but it stores the number of observations used in {cmd:e(n)} (instead of the
standard {cmd:e(N)}). When {opt jackknife} runs the regression omitting the
42nd observation, {opt jackknife} will observe that {cmd:e(n)} has the same
value as when {opt jackknife} previously ran the regression using all the
observations.  Thus {opt jackknife} will know that {opt myreg} did not use the
observation.

{dlgtab:Options}

{phang}
{opth cluster(varlist)} specifies the variables identifying
sample clusters.  If {opt cluster()} is specified, one cluster is
left out of each call to {it:command}, instead of 1 observation.

{phang}
{opth idcluster(newvar)} creates a new variable containing a
unique integer identifier for each resampled cluster, starting at {opt 1} and
leading up to the number of clusters.  This option may be specified only when
the {opt cluster()} option is specified.
{opt idcluster()} helps identify the cluster to which a
pseudovalue belongs.

INCLUDE help prefix_saving_option

{pmore}
See {help prefix_saving_option} for details about {it:suboptions}.

{phang}
{opt keep} specifies that new variables be added to the dataset
containing the pseudovalues of the requested statistics.  See 
{bind:{bf:[R] jackknife}} for details.  When the {opt cluster()} option is
specified, each cluster is given at most one nonmissing pseudovalue.  The
{opt keep} option implies the {opt nodrop} option.

{phang}
{opt mse} specifies that {opt jackknife} compute the variance by using
deviations of the replicates from the observed value of the statistics based
on the entire dataset.  By default, {opt jackknife} computes the variance by
using deviations of the pseudovalues from their mean.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt notable} suppresses the display of the table of results.

{phang}
{opt noheader} suppresses the display of the table header.  This option
implies {opt nolegend}.

{phang}
{opt nolegend} suppresses the display of the table legend.  The table
legend identifies the rows of the table with the expressions they represent.

{phang}
{opt verbose} specifies that the full table legend be displayed.  By default,
coefficients and standard errors are not displayed.

INCLUDE help dots

{phang}
{opt noisily} specifies that any output from {it:command} be displayed.
This option implies the {opt nodots} option.

{phang}
{opt trace} causes a trace of the execution of {it:command} to be displayed.
This option implies the {opt noisily} option.

{phang}
{opt title(text)} specifies a title to be displayed above the
table of jackknife results; the default title is {opt Jackknife results} or
what is produced in {cmd:e(title)} by an estimation command.

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
{opth reject(exp)} identifies an expression that indicates when results should
be rejected.  When {it:exp} is true, the resulting values are reset to missing
values.

{pstd}
The following option is available with {opt jackknife} but is not
shown in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Typing

{pin}
{cmd:. jackknife} {it:exp_list}{cmd::} {it:command}

{pstd}
executes {it:command} once for each observation in the dataset, leaving the
associated observation out of the calculations that make up {it:exp_list}.

{pstd}
{it:command} defines the statistical command to be executed.
Most Stata commands and user-written programs can be used with
{opt jackknife}, as long as they follow standard Stata syntax
and allow the {cmd:if} qualifier; see {helpb language:[U] 11 Language syntax}.
The {opt by} prefix may not be part of {it:command}.

{pstd}
{it:{help exp_list}} specifies the statistics to be collected from the execution of
{it:command}.  If {it:command} changes the contents in {cmd:e(b)},
{it:exp_list} is optional and defaults to {cmd:_b}.

{pstd}
When the {opt cluster()} option is given, clusters are omitted instead of
observations, and N is the number of clusters instead of the sample
size.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Jackknifed standard error of the sample mean{p_end}
{phang2}{cmd:. jackknife r(mean): summarize mpg}

{pstd}Jackknifed standard errors of the coefficients from a regression{p_end}
{phang2}{cmd:. jackknife: regress mpg weight trunk}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:jknife} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}sample size{p_end}
{synopt:{cmd:e(N_reps)}}number of complete replications{p_end}
{synopt:{cmd:e(N_misreps)}}number of incomplete replications{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_extra)}}number of extra equations{p_end}
{synopt:{cmd:e(k_exp)}}number of expressions{p_end}
{synopt:{cmd:e(k_eexp)}}number of extended expressions ({cmd:_b} or {cmd:_se})
{p_end}
{synopt:{cmd:e(df_r)}}degrees of freedom{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmdname)}}command name from {it:command}{p_end}
{synopt:{cmd:e(cmd)}}same as {cmd:e(cmdname)} or {cmd:jackknife}{p_end}
{synopt:{cmd:e(command)}}{it:command}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(prefix)}}{cmd:jackknife}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(cluster)}}cluster variables{p_end}
{synopt:{cmd:e(pseudo)}}new variables containing pseudovalues{p_end}
{synopt:{cmd:e(nfunction)}}{cmd:e(N)}, {cmd:r(N)}, {cmd:n()} option, or
	empty{p_end}
{synopt:{cmd:e(exp}{it:#}{cmd:)}}expression for the {it:#}th statistic{p_end}
{synopt:{cmd:e(mse)}}from {cmd:mse} option{p_end}
{synopt:{cmd:e(vce)}}{cmd:jackknife}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}observed statistics{p_end}
{synopt:{cmd:e(b_jk)}}jackknife estimates{p_end}
{synopt:{cmd:e(V)}}jackknife variance-covariance matrix{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{pstd}
When {it:exp_list} is {cmd:_b, jackknife} will also carry forward most of the
results already in {cmd:e()} from {it:command}.{p_end}
{p2colreset}{...}
