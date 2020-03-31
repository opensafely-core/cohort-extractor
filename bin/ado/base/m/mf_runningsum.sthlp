{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] runningsum()" "mansection M-5 runningsum()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] sum()" "help mf_sum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_runningsum##syntax"}{...}
{viewerjumpto "Description" "mf_runningsum##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_runningsum##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_runningsum##remarks"}{...}
{viewerjumpto "Conformability" "mf_runningsum##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_runningsum##diagnostics"}{...}
{viewerjumpto "Source code" "mf_runningsum##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] runningsum()} {hline 2}}Running sum of vector
{p_end}
{p2col:}({mansection M-5 runningsum():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric vector}{bind:    }
{cmd:runningsum(}{it:numeric vector x}
[{cmd:,} {it:missing}]{cmd:)}

{p 8 12 2}
{it:numeric vector} 
{cmd:quadrunningsum(}{it:numeric vector x}
[{cmd:,} {it:missing}]{cmd:)}


{p 8 12 2}
{it:void}{bind:             }
{cmd:_runningsum(}{it:y}{cmd:,} {it:numeric vector x}
[{cmd:,} {it:missing}]{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_quadrunningsum(}{it:y}{cmd:,} {it:numeric vector x}
[{cmd:,} {it:missing}]{cmd:)}


{p 4 4 2}
where optional argument {it:missing} is a {it:real scalar} that determines how
missing values in {it:x} are treated:

{p 8 12 2}
    1.  Specifying {it:missing} as 0 is equivalent to not specifying the
        argument; missing values in {it:x} are treated as contributing 0 to
        the sum.

{p 8 12 2}
    2.  Specifying {it:missing} as 1 specifies that missing values in {it:x}
        are to be treated as missing values and turn the sum to missing.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:runningsum(}{it:x}{cmd:)} returns a vector of the same dimension as
{it:x} containing the running sum of {it:x}.  Missing values are treated as
contributing zero to the sum.

{p 4 4 2}
{cmd:runningsum(}{it:x}{cmd:,} {it:missing}{cmd:)} does the same but lets you
specify how missing values are treated.  {cmd:runningsum(}{it:x}{cmd:, 0)} is
the same as {cmd:runningsum(}{it:x}{cmd:)}.  {cmd:runningsum(}{it:x}{cmd:, 1)}
specifies that missing values are to turn the sum to missing where they occur.

{p 4 4 2}
{cmd:quadrunningsum(}{it:x}{cmd:)} and
{cmd:quadrunningsum(}{it:x}{cmd:,} {it:missing}{cmd:)}
do the same but perform the accumulation in quad precision.

{p 4 4 2}
{cmd:_runningsum(}{it:y}{cmd:,} {it:x} [{cmd:,} {it:missing}]{cmd:)}
and 
{cmd:_quadrunningsum(}{it:y}{cmd:,} {it:x} [{cmd:,} {it:missing}]{cmd:)}
work the same way, except that rather than returning the running-sum vector, 
they store the result in {it:y}.  This method is slightly more efficient when 
{it:y} is a view.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 runningsum()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The running sum of (1, 2, 3) is (1, 3, 6).

{p 4 4 2}
All functions return the same type as the argument, real if argument is real,
complex if complex.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:runningsum(}{it:x}{cmd:,} {it:missing}{cmd:)}, 
{cmd:quadrunningsum(}{it:x}{cmd:,} {it:missing}{cmd:)}:
{p_end}
		{it:x}:  {it:r x} 1  or  1 {it:x} c
	  {it:missing}:  1 {it:x} 1                (optional)
	   {it:result}:  {it:r x} 1  or  1 {it:x} c

{p 4 4 2}
{cmd:_runningsum(}{it:y}{cmd:, }{it:x}{cmd:,} {it:missing}{cmd:)}, 
{cmd:_quadrunningsum(}{it:y}{cmd:, }{it:x}{cmd:,} {it:missing}{cmd:)}:
{p_end}
	{it:input:}
		{it:x}:  {it:r x} 1  or  1 {it:x} c
		{it:y}   {it:r x} 1  or  1 {it:x} c     (contents irrelevant)
	  {it:missing}:  1 {it:x} 1                (optional)
	{it:output:}
	        {it:y}:  {it:r x} 1  or  1 {it:x} c


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
If {it:missing} = 0,
missing values are treated as contributing zero to the sum; they do 
not turn the sum to missing.  Otherwise, missing values turn the sum to
missing.

{p 4 4 2}
{cmd:_runningsum(}{it:y}{cmd:, }{it:x}{cmd:,} {it:missing}{cmd:)}
and 
{cmd:_quadrunningsum(}{it:y}{cmd:, }{it:x}{cmd:,} {it:missing}{cmd:)}
abort with error if {it:y} is not
{help m6_glossary##p-conformability:p-conformable} with {it:x} and of 
the same {help m6_glossary##type:eltype}.  The contents of {it:y} are
irrelevant.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
