{smcl}
{* *! version 1.0.2  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "string functions" "help string functions"}{...}
{vieweralsosee "regex" "help regex"}{...}
{viewerjumpto "Syntax" "mf_regex##syntax"}{...}
{viewerjumpto "Description" "mf_regex##description"}{...}
{viewerjumpto "Remarks" "mf_regex##remarks"}{...}
{viewerjumpto "Conformability" "mf_regex##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_regex##diagnostics"}{...}
{viewerjumpto "Source code" "mf_regex##source"}{...}
{title:Title}

{p 4 4 2}
{bf:[M-5] regexm()} {hline 2} Regular expression match


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} {cmd:regexm(}{it:string matrix s}{cmd:,}
{it:string matrix re}{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:regexr(}{it:string matrix s1}{cmd:,}
{it:string matrix re}{cmd:,}
{it:string matrix s2}{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:regexs(}{it:void}{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:regexs(}{it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:regexm(}{it:s}{cmd:,} {it:re}{cmd:)}
returns one or zero, corresponding to a match or no match, of regular
expression string {it:re} against {it:s}. 

{p 4 4 2}
{cmd:regexr(}{it:s1}{cmd:,} {it:re}{cmd:,} {it:s2}{cmd:)}
returns the result of replacing the first substring within {it:s1} that matches
{it:re} with {it:s2}.  If {it:s1} contains no string that matches the regular
expression {it:re}, the unaltered {it:s1} is returned.

{p 4 4 2}
{cmd:regexs(}{it:void}{cmd:)}
returns all subexpressions from a previous {cmd:regexm()} match as a matrix
of strings. 

{p 4 4 2}
{cmd:regexs(}{it:n}{cmd:)}
returns subexpression {it:n} from a previous {cmd:regexm()} match, where
{bind:0 {ul:<} {it:n} < 10}.  Subexpression 0 is reserved for the entire string
that satisfied the regular expression.

{p 4 4 2}
When {it:s}, {it:s1}, {it:s2}, and {it:re} are not scalar, these functions
return element-by-element results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The syntax for these undocumented functions may change in the future.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:regexm(}{it:s}, {it:re}{cmd:)},
{cmd:regexr(}{it:s1}{cmd:,} {it:re}{cmd:,} {it:s2}{cmd:)},
{p_end}
		{it:s}{cmd:,} {it:s1}{cmd:,} {it:re}{cmd:,} {it:s2}:  {it:r x c}
	               {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
