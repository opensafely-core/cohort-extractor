{smcl}
{* *! version 1.2.10  14may2018}{...}
{vieweralsosee "[M-5] st_numscalar()" "mansection M-5 st_numscalar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_rclear()" "help mf_st_rclear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_numscalar##syntax"}{...}
{viewerjumpto "Description" "mf_st_numscalar##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_numscalar##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_numscalar##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_numscalar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_numscalar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_numscalar##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] st_numscalar()} {hline 2}}Obtain values from and put values into Stata scalars
{p_end}
{p2col:}({mansection M-5 st_numscalar():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real}{bind:  }
{cmd:st_numscalar(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void}{bind:  } 
{cmd:st_numscalar(}{it:string scalar name}{cmd:,} 
{it:real value}{cmd:)}

{p 8 28 2}
{it:void}{bind:  } 
{cmd:st_numscalar(}{it:string scalar name}{cmd:,} 
{it:real value}{cmd:,}
{it:string scalar hcat}{cmd:)}

{p 8 12 2}
{it:string}
{cmd:st_numscalar_hcat(}{it:string scalar name}{cmd:)} 


{p 8 12 2}
{it:string}
{cmd:st_strscalar(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void}{bind:  }
{cmd:st_strscalar(}{it:string scalar name}{cmd:,} 
{it:string value}{cmd:)}


{p 4 8 2}
where

{p 8 12 2}
1.  Functions allow {it:name} to be 
{p_end}

{p 16 20 2}
     a.  global scalar such as {cmd:"myname"},
{p_end}

{p 16 20 2}
     b.  {cmd:r()} scalar such as {cmd:"r(mean)"},
{p_end}

{p 16 20 2}
     c.  {cmd:e()} scalar such as {cmd:"e(N)"}, or
{p_end}

{p 16 20 2}
     d.  {cmd:c()} scalar such as {cmd:"c(namelenchar)"}.

{p 12 12 2}
Note that string scalars never appear in {cmd:r()} and {cmd:e()};
thus (b) and (c) do not apply to {cmd:st_strscalar()}.

{p 8 12 2}
2.  {cmd:st_numscalar(}{it:name}{cmd:)} and 
    {cmd:st_strscalar(}{it:name}{cmd:)} return the value of the 
    specified Stata scalar.  They
    return a 1 {it:x} 1 result if the specified Stata scalar exists and 
    return a 0 {it:x} 0 result otherwise.

{p 8 12 2}
3.  {cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:)} and 
    {cmd:st_strscalar(}{it:name}{cmd:,} {it:value}{cmd:)} set or reset 
    the contents of the specified Stata scalar. 

{p 8 12 2}
4.  {cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:)} and 
    {cmd:st_strscalar(}{it:name}{cmd:,} {it:value}{cmd:)} delete the 
    specified Stata scalar if {it:value}{cmd:==J(0,0,.)} (if {it:value} is 
    0 {it:x} 0). 

{p 8 12 2}
5.  {cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:,} {it:hcat}{cmd:)}
    sets or resets the specified Stata scalar and 
    sets or resets the hidden or historical status when {it:name} 
    is an {cmd:e()} or {cmd:r()} value.  Allowed {it:hcat} values are 
    "{cmd:visible}", "{cmd:hidden}", "{cmd:historical}",
    and a string scalar release number such as such as "{cmd:10}",
    "{cmd:10.1}", or any string release number matching
    "{it:#}[{it:#}][{cmd:.}[{it:#}[{it:#}]]]".  See {manlink P return} for a
    description of hidden and historical stored results.

{p 12 12 2}
    When {cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:)} is used to
    set an {cmd:e()} or {cmd:r()} value, its {it:hcat} is set to
    "{cmd:visible}".

{p 12 12 2}
    There is no three-argument form of {cmd:st_strscalar()} because 
    there are no {cmd:r()} or {cmd:e()} string scalar values.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_numscalar(}{it:name}{cmd:)} returns the value of the specified
Stata numeric scalar, or it returns {helpb mf_j:J(0,0,.)} if the scalar does
not exist.

{p 4 4 2}
{cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:)} sets or resets the
value of the specified numeric scalar, assuming {it:value}{cmd:!=J(0,0,.)}.
{cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:)} 
deletes the specified scalar if {it:value}{cmd:==J(0,0,.)}.
{cmd:st_numscalar("x", J(0,0,.))} erases the scalar {cmd:x}, or it does
nothing if scalar {cmd:x} did not exist.

{p 4 4 2}
{cmd:st_strscalar(}{it:name}{cmd:)} returns the value of the specified
Stata string scalar, or it returns {cmd:J(0,0,"")} if the scalar does not exist.

{p 4 4 2}
{cmd:st_strscalar(}{it:name}{cmd:,} {it:value}{cmd:)} sets or resets the
value of the specified scalar, assuming {it:value}{cmd:!=J(0,0,"")}.
{cmd:st_strscalar(}{it:name}{cmd:,} {it:value}{cmd:)} 
deletes the specified scalar if {it:value}{cmd:==J(0,0,"")}.
{cmd:st_strscalar("x", J(0,0,""))} erases the scalar {cmd:x}, or it does
nothing if scalar {cmd:x} did  not exist.

{p 4 4 2}
Concerning deletion of a scalar, it does not matter whether you code 
{cmd:st_numscalar(}{it:name}{cmd:, J(0,0,.))} 
or
{cmd:st_strscalar(}{it:name}{cmd:, J(0,0,""))}; both yield the same result.

{p 4 4 2}
{cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:,} {it:hcat}{cmd:)} and
{cmd:st_numscalar_hcat(}{it:name}{cmd:)} are used to set and query the
{it:hcat} corresponding to an {cmd:e()} or {cmd:r()} value.  They are also
rarely used.  See {manlink R Stored results} and {manlink P return} for more
information.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_numscalar()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
See {bf:{help mf_st_global:[M-5] st_global()}}
and
{bf:{help mf_st_rclear:[M-5] st_rclear()}}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
    {cmd:st_numscalar(}{it:name}{cmd:)},
    {cmd:st_strscalar(}{it:name}{cmd:)}:
{p_end}
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1  or  0 {it:x} 0

{p 4 4 2}
    {cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:)},
    {cmd:st_strscalar(}{it:name}{cmd:,} {it:value}{cmd:)}:
{p_end}
	     {it:name}:  1 {it:x} 1
	    {it:value}:  1 {it:x} 1  or  0 {it:x} 0
	   {it:result}:  {it:void}

    {cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:,} {it:hcat}{cmd:)}
	     {it:name}:  1 {it:x} 1
	    {it:value}:  1 {it:x} 1
	     {it:hcat}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:st_numscalar(}{it:name}{cmd:)}
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions abort with error if {it:name} is malformed.

{p 4 4 2}
{cmd:st_numscalar(}{it:name}{cmd:)} and 
{cmd:st_strscalar(}{it:name}{cmd:)}
return {cmd:J(0,0,.)} or {cmd:J(0,0,"")} if Stata scalar
{it:name} does not exist.  They abort with error, however, if 
the name is malformed.

{p 4 4 2}
{cmd:st_numscalar(}{it:name}{cmd:,} {it:value}{cmd:,} {it:hcat}{cmd:)} 
aborts with error if {it:hcat} is not an allowed value.

{p 4 4 2}
{cmd:st_numscalar_hcat(}{it:name}{cmd:)} returns
"{cmd:visible}" when {it:name} is not an {cmd:e()} or {cmd:r()} 
value and returns "" when {it:name} is an {cmd:e()} or {cmd:r()} 
value that does not exist.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
