{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] diag()" "mansection M-5 diag()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _diag()" "help mf__diag"}{...}
{vieweralsosee "[M-5] diagonal()" "help mf_diagonal"}{...}
{vieweralsosee "[M-5] isdiagonal()" "help mf_isdiagonal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_diag##syntax"}{...}
{viewerjumpto "Description" "mf_diag##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_diag##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_diag##remarks"}{...}
{viewerjumpto "Conformability" "mf_diag##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_diag##diagnostics"}{...}
{viewerjumpto "Source code" "mf_diag##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] diag()} {hline 2}}Create diagonal matrix
{p_end}
{p2col:}({mansection M-5 diag():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:diag(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:diag(}{it:numeric vector z}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:diag()} creates diagonal matrices.

{p 4 4 2}
{cmd:diag(}{it:Z}{cmd:)}, {it:Z} a matrix, extracts the principal diagonal 
of {it:Z} to create a new matrix.  {it:Z} must be square.

{p 4 4 2}
{cmd:diag(}{it:z}{cmd:)}, {it:z} a vector, creates a new matrix with 
the elements of {it:z} on its diagonal.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 diag()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Do not confuse {cmd:diag()} with its functional inverse, 
{cmd:diagonal()}; see 
{bf:{help mf_diagonal:[M-5] diagonal()}}.
{cmd:diag()} creates a matrix from a vector (or matrix); 
{cmd:diagonal()} extracts the diagonal of a matrix into a vector.

{p 4 4 2}
Use of {cmd:diag()} should be avoided because it wastes memory.
The {help m2_op_colon:colon operators} will allow you to use vectors directly:

		Desired calculation         Equivalent
		{hline 45}
		{cmd:diag(}{it:v}{cmd:)*}{it:X}, 
		     {it:v} a column              {it:v}{cmd::*}{it:X}
		     {it:v} a row                 {it:v}{bf:'}{cmd::*}{it:X}
		     {it:v} a matrix              {cmd:diagonal(}{it:v}{cmd:):*}{it:X}

	        {it:X}{cmd:*diag(}{it:v}{cmd:)}
		     {it:v} a column              {it:X}{cmd::*}{it:v}{bf:'}
		     {it:v} a row                 {it:X}{cmd::*}{it:v}
		     {it:v} a matrix              {it:X}{cmd::*diagonal(}{it:v}){bf:'}
		{hline 45}

{p 4 4 2}
In the above table, it is assumed that {it:v} is real.  If {it:v} might be
complex, the transpose operators that appear must be changed to
{cmd:transposeonly()} calls, because we do not want the conjugate.  For
instance, {it:v}{bf:'}{cmd::*}{it:X} would become
{cmd:transposeonly(}{it:v}{cmd:):*}{it:X}.


{marker conformability}{...}
{title:Conformability}

    {cmd:diag(}{it:Z}{cmd:)}:
		{it:Z}:  {it:m x n}
	   {it:result}:  min({it:m},{it:n}) {it:x} min({it:m},{it:n})

    {cmd:diag(}{it:z}{cmd:)}:
		{it:z}:  {it:1 x n}  or  {it:n x 1}
	   {it:result}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view diag.mata, adopath asis:diag.mata}
{p_end}
