{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_dropvar()" "mansection M-5 st_dropvar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_dropvar##syntax"}{...}
{viewerjumpto "Description" "mf_st_dropvar##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_dropvar##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_dropvar##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_dropvar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_dropvar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_dropvar##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] st_dropvar()} {hline 2}}Drop variables or observations
{p_end}
{p2col:}({mansection M-5 st_dropvar():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:st_dropvar(}{it:transmorphic rowvector vars}{cmd:)}


{p 8 12 2}
{it:void}
{cmd:st_dropobsin(}{it:real matrix range}{cmd:)}

{p 8 12 2}
{it:void}
{cmd:st_dropobsif(}{it:real colvector select}{cmd:)}


{p 8 12 2}
{it:void}
{cmd:st_keepvar(}{it:transmorphic rowvector vars}{cmd:)}


{p 8 12 2}
{it:void}
{cmd:st_keepobsin(}{it:real matrix range}{cmd:)}

{p 8 12 2}
{it:void}
{cmd:st_keepobsif(}{it:real colvector select}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_dropvar(}{it:vars}{cmd:)} drops the variables specified.
{it:vars} is a row vector that may contain either variable names or 
variable indices.  {cmd:st_dropvar(.)} drops all variables and observations.

{p 4 4 2}
{cmd:st_dropobsin()} and 
{cmd:st_dropobsif()} have to do with dropping observations.

{p 4 4 2}
{cmd:st_dropobsin(}{it:range}{cmd:)} specifies the observations to be dropped:

{p 8 12 2}
{cmd:st_dropobsin(5)} drops observation 5.  

{p 8 12 2}
{cmd:st_dropobsin((5,9))} drops observations 5 through 9.  

{p 8 12 2}
{cmd:st_dropobsin((5\8\12))} drops observations 5 and 8 and 12.

{p 8 12 2}
{cmd:st_dropobsin((5,7\8,11\13,13))} drops observations 5 through 7, 8
through 11, and 13.

{p 8 12 2}
{cmd:st_dropobsin(.)} drops all observations (but not the variables).

{p 8 12 2}
{cmd:st_dropobsin(J(0,1,.))} drops no observations (or variables).

{p 4 4 2}
{cmd:st_dropobsif(}{it:select}{cmd:)} specifies a {cmd:st_nobs()} {it:x} 1
vector.  Observations {it:i} for which {it:select}_{it:i}!=0 are dropped.

{p 4 4 2}
{cmd:st_keepvar()}, 
{cmd:st_keepobsin()}, and {cmd:st_keepobsif()} do the same thing, 
except that the variables and observations to be kept are specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_dropvar()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
To drop all variables and observations, code 
{cmd:st_dropvar(.)},  
{cmd:st_keepvar(J(1,0,.))}, 
or
{cmd:st_keepvar(J(1,0,""))}.  All do the same thing.
Dropping all the variables clears the dataset.

{p 4 4 2}
Dropping all the observations, however, leaves the variables in place.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_dropvar(}{it:vars}{cmd:)}, {cmd:st_keepvar(}{it:vars}{cmd:)}:
	     {it:vars}:  1 {it:x k}
	   {it:result}:  {it:void}


    {cmd:st_dropobsin(}{it:range}{cmd:)}, {cmd:st_keepobsin(}{it:range}{cmd:)}:
	    {it:range}:  {it:k x} 1  or  {it:k x} 2
	   {it:result}:  {it:void}

    {cmd:st_dropobsif(}{it:select}{cmd:)}, {cmd:st_keepobsif(}{it:select}{cmd:)}:
	   {it:select}:  {cmd:st_nobs()} {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_dropvar(}{it:vars}{cmd:)} and
{cmd:st_keepvar(}{it:vars}{cmd:)}
abort with error if any element of {it:vars} is missing unless {it:vars} is 1
{it:x} 1, in which case they drop or keep all the variables.

{p 4 4 2}
{cmd:st_dropvar(}{it:vars}{cmd:)} and
{cmd:st_keepvar(}{it:vars}{cmd:)}
abort with error if any element of {it:vars} is not a valid variable index or
name, or if {it:vars} is a view.
If {it:vars} is specified as names, abbreviations are not allowed.

{p 4 4 2}
{cmd:st_dropvar()} and {cmd:st_keepvar()} set {cmd:st_updata()} (see
{bf:{help mf_st_updata:[M-5] st_updata()}}) unless all variables dropped
are temporary; see {bf:{help mf_st_tempname:[M-5] tempname()}}.

{p 4 4 2}
{cmd:st_dropobsin(}{it:range}{cmd:)} and
{cmd:st_keepobsin(}{it:range}{cmd:)}
abort with error if any element of {it:range} is missing unless {it:range} is
1 {it:x} 1, in which case they drop or keep all the observations.

{p 4 4 2}
{cmd:st_dropobsin(}{it:range}{cmd:)} and
{cmd:st_keepobsin(}{it:range}{cmd:)}
abort with error if any element of {it:range} is not a valid observation
number (is not between 1 and {cmd:st_nobs()}
[see {bf:{help mf_st_nvar:[M-5] st_nvar()}}] inclusive)
or if {it:range} is a view.

{p 4 4 2}
{cmd:st_dropobsif(}{it:select}{cmd:)} and
{cmd:st_keepobsif(}{it:select}{cmd:)}
abort with error if {it:select} is a view.

{p 4 4 2}
{cmd:st_dropobsin()}, 
{cmd:st_dropobsif()}, 
{cmd:st_keepobsin()}, and
{cmd:st_keepobsif()}
{cmd:st_updata()} if any observations 
are removed from the data.

{p 4 4 2}
Be aware that, after dropping any variables or observations, any 
previously constructed views (see {bf:{help mf_st_view:[M-5] st_view()}})
are probably invalid because views are internally stored in terms of 
variable and observation numbers.   Subsequent use of an invalid view  
may lead to unexpected results or an abort with error.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
