{smcl}
{* *! version 1.2.5  15may2018}{...}
{vieweralsosee "[M-5] st_tsrevar()" "mansection M-5 st_tsrevar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_varindex()" "help mf_st_varindex"}{...}
{vieweralsosee "[M-5] st_varname()" "help mf_st_varname"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_tsrevar##syntax"}{...}
{viewerjumpto "Description" "mf_st_tsrevar##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_tsrevar##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_tsrevar##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_tsrevar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_tsrevar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_tsrevar##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] st_tsrevar()} {hline 2}}Create time-series op.varname variables
{p_end}
{p2col:}({mansection M-5 st_tsrevar():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real rowvector}{bind: }
{cmd:st_tsrevar(}{it:string rowvector s}{cmd:)}

{p 8 12 2}
{it:real rowvector}
{cmd:_st_tsrevar(}{it:string rowvector s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_tsrevar(}{it:s}{cmd:)} is the equivalent of Stata's 
{bf:{help tsrevar:[TS] tsrevar}} programming command:  it generates temporary 
variables containing the evaluation of any {it:op}{cmd:.}{it:varname}
combinations appearing in {it:s}.

{p 4 4 2}
{cmd:_st_tsrevar(}{it:s}{cmd:)} does the same thing as  {cmd:st_tsrevar()}.
The two functions differ in how they respond to invalid elements of {it:s}.
{cmd:st_tsrevar()} aborts with error, and 
{cmd:_st_tsrevar()} places missing in the appropriate element of the 
returned result.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_tsrevar()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Both of these functions help achieve efficiency
when using views and time-series variables.
Assume that in 
{it:vars} you have a list of
Stata variable names, some of which might contain 
time-series {it:op}{cmd:.}{it:varname} combinations such as {cmd:l.gnp}.
For example, {it:vars} might contain 

	{it:vars} = {cmd:"gnp r l.gnp"}

{p 4 4 2}
If you wanted to create in {it:V} a view to the data, you would usually 
code 

	{cmd:st_view(}{it:V}{cmd:, .,} {it:vars}{cmd:)}

{p 4 4 2}
We are not going to do that, however, because we plan to do many calculations
with {it:V} and, to speed execution, we want any {it:op}{cmd:.}{it:varname}
combinations evaluated just once, as {it:V} is created.  Of course, if
efficiency were our only concern, we would code

	{it:V} = {cmd:st_data(.,} {it:vars}{cmd:)}

{p 4 4 2}
Assume, however, that we have lots of data, so memory is an issue, and yet we
still want as much efficiency as possible given the constraint of not copying
the data.  The solution is to code,

	{cmd:st_view(}{it:V}{cmd:, ., st_tsrevar(tokens(}{it:vars}{cmd:)))}

{p 4 4 2}
{cmd:st_tsrevar()} will create temporary variables for each
{it:op}{cmd:.}{it:varname} combination ({cmd:l.gnp} in our example), and then
return the Stata variable indices of each of the variables, whether newly
created or already existing.  If {cmd:gnp} was the second variable in the
dataset, {cmd:r} was the 23rd, and in total there were 54 variables, then
returned by {cmd:st_tsrevar()} would be (2, 23, 55).  Variable 55 is new,
created by {cmd:st_tsrevar()}, and it contains the values of {cmd:l.gnp}.  The
new variable is temporary and will be dropped automatically at the appropriate
time.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_tsrevar(}{it:s}{cmd:)}, {cmd:_st_tsrevar(}{it:s}{cmd:)}:
		{it:s}:  1 {it:x c}
	   {it:result}:  1 {it:x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_tsrevar()} aborts with error if any variable name is not found
or any {it:op}{cmd:.}{it:varname} combination is invalid.

{p 4 4 2}
{cmd:_st_tsrevar()} puts missing in the appropriate element of the
returned result for any variable name that is not found
or any {it:op}{cmd:.}{it:varname} combination that is invalid.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
