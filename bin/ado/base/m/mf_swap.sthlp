{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] swap()" "mansection M-5 swap()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_swap##syntax"}{...}
{viewerjumpto "Description" "mf_swap##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_swap##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_swap##remarks"}{...}
{viewerjumpto "Conformability" "mf_swap##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_swap##diagnostics"}{...}
{viewerjumpto "Source code" "mf_swap##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] swap()} {hline 2}}Interchange contents of variables
{p_end}
{p2col:}({mansection M-5 swap():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void}
{cmd:swap(}{it:transmorphic matrix A}{cmd:,}
{it:transmorphic matrix B}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:swap(}{it:A}{cmd:,} {it:B}{cmd:)} 
interchanges the contents of {it:A} and {it:B}.  {it:A} and {it:B} 
are not required to be of the same type or dimension.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 swap()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
There is no faster way than {cmd:swap(}{it:A}{cmd:,} {it:B}{cmd:)} to assign
{it:A}{cmd:=}{it:B} when you do not care about the contents of {it:B} after the
assignment.  For instance, you have the code

		{it:A} {cmd:=} {it:B}
		{it:B} {cmd:=} ...{it:(matrix expression)}...

{p 4 4 2}
Faster is

		{cmd:swap(}{it:A}{cmd:,} {it:B}{cmd:)} 
		{it:B} {cmd:=} ...{it:(matrix expression)}...

{p 4 4 2}
The execution time of {cmd:swap()} is independent of the size of {it:A} and
{it:B}, and {cmd:swap()} conserves memory to boot.  Pretend that {it:B} is a 900
{it:x} 900 matrix.  {it:A}{cmd:=}{it:B} is executed, but before {it:B} is
reassigned, two copies of the 900 {it:x} 900 matrix exist.  That does not 
happen with {cmd:swap()}.


{marker conformability}{...}
{title:Conformability}

    {cmd:swap(}{it:A}{cmd:,} {it:B}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r1 x c1}
		{it:B}:  {it:r2 x c2}
	{it:output}
		{it:A}:  {it:r2 x c2}
		{it:B}:  {it:r1 x c1}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:swap(}{it:A}{cmd:,} {it:B}{cmd:)} works only with variables.  Do not
code, for instance, {cmd:swap(}{it:A}{cmd:[}{it:i}{cmd:,}{it:j}{cmd:],}
{it:A}{cmd:[}{it:j}{cmd:,}{it:i}{cmd:])}.  It is not an error, but
it will have no effect.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
