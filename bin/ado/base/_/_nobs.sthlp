{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] count" "help count"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{viewerjumpto "Syntax" "_nobs##syntax"}{...}
{viewerjumpto "Description" "_nobs##description"}{...}
{viewerjumpto "Options" "_nobs##options"}{...}
{viewerjumpto "Example" "_nobs##example"}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:[P] _nobs} {hline 2}}Programmer's utility for counting the number of
			observations{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:_nobs} {it:varname} [{it:weight}] [{cmd:if} {it:exp}]
		[{cmd:in} {it:range}] [{cmd:,} {cmd:min(}{it:#}{cmd:)}
		{cmdab:zero:weight} ]

{p 4 4 2}
{cmd:fweight}s, {cmd:aweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weights}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_nobs} counts the number of observations based on a 0/1 variable giving
the sample.  (Strictly speaking, the variable is evaluated as 0/not 0.)

{pstd}
It is an {hi:rclass} command, and the number of observations are returned
in {hi:r(N)}.

{pstd}
If frequency weights ({cmd:fweight}s) are specified, then the sum of the
weights is used for the number of observations.  If the weights are any other
type, they are marked out, but otherwise ignored.

{pstd}
If the number of observations is less than those specified by the
{cmd:min()} option, an appropriate error message is issued.


{marker options}{...}
{title:Options}

{phang}
{cmd:min(}{it:#}{cmd:)} specifies the minimum allowed number of
observations.  If the number of observations is less than {it:#}, an error
message is displayed.  The default is {cmd:min(1)}.

{phang}
{cmd:zeroweight} specifies that weights of zero are not to be marked
out.


{marker example}{...}
{title:Example}

{pstd}
{cmd:_nobs} is intended for use by programmers.  Its typical use is the
following:

	{cmd:program define myprog}
		{cmd:version} {it:...}
		{cmd:syntax [varlist] [fweight iweight] [if] [in]}
		{cmd:marksample touse}

		{cmd:_nobs `touse' [`weight'`exp'], min(2)}

		{cmd:local N = r(N)}

		{it:...}
	{cmd:end}
