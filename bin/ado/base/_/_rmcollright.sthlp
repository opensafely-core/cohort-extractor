{smcl}
{* *! version 1.0.9  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _rmcoll" "help _rmcoll"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "_rmcollright##syntax"}{...}
{viewerjumpto "Description" "_rmcollright##description"}{...}
{viewerjumpto "Options" "_rmcollright##options"}{...}
{viewerjumpto "Remarks" "_rmcollright##remarks"}{...}
{viewerjumpto "Examples" "_rmcollright##examples"}{...}
{viewerjumpto "Stored results" "_rmcollright##results"}{...}
{title:Title}

{p2colset 5 25 27 2}{...}
{p2col :{hi:[P] _rmcollright} {hline 2}}Remove
	collinear variables from the right{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_rmcollright} {it:varblocklist} {ifin} {weight}
       [{cmd:,} {cmdab:nocons:tant} {opt coll:inear}]

{pstd}
where {it:varblocklist} is a list of one or more {it:varblock}s, and a
{it:varblock} is
either {varname} or {cmd:(}{varlist}{cmd:)} (a {it:varlist} in parentheses
indicates that this list of variables is to be considered as a group).

{phang}
{cmd:fweight}s, {cmd:aweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_rmcollright} returns in {hi:r(varblocklist)} the groups of variables from
{it:varblocklist} that form a noncollinear set.  {cmd:_rmcollright} drops the
right-most among collinear variables.  Thus the order of the variables in
{it:varblocklist} determines which variable is dropped in a set of collinear
variables.

{pstd}
If any variables are collinear, in addition to each not being included in
{hi:r(varblocklist)}, a message is displayed for each:

{pin}
note:{space 2} ______ dropped due to collinearity.


{marker options}{...}
{title:Options}

{phang}
{cmd:noconstant} specifies that, in looking for collinearity, an
intercept should not be included.  That is, a variable that contains the same
nonzero value in every observation should not be considered collinear.

{phang}
{cmd:collinear} specifies that collinear variables remain in the 
varlist.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:_rmcollright} is typically used in estimation commands.

{pstd}
A code fragment for the caller of {cmd:_rmcollright} might read as

	{it:...}
	{cmd:syntax varlist [fweight iweight]} {it:...} {cmd:[, noCONStant} {it:...} {cmd:]}
	{cmd:marksample touse}

	{cmd:if "`weight'" != "" {c -(}}
		{cmd:tempvar w}
		{cmd:quietly gen double `w' = `exp' if `touse'}
		{cmd:local wgt [`weight'=`w']}
	{cmd:{c )-}}
	{cmd:else    local wgt} {it:/* is nothing */}

	{cmd:tokenize `varlist'}
	{cmd:local depvar `1'}
	{cmd:mac shift}
	{cmd:_rmcollright `*' `wgt' if `touse', `constant'}
	{cmd:local xvars `r(varlist)'}
	{it:...}

{pstd}
In this code fragment, {cmd:`varlist'} contains one dependent variable
and zero or more independent variables.  The dependent variable is split off
and stored in the local macro {cmd:depvar}.  Then the remaining variables are
passed through {cmd:_rmcollright}, and the resulting noncollinear set stored in
the local macro {cmd:xvars}.


{marker examples}{...}
{title:Examples}

{pstd}{cmd:. sysuse auto}{p_end}
{pstd}{cmd:. gen mpg2 = mpg}{p_end}
{pstd}{cmd:. gen tt = turn + trunk}{p_end}
{pstd}{cmd:. _rmcollright (mpg turn tt trunk) displ (gear mpg2 head)}{p_end}
{pstd}{cmd:. return list}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_rmcollright} stores the following in {cmd:r()}:

{phang}
Scalars:{p_end}
{col 8}{cmd:r(k)}{col 25}number of {it:varblock}s in {cmd:r(varblocklist)}

{phang}
Macros:{p_end}
{col 8}{cmd:r(varlist)}{col 25}list of remaining variables
{col 8}{cmd:r(dropped)}{col 25}list of dropped variables
{col 8}{cmd:r(varblocklist)}{col 25}{it:varblocklist} of remaining variables
{col 8}{cmd:r(block#)}{col 25}{it:#}th block of {cmd:r(varblocklist)}
