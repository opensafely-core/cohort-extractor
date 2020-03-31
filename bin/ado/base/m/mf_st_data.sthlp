{smcl}
{* *! version 1.2.8  15may2018}{...}
{vieweralsosee "[M-5] st_data()" "mansection M-5 st_data()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_store()" "help mf_st_store"}{...}
{vieweralsosee "[M-5] st_view()" "help mf_st_view"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] putmata" "help putmata"}{...}
{viewerjumpto "Syntax" "mf_st_data##syntax"}{...}
{viewerjumpto "Description" "mf_st_data##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_data##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_data##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_data##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_data##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_data##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] st_data()} {hline 2}}Load copy of current Stata dataset
{p_end}
{p2col:}({mansection M-5 st_data():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 8}{it:real scalar}{...}
{col 22}{cmd:_st_data(}{...}
{it:real scalar i}{cmd:,} {...}
{it:real scalar j}{cmd:)}


{col 8}{it:real matrix}{...}
{col 23}{cmd:st_data(}{...}
{it:real matrix i}{cmd:,} {...}
{it:rowvector j}{cmd:)}{...}
{right:(1,2)}

{col 8}{it:real matrix}{...}
{col 23}{cmd:st_data(}{...}
{it:real matrix i}{cmd:,} {...}
{it:rowvector j}{cmd:,} {...}
{it:scalar selectvar}{...}
{cmd:)}{...}
{right:(1,2,3)}


{col 8}{it:string scalar}{...}
{col 23}{cmd:_st_sdata(}{...}
{it:real scalar i}{cmd:,} {...}
{it:real scalar j}{...}
{cmd:)}


{col 8}{it:string matrix}{...}
{col 23}{cmd:st_sdata(}{...}
{it:real matrix i}{cmd:,} {...}
{it:rowvector j}){...}
{right:(1,2)}

{col 8}{it:string matrix}{...}
{col 23}{cmd:st_sdata(}{...}
{it:real matrix i}{cmd:,} {...}
{it:rowvector j}{cmd:,} {...}
{it:scalar selectvar}{cmd:)}{...}
{right:(1,2,3)}


{p 4 4 2}
where

{p 7 11 2}
1.  {it:i} may be specified as a 1 {it:x} 1 scalar, 
    as a 1 {it:x} 1 scalar containing missing, 
    as a column vector of observation numbers, 
    as a row vector specifying an observation range, 
    or as a {it:k x} 2 matrix specifying both.

{p 14 18 2}
a.  {cmd:st_data(1, 2)} returns the first observation on the second variable.

{p 14 18 2}
b.  {cmd:st_data(., 2)} returns all observations on the second variable.

{p 14 18 2}
c.  {cmd:st_data((1\2\5), 2)} returns observations 1, 2, and 5 on the 
    second variable.

{p 14 18 2}
d.  {cmd:st_data((1,5), 2)} returns observations 1 through 5 on the second 
    variable.

{p 14 18 2}
e.  {cmd:st_data((1,5\7,9), 2)} returns observations 1 through 5 and 
    observations 7 through 9 on the second variable.

{p 11 11 2}
When a range is specified, any element of the range 
({it:i1},{it:i2}) may be specified to contribute zero observations
if {it:i2}={it:i1}-1.

{p 7 11 2}
2.  {it:j} may be specified as a real row vector or as a string 
    scalar or string row vector.

{p 14 18 2}
a.  {cmd:st_data(., .)} returns the values of all variables, all observations
    of the Stata dataset.

{p 14 18 2}
b.  {cmd:st_data(., 1)} returns the value of the first variable, all
    observations.

{p 14 18 2}
c.  {cmd:st_data(., (3,1,9))} returns the values of the third, first, and ninth
    variables of all observations.

{p 14 18 2}
d.  {cmd:st_data(., ("mpg", "weight"))} returns the values of variables 
    {cmd:mpg} and {cmd:weight}, all observations.

{p 14 18 2}
e.  {cmd:st_data(., "mpg weight")} does the same as d above.

{p 14 18 2}
f.  {cmd:st_data(., ("gnp", "l.gnp"))} returns the values of {cmd:gnp} and the
    lag of {cmd:gnp}, all observations.

{p 14 18 2}
g.  {cmd:st_data(., "gnp l.gnp")} does the same as f above.

{p 14 18 2}
h.  {cmd:st_data(., "mpg i.rep78")} returns the value of {cmd:mpg} and 
    the 5 pseudovariables associated with {cmd:i.rep78}.  There are 
    5 pseudovariables because we are imagining that {cmd:auto.dta} is in 
    memory; the actual number is a function of the values taken on 
    by the variable in the sample specified.
    Factor variables can be specified only with string scalars; 
    specifying {cmd:("mpg", "i.rep78")} will not work.

{p 7 11 2}
3.  {it:selectvar} may be specified as real or as a string.
    Observations for which {it:selectvar}!=0 will be selected.
    If {it:selectvar} is real, it is interpreted as a variable number.  If
    string, {it:selectvar} should contain the name of a Stata variable.

{p 11 11 2}
    Specifying {it:selectvar} as {cmd:""} or as missing ({cmd:.})
    has the same result as not specifying {it:selectvar}; no  
    observations are excluded.

{p 11 11 2}
    Specifying {it:selectvar} as {cmd:0} means that observations 
    with missing values of the variables specified by {it:j} are to be
    excluded.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_st_data(}{it:i}, {it:j}{cmd:)} returns the numeric value of the
{it:i}th observation of the 
{it:j}th Stata variable.  
Observations are numbered 1 through
{bf:{help mf_st_nvar:st_nobs()}}.
Variables are numbered 1
through {bf:{help mf_st_nvar:st_nvar()}}.  

{p 4 4 2}
{cmd:st_data(}{it:i}, {it:j}{cmd:)} is similar to {cmd:_st_data(}{it:i},
{it:j}{cmd:)} except

{p 6 10 2}
1.  {it:i} may be specified as a vector or matrix to obtain multiple 
observations simultaneously,

{p 6 10 2}
2.  {it:j} may be specified using names or indices (indices are faster), and

{p 6 10 2}
3.  {it:j} may be specified to obtain multiple variables 
    simultaneously.

{p 4 4 2}
The net effect is that {cmd:st_data()} can return a scalar (the value of one
variable in one observation), a row vector (the value of many variables in an
observation), a column vector (the value of a variable in many observations),
or a matrix (the value of many variables in many observations).

{p 4 4 2}
{cmd:st_data(}{it:i}, {it:j}, {it:selectvar}{cmd:)} works like 
{cmd:st_data(}{it:i}, {it:j}{cmd:)} except
that only observations for which {it:selectvar}!=0 are returned.

{p 4 4 2}
{cmd:_st_sdata()} and {cmd:st_sdata()} are the string variants of 
{cmd:_st_data()} and {cmd:st_data()}.
{cmd:_st_data()} and {cmd:st_data()} are for use with numeric variables; 
they return missing ({cmd:.}) when used with string variables.
{cmd:_st_sdata()} and {cmd:st_sdata()} are for use with string variables; 
they return empty string ({cmd:""}) when used with numeric variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_data()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_st_data##remarks1:Description of _st_data() and _st_sdata()}
	{help mf_st_data##remarks2:Description of st_data() and st_sdata()}
	{help mf_st_data##remarks3:Details of observation subscripting using st_data() and st_sdata()}


{marker remarks1}{...}
{title:Description of _st_data() and _st_sdata()}

{p 4 4 2}
{cmd:_st_data()} returns one variable's value in one observation.  You refer to
variables and observations by their numbers.  The first variable in the Stata
dataset is 1; the first observation is 1.

	{cmd:_st_data(1, 1)}            value of 1st obs., 1st variable
	{cmd:_st_data(1, 2)}            value of 1st obs., 2nd variable
	{cmd:_st_data(2, 1)}            value of 2nd obs., 1st variable

{p 4 4 2}
{cmd:_st_sdata()} works the same way.  {cmd:_st_data()} is for use with
numeric variables, and {cmd:_st_sdata()} is for use with string variables.

{p 4 4 2}
{cmd:_st_data()} and {cmd:_st_sdata()} are the fastest way to obtain the 
value of a variable in one observation.


{marker remarks2}{...}
{title:Description of st_data() and st_sdata()}

{p 4 4 2}
{cmd:st_data()} can be used just like {cmd:_st_data()}, and used that way, 
it produces the same result.  

{p 4 4 2}
Variables, however, can be referred to by their names or their numbers:

	{cmd:st_data(1, 1)}             value of 1st obs., 1st variable
	{cmd:st_data(1, 2)}             value of 1st obs., 2nd variable
	{cmd:st_data(2, 1)}             value of 2nd obs., 1st variable

        {cmd:st_data(1, "mpg")}         value of 1st obs, variable {cmd:mpg}
        {cmd:st_data(2, "mpg")}         value of 2nd obs, variable {cmd:mpg}

{p 4 4 2}
Also, you may specify more than one variable:

	{cmd:st_data(2, (1,2,3))}       value of 2nd obs., variables 1, 2, and 3

	{cmd:st_data(2, ("mpg","weight","displ"))}
				  value of 2nd obs., variables {cmd:mpg}, {cmd:weight},
				  and {cmd:displ}

	{cmd:st_data(2, "mpg weight displ")}
				  (same as previous)

{p 4 4 2}
Used this way, {cmd:st_data()} returns a row vector.

{p 4 4 2}
Similarly, you may obtain multiple observations:

       {cmd:st_data((1\2\3), 10)}       values of obs. 1, 2, and 3, variable 10

       {cmd:st_data((1,5), 10)}         values of obs. 1 through 5, variable 10

       {cmd:st_data((1,5)\(7,9), 10)}   values of obs. 1 through 5 and 7 through 9,
                                  variable 10

{p 4 4 2}
{cmd:st_sdata()} works the same way as {cmd:st_data()}.


{marker remarks3}{...}
{title:Details of observation subscripting using st_data() and st_sdata()}

{p 4 8 2}
1.  {it:i} may be specified as a scalar:{break}
    the specified, single observation is returned.
    {it:i} must be between 1 and {cmd:st_nobs()}; see
    {helpb mf_st_nvar:[M-5] st_nvar()}.

{p 4 8 2}
2.  {it:i} may be specified as a scalar containing missing value:{break}
    all observations are returned.

{p 4 8 2}
3.  {it:i} may be specified as a column vector:{break}
    the specified observations are returned.  Each element of {it:i} 
    must be between 1 and {cmd:st_nobs()} or may be missing.  Missing 
    is interpreted as {cmd:st_nobs()}.

{p 4 8 2}
4.  {it:i} may be specified as a 1 {it:x} 2 row vector:{break}
    the specified range of observations is returned;
    {cmd:(}{it:c1}{cmd:,}{it:c2}{cmd:)} returns the {it:c2}-{it:c1}+1 
    observations {it:c1} through {it:c2}.

{p 8 8 2}
    {it:c2}-{it:c1}+1 must evaluate to a number greater than or equal to 0.
    In general, {it:c1} and {it:c2} must be between 1 and {cmd:st_nobs()}, but
    if {it:c2}-{it:c1}+1=0, then {it:c1} may be between 1 and
    {cmd:st_nobs()}+1 and {it:c2} may be between 0 and {cmd:st_nobs()}.
    Regardless, {it:c1}==. or {it:c2==.} is interpreted as {cmd:st_nobs()}.

{p 4 8 2}
5.  {it:i} may be specified as a {it:k x} 2 matrix:{break}
    {cmd:((1,5)\(7,7)\(20,30))} specifies observations 1 through 5, 7, 
    and 20 through 30.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:_st_data(}{it:i}, {it:j}{cmd:)},
{cmd:_st_sdata(}{it:i}, {it:j}{cmd:)}:
{p_end}
		{it:i}:  1 {it:x} 1
		{it:j}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 8 2}
{cmd:st_data(}{it:i}, {it:j}{cmd:)},
{cmd:st_sdata(}{it:i}, {it:j}{cmd:)}:
{p_end}
		{it:i}:  {it:n x} 1  or  {it:n2 x} 2
		{it:j}:  1 {it:x k}  or   1 {it:x} 1 containing {it:k} elements when expanded
	   {it:result}:  {it:n x k}

{p 4 8 2}
{cmd:st_data(}{it:i}, {it:j}, {it:selectvar}{cmd:)},
{cmd:st_sdata(}{it:i}, {it:j}, {it:selectvar}{cmd:)}:
{p_end}
		{it:i}:  {it:n x} 1  or  {it:n2 x} 2
		{it:j}:  1 {it:x k}  or   1 {it:x} 1 containing {it:k} elements when expanded
	{it:selectvar}:  1 {it:x} 1
{p 11 30 2}
        {it:result}:  ({it:n}-{it:e}) {it:x k}, where {it:e} is number of
                   observations excluded by {it:selectvar}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_st_data(}{it:i}, {it:j}{cmd:)} 
returns missing ({cmd:.}) if {it:i} 
or {it:j} is out of range; it does not abort with error.

{p 4 4 2}
{cmd:_st_sdata(}{it:i}, {it:j}{cmd:)} returns "" if {it:i} 
or {it:j} is out of range; it does not abort with error.

{p 4 4 2}
{cmd:st_data(}{it:i}{cmd:,} {it:j}{cmd:)} and
{cmd:st_sdata(}{it:i}{cmd:,} {it:j}{cmd:)} 
abort with error if any element of {it:i} or {it:j} is out of range.
{it:j} may be specified as variable names
or variable indices.  If names are specified, 
abbreviations are allowed.  If you do not want this
and no factor variables nor time-series-operated variables are specified,
use {cmd:st_varindex()} (see {bf:{help mf_st_varindex:[M-5] st_varindex()}})
to translate variable names into variable indices).


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
