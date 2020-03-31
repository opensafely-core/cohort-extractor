{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_dir()" "mansection M-5 st_dir()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_dir##syntax"}{...}
{viewerjumpto "Description" "mf_st_dir##description"}{...}
{viewerjumpto "Conformability" "mf_st_dir##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_dir##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_dir##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] st_dir()} {hline 2}}Obtain list of Stata objects
{p_end}
{p2col:}({mansection M-5 st_dir():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string colvector} 
{cmd:st_dir(}{it:cat}{cmd:,}
{it:subcat}{cmd:,}
{it:pattern}{cmd:)}

{p 8 12 2}
{it:string colvector} 
{cmd:st_dir(}{it:cat}{cmd:,}
{it:subcat}{cmd:,}
{it:pattern}{cmd:,}
{it:adorn}{cmd:)}

{p 4 4 2}
where

{p 12 18 2}
{it:cat}:
{it:string scalar} containing 
{cmd:"local"},
{cmd:"global"},
{cmd:"r()"},
{cmd:"e()"},
{cmd:"s()"}, or
{cmd:"char"}

{p 9 18 2}
{it:subcat}:
{it:string scalar} containing 
{cmd:"macro"}, 
{cmd:"numscalar"}, 
{cmd:"strscalar"}, 
{cmd:"matrix"}, or, 
if {it:cat}=={cmd:"char"}, {cmd:"_dta"} or a name.

{p 8 18 2}
{it:pattern}:
{it:string scalar} containing a pattern as defined in 
{bf:{help mf_strmatch:[M-5] strmatch()}}

{p 10 12 2}
{it:adorn}:
{it:string scalar} containing 0 or non-0


{p 4 4 2}
The valid {it:cat}--{it:subcat} combinations and their meanings are 

	    {it:cat}         {it:subcat}         Meaning
	    {hline 61}
	    {cmd:"local"     "macro"}        Stata's local macros

	    {cmd:"global"    "macro"}        Stata's global macros
	    {cmd:"global"    "numscalar"}    Stata's numeric scalars
	    {cmd:"global"    "strscalar"}    Stata's string scalars
	    {cmd:"global"    "matrix"}       Stata's matrices

	    {cmd:"r()"       "macro"}        macros in {cmd:r()}
	    {cmd:"r()"       "numscalar"}    numeric scalars in {cmd:r()}
	    {cmd:"r()"       "matrix"}       matrices in {cmd:r()}
                
	    {cmd:"e()"       "macro"}        macros in {cmd:e()}
	    {cmd:"e()"       "numscalar"}    numeric scalars in {cmd:e()}
	    {cmd:"e()"       "matrix"}       matrices in {cmd:e()}
               
	    {cmd:"s()"       "macro"}        macros in {cmd:s()}

	    {cmd:"char"      "_dta"}         characteristics in {cmd:_dta[]}
	    {cmd:"char"      "}{it:name}{cmd:"}         characteristics in variable {it:name}{cmd:[]}
	    {hline 61}

{p 4 4 2}
{cmd:st_dir()} returns an empty list if an invalid {it:cat}--{it:subcat} 
combination is specified.

		
{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_dir(}{it:cat}{cmd:,} {it:subcat}{cmd:,} {it:pattern}{cmd:)}
and 
{cmd:st_dir(}{it:cat}{cmd:,} {it:subcat}{cmd:,} {it:pattern}{cmd:,}
{it:adorn}{cmd:)}
return a column vector containing the names matching {it:pattern} of the
Stata objects described by {it:cat}--{it:subcat}.

{p 4 4 2}
Argument {it:adorn} is optional; not specifying it is equivalent to 
specifying {it:adorn}=0.  By default, simple names are returned.
If {it:adorn}!=0 is specified, the name is adorned in the standard 
Stata way used to describe the object.  Say that one is 
listing the macros in {cmd:e()} and one of the elements is 
{cmd:e(cmd)}.  By default, the returned vector will contain an element 
equal to "{cmd:cmd}".  With 
{it:adorn}!=0, the element will be "{cmd:e(cmd)}".  

{p 4 4 2}
For many objects, the adorned and unadorned forms of the names are the same.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_dir(}{it:cat}{cmd:,} {it:subcat}{cmd:,} {it:pattern}{cmd:,} {it:adorn}{cmd:)}:
	      {it:cat}:  1 {it:x} 1
	   {it:subcat}:  1 {it:x} 1
	  {it:pattern}:  1 {it:x} 1
	    {it:adorn}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:k x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_dir(}{it:cat}{cmd:,} {it:subcat}{cmd:,} {it:pattern}{cmd:)}
and 
{cmd:st_dir(}{it:cat}{cmd:,} {it:subcat}{cmd:,} {it:pattern}{cmd:,}
{it:adorn}{cmd:)}
abort with error if {it:cat} or {it:subcat} is invalid.  If the combination
is invalid, however, {cmd:J(0,1,"")} is returned.
{it:subcat}=={it:name} is considered invalid unless 
{it:cat}=={cmd:"char"}.

{p 4 4 2}
{cmd:st_dir()} aborts with error if any of its arguments are views.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
