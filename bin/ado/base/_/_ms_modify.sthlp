{smcl}
{* *! version 1.0.1  09jan2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{vieweralsosee "[P] _matrix_table" "help _matrix_table"}{...}
{viewerjumpto "Syntax" "_ms_modify##syntax"}{...}
{viewerjumpto "Description" "_ms_modify##description"}{...}
{viewerjumpto "Options" "_ms_modify##options"}{...}
{title:Title}

{p2colset 4 22 24 2}{...}
{p2col:{hi:[P] _ms_modify} {hline 2}}Modify column stripes
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_modify} {it:matrix_name} [{cmd:,}
{opt fvignore(#)} {opt row}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_modify} changes the column stripe elements of {it:matrix_name} by
removing the indicated number of factor variables.
{it:matrix_name} can be any matrix name except {cmd:e(b)}, {cmd:e(V)}, and
{cmd:e(Cns)}.


{marker options}{...}
{title:Options}

{phang}
{opt fvignore(#)} specifies that {it:#} factor variables be removed from each
column stripe element of {it:matrix_name}.
The rightmost factor variables are removed first.

{phang}
{opt row} specifies that the information comes from the row stripe.  The
default is the column stripe.
{p_end}
