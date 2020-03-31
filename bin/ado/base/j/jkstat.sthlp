{smcl}
{* *! version 1.1.7  14may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] char" "help char"}{...}
{viewerjumpto "Syntax" "jkstat##syntax"}{...}
{viewerjumpto "Description" "jkstat##description"}{...}
{viewerjumpto "Options" "jkstat##options"}{...}
{viewerjumpto "Remarks" "jkstat##remarks"}{...}
{viewerjumpto "Stored results" "jkstat##results"}{...}
{title:Title}

{p 4 18 2}
{hi:[SVY] jkstat} {hline 2} Reporting jackknife results


{marker syntax}{...}
{title:Syntax}

{pin}
{cmd:jkstat}
	[{varlist}]
	{weight}
	{ifin}
	[{cmd:,} {it:options} ]

{pin}
{cmd:jkstat}
	[{it:namelist}]
	[{opt using} {it:filename}]
	{ifin}
	[{cmd:,} {it:options} ]


{p2colset 9 28 32 2}{...}
{p2col :{it:options}}Description{p_end}
{p2line}
{p2col :{opt notable}}suppress table of output{p_end}
{p2col :{opt noh:eader}}suppress table header{p_end}
{p2col :{opt nol:egend}}suppress table legend{p_end}
{p2col :{opt v:erbose}}display the full table legend{p_end}

{p2col :{opt l:evel(#)}}confidence level for CIs{p_end}
{p2col :{opt ti:tle(text)}}title for jackknife results{p_end}

{p2col :{opt s:tat(vector)}}observed values{p_end}
{p2col :{opt str:ata(varname)}}strata{p_end}
{p2col :{opt mse}}use MSE formula for variance estimate{p_end}

{synopt :{it:{help jkstat##display_options:display_options}}}control
column formats{p_end}
{p2line}

{pstd}
{cmd:fweight}s, {cmd:pweight}s, and {cmd:iweight}s are allowed with
{cmd:jkstat}; see {help weight}.

{phang}
{cmd:jkstat} shares the features of all estimation commands, except that
{cmd:adjust}, {cmd:margins}, {cmd:predict}, and {cmd:predictnl} are not allowed;
see {help estcom}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:jkstat} is a programmer's command that computes and displays estimation
results from jackknife statistics.

{pstd}
{cmd:jkstat} computes a variance-covariance matrix using the variables in
{it:varlist}, assuming the variables contain replicate values from a jackknife
procedure.

{pstd}
If given the {opt using} modifier, {cmd:jkstat} will use the data in
{it:filename} to perform its calculations while preserving the data
currently in memory.  The data in memory are used by default.

{pstd}
The following options may be used when replaying estimation results from
{cmd:jkstat}:

{pmore}
	{opt l:evel(#)}
	{opt notable}
	{opt noh:eader}
	{opt nol:egend}
	{opt v:erbose}
	{opt ti:tle(text)}
        {it:display_options}

{pstd}
For all other options (and qualifiers {opt using}, {cmd:if}, and {cmd:in}),
{cmd:jkstat} requires a dataset.


{marker options}{...}
{title:Options}

{phang}
{opt notable} prevents displaying the output table.
This option implies {opt noheader}.

{phang}
{opt noheader} suppresses the displaying of the table header.
This option implies {opt nolegend}.

{phang}
{opt nolegend} suppresses the displaying of the table legend.  The table
legend identifies the rows of the table with the expressions they represent.

{phang}
{opt verbose} requests that the full table legend be displayed.  By default,
coefficients and standard errors are not displayed.

{phang}
{opt level(#)}; see {help estimation_options}.

{phang}
{opt title(text)} specifies a title to be displayed above the
table of jackknife results; the default title is "Jackknife statistics".

{phang}
{opt stat(vector)} allows the user to specify the observed value of each
statistic (that is, the value of the statistic using the original dataset).

{phang}
{opt strata(varname)} specifies the variable that contains the stratum
identifiers.

{phang}
{opt mse} specifies that {opt jkstat} compute the variance by using
deviations of the replicates from the observed value of the statistics based
on the entire dataset.  By default, {opt jkstat} computes the variance by
using deviations of the pseudovalues from their mean.

{marker display_options}{...}
{phang}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)}, and
{opt sformat(%fmt)};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Although {cmd:jkstat} allows users to specify the observed value and
stratum identifier of each jackknife statistic via the {cmd:stat()} and
{cmd:strata()} options, programmers may be interested in what {cmd:jkstat} uses
when these options are not supplied.

{pstd}
When working from a jackknife dataset, {cmd:jkstat} first checks the
data characteristics (see {manhelp char P}).  Here is a list of the
characteristics that {cmd:jkstat} understands:

{phang}
{cmd:_dta[jk_version]} identifies the version of the jackknife dataset.  This
characteristic is assumed to be empty (not defined) or {cmd:1}; otherwise
{cmd:jkstat} will behave as if it were empty.  This version informs
{cmd:jkstat} which other characteristics to look for in the jackknife dataset.

{pmore}
{cmd:jkstat} uses the following characteristics from version {cmd:1}
jackknife datasets:

{pmore2}
{cmd:_dta[N]}{break}
{cmd:_dta[N_cluster]}{break}
{cmd:_dta[command]}{break}
{cmd:_dta[jk_svy]}{break}
{cmd:_dta[names]}{break}
{it:varname}{cmd:[observed]}{break}
{it:varname}{cmd:[expression]}

{pmore}
An empty jackknife dataset version implies that the dataset was not created by
{helpb jackknife}.  Here the {opt stat()} option is required.  All
other characteristics are ignored.

{phang}
{cmd:_dta[N]} is the number of observations in the observed dataset.

{phang}
{cmd:_dta[N_cluster]} is the number of clusters in the observed
dataset.

{phang}
{cmd:_dta[command]} is the command used to compute the observed values
of the statistics.

{phang}
{cmd:_dta[jk_svy]} identifies that the jackknife data came from survey data
when is contains "{hi:svy}"; otherwise, nonsurvey data is assumed.  When this
characteristic is appropriately set, it causes {cmd:jkstat} to look for the
following other characteristics:

{pmore2}
{cmd:_dta[N_strata]}{break}
{cmd:_dta[N_psu]}{break}
{cmd:_dta[strata]}{break}
{cmd:_dta[jk_strata]}{break}
{cmd:_dta[jk_multiplier]}{break}
{cmd:_dta[psu]}
{cmd:_dta[wtype]}
{cmd:_dta[wexp]}
{cmd:_dta[rweights]}

{phang}
{cmd:_dta[names]} identifies the variables containing the jackknife replicates.

{phang}
{it:varname}{cmd:[observed]} is the observed value of the statistic
identified by {it:varname}.  This characteristic may be overruled by
specifying the {cmd:stat()} option.

{phang}
{it:varname}{cmd:[expression]} is the expression or label that
describes the statistic identified by {it:varname}.

{pstd}
The following characteristics are available only when {cmd:_dta[jk_svy]}
is "{hi:svy}":

{phang}
{cmd:_dta[N_strata]} is the number of strata in the observed dataset.

{phang}
{cmd:_dta[N_psu]} is the number of PSUs in the observed dataset.

{phang}
{cmd:_dta[strata]} is the name of the variable from the original dataset that
identifies the strata.  This characteristic will usually contain the same
variable name as {cmd:_dta[jk_strata]}.

{phang}
{cmd:_dta[jk_strata]} is the name of the variable that identifies the strata.
This characteristic may be overruled by specifying the {opt strata()} option.

{phang}
{cmd:_dta[jk_multiplier]} is the name of the variable that contains multiplier
values used in the jackknife variance formula.  This characteristic can be
overruled by specifying {it:weight}.

{phang}
{cmd:_dta[psu]} is the name of the variable from the original dataset that
identifies the primary sampling units.

{phang}
{cmd:_dta[wtype]},
{cmd:_dta[wexp]}, and
{cmd:_dta[rweights]} identify the weight type, expression, and list of
replicate weight variable names from the observed dataset.  
{cmd:_dta[wtype]} and {cmd:_dta[wexp]} may also be set for nonsurvey data, but
this is only advisable with {hi:fweight}s; see {help weights}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:jkstat} stores the following in {cmd:e()}:

{p2colset 9 24 28 2}{...}
{pstd}
Scalars

{p2col :{cmd:e(N)}}sample size{p_end}
{p2col :{cmd:e(N_strata)}}number of strata{p_end}
{p2col :{cmd:e(N_cluster)}}number of clusters (for nonsurvey data){p_end}
{p2col :{cmd:e(N_psu)}}number of PSUs (for survey data){p_end}
{p2col :{cmd:e(N_reps)}}number of requested replications{p_end}

{pstd}
Macros

{p2col :{cmd:e(cmd)}}{cmd:jackknife}{p_end}
{p2col :{cmd:e(command)}}{it:command} from {hi:_dta[command]}{p_end}
{p2col :{cmd:e(exp}{it:#}{cmd:)}}expression for the {it:#}th statistic{p_end}
{p2col :{cmd:e(strata)}}strata variable{p_end}
{p2col :{cmd:e(cluster)}}cluster variable{p_end}
{p2col :{cmd:e(missing)}}"{hi:missing}"
	if missing values found, otherwise empty{p_end}
{p2col :{cmd:e(varlist)}}{it:varlist} or {it:namelist}{p_end}
{p2col :{cmd:e(vcetype)}}"{hi:Jackknife}" or "{hi:Jknife *}"{p_end}
{p2col :{cmd:e(vce)}}"{hi:jackknife}"{p_end}
{p2col :{cmd:e(mse)}}"{hi:mse}" if {opt mse} option supplied{p_end}

{pstd}
Matrices

{p2col :{cmd:e(b)}}observed statistics{p_end}
{p2col :{cmd:e(V)}}jackknife variance matrix{p_end}
{p2col :{cmd:e(jk_b)}}jackknife means{p_end}
{p2colreset}{...}
