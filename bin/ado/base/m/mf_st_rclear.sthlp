{smcl}
{* *! version 1.1.5  14may2018}{...}
{vieweralsosee "[M-5] st_rclear()" "mansection M-5 st_rclear()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_global()" "help mf_st_global"}{...}
{vieweralsosee "[M-5] st_matrix()" "help mf_st_matrix"}{...}
{vieweralsosee "[M-5] st_numscalar()" "help mf_st_numscalar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_rclear##syntax"}{...}
{viewerjumpto "Description" "mf_st_rclear##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_rclear##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_rclear##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_rclear##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_rclear##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_rclear##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_rclear()} {hline 2}}Clear r(), e(), or s()
{p_end}
{p2col:}({mansection M-5 st_rclear():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:st_rclear()}

{p 8 12 2}
{it:void}
{cmd:st_eclear()}

{p 8 12 2}
{it:void}
{cmd:st_sclear()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_rclear()} clears Stata's {cmd:r()} stored results.

{p 4 4 2}
{cmd:st_eclear()} clears Stata's {cmd:e()} stored results.

{p 4 4 2}
{cmd:st_sclear()} clears Stata's {cmd:s()} stored results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_rclear()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Returning results in {cmd:r()}, {cmd:e()}, or {cmd:s()} is one way 
of communicating results calculated in Mata back to Stata; 
see {bf:{help m1_ado:[M-1] Ado}}.
See {bf:{help stored_results:[R] Stored results}} for a description of 
{cmd:e()}, {cmd:r()}, and {cmd:s()}.

{p 4 4 2}
Use {cmd:st_rclear()}, {cmd:st_eclear()}, or {cmd:st_sclear()}
to clear results, and then use 
{cmd:st_global()} to define macros, 
{cmd:st_numscalar()} to define scalars, 
and {cmd:st_matrix()} to define Stata matrices in {cmd:r()}, {cmd:e()}, 
or {cmd:s()}.  For example, 

	{cmd:st_rclear()}
	{cmd:st_global("r(name)", "tab")}{...}
{col 50}<- see {bf:{help mf_st_global:[M-5] st_global()}}
	{cmd:st_numscalar("r(N)", n1+n2)}{...}
{col 50}<- see {bf:{help mf_st_numscalar:[M-5] st_numscalar()}}
	{cmd:st_matrix("r(table)", X+Y)}{...}
{col 50}<- see {bf:{help mf_st_matrix:[M-5] st_matrix()}}

{p 4 4 2}
It is not necessary to clear before saving, but it is considered good style
unless it is your intention to add to previously stored results.  

{p 4 4 2}
If a stored result already exists, {cmd:st_global()}, {cmd:st_numscalar()},
and {cmd:st_matrix()} may be used to redefine it and even to redefine it to a
different type.  For instance, continuing with our example, later in the same
code might appear

	{cmd:if (}...{cmd:) {c -(}}
		{cmd:st_matrix("r(name)", X)}
	{cmd:{c )-}}

{p 4 4 2}
Stored result {cmd:r(name)} was previously defined as a macro containing
{cmd:"tab"}, and, even so, can now be redefined to become a matrix.

{p 4 4 2}
If you want to eliminate a particular stored result, use {cmd:st_global()}
to change its contents to {cmd:""}:

	{cmd:st_global("r(name)", "")}

{p 4 4 2}
Do this regardless of the type of the stored result.  Here
we use {cmd:st_global()} to clear stored result {cmd:r(name)}, 
which might be a macro and might be a matrix.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:st_rclear()}, 
{cmd:st_eclear()}, and
{cmd:st_sclear()}
take no arguments and return void.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_rclear()}, 
{cmd:st_eclear()}, and
{cmd:st_sclear()}
cannot fail.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
