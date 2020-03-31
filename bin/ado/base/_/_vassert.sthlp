{smcl}
{* *! version 1.0.1  19dec2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] assert" "help assert"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _assert_mreldif" "help _assert_mreldif"}{...}
{viewerjumpto "Syntax" "_vassert##syntax"}{...}
{viewerjumpto "Description" "_vassert##description"}{...}
{viewerjumpto "Options" "_vassert##options"}{...}
{title:Title}

{p2colset 5 21 21 2}{...}
{p2col :{hi:[P] _vassert} {hline 2}}Verify two variables are equal{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt _vassert} {it:var1} {it:var2} {ifin}
    [{cmd:,} {opt tol(real)} {opt scale(real)} {opt nostop}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_vassert} verifies that {cmd:reldif(}{it:var1}{cmd:,}{it:var2}{cmd:)} <
{it: tol} is true.  If it is true, the command produces no output.  If it is
not true, {cmd:_vassert} informs you of the "assertion failure",
displays a summary of the relative difference, and issues a return code of 9;
see {findalias frrc}.


{marker options}{...}
{title:Options}

{phang}
{opt tol(real)} sets the tolerance limit for the relative difference.
The default is {cmd:tol(1e-8)}.

{phang}
{opt scale(scale)} scales the variables by scalar {it:scale}.  This option
is used when {cmd:reldif()} asymptotically becomes an absolute difference for
abs(x)<1.

{phang}
{opt nostop} prevents termination with error code 9 but still displays the 
	error message.
{p_end}
