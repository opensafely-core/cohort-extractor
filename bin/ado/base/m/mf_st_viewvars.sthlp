{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_viewvars()" "mansection M-5 st_viewvars()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_view()" "help mf_st_view"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_viewvars##syntax"}{...}
{viewerjumpto "Description" "mf_st_viewvars##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_viewvars##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_viewvars##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_viewvars##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_viewvars##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_viewvars##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] st_viewvars()} {hline 2}}Variables and observations of view
{p_end}
{p2col:}({mansection M-5 st_viewvars():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real rowvector} 
{cmd:st_viewvars(}{it:matrix V}{cmd:)}

{p 8 12 2}
{it:real vector}{bind:   }
{cmd:st_viewobs(}{it:matrix V}{cmd:)}


{p 4 8 2}
where {it:V} is required to be a view.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_viewvars(}{it:V}{cmd:)}
returns the indices of the Stata variables corresponding to the 
columns of {it:V}.

{p 4 4 2}
{cmd:st_viewobs(}{it:V}{cmd:)} 
returns the Stata observation numbers corresponding to the rows of 
{it:V}.  Returned is either a 1 {it:x} 2 row vector recording the observation
range or an {it:N x} 1 column vector recording the individual observation
numbers.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_viewvars()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The results returned by these two functions are suitable for 
inclusion as arguments in subsequent calls to 
{cmd:st_view()} and {cmd:st_sview()}; see
{bf:{help mf_st_view:[M-5] st_view()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_viewvars(}{it:V}{cmd:)}
		{it:V}:  {it:N x k}
	   {it:result}:  1 {it:x k}

    {cmd:st_viewobs(}{it:V}{cmd:)}
		{it:V}:  {it:N x k}
	   {it:result}:  1 {it:x} 2  or  {it:N x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_viewvars(}{it:V}{cmd:)}
and
{cmd:st_viewobs(}{it:V}{cmd:)}
abort with error if {cmd:V} is not a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
