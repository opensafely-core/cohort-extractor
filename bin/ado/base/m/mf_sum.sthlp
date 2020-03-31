{smcl}
{* *! version 1.2.6  15may2018}{...}
{vieweralsosee "[M-5] sum()" "mansection M-5 sum()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cross()" "help mf_cross"}{...}
{vieweralsosee "[M-5] mean()" "help mf_mean"}{...}
{vieweralsosee "[M-5] runningsum()" "help mf_runningsum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_sum##syntax"}{...}
{viewerjumpto "Description" "mf_sum##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_sum##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_sum##remarks"}{...}
{viewerjumpto "Conformability" "mf_sum##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_sum##diagnostics"}{...}
{viewerjumpto "Source code" "mf_sum##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] sum()} {hline 2}}Sums
{p_end}
{p2col:}({mansection M-5 sum():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric colvector} 
{cmd:rowsum(}{it:numeric matrix Z}
[{cmd:,} {it:missing}]{cmd:)}

{p 8 12 2}
{it:numeric rowvector} 
{cmd:colsum(}{it:numeric matrix Z}
[{cmd:,} {it:missing}]{cmd:)}

{p 8 12 2}
{it:numeric scalar}{bind:      }
{cmd:sum(}{it:numeric matrix Z}
[{cmd:,} {it:missing}]{cmd:)}


{p 8 12 2}
{it:numeric colvector} 
{cmd:quadrowsum(}{it:numeric matrix Z}
[{cmd:,} {it:missing}]{cmd:)}

{p 8 12 2}
{it:numeric rowvector} 
{cmd:quadcolsum(}{it:numeric matrix Z}
[{cmd:,} {it:missing}]{cmd:)}

{p 8 12 2}
{it:numeric scalar}{bind:      }
{cmd:quadsum(}{it:numeric matrix Z}
[{cmd:,} {it:missing}]{cmd:)}

{p 4 4 2}
where optional argument {it:missing} is a {it:real scalar} that determines how
missing values in {it:Z} are treated:

{p 8 12 2}
    1.  Specifying {it:missing} as 0 is equivalent to not specifying the
        argument; missing values in {it:Z} are treated as contributing 0 to
        the sum.

{p 8 12 2}
    2.  Specifying {it:missing} as 1 (or nonzero) specifies that missing
    values in {it:Z} are to be treated as missing values and to turn the sum
    to missing.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:rowsum(}{it:Z}{cmd:)} 
and
{cmd:rowsum(}{it:Z}{cmd:,} {it:missing}{cmd:)} 
return a column vector containing the 
sum over the rows of {it:Z}.

{p 4 4 2}
{cmd:colsum(}{it:Z}{cmd:)} 
and
{cmd:colsum(}{it:Z}{cmd:,} {it:missing}{cmd:)} 
return a row vector containing the 
sum over the columns of {it:Z}.

{p 4 4 2}
{cmd:sum(}{it:Z}{cmd:)} 
and
{cmd:sum(}{it:Z}{cmd:,} {it:missing}{cmd:)} 
return a scalar containing the 
sum over the rows and columns of {it:Z}.

{p 4 4 2}
{cmd:quadrowsum()}, 
{cmd:quadcolsum()}, and 
{cmd:quadsum()} are quad-precision variants of 
the above functions.
The sum is accumulated in quad precision and then rounded
to double precision and returned.

{p 4 4 2}
Argument {it:missing} determines how missing values are treated.  If missing
is not specified, results are the same as if {it:missing}=0 were specified:
missing values are treated as zero.  If {it:missing}=1 is specified, missing
values are treated as missing values.

{p 4 4 2}
These functions may be used with real or complex matrix {it:Z}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 sum()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
All functions return the same type as the argument, real if argument is real,
complex if complex.


{marker conformability}{...}
{title:Conformability}

    {cmd:rowsum(}{it:Z}{cmd:,} {it:missing}{cmd:)}, {cmd:quadrowsum(}{it:Z}{cmd:,} {it:missing}{cmd:)}:
		{it:Z}:  {it:r x c}
	  {it:missing}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:r x} 1

    {cmd:colsum(}{it:Z}{cmd:,} {it:missing}{cmd:)}, {cmd:quadcolsum(}{it:Z}{cmd:,} {it:missing}{cmd:)}:
		{it:Z}:  {it:r x c}
	  {it:missing}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x c}

    {cmd:sum(}{it:Z}{cmd:,} {it:missing}{cmd:)}, {cmd:quadsum(}{it:Z}{cmd:,} {it:missing}{cmd:)}:
		{it:Z}:  {it:r x c}
	  {it:missing}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
If {it:missing}=0,
missing values are treated as contributing zero to the sum; they do 
not turn the sum to missing.  Otherwise, missing values turn the sum to
missing.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
