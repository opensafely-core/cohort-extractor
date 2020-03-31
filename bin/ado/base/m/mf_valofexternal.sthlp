{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] valofexternal()" "mansection M-5 valofexternal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] findexternal()" "help mf_findexternal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_valofexternal##syntax"}{...}
{viewerjumpto "Description" "mf_valofexternal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_valofexternal##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_valofexternal##remarks"}{...}
{viewerjumpto "Conformability" "mf_valofexternal##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_valofexternal##diagnostics"}{...}
{viewerjumpto "Source code" "mf_valofexternal##source"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[M-5] valofexternal()} {hline 2}}Obtain value of external global
{p_end}
{p2col:}({mansection M-5 valofexternal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:transmorphic matrix}
{cmd:valofexternal(}{it:string scalar name}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:valofexternal(}{it:name}{cmd:)} returns the contents of the
external global matrix, vector, or scalar whose name is specified by
{it:name}; it returns {helpb mf_j##void_matrices:J(0,0,.)} if the external
global is not found.

{p 4 4 2}
Also see {it:{help m2_declarations##remarks10:Linking to external globals}} in 
{bf:{help m2_declarations:[M-2] Declarations}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 valofexternal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Also see {bf:{help mf_findexternal:[M-5] findexternal()}}.  Rather than
returning a pointer to the external global, as does {cmd:findexternal()},
{cmd:valofexternal()} returns the contents of the external global.  This
is useful when the external global contains a scalar:

	{cmd:tol = valofexternal("tolerance")}
	{cmd:if (tol==J(0,0,.)) tol = 1e-6}

{p 4 4 2}
Using {cmd:findexternal()}, one alternative would be

	{cmd}if ((p = findexternal("tolerance"))==NULL) tol = 1e-6
	else tol = *p{txt}

{p 4 4 2}
For efficiency reasons, use of {cmd:valofexternal()} should be avoided 
with nonscalar objects; see {bf:{help mf_findexternal:[M-5] findexternal()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:valofexternal(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:r x c}  or  0 {it:x} 0 if not found


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:valofexternal()} aborts with error if {it:name} contains an invalid name.

{p 4 4 2}
{cmd:valofexternal(}{it:name}{cmd:)} returns {cmd:J(0,0,.)} if {it:name} does
not exist.


{marker source}{...}
{title:Source code}

{pstd}Function is built in.
{p_end}
