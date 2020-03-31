{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_tempname()" "mansection M-5 st_tempname()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_addvar()" "help mf_st_addvar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_tempname##syntax"}{...}
{viewerjumpto "Description" "mf_st_tempname##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_tempname##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_tempname##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_tempname##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_tempname##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_tempname##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] st_tempname()} {hline 2}}Temporary Stata names
{p_end}
{p2col:}({mansection M-5 st_tempname():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:st_tempname()}

{p 8 12 2}
{it:string rowvector}
{cmd:st_tempname(}{it:real scalar n}{cmd:)}


{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:st_tempfilename()}

{p 8 12 2}
{it:string rowvector}
{cmd:st_tempfilename(}{it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_tempname()} returns a Stata temporary name, the same as would be 
returned by Stata's {cmd:tempvar} and {cmd:tempname} commands; see 
{bf:{help macro:[P] macro}}.

{p 4 4 2}
{cmd:st_tempname(}{it:n}{cmd:)} returns {it:n} temporary Stata names, {it:n}>=0.

{p 4 4 2}
{cmd:st_tempfilename()} returns a Stata temporary filename, the same as would
be returned by Stata's {cmd:tempfile} command; see
{bf:{help macro:[P] macro}}.

{p 4 4 2}
{cmd:st_tempfilename(}{it:n}{cmd:)} returns {it:n} temporary filenames,
{it:n}>=0.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_tempname()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_st_tempname##remarks1:Creating temporary objects}
	{help mf_st_tempname##remarks2:When temporary objects will be eliminated}


{marker remarks1}{...}
{title:Creating temporary objects}

{p 4 4 2}
{cmd:st_tempname()}s can be used to name Stata's variables, matrices, and
scalars.  Although in Stata a distinction is drawn between {cmd:tempvar}s and
{cmd:tempname}s, there is no real distinction, and so
{cmd:st_tempname()} handles both in Mata.  For instance, one can create a
temporary variable by coding

	{cmd:idx = st_addvar("double", st_tempname())}

{p 4 4 2}
See {bf:{help mf_st_addvar:[M-5] st_addvar()}}.

{p 4 4 2}
One creates a temporary file by coding

	{cmd:fh = fopen(st_tempfilename(), "w")}

{p 4 4 2}
See {bf:{help mf_fopen:[M-5] fopen()}}.


{marker remarks2}{...}
{title:When temporary objects will be eliminated}

{p 4 4 2}
Temporary objects do not vanish when the Mata function ends, nor when Mata
itself ends.  They are removed when the ado-file (or do-file) calling Mata
terminates.

{p 4 4 2}
Forget Mata for a minute.  Stata eliminates temporary variables and files when
the program that created them ends.
That same rule applies to Mata:  Stata eliminates them, not Mata, and that
means that the ado-file or do-file that called Mata will eliminate them when
that ado-file or do-file ends.  Temporary variables and files are not
eliminated by Mata when the Mata function ends.  Thus Mata
functions can create temporary objects for use by their ado-file
callers, should that prove useful.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_tempname()}, {cmd:st_tempfilename()}:
	   {it:result}:  1 {it:x} 1

    {cmd:st_tempname(}{it:n}{cmd:)}, {cmd:st_tempfilename(}{it:n}{cmd:)}:
		{it:n}:  1 {it:x} 1
	   {it:result}:  1 {it:x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_tempname(}{it:n}{cmd:)} 
and 
{cmd:st_tempfilename(}{it:n}{cmd:)} 
abort with error if {it:n}<0 and return
{cmd:J(1,0,"")} if {it:n}=0.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
