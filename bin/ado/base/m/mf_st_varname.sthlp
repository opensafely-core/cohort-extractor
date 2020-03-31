{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_varname()" "mansection M-5 st_varname()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_tsrevar()" "help mf_st_tsrevar"}{...}
{vieweralsosee "[M-5] st_varindex()" "help mf_st_varindex"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_varname##syntax"}{...}
{viewerjumpto "Description" "mf_st_varname##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_varname##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_varname##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_varname##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_varname##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_varname##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] st_varname()} {hline 2}}Obtain variable names from variable indices
{p_end}
{p2col:}({mansection M-5 st_varname():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string rowvector}
{cmd:st_varname(}{it:real rowvector k}{cmd:)}

{p 8 12 2}
{it:string rowvector}
{cmd:st_varname(}{it:real rowvector k}{cmd:,}
{it:real scalar tsmap}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_varname(}{it:k}{cmd:)} returns the Stata variable names associated
with the variable indices stored in {it:k}.  For instance, with the 
automobile data in memory

	{cmd:names = st_varname((1..3))}

{p 4 4 2}
results in {cmd:names} being ("make", "price", "mpg").

{p 4 4 2}
{cmd:st_varname(}{it:k}{cmd:,} {it:tsmap}{cmd:)} does the same thing but
allows you to specify whether you want the actual or logical variable names
of any time-series-operated variables created by the Mata function 
{cmd:st_tsrevar()} (see {bf:{help mf_st_tsrevar:[M-5] st_tsrevar()}}) or by
the Stata command {cmd:tsrevar} (see {bf:{help tsrevar:[TS] tsrevar}}).

{p 4 4 2}
{cmd:st_varname(}{it:k}{cmd:)} is equivalent to {cmd:st_varname(}{it:k}{cmd:,}
{cmd:0)}; actual variable names are returned.

{p 4 4 2}
{cmd:st_varname(}{it:k}{cmd:, 1)} returns logical variable names.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_varname()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
To understand the actions of {cmd:st_varname(}{it:k}{cmd:, 1)}, pretend that
variable 58 was created by {cmd:st_tsrevar()}:

	{cmd:k = st_tsrevar(("gnp", "r", "l.gnp"))}

{p 4 4 2}
Pretend that {cmd:k} now contains (12, 5, 58).  Variable 58 is a new, temporary
variable, containing {cmd:l.gnp} values.  Were you to ask for the 
actual names of the variables

	{cmd:actualnames = st_varname(k)}

{p 4 4 2}
{cmd:actualnames} would contain 
("gnp", "r", "__00004a"), although the name of the last variable
will vary because it is a temporary variable.  Were you to ask for the
logical names,

	{cmd:logicalnames = st_varname(k, 1)}

{p 4 4 2}
you would get back ("gnp", "r", "L.gnp").


{marker conformability}{...}
{title:Conformability}

    {cmd:st_varname(}{it:k}, {it:tsmap}{cmd:)}
		{it:k}:  1 {it:x c}
	    {it:tsmap}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_varname(}{it:k}{cmd:)} and 
{cmd:st_varname(}{it:k}{cmd:,} {it:tsmap}{cmd:)}
abort with error if any element of {it:k} is 
less than 1 or greater than {cmd:st_nvar()}; 
see {bf:{help mf_st_nvar:[M-5] st_nvar()}}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
