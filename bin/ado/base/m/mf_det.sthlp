{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] det()" "mansection M-5 det()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] lud()" "help mf_lud"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_det##syntax"}{...}
{viewerjumpto "Description" "mf_det##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_det##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_det##remarks"}{...}
{viewerjumpto "Conformability" "mf_det##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_det##diagnostics"}{...}
{viewerjumpto "Source code" "mf_det##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] det()} {hline 2}}Determinant of matrix
{p_end}
{p2col:}({mansection M-5 det():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric scalar} 
{cmd:det(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:numeric scalar} 
{cmd:dettriangular(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:det(}{it:A}{cmd:)} returns the determinant of {it:A}.

{p 4 4 2}
{cmd:dettriangular(}{it:A}{cmd:)} returns the determinant of {it:A},
treating {it:A} as if it were triangular (even if it is not).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 det()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Calculation of the determinant is made by obtaining the LU decomposition of 
{it:A} and then calculating the determinant of {it:U}:

		det({it:A}) = det({it:PLU})
		       = det({it:P})*det({it:L})*det({it:U})
		       = (+/-1)*1*det({it:U})
		       = +/-det({it:U})

{p 4 4 2}
Since {it:U} is (upper) triangular, det({it:U}) is simply the product of its 
diagonal elements.
See {bf:{help mf_lud:[M-5] lud()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:det(}{it:A}{cmd:)}, {cmd:dettriangular(}{it:A}{cmd:)}:
		{it:A}:  {it:n x n}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {cmd:det(}{it:A}{cmd:)} and 
    {cmd:dettriangular(}{it:A}{cmd:)} 
    return 1 if {it:A} is 0 {it:x} 0.

{p 4 4 2}
    {cmd:det(}{it:A}{cmd:)} aborts with error if {it:A} is not square
    and returns missing if {it:A} contains missing values.
    
{p 4 4 2}
    {cmd:dettriangular(}{it:A}{cmd:)} aborts with error if {it:A} is not 
    square and returns missing if any element on the diagonal of {it:A} 
    is missing.

{p 4 4 2}
    Both 
    {cmd:det(}{it:A}{cmd:)} and 
    {cmd:dettriangular(}{it:A}{cmd:)} 
    will return missing value if the determinant exceeds 8.99e+307.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view det.mata, adopath asis:det.mata},
{view dettriangular.mata, adopath asis:dettriangular.mata}
{p_end}
