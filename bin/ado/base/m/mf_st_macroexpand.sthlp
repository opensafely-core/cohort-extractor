{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[M-5] st_macroexpand()" "mansection M-5 st_macroexpand()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_macroexpand##syntax"}{...}
{viewerjumpto "Description" "mf_st_macroexpand##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_macroexpand##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_macroexpand##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_macroexpand##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_macroexpand##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_macroexpand##source"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[M-5] st_macroexpand()} {hline 2}}Expand Stata macros in string
{p_end}
{p2col:}({mansection M-5 st_macroexpand():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}
{cmd:st_macroexpand(}{it:string scalar s}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:_st_macroexpand(}{it:S}{cmd:,} 
{it:string scalar s}{cmd:)}


{p 4 11 2}
Note: The type of {it:S} does not matter; it is replaced and becomes a 
string scalar.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_macroexpand(}{it:s}{cmd:)}
returns {it:s} with any quoted or dollar sign--prefixed macros expanded.

{p 4 4 2}
{cmd:_st_macroexpand(}{it:S}{cmd:,} {it:s}{cmd:)}
places in {it:S} the contents of {it:s} with any quoted or
dollar sign--prefixed macros expanded and returns a Stata return code (it
returns 0 if all went well).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_macroexpand()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Be careful coding string literals containing quoted or prefixed macros
because macros are also expanded at compile time.  For instance,
consider 

	{cmd:s = st_macroexpand("regress `varlist'")}

{p 4 4 2}
{cmd:`varlist'} will be substituted with its value at compile time.  What you
probably want is

        {cmd:s = st_macroexpand("regress " + "`" + "varlist" + "'")}


{marker conformability}{...}
{title:Conformability}

    {cmd:st_macroexpand(}{it:s}{cmd:)}:
		{it:s}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:_st_macroexpand(}{it:S}{cmd:,} {it:s}{cmd:)}:
	{it:input:}
		{it:s}:  1 {it:x} 1
	{it:output:}
		{it:S}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_macroexpand(}{it:s}{cmd:)} aborts with error if {it:s} is too long
(exceedingly unlikely) or if macro expansion fails (also unlikely).

{p 4 4 2}
{cmd:_st_macroexpand(}{it:S}{cmd:,} {it:s}{cmd:)} aborts with error if {it:s}
is too long.  


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
