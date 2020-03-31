{smcl}
{* *! version 1.0.1  23feb2019}{...}
{vieweralsosee "[M-5] ustrsplit()" "mansection M-5 ustrsplit()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{vieweralsosee "[M-5] ustrword()" "help mf_ustrword"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_ustrsplit##syntax"}{...}
{viewerjumpto "Description" "mf_ustrsplit##description"}{...}
{viewerjumpto "Remarks" "mf_ustrsplit##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrsplit##conformability"}{...}
{viewerjumpto "Source code" "mf_ustrsplit##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] ustrsplit()} {hline 2}}Split string into parts based on a Unicode regular expression
{p_end}
{p2col:}({mansection M-5 ustrsplit():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string rowvector}
{cmd:ustrsplit(}{it:string scalar s}{cmd:,}
{it:string scalar ustrregexp}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrsplit(}{it:s}{cmd:,} {it:ustrregexp}{cmd:)}
returns the contents of {it:s} split into parts based on {it:ustrregexp}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:ustrsplit()} splits a string into parts according to a Unicode regular
expression.

{pstd}
For example,

	{cmd:ustrsplit("$12.31 €6.75", "[$€]") = ("", "12.31 ", "6.75")}
	
{p 4 4 2}
Note that the first element of the result is an empty string.  This is because
{cmd:ustrsplit()} encountered the first "$" in the string being split and an
empty string (that is, nothing) was to the left of that "$".  Assuming you
put the above result into a string scalar named "{cmd:result}", you can
type the following to remove that leading empty string and any other
all-whitespace parts:

	{cmd:select(result, ustrlen(ustrtrim(result)):!=0)}

{p 4 4 2}
The example above splits on any dollar sign or Euro symbol.  To split on any
Unicode character that is considered a currency symbol, we can use the regular
expression {cmd:[\p{Sc}]},

	{cmd:ustrsplit("$12.31 €6.75 ¥100.50 ₩25.45", "[\p{Sc}]")} 

{p 4 4 2}
which returns
	
	{cmd:("", "12.31 ", "6.75 ","100.50 ","25.45")}


{marker conformability}{...}
{title:Conformability}

    {cmd:ustrsplit(}{it:s}{cmd:,} {it:ustrregexp}{cmd:)}
		 {it:s}:  1 {it:x} 1
	{it:ustrregexp}:  1 {it:x} 1 
	    {it:result}:  1 {it:x w}, {it:w} = number of parts in {it:s}


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
