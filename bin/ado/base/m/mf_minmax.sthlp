{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] minmax()" "mansection M-5 minmax()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] minindex()" "help mf_minindex"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_minmax##syntax"}{...}
{viewerjumpto "Description" "mf_minmax##description"}{...}
{viewerjumpto "Conformability" "mf_minmax##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_minmax##diagnostics"}{...}
{viewerjumpto "Source code" "mf_minmax##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] minmax()} {hline 2}}Minimums and maximums
{p_end}
{p2col:}({mansection M-5 minmax():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real colvector} {cmd:rowmin(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real rowvector} {cmd:colmin(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:       }{cmd:min(}{it:real matrix X}{cmd:)}


{p 8 12 2}
{it:real colvector} {cmd:rowmax(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real rowvector} {cmd:colmax(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:       }{cmd:max(}{it:real matrix X}{cmd:)}


{p 8 12 2}
{it:real matrix}{bind:    }{cmd:rowminmax(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:    }{cmd:colminmax(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real rowvector}{bind:    }{cmd:minmax(}{it:real matrix X}{cmd:)}


{p 8 12 2}
{it:real matrix}{bind:    }{cmd:rowminmax(}{it:real matrix X}{cmd:,}
{it:real scalar usemiss}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:    }{cmd:colminmax(}{it:real matrix X}{cmd:,}
{it:real scalar usemiss}{cmd:)}

{p 8 12 2}
{it:real rowvector}{bind:    }{cmd:minmax(}{it:real matrix X}{cmd:,}
{it:real scalar usemiss}{cmd:)}


{p 8 12 2}
{it:real colvector} {cmd:rowmaxabs(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:real rowvector} {cmd:colmaxabs(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions return the indicated minimums and maximums of {it:X}.

{p 4 4 2}
{cmd:rowmin(}{it:X}{cmd:)}
returns the minimum of each row of {it:X},
{cmd:colmin(}{it:X}{cmd:)}
returns the minimum of each column, 
and {cmd:min(}{it:X}{cmd:)}
returns the overall minimum.
Elements of {it:X} that contain missing values are ignored.

{p 4 4 2}
{cmd:rowmax(}{it:X}{cmd:)}
returns the maximum of each row of {it:X}, 
{cmd:colmax(}{it:X}{cmd:)}
returns the maximum of each column,
and {cmd:max(}{it:X}{cmd:)}
returns the overall maximum.
Elements of {it:X} that contain missing values are ignored.

{p 4 4 2}
{cmd:rowminmax(}{it:X}{cmd:)} returns the minimum and maximum of 
each row of {it:X} in an {it:r x} 2 matrix; 
{cmd:colminmax(}{it:X}{cmd:)} 
returns the minimum and maximum of each column in a 2 {it:x c} matrix;
and 
{cmd:minmax(}{it:X}{cmd:)} returns the overall minimum and maximum.
Elements of {it:X} that contain missing values are ignored.

{p 4 4 2}
The two-argument versions of 
{cmd:rowminmax()}, 
{cmd:colminmax()}, 
and {cmd:minmax()} allow you to specify how
missing values are to be treated.  
Specifying a second argument with value 0 is the same as 
using the single-argument versions of the functions.  In the two-argument 
versions, if the second argument is not zero, missing values are treated 
like all other values in determining the minimums and maximums: 
{it:nonmissing} < {cmd:.} < {cmd:.a} < {cmd:.b} < ... < {cmd:.z}.

{p 4 4 2}
{cmd:rowmaxabs(}{it:A}{cmd:)}
and
{cmd:colmaxabs(}{it:A}{cmd:)}
return the same result as 
{cmd:rowmax(abs(}{it:A}{cmd:))}
and 
{cmd:colmax(abs(}{it:A}{cmd:))}.
The advantage is that matrix {cmd:abs(}{it:A}{cmd:)} is never formed 
or stored, and so these functions use less memory.


{marker conformability}{...}
{title:Conformability}

    {cmd:rowmin(}{it:X}{cmd:)}, {cmd:rowmax(}{it:X}{cmd:)}:
		{it:X}:  {it:r x c}
	   {it:result}:  {it:r x} 1

    {cmd:colmin(}{it:X}{cmd:)}, {cmd:colmax(}{it:X}{cmd:)}:
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x c}

    {cmd:min(}{it:X}{cmd:)}, {cmd:max(}{it:X}{cmd:)}:
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x} 1

    {cmd:rowminmax(}{it:X}{cmd:,} {it:usemiss}{cmd:)}:
		{it:X}:  {it:r x c}
	  {it:usemiss}:  1 {it:x} 1
	   {it:result}:  {it:r x} 2

    {cmd:colminmax(}{it:X}{cmd:,} {it:usemiss}{cmd:)}
		{it:X}:  {it:r x c}
	  {it:usemiss}:  1 {it:x} 1
	   {it:result}:  2 {it:x c}

    {cmd:minmax(}{it:X}{cmd:,} {it:usemiss}{cmd:)}
		{it:X}:  {it:r x c}
	  {it:usemiss}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 2

    {cmd:rowmaxabs(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  {it:r x} 1

    {cmd:colmaxabs(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  1 {it:x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {cmd:row}{it:*}{cmd:()} functions return missing value for the
    corresponding minimum or maximum when the entire row contains missing
    values.

{p 4 4 2}
    {cmd:col}{it:*}{cmd:()} functions return missing value for the
    corresponding minimum or maximum when the entire column contains missing
    values.

{p 4 4 2}
    {cmd:min()} and {cmd:max()} return missing value 
    when the entire matrix contains missing values.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view rowmin.mata, adopath asis:rowmin.mata},
{view colmin.mata, adopath asis:colmin.mata},
{view min.mata, adopath asis:min.mata},
{view rowmax.mata, adopath asis:rowmax.mata},
{view colmax.mata, adopath asis:colmax.mata},
{view max.mata, adopath asis:max.mata};
other functions are built in.
{p_end}
