{smcl}
{* *! version 1.1.4  14may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy brr" "help svy_brr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] char" "help char"}{...}
{viewerjumpto "Syntax" "brrstat##syntax"}{...}
{viewerjumpto "Description" "brrstat##description"}{...}
{viewerjumpto "Options" "brrstat##options"}{...}
{viewerjumpto "Remarks" "brrstat##remarks"}{...}
{viewerjumpto "Stored results" "brrstat##results"}{...}
{title:Title}

{p 4 23 2}
{hi:[SVY] brrstat} {hline 2}
Reporting results from balanced repeated replication (BRR)


{marker syntax}{...}
{title:Syntax}

{pin}
{cmd:brrstat}
	[{varlist}]
	{ifin}
	[{cmd:,} {it:options}]

{pin}
{cmd:brrstat}
	[{it:namelist}]
	[{opt using} {it:filename}]
	{ifin}
	[{cmd:,} {it:options}]

{synoptset 20}{...}
{p2col :{it:options}}Description{p_end}
{p2line}
{p2col :{opt notable}}suppress table of output{p_end}
{p2col :{opt noh:eader}}suppress table header{p_end}
{p2col :{opt nol:egend}}suppress table legend{p_end}
{p2col :{opt v:erbose}}display the full table legend{p_end}

{p2col :{opt l:evel(#)}}confidence level for CIs{p_end}
{p2col :{opt ti:tle(text)}}title for BRR results{p_end}

{p2col :{opt s:tat(vector)}}observed values{p_end}
{p2col :{opt mse}}use MSE formula for variance estimate{p_end}
{p2line}
{p 4 6 2}
{cmd:brrstat} shares the features of all estimation commands, except that
{cmd:mfx}, {cmd:adjust}, {cmd:predict}, and {cmd:predictnl} are not allowed;
see {help estcom}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:brrstat} is a programmer's command that computes and displays estimation
results from BRR statistics.

{pstd}
{cmd:brrstat} computes a variance-covariance matrix using the variables in
{it:varlist}, assuming the variables contain replicate values from a BRR
procedure.

{pstd}
If given the {opt using} modifier, {cmd:brrstat} will use the data in
{it:filename} to perform its calculations while preserving the data
currently in memory.  The data in memory are used by default.

{pstd}
The following options may be used to replay estimation results from
{cmd:brrstat}:

{pmore}
	{opt l:evel(#)}
	{opt notable}
	{opt noh:eader}
	{opt nol:egend}
	{opt v:erbose}
	{opt ti:tle(text)}

{pstd}
For all other options (including {opt using}, {cmd:if}, and {cmd:in}),
{cmd:brrstat} requires a dataset.


{marker options}{...}
{title:Options}

{phang}
{opt notable} prevents displaying the output table.

{phang}
{opt noheader} suppresses the displaying of the table header.  This option
implies {opt nolegend}.

{phang}
{opt nolegend} suppresses the displaying of the table legend.  The table
legend identifies the rows of the table with the expressions they represent.

{phang}
{opt verbose} requests that the full table legend be displayed.  By default,
coefficients and standard errors are not displayed.

{phang}
{opt level(#)}; see 
{helpb estimation options:[R] Estimation options}.

{phang}
{opt title(text)} specifies a title to be displayed above the
table of BRR results; the default title is "BRR statistics".

{phang}
{opt stat(vector)} allows the user to specify the observed value of each
statistic (that is, the value of the statistic using the original dataset).

{phang}
{opt mse} specifies that {opt brrstat} compute the variance by using
deviations of the replicates from the observed value of the statistics based
on the entire dataset.  By default, {opt jkstat} computes the variance by
using deviations of the pseudovalues from their mean.


{marker remarks}{...}
{title:Remarks}

{pstd}
Although {cmd:brrstat} allows users to specify the observed value of each
replicate statistic via the {cmd:stat()} option, programmers may be interested
in what {cmd:brrstat} uses when this option is not supplied.

{pstd}
When working from a BRR dataset, {cmd:brrstat} first checks the
data characteristics (see {manhelp char P}).  Here is a list of the
characteristics that {cmd:brrstat} understands:

{phang}
{cmd:_dta[brr_version]} identifies the version of the BRR dataset.  This
characteristic is assumed to be empty (not defined) or {cmd:1}; otherwise
{cmd:brrstat} will behave as if it were empty.  This version informs
{cmd:brrstat} which other characteristics to look for in the BRR dataset.

{pmore}
{cmd:brrstat} uses the following characteristics from version {cmd:1}
BRR datasets:

{pmore2}
{cmd:_dta[N]}{break}
{cmd:_dta[N_strata]}{break}
{cmd:_dta[N_psu]}{break}
{cmd:_dta[N_pop]}{break}
{cmd:_dta[strata]}{break}
{cmd:_dta[psu]}
{cmd:_dta[wtype]}
{cmd:_dta[wexp]}
{cmd:_dta[rweights]}
{cmd:_dta[command]}{break}
{cmd:_dta[names]}{break}
{it:varname}{cmd:[observed]}{break}
{it:varname}{cmd:[expression]}

{pmore}
An empty BRR dataset version implies that the dataset was not created by
the {cmd:brr}.  In this case, the {opt stat()} option is required.  All
other characteristics are ignored.

{phang}
{cmd:_dta[N_strata]} is the number of strata in the observed dataset.

{phang}
{cmd:_dta[N_psu]} is the number of PSUs in the observed dataset.

{phang}
{cmd:_dta[strata]} is the name of the variable that originally identified the
strata.

{phang}
{cmd:_dta[psu]} is the name of the variable from the original dataset that
identifies the primary sampling units.

{phang}
{cmd:_dta[wtype]},
{cmd:_dta[wexp]}, and
{cmd:_dta[rweights]} identify the weight type, expression, and list of
replicate weight variable names from the observed dataset.

{phang}
{cmd:_dta[command]} is the command used to compute the observed values
of the statistics.

{phang}
{cmd:_dta[names]} identifies the variables containing the jackknife replicates.

{phang}
{it:varname}{cmd:[observed]} is the observed value of the statistic
identified by {it:varname}.  This characteristic may be overruled by
specifying the {cmd:stat()} option.

{phang}
{it:varname}{cmd:[expression]} is the expression or label that
describes the statistic identified by {it:varname}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:brrstat} stores the following in {cmd:e()}:

{p2colset 9 24 28 2}{...}
{pstd}
Scalars{p_end}
{p2col :{cmd:e(N)}}sample size{p_end}
{p2col :{cmd:e(N_strata)}}number of strata{p_end}
{p2col :{cmd:e(N_psu)}}number of PSUs{p_end}
{p2col :{cmd:e(N_reps)}}number of requested replications{p_end}

{pstd}
Macros{p_end}
{p2col :{cmd:e(cmd)}}{cmd:brr}{p_end}
{p2col :{cmd:e(cmdline)}}command as typed{p_end}
{p2col :{cmd:e(command)}}{it:command} from {hi:_dta[command]}{p_end}
{p2col :{cmd:e(exp}{it:#}{cmd:)}}expression for the {it:#}th statistic{p_end}
{p2col :{cmd:e(strata)}}strata variable{p_end}
{p2col :{cmd:e(cluster)}}cluster variable{p_end}
{p2col :{cmd:e(missing)}}"{hi:missing}"
	if missing values found, otherwise empty{p_end}
{p2col :{cmd:e(vcetype)}}"{hi:BRR}" or "{hi:BRR *}"{p_end}
{p2col :{cmd:e(vce)}}"{hi:brr}"{p_end}
{p2col :{cmd:e(mse)}}"{hi:mse}" if {opt mse} option supplied{p_end}

{pstd}
Matrices{p_end}
{p2col :{cmd:e(b)}}observed statistics{p_end}
{p2col :{cmd:e(V)}}BRR variance matrix{p_end}
{p2col :{cmd:e(brr_b)}}replicate means{p_end}
{p2colreset}{...}
