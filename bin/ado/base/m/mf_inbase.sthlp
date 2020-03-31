{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-5] inbase()" "mansection M-5 inbase()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_inbase##syntax"}{...}
{viewerjumpto "Description" "mf_inbase##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_inbase##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_inbase##remarks"}{...}
{viewerjumpto "Conformability" "mf_inbase##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_inbase##diagnostics"}{...}
{viewerjumpto "Source code" "mf_inbase##source"}{...}
{viewerjumpto "Reference" "mf_inbase##reference"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] inbase()} {hline 2}}Base conversion
{p_end}
{p2col:}({mansection M-5 inbase():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 31 2}
{it:string matrix}{bind:  }
{cmd:inbase(}{it:real scalar base}{cmd:,}
{it:real matrix x}
[{cmd:,}{break}{it:real scalar fdigits}
[{cmd:,} {it:err}]]{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:  }
{cmd:frombase(}{it:real scalar base}{cmd:,}
{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:)} returns a string matrix 
containing the values of {it:x} in base {it:base}.

{p 4 4 2}
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:)} does the 
same; {it:fdigits} specifies the maximum number of digits to the right 
of the base point to appear in the returned result when {it:x} has a 
fractional part.  
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:)} is equivalent to 
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:, 8)}.

{p 4 4 2}
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:,} {it:err}{cmd:)}
is the same as 
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:)}, except
that it returns in {it:err} the difference between {it:x} and the converted 
result.

{p 4 4 2}
{it:x} = {cmd:frombase(}{it:base}{cmd:,} {it:s}{cmd:)} is the inverse of 
{it:s} = {cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:)}.
It returns base {it:base} number {it:s} as a number.
We are tempted to say, "as a number in base 10", but that is not exactly 
true.  It returns the result as a {it:real}, that is, as an 
IEEE base-2 double-precision float that, when you display it, is displayed
in base 10.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 inbase()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_inbase##remarks1:Positive integers}
	{help mf_inbase##remarks2:Negative integers}
	{help mf_inbase##remarks3:Numbers with nonzero fractional parts}
	{help mf_inbase##remarks4:Use of the functions}


{marker remarks1}{...}
{title:Positive integers}

{p 4 4 2}
{cmd:inbase(2, 1691)} is {cmd:11010011011}; that is, 1691 base 10 equals 
11010011011 base 2.  {cmd:frombase(2, "11010011011")} is 1691.

{p 4 4 2}
{cmd:inbase(3, 1691)} is {cmd:2022122}; that is, 1691 base 10 equals
2022122 base 3.  {cmd:frombase(3, "2022122")} is 1691.

{p 4 4 2}
{cmd:inbase(16, 1691)} is {cmd:69b}; that is, 1691 base 10 equals 1691
base 16.  {cmd:frombase(16, "69b")} is 1691.  (The base-16 digits are 0, 1, 2,
3, 4, 5, 6, 7, 8, 9, a, b, c, d, e, f.)

{p 4 4 2}
{cmd:inbase(62, 1691)} is {cmd:rh}; that is, 1691 base 10 equals rh
base 62.  {cmd:frombase(62, "rh")} is 1691.  (The base-62 digits are 0, 1, 2,
3, 4, 5, 6, 7, 8, 9, a, b, ..., z, A, B, ..., Z.)

{p 4 4 2}
There is a one-to-one correspondence between the integers in different 
bases.  The error of the conversion is always zero.


{marker remarks2}
{title:Negative integers}

{p 4 4 2}
Negative integers are no different from positive integers.  For instance,
{cmd:inbase(2, -1691)} is {cmd:-11010011011}; that is, -1691 base 10
equals -11010011011 base 2.  {cmd:frombase(2, "-11010011011")} is -1691.

{p 4 4 2}
The error of the conversion is always zero.


{marker remarks3}
{title:Numbers with nonzero fractional parts}

{p 4 4 2}
{cmd:inbase(2, 3.5)} is {cmd:11.1}; that is, 3.5 base 10 equals 11.1
base 2.  {cmd:frombase(2, "11.1")} is 3.5.

{p 4 4 2}
{cmd:inbase(3, 3.5)} is {cmd:10.11111111}.

{p 4 4 2}
{cmd:inbase(3, 3.5, 20)} is {cmd:10.11111111111111111111}.

{p 4 4 2}
{cmd:inbase(3, 3.5, 30)} is {cmd:10.111111111111111111111111111111}.

{p 4 4 2}
Therefore, 3.5 base 10 equals 1.1111... in base 3.  There is 
no exact representation of one-half in base 3.  The errors of the 
above three conversions are .0000762079, 1.433399e-10, and 2.45650e-15.
Those are the values that would be returned in {it:err}
if {cmd:inbase(3, 3.5,} {it:fdigits}{cmd:,} {it:err}{cmd:)} were coded.

{p 4 4 2}
{cmd:frombase(3, "10.11111111")} is {cmd:3.499923792}.

{p 4 4 2}
{cmd:frombase(3, "10.11111111111111111111")} is {cmd:3.4999999998566}.

{p 4 4 2}
{cmd:frombase(3, "10.111111111111111111111111111111")} is
{cmd:3.49999999999999734}.

{p 4 4 2}
{cmd:inbase(16, 3.5)} is {cmd:3.8}; that is, 3.5 base 10 equals 3.8
base 16.  The error is zero.  {cmd:frombase(16, "3.8")} is 3.5.

{p 4 4 2}
{cmd:inbase(62, 3.5)} is {cmd:3.v}; that is, 3.5 base 10 equals 
3.v base 62.
{cmd:frombase(62, "3.v")} is 3.5.  The error is zero.

{p 4 4 2}
In {cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:)},
{it:fdigits} specifies the maximum number of digits to appear to the right of
the base point.  {it:fdigits} is required to be greater than or equal to 1.
{cmd:inbase(16, 3.5,} {it:fdigits}{cmd:)} will be {cmd:3.8} regardless of
the value of {it:fdigits} because more digits are unnecessary.

{p 4 4 2}
The error that is returned in 
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:,} {it:err}{cmd:)}
can be an understatement.  For instance, {cmd:inbase(16, .1, 14,}
{it:err}{cmd:)} is {cmd:0.1999999999999a} and returned in {it:err} is 0
even though there is no finite-digit representation of 0.1 base 10 in base 16.
That is because the {cmd:.1} you specified in the call was not 
actually 0.1 base 10.  The computer that you are using is binary, and 
it converted the {cmd:.1} you typed to 

{center:0.00011001100110011001100110011001100110011001100110011010 base 2}

{p 4 4 2}
before {cmd:inbase()} was ever called.
0.1999999999999a base 16 is an exact representation of that number.


{marker remarks4}
{title:Use of the functions}

{p 4 4 2}
These functions are used mainly for teaching, especially on the sources 
and avoidance of roundoff error; see {help mf_inbase##G2006:Gould (2006)}.

{p 4 4 2}
The functions can have a use in data processing, however, when used with 
integer arguments.  You have a dataset with 10-digit identification
numbers.  You wish to record the 10-digit number, but more densely.
You could convert the number to base 62.  The largest 10-digit 
ID number possible is 9999999999, or aUKYOz base 62.  You can record 
the ID numbers in a six-character string by using {cmd:inbase()}.  If you 
needed the original numbers back, you could use {cmd:frombase()}.

{p 4 4 2}
In a similar way, 
Stata internally uses base 36 for naming temporary files, 
and that was important when filenames were limited to 
eight characters.  Base 36 allows Stata to generate up to 2,821,109,907,455
filenames before wrapping of filenames occurs.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:,} {it:err}{cmd:)}:
{p_end}
        {it:input:}
	     {it:base}:  1 {it:x} 1
		{it:x}:  {it:r x c}
	  {it:fdigits}:  1 {it:x} 1                (optional)
        {it:output:}
	      {it:err}:  {it:r x c}                (optional)
	   {it:result}:  {it:r x c}

    {cmd:frombase(}{it:base}{cmd:,} {it:s}{cmd:)}:
	     {it:base}:  1 {it:x} 1
		{it:s}:  {it:r x c}
	   {it:result}:  {it:r x c}
		

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The digits used by {cmd:inbase()}/{cmd:frombase()} to encode/decode 
results are

         {it:0} {cmd:0}    {it:10} {cmd:a}    {it:20} {cmd:k}    {it:30} {cmd:u}    {it:40} {cmd:E}    {it:50} {cmd:O}    {it:60} {cmd:Y}
         {it:1} {cmd:1}    {it:11} {cmd:b}    {it:21} {cmd:l}    {it:31} {cmd:v}    {it:41} {cmd:F}    {it:51} {cmd:P}    {it:61} {cmd:Z}
         {it:2} {cmd:2}    {it:12} {cmd:c}    {it:22} {cmd:m}    {it:32} {cmd:w}    {it:42} {cmd:G}    {it:52} {cmd:Q} 
         {it:3} {cmd:3}    {it:13} {cmd:d}    {it:23} {cmd:n}    {it:33} {cmd:x}    {it:43} {cmd:H}    {it:53} {cmd:R}
         {it:4} {cmd:4}    {it:14} {cmd:e}    {it:24} {cmd:o}    {it:34} {cmd:y}    {it:44} {cmd:I}    {it:54} {cmd:S}
         {it:5} {cmd:5}    {it:15} {cmd:f}    {it:25} {cmd:p}    {it:35} {cmd:z}    {it:45} {cmd:J}    {it:55} {cmd:T}
         {it:6} {cmd:6}    {it:16} {cmd:g}    {it:26} {cmd:q}    {it:36} {cmd:A}    {it:46} {cmd:K}    {it:56} {cmd:U}
	 {it:7} {cmd:7}    {it:17} {cmd:h}    {it:27} {cmd:r}    {it:37} {cmd:B}    {it:47} {cmd:L}    {it:57} {cmd:V}
         {it:8} {cmd:8}    {it:18} {cmd:i}    {it:28} {cmd:s}    {it:38} {cmd:C}    {it:48} {cmd:M}    {it:58} {cmd:W}
         {it:9} {cmd:9}    {it:19} {cmd:j}    {it:29} {cmd:t}    {it:39} {cmd:D}    {it:49} {cmd:N}    {it:59} {cmd:X}

{p 4 4 2}
When {it:base}<=36, {cmd:frombase()} treats {cmd:A}, {cmd:B}, {cmd:C}, ..., 
as if they were {cmd:a}, {cmd:b}, {cmd:c}, ....

{p 4 4 2}
{cmd:inbase(}{it:base}{cmd:,} {it:x}{cmd:,} {it:fdigits}{cmd:,} {it:err}{cmd:)}
returns {cmd:.} (missing) if {it:base}<2, {it:base}>62, {it:base} is not an
integer, or {it:x} is missing.  If {it:fdigits} is less than 1 or {it:fdigits}
is missing, results are as if {it:fdigits}=8 were specified.

{p 4 4 2}
{cmd:frombase(}{it:base}{cmd:,} {it:s}{cmd:)}
returns {cmd:.} (missing) if 
{it:base}<2, {it:base}>62, {it:base} is not an integer,
or {it:s} is missing; if {it:s} is not a valid base {it:base} number;
or if the converted value of {it:s} is greater than 8.988e+307 in 
absolute value.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view inbase.mata, adopath asis:inbase.mata}, 
{view frombase.mata, adopath asis:frombase.mata}


{marker reference}{...}
{title:Reference}

{marker G2006}{...}
{p 4 8 2}
Gould, W. W. 2006.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0025":Mata Matters: Precision}.
{it:Stata Journal} 6: 550-560.
{p_end}
