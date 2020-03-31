{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_addobs()" "mansection M-5 st_addobs()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_addobs##syntax"}{...}
{viewerjumpto "Description" "mf_st_addobs##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_addobs##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_addobs##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_addobs##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_addobs##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_addobs##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_addobs()} {hline 2}}Add observations to current Stata dataset
{p_end}
{p2col:}({mansection M-5 st_addobs():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:        }
{cmd:st_addobs(}{it:real scalar n}{cmd:)}

{p 8 12 2}
{it:void}{bind:        }
{cmd:st_addobs(}{it:real scalar n}{cmd:,}
{it:real scalar nofill}{cmd:)}


{p 8 12 2}
{it:real scalar}
{cmd:_st_addobs(}{it:real scalar n}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:_st_addobs(}{it:real scalar n}{cmd:,}
{it:real scalar nofill}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_addobs(}{it:n}{cmd:)} adds {it:n} observations to the current Stata
dataset.

{p 4 4 2}
{cmd:st_addobs(}{it:n}{cmd:,} {it:nofill}{cmd:)} does the same thing but
saves computer time by not filling in the additional observations with the
appropriate missing-value code if {it:nofill}!=0.
{cmd:st_addobs(}{it:n}{cmd:, 0)} is equivalent to {cmd:st_addobs(}{it:n}{cmd:)}.
Use of {cmd:st_addobs()} with {it:nofill}!=0 is not recommended.  If you 
specify {it:nofill}!=0, it is your responsibility to ensure that the 
added observations ultimately are filled in or removed before control is 
returned to Stata.

{p 4 4 2}
{cmd:_st_addobs(}{it:n}{cmd:)} 
and 
{cmd:_st_addobs(}{it:n}{cmd:,} {it:nofill}{cmd:)} perform the same action 
as 
{cmd:st_addobs(}{it:n}{cmd:)} 
and 
{cmd:st_addobs(}{it:n}{cmd:,} {it:nofill}{cmd:)}, except that they 
return 0 if successful and the appropriate Stata return code otherwise
(otherwise usually being caused by insufficient memory).
Where {cmd:_st_addobs()} would return nonzero, 
{cmd:st_addobs()} aborts with error.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_addobs()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
There need not be any variables defined to add observations.  If you are 
attempting to create a dataset from nothing, you can add the observations 
first and then add the variables, or you can add the variables and then add the 
observations.  Use {cmd:st_addvar()} (see
{bf:{help mf_st_addvar:[M-5] st_addvar()}}) to add variables.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_addobs(}{it:n}{cmd:,} {it:nofill}{cmd:)}:
		{it:n}:  1 {it:x} 1
	   {it:nofill}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:void}

    {cmd:_st_addobs(}{it:n}{cmd:,} {it:nofill}{cmd:)}:
		{it:n}:  1 {it:x} 1
	   {it:nofill}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_addobs(}{it:n}[{cmd:,} {it:nofill}]{cmd:)} and 
{cmd:_st_addobs(}{it:n}[{cmd:,} {it:nofill}]{cmd:)}
abort with error if {it:n}<0.  They do nothing if {it:n}=0.

{p 4 4 2}
{cmd:st_addobs()} aborts with error if there is insufficient memory 
to add the requested number of observations.

{p 4 4 2}
{cmd:_st_addobs()} aborts with error if {it:n}<0 but otherwise returns 
the appropriate Stata return code if the observations cannot be added.
If they are added, 0 is returned.

{p 4 4 2}
{cmd:st_addobs()} and {cmd:_st_addobs()} do not set {cmd:st_updata}
(see {bf:{help mf_st_updata:[M-5] st_updata()}}); you must
set it if you want it set.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
