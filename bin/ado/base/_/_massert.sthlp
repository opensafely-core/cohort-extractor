{smcl}
{* *! version 1.0.1  19dec2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _assert_mreldif" "help _assert_mreldif"}{...}
{viewerjumpto "Syntax" "_massert##syntax"}{...}
{viewerjumpto "Description" "_massert##description"}{...}
{viewerjumpto "Options" "_massert##options"}{...}
{title:Title}

{p2colset 5 21 21 2}{...}
{p2col :{hi:[P] _massert} {hline 2}}Verify two matrices are equal{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt _massert} {it:matrix1} {it:matrix2} [{cmd:,} {opt tol(real)}
		{opt nostop}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_massert} verifies that 
{cmd:reldif(}{it:matrix1}{cmd:,}{it:matrix2}{cmd:)} <= {it:tol} is true.
If it is true, the command produces no output.  If it is not true, 
{cmd:_massert} informs you of the "assertion failure", displays the 
relative difference, and issues a return code of 9; see {findalias frrc}.


{marker options}{...}
{title:Options}

{phang}
{opt tol(real)} sets the tolerance limit for the relative difference.
The default is {cmd:tol(1e-8)}.

{phang}
{opt nostop} prevents termination with error code 9 but still displays the 
	error message.
{p_end}
