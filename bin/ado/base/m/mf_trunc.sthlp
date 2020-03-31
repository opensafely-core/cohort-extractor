{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] trunc()" "mansection M-5 trunc()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_trunc##syntax"}{...}
{viewerjumpto "Description" "mf_trunc##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_trunc##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_trunc##remarks"}{...}
{viewerjumpto "Conformability" "mf_trunc##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_trunc##diagnostics"}{...}
{viewerjumpto "Source code" "mf_trunc##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] trunc()} {hline 2}}Round to integer
{p_end}
{p2col:}({mansection M-5 trunc():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} {cmd:trunc(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real matrix} {cmd:floor(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:  }{cmd:ceil(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real matrix} {cmd:round(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real matrix} {cmd:round(}{it:real matrix R}{cmd:,} {it:real matrix U}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
    These functions convert noninteger values to integers by moving
    toward 0, moving down, moving up, or rounding.  These functions are
    typically used with scalar arguments, and they return a scalar in that
    case.  When used with vectors or matrices, the operation is performed
    element by element.

{p 4 4 2}
    {cmd:trunc(}{it:R}{cmd:)} returns the integer part of {it:R}.

{p 4 4 2}
    {cmd:floor(}{it:R}{cmd:)} returns the largest integer {it:i} such that 
    {it:i} <= {it:R}.

{p 4 4 2}
    {cmd:ceil(}{it:R}{cmd:)} returns the smallest integer {it:i} such that 
    {it:i} >= {it:R}.

{p 4 4 2}
    {cmd:round(}{it:R}{cmd:)} returns the integer closest to {it:R}.

{p 4 4 2}
    {cmd:round(}{it:R}{cmd:,} {it:U}{cmd:)} returns the values of {it:R} 
    rounded in units of {it:U} and is equivalent to 
    {cmd:round(}({it:R}:/{it:U}){cmd:):*}{it:U}.
    For instance, {cmd:round(}{it:R}{cmd:,} 2{cmd:)} returns {it:R} rounded
    to the closest even number. 
    {cmd:round(}{it:R}{cmd:,} .5{cmd:)} returns {it:R} rounded to the 
    closest multiple of one half.  
    {cmd:round(}{it:R}{cmd:,} 1{cmd:)} returns {it:R} rounded to the 
    closest integer and so is equivalent to {cmd:round(}{it:R}{cmd:)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 trunc()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_trunc##remarks1:Relationship to Stata's functions}
	{help mf_trunc##remarks2:Examples of rounding}


{marker remarks1}{...}
{title:Relationship to Stata's functions}

{p 4 4 2}
    {cmd:trunc()} is equivalent to Stata's {helpb int()} function.

{p 4 4 2}
    {helpb floor()}, {helpb ceil()}, and {helpb round()} are equivalent to 
    Stata's functions of the same name.


{marker remarks2}{...}
{title:Examples of rounding}

 	  {it:x}     {cmd:trunc(}{it:x}{cmd:)}     {cmd:floor(}{it:x}{cmd:)}     {cmd:ceil(}{it:x}{cmd:)}    {cmd:round(}{it:x}{cmd:)}
	{hline 53}
  	 1         1            1           1           1
  	 1.3       1            1           2           1
  	 1.6       1            1           2           2
 	-1        -1           -1          -1          -1
 	-1.3      -1           -2          -1          -1
 	-1.6      -1           -2          -1          -2
	{hline 53}


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:trunc(}{it:R}{cmd:)},
{cmd:floor(}{it:R}{cmd:)},
{cmd:ceil(}{it:R}{cmd:)}:
{p_end}
		{it:R}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:round(}{it:R}{cmd:)}:
		{it:R}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:round(}{it:R}{cmd:,} {it:U}{cmd:)}:
		{it:R}:  {it:r1 x c1}
		{it:U}:  {it:r2 x c2}, {it:R} and {it:U} r-conformable
	   {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    Most Stata and Mata functions return missing when arguments contain
    missing, and in particular, return {cmd:.} whether the argument is
    {cmd:.}, {cmd:.a}, {cmd:.b}, ..., {cmd:.z}.  The logic is that 
    performing the operation on a missing value always results in the 
    same missing-value result.  For example, {cmd:sqrt(.a)==.}

{p 4 4 2}
    These functions, however, when passed a missing value, return 
    the particular missing value.  Thus {cmd:trunc(.a)==.a}, 
    {cmd:floor(.b)==.b}, {cmd:ceil(.c)==.c}, and {cmd:round(.d)==.d}.

{p 4 4 2}
    For {cmd:round()} with two arguments, this applies to 
    the first argument and only when the second argument is not missing.
    If the second argument is missing (whether {cmd:.}, {cmd:.a}, ..., 
    or {cmd:.z}), then {cmd:.} is returned.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
