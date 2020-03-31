{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] issymmetric()" "mansection M-5 issymmetric()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] makesymmetric()" "help mf_makesymmetric"}{...}
{vieweralsosee "[M-5] reldif()" "help mf_reldif"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_issymmetric##syntax"}{...}
{viewerjumpto "Description" "mf_issymmetric##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_issymmetric##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_issymmetric##remarks"}{...}
{viewerjumpto "Conformability" "mf_issymmetric##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_issymmetric##diagnostics"}{...}
{viewerjumpto "Source code" "mf_issymmetric##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] issymmetric()} {hline 2}}Whether matrix is symmetric (Hermitian)
{p_end}
{p2col:}({mansection M-5 issymmetric():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:issymmetric(}{it:transmorphic matrix A}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:issymmetriconly(}{it:transmorphic matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:issymmetric(}{it:A}{cmd:)} returns 1 if {it:A}=={it:A}{bf:'} and 
returns 0 otherwise.  (Also see {cmd:mreldifsym()} in
{bf:{help mf_reldif:[M-5] reldif()}}).

{p 4 4 2}
{cmd:issymmetriconly(}{it:A}{cmd:)} returns 1 if 
{it:A}=={bf:transposeonly(}{it:A}{cmd:)} and returns 0
otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 issymmetric()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:issymmetric(}{it:A}{cmd:)} and 
{cmd:issymmetriconly(}{it:A}{cmd:)} 
return the same result except when {it:A} is complex.  

{p 4 4 2}
In the complex case, {cmd:issymmetric(}{it:A}{cmd:)} returns 1 if 
{it:A} is equal to its conjugate transpose, that is, if {it:A} is 
Hermitian,  which is the complex analog of symmetric.  
{it:A} is symmetric (Hermitian) if its off-diagonal elements are 
conjugates of each other and its diagonal elements are real.

{p 4 4 2}
{cmd:issymmetriconly(}{it:A}{cmd:)}, on the other hand, 
uses the mechanical definition of symmetry:  {it:A} is symmetriconly
[{it:sic}] if its off-diagonal elements are equal.  
{cmd:issymmetriconly()} is uninteresting, mathematically speaking, but can be
useful in certain data-management programming situations.


{marker conformability}{...}
{title:Conformability}

    {cmd:issymmetric(}{it:A}{cmd:)}, {cmd:issymmetriconly(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:issymmetric(}{it:A}{cmd:)} returns 0 
if {it:A} is not square.  
If {it:A} is 0 {it:x} 0, it is symmetric.

{p 4 4 2}
{cmd:issymmetriconly(}{it:A}{cmd:)} returns 0 
if {it:A} is not square.  
If {it:A} is 0 {it:x} 0, it is symmetriconly.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
