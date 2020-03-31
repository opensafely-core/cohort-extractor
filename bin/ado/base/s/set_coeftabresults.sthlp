{smcl}
{* *! version 1.0.3  11feb2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[P] quietly" "help quietly"}{...}
{viewerjumpto "Syntax" "set_coeftabresults##syntax"}{...}
{viewerjumpto "Description" "set_coeftabresults##description"}{...}
{viewerjumpto "Remarks" "set_coeftabresults##remarks"}{...}
{title:Title}

{phang}Set whether coefficient table results are saved{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:coeftabresults}
{c -(}{cmd:on} | {cmd:off}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:coeftabresults} allows you to control whether coefficient table
results are stored in {cmd:r()}.  The default is to store results. 


{marker remarks}{...}
{title:Remarks}

{pstd}
If you type

	{cmd:. sysuse auto}
	{cmd:. regress mpg turn length}
	{cmd:. return list}

{pstd}
you will see results saved from the coefficient table.
These results include the reported parameter estimates, their standard errors,
test statistic, p-value, and confidence limits.

{pstd}
When performing simulations or when using replication methods for variance
estimation, it would save time to skip over the extra work that goes into
computing these coefficient table results.
In such cases, simply type

	{cmd:. set coeftabresults off}

{pstd}
and Stata will now no longer do the work to compute and save coefficient table
results in {cmd:r()} when run {cmd:quietly} (see {helpb quietly:[P] quietly}).
{p_end}
