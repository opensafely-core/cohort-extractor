{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_varindex()" "mansection M-5 st_varindex()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_varname()" "help mf_st_varname"}{...}
{vieweralsosee "[M-5] tokens()" "help mf_tokens"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_varindex##syntax"}{...}
{viewerjumpto "Description" "mf_st_varindex##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_varindex##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_varindex##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_varindex##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_varindex##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_varindex##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] st_varindex()} {hline 2}}Obtain variable indices from variable names
{p_end}
{p2col:}({mansection M-5 st_varindex():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real rowvector}{bind: }
{cmd:st_varindex(}{it:string rowvector s}{cmd:)}

{p 8 12 2}
{it:real rowvector}{bind: }
{cmd:st_varindex(}{it:string rowvector s}{cmd:,} 
{it:real scalar abbrev}{cmd:)}

{p 8 12 2}
{it:real rowvector}
{cmd:_st_varindex(}{it:string rowvector s}{cmd:)}

{p 8 12 2}
{it:real rowvector}
{cmd:_st_varindex(}{it:string rowvector s}{cmd:,} 
{it:real scalar abbrev}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_varindex(}{it:s}{cmd:)} returns the variable index associated with 
each variable name recorded in {it:s}.  {cmd:st_varindex(}{it:s}{cmd:)} does
not allow variable-name abbreviations such as {cmd:"pr"} for {cmd:"price"}.

{p 4 4 2}
{cmd:st_varindex(}{it:s}{cmd:,} {it:abbrev}{cmd:)} does the same thing but 
allows you to specify whether variable-name abbreviations are to be allowed.
Abbreviations are allowed if {it:abbrev}!=0.  
{cmd:st_varindex(}{it:s}{cmd:)} is equivalent to 
{cmd:st_varindex(}{it:s}{cmd:,} {cmd:0)}.

{p 4 4 2}
{cmd:_st_varindex()} does the same thing as  
{cmd:st_varindex()}.
The two functions differ in how they respond when a name is not found.
{cmd:st_varindex()} aborts with error, and 
{cmd:_st_varindex()} places missing in the appropriate element of the 
returned result.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_varindex()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
These functions require that each element of {it:s} contain a variable name, 
such as 

		{it:s} = {cmd:("price", "mpg", "weight")}

{p 4 4 2}
If you have one string containing multiple names

		{it:s} = {cmd:("price mpg weight")}

{p 4 4 2} 
then use {cmd:tokens()} to split it into the desired form, as in

		{it:k} {cmd:=} {cmd:st_varindex(tokens(}{it:s}{cmd:))}

{p 4 4 2} 
See {bf:{help mf_tokens:[M-5] tokens()}}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
    {cmd:st_varindex(}{it:s}{cmd:,} {it:abbrev}{cmd:)},
    {cmd:_st_varindex(}{it:s}{cmd:,} {it:abbrev}{cmd:)}:
{p_end}
		{it:s}:  1 {it:x k}
	   {it:abbrev}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x k}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_varindex()} aborts with error if any name is not found.

{p 4 4 2}
{cmd:_st_varindex()} puts missing in the appropriate element of the
returned result for any name that is not found.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
