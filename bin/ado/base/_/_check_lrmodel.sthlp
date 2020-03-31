{smcl}
{* *! version 1.0.4  19apr2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_check_lrmodel##syntax"}{...}
{viewerjumpto "Description" "_check_lrmodel##description"}{...}
{viewerjumpto "Options" "_check_lrmodel##options"}{...}
{viewerjumpto "Stata commands that use _check_lrmodel" "_check_lrmodel##use"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] _check_lrmodel} {hline 2}
Programmer's utility for checking option lrmodel 


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:_check_lrmodel} [{it:command_name}] [{cmd:,} {it:options}]

{synoptset 27}{...}
{synopthdr}
{synoptline}
{synopt :{opt noskip}}specify that {opt noskip} is not allowed{p_end}
{synopt :{opt nocons:tant}}specify that {opt noconstant} is not allowed{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}specify that {cmd:constraints()} is not allowed{p_end}
{synopt :{opt options(opts)}}specify that user-defined {it:opts} are not allowed{p_end}
{synopt :{opt r:obust}}specify that {opt robust} is not allowed{p_end}
{synopt :{opt c:luster(clustvar)}}specify that {opt cluster(clustvar)} is not allowed{p_end}
{synopt :{opt vce(passthru)}}specify that {it:passthru} ({cmd:robust} or {cmd:cluster}) is not allowed{p_end}
{synopt :{opt vcetype(vce_type)}}specify that {it:vce_type} ({cmd:robust}, {cmd:cluster}, {cmd:bootstrap}, or {cmd:jackknife}) is not allowed{p_end}
{synopt :{opt prefix(prefix_type)}}specify that {it:prefix_type} ({cmd:jackknife}, {cmd:bootstrap}, {cmd:svy}, or {cmd:mi estimate}) is not allowed{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_check_lrmodel} checks the syntax when the {opt lrmodel} option
is specified for estimation commands.  It displays an error message if any
specified {it:options} are combined with the {opt lrmodel} option.


{marker options}{...}
{title:Options}

{phang}
{opt noskip} specifies that the {opt noskip} option may not be combined with
the {opt lrmodel} option, resulting in an error message.

{phang}
{opt noconstant} specifies that the {opt noconstant} option may not be
combined with the {opt lrmodel} option, resulting in an error message.

{phang}
{opt constraints(constraints)} specifies that linear constraints may not be
combined with the {opt lrmodel} option, resulting in an error message.

{phang}
{opt options(opts)} specifies that the user-defined {it:opts} option may not
be combined with the {opt lrmodel} option, resulting in an error message.

{phang}
{opt robust} specifies that the {opt robust} option may not be
combined with the {opt lrmodel} option, resulting in an error message.

{phang}
{opt cluster} specifies that the {opt cluster(clustvar)} option may not be
combined with the {opt lrmodel} option, resulting in an error message.

{phang}
{opt vce(passthru)} specifies that the {cmd:vce(robust)} and
{cmd:vce(cluster)} options may not be combined with the {opt lrmodel} option,
resulting in an error message.

{phang}
{opt vcetype(vce_type)} specifies that {it:vce_type} ({cmd:robust},
{cmd:cluster}, {cmd:bootstrap}, or {cmd:jackknife}) may not be combined with
the {opt lrmodel} option, resulting in an error message.

{phang}
{opt prefix(prefix_type)} specifies that {it:prefix_type} ({cmd:jackknife},
{cmd:bootstrap}, {cmd:svy}, or {cmd:mi estimate}) may not be combined with
the {opt lrmodel} option, resulting in an error message.


{marker use}{...}
{title:Stata commands that use _check_lrmodel}

{pstd}
The following official commands use {cmd:_check_lrmodel}:

{pmore}
{helpb bootstrap},
{helpb biprobit},
{helpb etregress},
{helpb heckman},
{helpb heckprobit},
{helpb hetprobit},
{helpb jackknife},
{helpb truncreg},
{helpb _vce_parserun},
{helpb xtcloglog},
{helpb xtintreg},
{helpb xtlogit},
{helpb xtnbreg},
{helpb xtologit},
{helpb xtoprobit},
{helpb xtpoisson},
{helpb xtprobit},
{helpb xtstreg}, and
{helpb xttobit}.
{p_end}
