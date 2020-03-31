{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{viewerjumpto "Syntax" "di_g##syntax"}{...}
{viewerjumpto "Description" "di_g##description"}{...}
{viewerjumpto "Remarks" "di_g##remarks"}{...}
{title:Title}

{p 4 14 2}
{hi:[G-2] di_g} {hline 2} Display debug message


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:di_g}
{it:{help display:display_syntax}}

{p 8 13 2}
{cmd:set}
{cmd:di_g}
{c -(}{cmd:on}|{cmd:off}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:di_g} does nothing (is treated as a comment) if {cmd:set} {cmd:di_g} is
{cmd:off}, or it is equivalent to the {cmd:display} command (see
{manhelp display P}).

{pstd}
{cmd:set} {cmd:di_g} sets the behavior of {cmd:di_g}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:di_g} is used for including debug messages in {cmd:graph}; see
{manhelp graph G-2}.

{pstd}
The setting of {cmd:di_g} is not shown by {cmd:query}.
{p_end}
