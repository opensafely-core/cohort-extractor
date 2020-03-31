{smcl}
{* *! version 1.0.1  19dec2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] assert" "help assert"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _assert_mreldif" "help _assert_mreldif"}{...}
{viewerjumpto "Syntax" "_sassert##syntax"}{...}
{viewerjumpto "Description" "_sassert##description"}{...}
{viewerjumpto "Options" "_sassert##options"}{...}
{title:Title}

{p2colset 5 21 21 2}{...}
{p2col :{hi: [P] _sassert} {hline 2}}Verify two scalars are equal{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt _sassert} {it:scalar1} {it:scalar2} [{cmd:,} {opt tol(real)}
		{opt nostop} {opt rel:dif(real)} {opt int:eger} 
		{opt eq:ual}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_sassert} verifies that 
{cmd:reldif(}{it:scalar1}{cmd:,}{it:scalar2}{cmd:)} <= {it:tol} is true.
If it is true, the command produces no output.  If it is not true, 
{cmd:_sassert} informs you of the "assertion failure", displays the 
relative difference, and issues a return code of 9; see {findalias frrc}.


{marker options}{...}
{title:Options}

{phang}
{opt tol(real)} sets the tolerance limit for the relative difference.
The default is {cmd:tol(1e-8)}.

{phang}
{opt nostop} prevents termination with error code 9 but still displays the 
	error message.

{phang}
{opt reldif(real)} sets the scalar in the denominator of the relative 
	difference computation, 
     {cmd:abs(}{it:scalar1}{cmd:)}/({cmd:abs(}{it:scalar2}{cmd:)}+{it:reldif}).
	Machine epsilon is a common alternative, {cmd:c(epsdouble)}. 
	The default is {cmd:reldif(1.0)}.

{phang}
{opt integer} states that {it:scalar1} and {it:scalar2} are integers, and
	a check for equivalence is to be performed.

{phang}
{opt equal} checks for exact equivalency (within machine precision), 
	for example, {it:scalar1} {cmd:==} {it:scalar2}.
{p_end}
