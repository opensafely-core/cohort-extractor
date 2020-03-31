{smcl}
{* *! version 1.0.2  18jan2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{viewerjumpto "Syntax" "_cassert##syntax"}{...}
{viewerjumpto "Description" "_cassert##description"}{...}
{viewerjumpto "Options" "_cassert##options"}{...}
{title:Title}

{p2colset 5 21 21 2}{...}
{p2col :{hi: [P] _cassert} {hline 2}}Verify two strings are equal{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt _cassert}{cmd:,} {opt str:ing(string1)} {opt to(string2)} [{opt nostop}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_cassert} verifies that {it:string1}=={it:string2} is true.  If it is
true, the command produces no output.  If it is not true, {cmd:_cassert}
informs you of the "assertion failure", displays the strings, and issues a
return code of 9; see {findalias frrc}.


{marker options}{...}
{title:Options}

{pstd}
{opt string(string1)} specifies the string in question.

{pstd}
{opt to(string2)} specifies the expected string.

{pstd}
{opt nostop} prevents termination with error code 9 but still displays the 
	error message.
{p_end}
