{smcl}
{* *! version 1.1.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[R] vce_option" "help vce_option"}{...}
{viewerjumpto "Syntax" "_eqlist##syntax"}{...}
{viewerjumpto "Description" "_eqlist##description"}{...}
{viewerjumpto "Options for .new and .reset" "_eqlist##options_new"}{...}
{viewerjumpto "Options for .markout and .rmcoll" "_eqlist##options_markout"}{...}
{viewerjumpto "Options for .rebuild" "_eqlist##options_rebuild"}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col:{hi:[P] _eqlist} {hline 2}}General-purpose class for managing equation
specifications{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Declare an {cmd:_eqlist} object

{phang2}
{cmd:.}{it:obj} = {cmd:._eqlist.new}
	[{cmd:,} {it:{help _eqlist##reset:reset_options}}]


{pstd}
Reset parse settings

{phang2}
{cmd:.}{it:obj}{cmd:.reset}
	[{cmd:,} {it:{help _eqlist##reset:reset_options}}]


{pstd}
Parse the command line

{phang2}
{cmd:.}{it:obj}{cmd:.parse} {it:command_line}

{pstd}
where {it:command_line} is

{phang2}
{it:eqlist} {ifin} {weight} [{cmd:,} {it:global_options}]

{pstd}
{it:eqlist} is one or more of the following equation specifications

{phang2}
[{it:eqid}{cmd::}] [{depvars} [{cmd:=}]] [{indepvars}] {ifin} {weight}
	[{cmd:,} {it:equation_options}]

{pstd}
and multiple equations are assumed to be bound in parentheses or
delimited by {cmd:||}.


{pstd}
Report the number of parameters to {cmd:s(value)}:

{phang2}
{cmd:.}{it:obj}{cmd:.dim}


{pstd}
Mark the estimation sample:

{phang2}
{cmd:.}{it:obj}{cmd:.markout} [{varname}]
	[{cmd:,} {it:{help _eqlist##markout:markout_options}}]


{pstd}
Remove collinear predictors:

{phang2}
{cmd:.}{it:obj}{cmd:.rmcoll} [{varname}]
	[{cmd:,} {it:{help _eqlist##markout:markout_options}}]


{pstd}
Rebuild the command line:

{phang2}
{cmd:.}{it:obj}{cmd:.rebuild}
	[{cmd:,} {it:{help _eqlist##rebuild:rebuild_options}}]


{marker reset}{...}
{synoptset 20}{...}
{synopthdr:reset_options}
{synoptline}
{synopt :{opt eq:opts(opt_name)}}on/off options
	to recognize in an equation specification{p_end}
{synopt :{opt eqarg:opts(opt_name)}}options
	with arguments to recognize in an equation specification{p_end}
{synopt :{opt needvarlist}}equation
	specifications require a {varlist}{p_end}
{synopt :{opt common:opts(opt_spec)}}options
	not specific to equations{p_end}
{synopt :{opt mark:opts(opt_name)}}options
	taking a {varlist} that should be marked for the estimation
	sample{p_end}
{synopt :{opt rmcoll:opts(opt_name)}}options
	taking a {varlist} that should be checked for collinear variables{p_end}
{synopt :{opt rmdcoll:opts(opt_name)}}options
	taking a {varlist} with {depvars} that should be checked for
	collinear variables{p_end}
{synopt :{opt numdep:vars(#)}}minimum
	number of {depvars} required in each equation specification;
	default is 1{p_end}
{synopt :{opt needequal}}an equal sign is required for
	separating the {depvars} from the {indepvars}{p_end}
{synopt :{opt wtypes(weight_types)}}allowed weight types; default is none{p_end}
{synopt :{opt ignorecons}}ignore {opt noconstant} option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:opt_spec} is an option specification as in {helpb syntax}.
{p_end}
{p 4 6 2}
{it:opt_name} is the name of an option for the {cmd:.parse} routine to
identify.
Use capital letters to specify minimum abbreviations as in {helpb syntax}.
{p_end}


{marker markout}{...}
{synoptset 20}{...}
{synopthdr:markout_options}
{synoptline}
{synopt :{opt replace}}replace the values in {it:varname};
	default is to assume {it:varname} is a new variable{p_end}
{synopt :{opt alldepsmis:sing}}only
	mark out observations in which all the {it:depvars} in an equation
	contain missing values{p_end}
{synoptline}
{p2colreset}{...}


{marker rebuild}{...}
{synoptset 20}{...}
{synopthdr:rebuild_options}
{synoptline}
{synopt :{opt par:entheses}}bind equations in parentheses;
	default for specifications with two or more equations{p_end}
{synopt :{opt unparfirst:eq}}do
	not bind the first equation in parentheses{p_end}
{synopt :{opt or}}delimit equations with {opt ||} instead of
binding them in parentheses{p_end}
{synopt :{opt equal}}separate
	{depvars} from the {indepvars} with an equal sign{p_end}
{synopt :{opt unequalfirst:eq}}do
	not put an equal sign in the first equation{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_eqlist} is a programmer's tool for parsing equation specifications.


{marker options_new}{...}
{title:Options for .new and .reset}

{phang}
{opt eqopts(opt_name)} identifies on/off options to recognize when parsing 
{it:command_line}.
If you supply the {opt noconstant} option in {opt eqopts()}, the {cmd:.parse}
routine will verify that there are {it:indepvars} present whenever the
{opt noconstant} option is specified in an equation.

{pmore}
Use capital letters to specify minimum abbreviations as in {helpb syntax}.

{phang}
{opt eqargopts(opt_name)} identifies options with arguments to recognize when
parsing {it:command_line}.  If you supply {opt offset} or
{opt exposure}, the {cmd:.markout} routine will include the offset or exposure
variable for identifying the estimation sample whenever one is specified in an
equation.

{phang}
{opt needvarlist} requires a {it:varlist} in each equation specification.

{phang}
{opt commonopts(opt_spec)} identifies global options that are not equation
specific.

{phang}
{opt markopts(opt_name)} identifies options that accept a {it:varlist} in its
arguments.  The {cmd:.markout} routine will include the variables for
identifying the estimation sample.

{phang}
{opt rmcollopts(opt_name)} identifies options that accept a {it:varlist} in
its arguments.  The {cmd:.rmcoll} routine will drop collinear variables from
{it:varlist}.

{phang}
{opt rmdcollopts(opt_name)} identifies options that accept an equation
specification with {it:depvars} and {it:indepvars} in its arguments.  The
{cmd:.rmcoll} routine will drop collinear variables from the {it:indepvars}.

{phang}
{opt numdepvars(#)} specifies the minimum number of {it:depvars} allowed
within an equation.

{phang}
{opt needequal} specifies that the equal sign is required to separate the
{it:depvars} from the {it:indepvars} within each equation.

{phang}
{opt wtypes(weight_types)} specifies which weight types are allowed to be
specified in {it:command} and determines the default weight type.
{it:weight_types} is a list of weight types accepted by {helpb syntax}.
If {opt wtypes()} is not specified, the default is {cmd:wtypes(fw aw pw iw)}.

{phang}
{opt ignorenocons} specifies that {cmd:.parse} and {cmd:.rmcoll} ignore the
{opt noconstant} option if it is specified in any of the equations.  This
option is seldom used.


{marker options_markout}{...}
{title:Options for .markout and .rmcoll}

{phang}
{opt replace} indicates that {it:varname} exists.  {it:varname} is assumed to
be a new variable name if {opt replace} is not specified.

{phang}
{opt alldepsmissing} indicates that only observations in which all the
{it:depvars} within an equation are missing are to be marked out from the
estimation sample.  See {helpb intreg} for an example estimation command that
accepts missing values in its {it:depvars} so long as it is not both in the same
observation.


{marker options_rebuild}{...}
{title:Options for .rebuild}

{phang}
{opt parentheses} causes all the equations to be bound in parentheses.
This is the default behavior when two or more equations are specified.

{phang}
{opt unparfirsteq} prevents the first equation from being bound in parentheses,
even when the {opt parentheses} option is specified.  See {helpb ivregress} for
an estimation command where this option would be required.

{phang}
{opt or} causes the equations to be separated by {cmd:||} instead of being
bound in parentheses.

{phang}
{opt equal} causes the equal sign to delimit {it:depvars} from {it:indepvars}
in all the equations.

{phang}
{opt unequalfirsteq} prevents the {opt equal} option from having an effect in
the first equation.  See {helpb ivregress} for an estimation command where this
option would be required.
{p_end}
