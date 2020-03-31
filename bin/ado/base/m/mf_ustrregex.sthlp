{smcl}
{* *! version 1.0.3  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "string functions" "help string functions"}{...}
{viewerjumpto "Syntax" "mf_ustrregex##syntax"}{...}
{viewerjumpto "Description" "mf_ustrregex##description"}{...}
{viewerjumpto "Remarks" "mf_ustrregex##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrregex##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrregex##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrregex##source"}{...}
{title:Title}

{p 4 4 2}
{bf:[M-5] ustrregexm()} {hline 2} Unicode regular expression match


{marker syntax}{...}
{title:Syntax}

{p 8 34 2}
{it:real matrix}{space 4}{cmd:ustrregexm(}{it:string matrix s}{cmd:,}
{it:string matrix re} {break}
[{cmd:,} {it:real scalar noc}]{cmd:)}

{p 8 34 2}
{it:string matrix} {cmd:ustrregexrf(}{it:string matrix s1}{cmd:,}
{it:string matrix re}{cmd:,}{break}
{it:string matrix s2} [{cmd:,} {it:real scalar noc}]{cmd:)}

{p 8 34 2}
{it:string matrix} {cmd:ustrregexra(}{it:string matrix s1}{cmd:,}
{it:string matrix re}{cmd:,} {break}
{it:string matrix s2} [{cmd:,} {it:real scalar noc}]{cmd:)}

{p 8 34 2}
{it:string matrix} {cmd:ustrregexs(}{it:real matrix r}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrregexm(}{it:s}{cmd:,} {it:re} [{cmd:,} {it:noc}]{cmd:)}
performs a match of a regular expression and evaluates to {cmd:1} if regular 
expression {it:re} is satisfied by the Unicode string {it:s}; otherwise, 
it evaluates to {cmd:0}.  If {it:noc} is specified and is not zero, a case
insensitive match is performed. 

{p 4 4 2}
{cmd:ustrregexrf(}{it:s1}{cmd:,} {it:re}{cmd:,} {it:s2} [{cmd:,} {it:noc}]{cmd:)}
replaces the first substring within the Unicode string {it:s1} that matches 
{it:re} with {it:s2} and returns the resulting string.  If {it:noc} is 
specified and is not zero, a case insensitive match is performed. 

{p 4 4 2}
{cmd:ustrregexra(}{it:s1}{cmd:,} {it:re}{cmd:,} {it:s2} [{cmd:,} {it:noc}]{cmd:)}
replaces all substrings within the Unicode string {it:s1} that match {it:re}
with {it:s2} and returns the resulting string.  If {it:noc} is specified and
is not zero, a case insensitive match is performed. 

{p 4 4 2}
{cmd:ustrregexs(}{it:r}{cmd:)}
returns subexpression {it:r} from a previous {cmd:ustrregexm()} match.  
Subexpression 0 is reserved for the entire string that satisfied the regular 
expression.  The function may return an empty string if {it:r} is larger
than the maximum count of subexpressions from the previous match.
	
{p 4 4 2}
When {it:s}, {it:s1}, {it:s2}, {it:re}, and {it:r} are not scalar,
these functions return element-by-element results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
An invalid UTF-8 sequence is replaced with the Unicode replacement
character {bf:\ufffd} before the match is performed. 


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrregexm(}{it:s}{cmd:,} {it:re} [{cmd:,} {it:noc}]{cmd:)},
{cmd:ustrregexrf(}{it:s1}{cmd:,} {it:re}{cmd:,} {it:s2} [{cmd:,} {it:noc}]{cmd:)},
{cmd:ustrregexra(}{it:s1}{cmd:,} {it:re}{cmd:,} {it:s2} [{cmd:,} {it:noc}]{cmd:)}:
{p_end}
		{it:s}:  {it:r x c} 
	       {it:s1}:  {it:r x c} or 1 {it:x} 1
	       {it:re}:  {it:r x c} or 1 {it:x} 1
	       {it:s2}:  {it:r x c} or 1 {it:x} 1
	      {it:noc}:  {it:1 x 1}
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:ustrregexrs(}{it:r}{cmd:)}:
{p_end}
	        {it:r}:   1 {it:x} 1
	   {it:result}:   1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrregexm()} returns a negative integer if an error occurs. 

{p 4 4 2}
{cmd:ustrregexrf()}, {cmd:ustrregexra()}, and {cmd:ustrregexrs()} return
an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
