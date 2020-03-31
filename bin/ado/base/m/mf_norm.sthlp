{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] norm()" "mansection M-5 norm()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_norm##syntax"}{...}
{viewerjumpto "Description" "mf_norm##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_norm##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_norm##remarks"}{...}
{viewerjumpto "Conformability" "mf_norm##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_norm##diagnostics"}{...}
{viewerjumpto "Source code" "mf_norm##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] norm()} {hline 2}}Matrix and vector norms
{p_end}
{p2col:}({mansection M-5 norm():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real scalar}{bind: }
{cmd:norm(}{it:numeric matrix A}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind: }
{cmd:norm(}{it:numeric matrix A}{cmd:,} {it:real scalar p}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:norm(}{it:A}{cmd:)} returns {cmd:norm(}{it:A}, 2{cmd:)}.

{p 4 4 2}
{cmd:norm(}{it:A}{cmd:,} {it:p}{cmd:)} returns the
value of the norm of {it:A} for the specified {it:p}.  The possible values
and the meaning of {it:p} depend on whether {it:A} is a vector or a matrix.

{p 4 4 2}
When {it:A} is a vector, {cmd:norm(}{it:A}{cmd:,} {it:p}{cmd:)} returns

		{cmd:sum(abs(}{it:A}{cmd:):^}{it:p}{cmd:) ^ (1/}{it:p}{cmd:)}{col 45}if 1 <= {it:p} < {cmd:.}

		{cmd:max(abs(A))}{col 45}if {it:p} >= {cmd:.}
	
{p 4 4 2}
When {it:A} is a matrix, returned is

{col 17}{it:p}{col 26}{cmd:norm(}{it:A}{cmd:,} {it:p}{cmd:)}
{col 17}{hline 31}
{col 17}0{col 26}{cmd:sqrt(trace(conj(}{it:A}{cmd:)'}{it:A}{cmd:))}
{col 17}1{col 26}{cmd:max(colsum(abs(}{it:A}{cmd:)))}
{col 17}2{col 26}{cmd:max(svdsv(}{it:A}{cmd:))}
{col 17}.{col 26}{cmd:max(rowsum(abs(}{it:A}{cmd:)))}
{col 17}{hline 31}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 norm()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:norm(}{it:A}{cmd:)} 
and 
{cmd:norm(}{it:A}{cmd:,} {it:p}{cmd:)} 
calculate vector norms and matrix norms.  {it:A} may be real or complex and
need not be square when it is a matrix.

{p 4 4 2}
The formulas presented above are not the actual ones used in calculation.  In
the vector-norm case when 1 <= {it:p} < {cmd:.}, the formula is applied to
{it:A}{cmd::/max(abs(}{it:A}{cmd:))} and the result then multiplied by
{cmd:max(abs(}{it:A}{cmd:))}.  This prevents numerical overflow.  A similar
technique is used in calculating the matrix norm for {it:p}=0, and that 
technique also avoids storage of {cmd:conj(}{it:A}{cmd:)'}{it:A}.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:norm(}{it:A}{cmd:)}
{p_end}
		{it:A}:  {it:r x c}
    	   {it:result}:  1 {it:x} 1

{p 4 8 2}
{cmd:norm(}{it:A}, {it:p}{cmd:)}
{p_end}
		{it:A}:  {it:r x c}
		{it:p}:  1 {it:x} 1
    	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
   The {cmd:norm()} is defined to return 0 if {it:A} is void and missing 
   if any element of {it:A} is missing.

{p 4 4 2}
   {cmd:norm(}{it:A}, {it:p}{cmd:)} aborts with error if {it:p} is out of
   range.  When {it:A} is a vector, {it:p} must be greater than or equal to
   1.  When {it:A} is a matrix, {it:p} must be 0, 1, 2, or {cmd:.} (missing).

{p 4 4 2}
   {cmd:norm(}{it:A}{cmd:)} and
   {cmd:norm(}{it:A}, {it:p}{cmd:)}
   return missing if the 
   2-norm is requested and the singular
   value decomposition does not converge, an event not expected
   to occur;
   see {bf:{help mf_svd:[M-5] svd()}}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view norm.mata, adopath asis:norm.mata}
{p_end}
