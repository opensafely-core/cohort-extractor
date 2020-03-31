{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5]  mindouble()" "mansection M-5  mindouble()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] epsilon()" "help mf_epsilon"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_mindouble##syntax"}{...}
{viewerjumpto "Description" "mf_mindouble##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_mindouble##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_mindouble##remarks"}{...}
{viewerjumpto "Conformability" "mf_mindouble##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_mindouble##diagnostics"}{...}
{viewerjumpto "Source code" "mf_mindouble##source"}{...}
{viewerjumpto "Reference" "mf_mindouble##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] mindouble()} {hline 2}}Minimum and maximum nonmissing value
{p_end}
{p2col:}({mansection M-5 mindouble():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real scalar}
{cmd:mindouble()}

{p 8 8 2}
{it:real scalar}
{cmd:maxdouble()}

{p 8 8 2}
{it:real scalar}
{cmd:smallestdouble()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mindouble()} returns the largest negative, nonmissing value.

{p 4 4 2}
{cmd:maxdouble()} returns the largest positive, nonmissing value.

{p 4 4 2}
{cmd:smallestdouble()} returns the smallest full-precision value of {it:e},
{it:e}>0.  The largest full-precision value of {it:e}, {it:e}<0 is
{cmd:-smallestdouble()}.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 mindouble()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
All nonmissing values {it:x} fulfill 

	{cmd:mindouble()} <= {it:x} <= {cmd:maxdouble()}.

{p 4 4 2}
All missing values {it:m} fulfill

	{it:m} > {cmd:maxdouble()}

{p 4 4 2}
Missing values also fulfill 

	{it:m} >= {cmd:.}

{p 4 4 2}
On all computers on which Stata and Mata are currently implemented -- 
which are computers following IEEE standards -- 

                                 Exact                  Approximate
	Function             hexadecimal value         decimal value
	{hline 60}
	{cmd:mindouble()}        -1.fffffffffffffX+3ff        -1.7977e+308
	{cmd:smallestdouble()}   +1.0000000000000X-3fe         2.2251e-308
	{cmd:epsilon(1)}         +1.0000000000000X-034         2.2205e-016
	{cmd:maxdouble()}        +1.fffffffffffffX+3fe         8.9885e+307
	{hline 60}

{p 4 4 2}
The smallest missing value ({cmd:.} < {cmd:.a} < ... < {cmd:.z})
is +1.0000000000000X+3ff.

{p 4 4 2}
Do not confuse {cmd:smallestdouble()} with the more interesting value 
{cmd:epsilon(1)}.  {cmd:smallestdouble()} is the smallest full-precision value of {it:e},
{it:e}>0.  {cmd:epsilon(1)} is the smallest value of {it:e}, {it:e}+1>1;
see {bf:{help mf_epsilon:[M-5] epsilon()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:mindouble()}, {cmd:maxdouble()}, {cmd:smallestdouble()}:
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Linhart, J. M. 2008.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0038":Mata Matters: Overflow, underflow and the IEEE floating-point format}.
{it:Stata Journal} 8: 255-268.
{p_end}
