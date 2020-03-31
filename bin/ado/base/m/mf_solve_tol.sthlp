{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] solve_tol()" "mansection M-5 solve_tol()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_solve_tol##syntax"}{...}
{viewerjumpto "Description" "mf_solve_tol##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_solve_tol##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_solve_tol##remarks"}{...}
{viewerjumpto "Conformability" "mf_solve_tol##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_solve_tol##diagnostics"}{...}
{viewerjumpto "Source code" "mf_solve_tol##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] solve_tol()} {hline 2}}Tolerance used by solvers and inverters
{p_end}
{p2col:}({mansection M-5 solve_tol():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:solve_tol(}{it:numeric matrix Z}{cmd:,}
{it:real scalar usertol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:solve_tol(}{it:Z}{cmd:,} {it:usertol}{cmd:)} 
returns the tolerance used by many 
Mata solvers to solve {it:AX}={it:B} and by many Mata inverters to obtain 
{it:A}^(-1).
{it:usertol} is the tolerance specified by the 
user or is missing value if the user did not specify a tolerance.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 solve_tol()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The tolerance used by many Mata solvers to solve {it:AX}={it:B} and 
by many Mata inverters to obtain {it:A}^(-1) is

		{it:eta} = {it:s} * {cmd:trace(abs(}{it:Z}{cmd:))}/{it:n}{right:(1)    }

{p 4 4 2}
where {it:s}=1e-13 or a value specified by the user, {it:n} is the
{cmd:min(rows(}{it:Z}{cmd:), cols(}{it:Z}{cmd:))}, and {it:Z} is a matrix
related to {it:A}, usually by some form of decomposition, but could be {it:A} 
itself (for instance, if {it:A} were triangular).
See, for instance, 
{bf:{help mf_solvelower:[M-5] solvelower()}} and 
{bf:{help mf_cholsolve:[M-5] cholsolve()}}.


{p 4 4 2}
When {it:usertol}>0 and {it:usertol}<{cmd:.} is specified, 
{cmd:solvetol()} returns {it:eta} calculated with {it:s}={it:usertol}.

{p 4 4 2}
When {it:usertol}<=0 is specified, 
{cmd:solvetol()} returns -{it:usertol}.  

{p 4 4 2}
When {it:usertol}>={cmd:.} is specified, 
{cmd:solvetol()} returns a default result, calculated as

{p 8 12 2}
1.  If external real scalar {cmd:_solvetolerance} does not exist, as 
    is usually the case, the value of {it:eta} is returned using 
    {it:s}=1e-13.

{p 8 12 2}
2.  If external real scalar {cmd:_solvetolerance} does exist, 

{p 12 16 2}
a.  If {cmd:_solvetolerance}>0, the value of {it:eta} is returned 
    using {it:s}={cmd:solvetolerance}.

{p 12 16 2}
b.  If {cmd:_solvetolerance}<=0, -{cmd:_solvetolerance} is returned.


{marker conformability}{...}
{title:Conformability}

    {cmd:solve_tol(}{it:Z}{cmd:,} {it:usertol}{cmd:)}:
		{it:Z}:  {it:r x c}
	  {it:usertol}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:solve_tol(}{it:Z}{cmd:,} {it:usertol}{cmd:)} 
skips over missing values in {it:Z} in calculating (1); {it:n} is 
defined as the number of nonmissing elements on the diagonal.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view solve_tol.mata, adopath asis:solve_tol.mata}
{p_end}
