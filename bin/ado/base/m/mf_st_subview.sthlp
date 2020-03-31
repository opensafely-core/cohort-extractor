{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_subview()" "mansection M-5 st_subview()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] select()" "help mf_select"}{...}
{vieweralsosee "[M-5] st_view()" "help mf_st_view"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_subview##syntax"}{...}
{viewerjumpto "Description" "mf_st_subview##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_subview##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_subview##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_subview##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_subview##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_subview##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] st_subview()} {hline 2}}Make view from view
{p_end}
{p2col:}({mansection M-5 st_subview():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:st_subview(}{it:X}{cmd:,}
{it:transmorphic matrix V}{cmd:,}
{it:real matrix i}{cmd:,}
{it:real matrix j}{cmd:)}


{p 4 8 2}
where

{p 7 11 2}
1.  The type of {it:X} does not matter; it is replaced.

{p 7 11 2}
2.  {it:V} is typically a view, but that is not required.  {it:V}, however,
    must be real or string.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_subview(}{it:X}{cmd:,} 
{it:V}{cmd:,} 
{it:i}{cmd:,} 
{it:j}{cmd:)} 
creates new view matrix {it:X} from existing view matrix {it:V}.  {it:V} is
to have been created 
from a previous call to {bf:{help mf_st_view:st_view()}} or {cmd:st_subview()}.

{p 4 4 2}
Although {cmd:st_subview()} is intended for use with view matrices, it may also
be used when {it:V} is a regular matrix.  Thus code may be written in such a
way that it will work without regard to whether a matrix is or is not a view.

{p 4 4 2}
{it:i} may be specified as a 1 x 1 scalar, 
a 1 x 1 scalar containing missing, as a
column vector of row numbers, as a row vector specifying a row-number range,
or as a k x 2 matrix specifying both:

{p 7 11 2} 
    a.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
        {cmd: 1,2)} makes {it:X} equal to 
        the first row of the second column of {it:V}.

{p 7 11 2} 
    b.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
        {cmd: .,2)} makes {it:X} equal to 
        all rows of the second column of {it:V}.

{p 7 11 2} 
    c.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:(1\2\5),2)} makes {it:X} equal to 
        rows 1, 2, and 5 of the second column of {it:V}.

{p 7 11 2} 
    d.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:(1,5),2)} makes {it:X} equal to 
        rows 1 through 5 of the second column of {it:V}.

{p 7 11 2} 
    e.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:(1,5\7,9),2)} makes {it:X} equal to 
        rows 1 through 5 and 7 through 9 of the 
        second column of {it:V}.

{p 7 11 2} 
    f.  When a range is specified, any element of the range 
        ({it:i1},{it:i2}) may be set to contribute zero observations 
        if {it:i2}={it:i1}-1.  For example, {cmd:(1,0)} is not an error and 
        neither is {cmd:(1,0\5,7)}.

{p 4 4 2} 
{it:j} may be specified in the same way as {it:i}, except transposed, to
specify the selected columns:

{p 7 11 2} 
    a.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
        {cmd: 2,.)} makes {it:X} equal to 
        all columns of the second row of {it:V}.

{p 7 11 2} 
    b.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:2,(1,2,5))} makes {it:X} equal to 
        columns 1, 2, and 5 of the second row of {it:V}.

{p 7 11 2} 
    c.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:2,(1\5))} makes {it:X} equal to 
        columns 1 through 5 of the second row of {it:V}.

{p 7 11 2} 
    d.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:2,((1\5),(7\9)))} makes {it:X} equal to 
        columns 1 through 5 and 7 through 9 of the 
        second row of {it:V}.

{p 7 11 2} 
    e.  When a range is specified, any element of the range 
        ({it:j1}\{it:j2}) may be set to contribute zero columns 
        if {it:j2}={it:j1}-1.  For example, {cmd:(1\0)} is not an error and 
        neither is {cmd:((1\0),(5\7))}.

{p 4 4 2}
Obviously, notations for {it:i} and {it:j} can be specified simultaneously:

{p 7 11 2} 
    a.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
        {cmd: .,.)}
        makes {it:X} a duplicate of {it:V}.

{p 7 11 2} 
    b.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:.,(1\5))} makes {it:X} equal to 
        columns 1 through 5 of all rows of {it:X}.

{p 7 11 2} 
    c.
        {cmd:st_subview(}{it:X}{cmd:,}{it:V}{cmd:,} 
	{cmd:(10,25),(1\5))} makes {it:X} equal to 
        columns 1 through 5 of rows 10 through 25 of {it:X}.

{p 4 4 2}
Also, {cmd:st_subview()} may be used to create views with 
duplicate variables or observations from {it:V}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_subview()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Say that you need to make a calculation on matrices {it:X} and {it:Y}, which
might be views.  Perhaps the calculation is
{cmd:invsym(}{it:X'X}{cmd:)*}{it:X}{cmd:'}{it:Y}.  Regardless, you start 
as follows:

	{cmd:st_view(X, ., "v2 v3 v4", 0)}
	{cmd:st_view(Y, ., "v1 v7"   , 0)}

{p 4 4 2}
You are already in trouble.  You smartly coded fourth argument as 0, meaning 
exclude the missing values, but you do not know that the same observations
were excluded in the manufacturing of {cmd:X} as in the manufacturing of 
{cmd:Y}.

{p 4 4 2}
If you had previously created a {cmd:touse} variable in your dataset marking
the observations to be used in the calculation, one solution would be

	{cmd:st_view(X, ., "v2 v3 v4", "touse")}
	{cmd:st_view(Y, ., "v1 v7"   , "touse")}

{p 4 4 2}
That solution is recommended, but let's assume you did not do that.
The other solution is 

	{cmd:st_view(M, ., "v2 v3 v4 v1 v7", 0)}
	{cmd:st_subview(X, M, ., (1,2,3))}
	{cmd:st_subview(Y, M, ., (4,5))}

{p 4 4 2}
The first call to {cmd:st_view()} will eliminate observations with missing
values on any of the variables, and the second two {cmd:st_subview()} 
calls will create the matrices you wanted, obtaining them from the 
correctly formed {cmd:M}.  Basically, the two {cmd:st_subview()} calls 
amount to the same thing as 

	{cmd:X = M[., (1,2,3)]}
	{cmd:Y = M[., (4,5)]}

{p 4 4 2}
but you do not want to code that because then matrices {cmd:X} and {cmd:Y}
would contain copies of the data, and you are worried that the dataset might
be large.

{p 4 4 2}
For a second example, let's pretend that you are processing a panel dataset
and making calculations from matrix {cmd:X} within panel.  Your code 
looks something like 

	{cmd:st_view(id, ., "panelid", 0)}
	{cmd:for (i=1; i<=rows(id); i=j+1) {c -(}}
		{cmd:j = endobs(id, i)}
		{cmd:st_view(X, (i,j), "v1 v2} ...{cmd:", 0)}
		...
	{cmd:{c )-}}

{p 4 4 2} 
where you have previously written function {cmd:endobs()} to be 

	{cmd}scalar endobs(vector id, scalar i)
	{
		scalar   j

		for (j=i+1; j<=rows(id); j++) {
			if (id[j]!=id[i]) return(j-1)
		}
		return(rows(id))
	}{txt}

{p 4 4 2}
In any case, there could be a problem.  Missing values of variable
{cmd:panelid} might not align with missing values of variables 
{cmd:v1}, {cmd:v2}, etc.  The result could be that observation and row 
numbers are not in accordance or that there appears to be a group that, 
in fact, has all missing data.  The right way to handle the problem is

	{cmd:st_view(M, ., "panelid v1 v2} ...{cmd:", 0)}

	{cmd:st_subview(id, M, ., 1)}
	{cmd:for (i=1; i<=rows(id); i=j+1) {c -(}}
		{cmd:j = endobs(id, i)}
		{cmd:st_subview(X, M, (i,j), (2\cols(M)))}
		...
	{cmd:{c )-}}


{marker conformability}{...}
{title:Conformability}

    {cmd:st_subview(}{it:X}{cmd:,} {it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)}:
	{it:input:}
		{it:V}:  {it:r x c}
		{it:i}:  1 {it:x} 1, {it:n x} 1, or {it:n2 x} 2
		{it:j}:  1 {it:x} 1, 1 {it:x k}, or 2 {it:x k2}
	{it:output:}
		{it:X}:  {it:n x k}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_subview(}{it:X}{cmd:,} 
{it:V}{cmd:,} 
{it:i}{cmd:,} 
{it:j}{cmd:)} 
aborts with error if {it:i} or {it:j} are out of range.
{it:i} and {it:j} refer to row and column numbers of 
{it:V}, not observation and variable numbers of the underlying Stata 
dataset.  


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
