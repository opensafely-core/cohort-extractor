{smcl}
{* *! version 1.1.2  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf__parse_colon##syntax"}{...}
{viewerjumpto "Description" "mf__parse_colon##description"}{...}
{viewerjumpto "Remarks" "mf__parse_colon##remarks"}{...}
{viewerjumpto "Conformability" "mf__parse_colon##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__parse_colon##diagnostics"}{...}
{viewerjumpto "Source code" "mf__parse_colon##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] _parse_colon()} {hline 2} Parse utility for Stata prefix commands


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mata:} {cmd:_parse_colon("}{it:hascolon}{cmd:",}
{cmd:"}{it:rhscmd}{cmd:")}


{p 8 8 2}
Inputs (from Stata):

{col 12}{cmd:`0'}{col 25}string to be parsed

{p 8 8 2}
Outputs (to Stata):

{col 12}{cmd:`}{it:hascolon}{cmd:'}{col 25}0 or 1, whether {cmd:`0'} had colon
{col 12}{cmd:`0'}{col 25}original {cmd:`0'} prior to colon {...}
(unchanged if no colon)
{col 12}{cmd:`}{it:rhscmd}{cmd:'}{col 25}original {cmd:`0'} to the right of the colon ("" if no colon)


{p 4 4 2}
(Syntax is shown in Stata format because {cmd:_parse_colon()} 
is intended for use from Stata ado-files.  
Arguments are names of local macros to be created.
Mata function 
{cmd:_parse_colon()} is in fact {it:void}, and each argument is
{it:string scalar}.)


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_parse_colon("}{it:hascolon}{cmd:",}
{cmd:"}{it:rhscmd}{cmd:")}
is a function designed for use from Stata ado-files to assist in the 
parsing of prefix commands.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Assume {cmd:`0'} contains "{cmd:by group: generate x = _n}".
Then after running {cmd:mata: _parse_colon(colon, rhs)}, 
{cmd:`colon'} contains 1,
{cmd:`0'} contains "{cmd:by group}", and
{cmd:`rhs'} contains "{cmd:generate x = _n}".


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
All arguments are {it:string scalar} and contain the name of Stata local 
macros to be created or replaced.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:`0'} is always split on the left-most colon, so 
{cmd:_parse_colon()}
may be used to process nested colon commands.

{p 4 4 2}
Colons inside quotes, parentheses, brackets, or braces are ignored.

{p 4 4 2}
{cmd:mata:} {cmd:_parse_colon("}{it:hascolon}{cmd:",}
{cmd:"}{it:rhscmd}{cmd:")}
    does not abort with error and produces no error messages.
    If local macro {cmd:`0'} does not contain a 
    colon, then {cmd:`}{it:hascolon}{cmd:'} is set to 0
    and {cmd:`}{it:rhscmd}{cmd:'} is set to "".
    If a colon is present but nothing appears to the right of it, 
    {cmd:`}{it:hascolon}{cmd:'} is set to 1
    and {cmd:`}{it:rhscmd}{cmd:'} is set to "".


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view _parse_colon.mata, adopath asis:_parse_mata.mata}
{p_end}
