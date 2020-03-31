{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] st_updata()" "mansection M-5 st_updata()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_updata##syntax"}{...}
{viewerjumpto "Description" "mf_st_updata##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_updata##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_updata##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_updata##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_updata##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_updata##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_updata()} {hline 2}}Determine or set data-have-changed flag
{p_end}
{p2col:}({mansection M-5 st_updata():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:st_updata()}

{p 8 12 2}
{it:void}{bind:       }
{cmd:st_updata(}{it:real scalar value}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_updata()} returns 0 if the data in memory have not changed 
since they were last saved and returns 1 otherwise.

{p 4 4 2}
{cmd:st_updata(}{it:value}{cmd:)} sets the data-have-changed flag 
to 0 if {it:value}=0 and 1 otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_updata()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Stata's {helpb describe} command reports whether the data have changed since
they were last changed.  Stata's {helpb use} command refuses to load a new
dataset if the data currently in memory have not been saved since they were
last saved.  Other components of Stata also react to the data-have-changed
flag.

{p 4 4 2}
{cmd:st_updata()} allows you to respect that same flag.

{p 4 4 2}
Also, as a Mata programmer, you must set the flag if
your function changes the data in memory.  Mata attempts to set the flag for
you (for instance, when you add a new variable using {cmd:st_addvar()} [see
{bf:{help mf_st_addvar:[M-5] st_addvar()}}]), but there are other places where
the flag ought to be set, and you must do so.  For
instance, Mata does not set the flag every time you change a value in the
dataset.  Setting the flag what may be many thousands of times would reduce
performance too much.

{p 4 4 2}
Moreover, even when Mata does set the flag, it might do so inappropriately, 
because the logic of your program fooled Mata.  For instance, perhaps you 
added a variable and later dropped it.  In such cases, the appropriate 
code is

	{cmd:priorupdatavalue = st_updata()}
	...
	{cmd:st_updata(priorupdatavalue)}

	
{marker conformability}{...}
{title:Conformability}

    {cmd:st_updata()}:
	   {it:result}:  1 {it:x} 1
	
    {cmd:st_updata(}{it:value}{cmd:)}:
	    {it:value}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
