{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_get_eqspec##syntax"}{...}
{viewerjumpto "Warning" "_get_eqspec##warning"}{...}
{viewerjumpto "Description" "_get_eqspec##description"}{...}
{viewerjumpto "Local macros reserved by caller" "_get_eqspec##reserved"}{...}
{viewerjumpto "Arguments" "_get_eqspec##arguments"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] _get_eqspec} {hline 2} Parsing tool for generating scores


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_get_eqspec}
	{it:c_eqlist}
	{it:c_stub}
	{it:c_k}
	{cmd::}
	{it:matname}


{marker warning}{...}
{title:Warning}

{pstd}
{cmd:_get_eqspec} uses {cmd:c_local} to create local macros in the command
that calls it.  Therefore, choose your {it:c_*} arguments carefully.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_get_eqspec} is a programming tool that helps identify the equation
elements from a coefficient vector.


{marker reserved}{...}
{title:Local macros reserved by caller}

{phang}
{it:c_eqlist} will contain the list of equation names.

{phang}
{it:c_stub} is the stub for local macros that will contain the names of the
independent variables ({it:x} variables) for a given equation, and whether
a constant was suppressed from that equation.

{pmore}
For example, if {cmd:x1} and {cmd:x2} are independent variables in the second
equation, then {it:c_stub}{cmd:2xvars} will contain "{cmd:x1} {cmd:x2}".  If
the constant term was suppressed from this equation, then
{it:c_stub}{cmd:2nocons} will contain "{cmd:nocons}"; otherwise it would be
empty.

{phang}
{it:c_k} will contain the number of equations.


{marker arguments}{...}
{title:Arguments}

{phang}
{it:matname} identifies a coefficient vector.  The most common case is where
{it:matname} is a temporary copy of {cmd:e(b)}.
{p_end}
