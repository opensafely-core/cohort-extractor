{smcl}
{* *! version 1.0.2  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "[P] cscript_log" "help cscript_log"}{...}
{vieweralsosee "[P] rcof" "help rcof"}{...}
{vieweralsosee "[P] savedresults" "help savedresults"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "moptobj##syntax"}{...}
{viewerjumpto "Description" "moptobj##description"}{...}
{viewerjumpto "Remarks" "moptobj##remarks"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] moptobj} {hline 2} Recallable ML evaluator


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Syntax is presented under the following headings:

	{help moptobj##step1:Step 1:  Initialization}
	{help moptobj##step2:Step 2:  Perform a single function evaluation}
	{help moptobj##step3:Step 3:  Clean up}


{marker step1}{...}
    {title:Step 1:  Initialization}

{col 9}{...}
{it:command} ... {cmd:,} ... {...}
{help moptobj##syn_init:{bf:moptobj(}{it:name}{bf:)}}


{marker step2}{...}
    {title:Step 2:  Perform a single function evaluation}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help moptobj##syn_eval:{bf:Mopt_reset_params(}{it:name}{bf:,} {it:b}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help moptobj##syn_eval:{bf:Mopt_ll_eval(}{it:name}{bf:)}}


{marker step3}{...}
    {title:Step 3:  Clean up}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help moptobj##syn_clean:{bf:Mopt_moptobj_cleanup(}{it:name}{bf:)}}


{marker syn_init}{...}
    {title:Step 1:  Initialization}

{p 4 4 2}
To use a recallable ML evaluator in Mata, you must first run a Stata
estimation command that supports the {cmd:moptobj()} option.
This option saves the underlying {helpb mf_moptimize:moptimize()} structure in
Mata memory under {it:name}.

{p 4 4 2}
Certain temporary variables created during the command execution are saved
in the current dataset as permanent variables with the {it:name} prefix.

{p 4 4 2}
The commands that support the {cmd:moptobj()} option are
{helpb betareg},
{helpb binreg},
{helpb biprobit},
{helpb clogit},
{helpb cloglog},
{helpb fracreg},
{helpb glm},
{helpb gsem_command:gsem},
{helpb heckman},
{helpb heckoprobit},
{helpb heckprobit},
{helpb hetprobit},
{helpb hetregress},
{helpb intreg},
{helpb logistic},
{helpb logit},
{helpb mlogit},
{helpb mprobit},
{helpb nbreg},
{helpb ologit},
{helpb oprobit},
{helpb poisson},
{helpb probit},
{helpb streg},
{helpb tnbreg},
{helpb tpoisson},
{helpb truncreg},
{helpb zinb},
{helpb zip},
and
{helpb zioprobit}.


{marker syn_eval}{...}
    {title:Step 2:  Performing a single function evaluation}

{p 4 4 2}
The first function replaces the current coefficient vector with a new one;
the second function returns the log likelihood evaluated at the new values
of the coefficient vector.

{p 8 12 2}
{cmd:Mopt_reset_params(}{it:name}{cmd:,} {it:{help mf_moptimize##def_b:b}}{cmd:)}
    replaces the current coefficient vector with {it:b}.  The new vector
    must be of the same dimension as the current one.

{p 8 12 2}
{cmd:Mopt_ll_eval(}{it:name}{cmd:)}
    performs one evaluation of the function at the current
    coefficient vector.


{marker syn_clean}{...}
    {title:Step 3:  Clean up}

{p 8 12 2}
{cmd:Mopt_moptobj_cleanup(}{it:name}{cmd:)}
    removes the {helpb mf_moptimize:moptimize()} structure from memory and
    drops any permanent temporary variables created in
    {help moptobj##syn_init:step 1}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:moptobj()} represents a collection of Stata estimation commands and Mata
functions that support a recallable ML evaluator.


{marker remarks}{...}
{title:Remarks}

{pstd}
The recallable ML evaluator utilities are not documented in the manual because
they would not interest many users.

{pstd}
The suggested workflow is as follows:

	{hline 60}
	{it:command} ... {cmd:,} ... {cmd:moptobj(}{it:name}{cmd:)}
	
	{cmd:mata:}
		{cmd:for (i=1; i<=n; i++) {c -(}}
			...
			{cmd:b =} ...
			{cmd:Mopt_reset_params(}{it:name}{cmd:, b)}
			{cmd:ll = Mopt_ll_eval(}{it:name}{cmd:)}
			...
		{cmd:{c )-}}	
		{cmd:Mopt_moptobj_cleanup(}{it:name}{cmd:)}
	{cmd:end}
	{hline 60}
