{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] range()" "mansection M-5 range()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_range##syntax"}{...}
{viewerjumpto "Description" "mf_range##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_range##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_range##remarks"}{...}
{viewerjumpto "Conformability" "mf_range##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_range##diagnostics"}{...}
{viewerjumpto "Source code" "mf_range##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] range()} {hline 2}}Vector over specified range
{p_end}
{p2col:}({mansection M-5 range():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric colvector}{bind: }
{cmd:range(}{it:a}{cmd:,}
{it:b}{cmd:,}
{it:numeric scalar} {it:delta}{cmd:)}

{p 8 12 2}
{it:numeric colvector}
{cmd:rangen(}{it:a}{cmd:,}
{it:b}{cmd:,}
{it:real scalar} {it:n}{cmd:)}


{p 4 8 2}
where {it:a} and {it:b} are numeric scalars.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:range(}{it:a}{cmd:,} {it:b}, {it:delta}{cmd:)} returns a column vector
going from {it:a} to {it:b} in steps of {cmd:abs(}{it:delta}{cmd:)}
({it:b}>={it:a}) or -{cmd:abs(}{it:delta}{cmd:)} ({it:b}<{it:a}).

{p 4 4 2}
{cmd:rangen(}{it:a}{cmd:,} {it:b}, {it:n}{cmd:)} returns a 
{cmd:round(}{it:n}{cmd:)} {it:x} 1
column vector going from {it:a} to {it:b} in {cmd:round(}{it:n}{cmd:)}-1
steps.  {it:a} may be less than, equal to, or greater than {it:b}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 range()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:range(0, 1, .25)} returns (0 \ .25 \ .5 \ .75 \ 1).
The sign of the third argument does not matter; 
{cmd:range(0, 1, -.25)} returns the same thing.
{cmd:range(1, 0, .25)} and 
{cmd:range(1, 0, -.25)} return 
(1 \ .75 \ .5 \ .25 \ 0).

{p 4 4 2}
{cmd:rangen(0, .5, 6)} returns (0 \ .1 \ .2 \ .3 \ .4 \ .5).
{cmd:rangen(.5, 0, 6)} returns (.5 \ .4 \ .3 \ .2 \ .1 \ 0).

{p 4 4 2}
{cmd:range()} and {cmd:rangen()} may be used with complex arguments.
{cmd:range(1, 1i, .4)} returns
(1 \ .75+.25i \ .5+.5i \ .25+.75i \ 1i).
{cmd:rangen(1, 1i, 5)} returns the same thing.
For {cmd:range()}, only the distance of {it:delta} from zero
matters, so 
{cmd:range(1, 1i, .4i)} would produce the same result, as would 
{cmd:range(1, 1i, .25+.312i)}.


{marker conformability}{...}
{title:Conformability}

    {cmd:range(}{it:a}{cmd:,} {it:b}, {it:delta}{cmd:)}:
		{it:a}:  1 {it:x} 1
		{it:b}:  1 {it:x} 1
	    {it:delta}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1{col 55}if {it:a} = {it:b}
		    max(1+abs({it:b}-{it:a})/abs({it:delta}),2) {it:x} 1{col 55}otherwise

    {cmd:rangen(}{it:a}{cmd:,} {it:b}, {it:n}{cmd:)}:
		{it:a}:  1 {it:x} 1
		{it:b}:  1 {it:x} 1
		{it:n}:  {it:n} {it:x} 1
	   {it:result}:  {opt round(n)} {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:range(}{it:a}{cmd:,} {it:b}, {it:delta}{cmd:)}
aborts with error if {it:a}, {it:b}, or {it:delta} contains missing, 
if abs({it:b}-{it:a})/abs({it:delta}) results in overflow, or if 
1+abs({it:b}-{it:a})/abs({it:delta}) results in a vector that is too big given
the amount of memory available.

{p 4 4 2}
{cmd:range(}{it:a}{cmd:,} {it:b}, {it:delta}{cmd:)}
returns a 1 {it:x} 1 result when {it:a} = {it:b}.  In all other cases, 
the result is 2 {it:x} 1 or longer.

{p 4 4 2}
{cmd:rangen(}{it:a}{cmd:,} {it:b}, {it:n}{cmd:)}
aborts with error if {cmd:round(}{it:n}{it:)} is less than 0 or missing.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view range.mata, adopath asis:range.mata},
{view rangen.mata, adopath asis:rangen.mata}
{p_end}
