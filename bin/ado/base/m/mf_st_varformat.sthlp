{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_varformat()" "mansection M-5 st_varformat()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_varformat##syntax"}{...}
{viewerjumpto "Description" "mf_st_varformat##description"}{...}
{viewerjumpto "Conformability" "mf_st_varformat##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_varformat##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_varformat##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] st_varformat()} {hline 2}}Obtain/set format, etc., of Stata variable
{p_end}
{p2col:}({mansection M-5 st_varformat():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}
{cmd:st_varformat(}{it:scalar var}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_varformat(}{it:scalar var}{cmd:,}
{it:string scalar fmt}{cmd:)}


{p 8 12 2}
{it:string scalar}
{cmd:st_varlabel(}{it:scalar var}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_varlabel(}{it:scalar var}{cmd:,}
{it:string scalar label}{cmd:)}


{p 8 12 2}
{it:string scalar}
{cmd:st_varvaluelabel(}{it:scalar var}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_varvaluelabel(}{it:scalar var}{cmd:,}
{it:string scalar labelname}{cmd:)}


{p 4 4 2}
where {it:var} contains a Stata variable name or a Stata variable index.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_varformat(}{it:var}{cmd:)}
returns the display format associated with {it:var}, such as 
{cmd:"%9.0gc"}.
{cmd:st_varformat(}{it:var}{cmd:,} {it:fmt}{cmd:)}
changes {it:var}'s display format.

{p 4 4 2}
{cmd:st_varlabel(}{it:var}{cmd:)}
returns the variable label associated with {it:var}, such as 
{cmd:"Sex of Patient"}, or it returns {cmd:""} if {it:var} has no 
variable label.
{cmd:st_varformat(}{it:var}{cmd:,} {it:label}{cmd:)}
changes {it:var}'s variable label.

{p 4 4 2}
{cmd:st_varvaluelabel(}{it:var}{cmd:)}
returns the value-label name associated with {it:var}, such as 
{cmd:"origin"}, or it returns {cmd:""} if {it:var} has no 
value label.
{cmd:st_varvaluelabel(}{it:var}{cmd:,} {it:labelname}{cmd:)}
changes the value-label name associated with {it:var}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:st_varformat(}{it:var}{cmd:)},
{cmd:st_varlabel(}{it:var}{cmd:)},
{cmd:st_varvaluelabel(}{it:var}{cmd:)}:
{p_end}
	      {it:var}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{p 4 4 2}
{cmd:st_varformat(}{it:var}{cmd:,} {it:fmt}{cmd:)},
{cmd:st_varlabel(}{it:var}{cmd:,} {it:label}{cmd:)},
{cmd:st_varvaluelabel(}{it:var}{cmd:,} {it:labelname}{cmd:)}:
{p_end}
	      {it:var}:  1 {it:x} 1
	    {it:value}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
In all functions, if {it:var} is specified as a name, abbreviations are 
not allowed.

{p 4 4 2}
All functions abort with error if {it:var} is not a valid Stata variable.

{p 4 4 2}
{cmd:st_varformat(}{it:var}{cmd:,} {it:fmt}{cmd:)}
aborts with error if {it:fmt} does not contain a valid display format 
for {it:var}.

{p 4 4 2}
{cmd:st_varlabel(}{it:var}{cmd:,} {it:label}{cmd:)}
will truncate {it:label} if it is too long.

{p 4 4 2}
{cmd:st_varvaluelabel(}{it:var}{cmd:,} {it:labelname}{cmd:)}
aborts with error 
if {it:var} is a Stata string variable or if 
{it:labelname} does not contain a valid name (assuming {it:labelname} is 
not {cmd:""}).
It is not required, however, that the label name exist.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
