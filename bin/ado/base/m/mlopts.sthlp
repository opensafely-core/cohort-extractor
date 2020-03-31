{smcl}
{* *! version 1.3.3  19feb2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Maximize" "help maximize"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "mlopts##syntax"}{...}
{viewerjumpto "Description" "mlopts##description"}{...}
{viewerjumpto "Some official Stata commands that use mlopts" "mlopts##mlopts"}{...}
{viewerjumpto "Examples" "mlopts##examples"}{...}
{viewerjumpto "Stored results" "mlopts##results"}{...}
{title:Title}

{p 4 16 2}
{hi:[P] mlopts} {hline 2} Parsing tool for ml commands


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:mlopts}
	{it:mlopts}
	[{it:rest}]
	[{cmd:,} {it:options} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:mlopts} is a parsing tool that was written to assist in syntax checking
and parsing of estimation commands that use {cmd:ml}.  The options specified
in {it:options} will be separated into groups and returned in local macros
specified by the caller.  The names of the local macros are identified by
{it:mlopts} and {it:rest}.

{phang}
{it:mlopts} is required and will contain those options that the {cmd:ml}
command recognizes as {help maximize} options.  Options returned in {it:mlopts}
are

{pmore}
	{opt tr:ace}
	{opt grad:ient}
	{opt hess:ian}
	{cmd:showstep}
	{opt tech:nique(algorithm_specs)}
	{cmd:vce(}{cmd:oim}|{cmdab:o:pg}|{cmdab:r:obust}{cmd:)}
	{opt iter:ate(#)}
	{opt tol:erance(#)}
	{opt ltol:erance(#)}
	{opt nrtol:erance(#)}
	{opt qtol:erance(#)}
	{opt nonrtol:erance}
	{opt showtol:erance}
	{cmdab:dif:ficult}
	{opt const:raints(clist|matname)}
	{opt col:linear}
	{opt nocnsnote:s}

{pmore}
For a description of the above options (except {cmd:constraints()}), see
{helpb maximize:[R] Maximize}.  For a description of constraints, see
{manhelp cnsreg R} and {manhelp reg3 R}.

{phang}
{it:rest} is optional and, if specified, will contain all other options that
were not returned in {it:mlopts}.  If {it:rest} is not specified, then any
extra options will cause an error.


{marker mlopts}{...}
{title:Some official Stata commands that use {cmd:mlopts}}

{pstd}
The following commands use {cmd:mlopts}.  See help for

{pmore}
	{helpb arch},
	{helpb arima},
	{helpb biprobit},
	{helpb boxcox},
	{helpb cloglog},
	{helpb etregress},
	{helpb frontier},
	{helpb glm},
	{helpb gnbreg},
	{helpb heckman},
	{helpb heckprobit},
	{helpb hetoprobit},
	{helpb hetprobit},
	{helpb hetregress},
	{helpb intreg},
	{helpb nbreg},
	{helpb nlogit},
	{helpb poisson},
	{helpb rocfit},
	{helpb scobit},
	{helpb svar},
	{helpb truncreg},
	{helpb tssmooth},
	{helpb xtcloglog},
	{helpb xtfrontier},
	{helpb xtintreg},
	{helpb xtlogit},
	{helpb xtnbreg},
	{helpb xtpoisson},
	{helpb xtprobit},
	{helpb xtrchh},
	{helpb xttobit},
	{helpb zinb},
	{helpb zip}


{marker examples}{...}
{title:Examples}

{pstd}
{cmd}. mlopts mlopts, constraints(1/3){text}

{pstd}
{cmd}. mlopts mlopts, constraints(1/3) junk{text}{break}
{err}option junk not allowed{break}
{txt}{search r(198):r(198);}

{pstd}
{cmd}. mlopts mlopts options, constraints(1/3) junk{text}{break}

{pstd}
{cmd}. sreturn list

{p 4 11 2}
{txt}macros:{break}
       s(constraints) : "{res}1 2 3{txt}"


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mlopts} stores the following in {cmd:s()}:

{pstd}
Macros:

        {cmd:s(constraints)}   contents of {cmd:constraints()} option
        {cmd:s(collinear)}     {bf:collinear}, if option was specified
        {cmd:s(technique)}     contents of {cmd:technique()} option
