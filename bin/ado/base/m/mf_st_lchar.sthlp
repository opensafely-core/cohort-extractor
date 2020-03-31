{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_global()" "help mf_st_global"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_lchar##syntax"}{...}
{viewerjumpto "Description" "mf_st_lchar##description"}{...}
{viewerjumpto "Remarks" "mf_st_lchar##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_lchar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_lchar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_lchar##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] st_lchar()} {hline 2} Obtain/set "long" characteristics


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_lchar(}{it:basename}{cmd:,} {it:charname}, {it:string scalar s})

{p 8 12 2}
{it:string scalar} 
{cmd:st_lchar(}{it:basename}{cmd:,} {it:charname})



{p 8 12 2}
{it:void}{bind:         }
{cmd:ado_intolchar(}{it:basename}{cmd:,}
{it:charname}{cmd:,}
{it:macname}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:ado_fromlchar(}{it:macname}{cmd:,}
{it:basename}{cmd:,}
{it:charname}{cmd:)}


{p 4 4 2}
where {it:basename}, {it:charname}, and {it:macname} are {it:string scalar}.


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions concern obtaining and setting {help char:characteristics} that
might be longer than 67,784 bytes.
To obtain and set characteristics in the usual case, you code 

		{cmd:s = st_global("_dta[example]")}     // obtain

		{cmd:st_global("_dta[example]", s)}      // set

{p 4 4 2}
See {bf:{help mf_st_global:[M-5] st_global}}.

{p 4 4 2}
The maximum length of a characteristic is 67,784 bytes whether you are
running {help stataic:Stata/IC}, {help specialedition:Stata/SE}, or
{help statamp:Stata/MP}.  Macros can be
longer than that.  These functions allow saving Stata macros in
characteristics and vice versa, and they handle the problem that macros can
exceed the maximum allowed length of Stata's characteristics.

{p 4 4 2}
{cmd:st_lchar()} is for use by Mata programmers:

{p 8 12 2}
1.
{cmd:st_lchar(}{it:charname}{cmd:,} {it:basename}{cmd:,} {it:s}{cmd:)}
saves {it:s} in "long" characteristic 
{it:basename}{cmd:[}{it:charname}{cmd:]}.

{p 8 12 2}
2.
{cmd:st_lchar(}{it:charname}{cmd:,} {it:basename}{cmd:)}
returns the contents of "long" characteristic
{it:basename}{cmd:[}{it:charname}{cmd:]}.

{p 8 12 2}
3.
{cmd:st_lchar(}{it:charname}{cmd:,} {it:basename}{cmd:, "")}
can be used to delete "long" characteristic 
{it:basename}{cmd:[}{it:charname}{cmd:]}.

{p 4 4 2}
{cmd:ado_intolchar()} and {cmd:ado_fromlchar()} are for use by 
Stata ado-file programmers:

{p 8 12 2}
1.
{cmd:ado_intolchar(}{it:basename}{cmd:,}
{it:charname}{cmd:,}
{it:macname}{cmd:)}
saves the contents of local macro {it:macname} in "long" characteristic
{it:basename}{cmd:[}{it:charname}{cmd:]}.

{p 8 12 2}
2.
{cmd:ado_fromlchar(}{it:macname}{cmd:,}
{it:basename}{cmd:,}
{it:charname}{cmd:)}
places the contents of "long" characteristic
{it:basename}{cmd:[}{it:charname}{cmd:]}
into local macro {it:macname}.

{p 8 12 2}
3. 
Ado-file programmers use the same function as Mata programmers to 
delete a characteristic:
{cmd:st_lchar(}{it:charname}{cmd:,} {it:basename}{cmd:, "")}
deletes "long" characteristic
{it:basename}{cmd:[}{it:charname}{cmd:]}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help mf_st_lchar##remarks1:Introduction}
        {help mf_st_lchar##remarks2:Example 1 -- Ado-file usage}
        {help mf_st_lchar##remarks3:Example 2 -- Mata usage}


{marker remarks1}{...}
{title:Introduction}

{p 4 4 2}
Stata macros can be longer than Stata dataset {help char:characteristics}.
The maximum length of a characteristic is 67,784 bytes.  Macros are
longer than that.  How much longer macros can be depends on
{help memory:maxvar} because maximum macro length is defined to be sufficient
to hold all the names in possible Stata datasets, with a space between, plus
some more.

{p 4 4 2}
In Stata/IC, the maximum number of variables is 2,048.
Variable names can be 32 Unicode characters, which can be as long as 128
bytes.  With a space between variable names, macros must allow at least
2,048*129 = 264,192 characters.

{p 4 4 2}
In Stata/MP, the maximum number of variables is 5,000 by default and
can be set up to 120,000.  Thus, the maximum length of macros must allow at
least 5,000*129 = 645,000 to 120,000*129 = 15,480,000 characters.  Yet, in all
of these cases, the maximum length of a characteristic remains fixed at 67,784
characters, meaning that saving all the variable names in one characteristic
is not generally possible.

{p 4 4 2}
In Stata/SE, the maximum number of variables is 5,000 by default
and can be set up to 32,767.  Thus, the maximum length of macros must allow at
least 5,000*129 = 645,000 to 32,767*129 = 4,226,943 characters.  Yet, in all
of these cases, the maximum length of a characteristic remains fixed at 67,784
characters, meaning that saving all the variable names in one characteristic
is not generally possible.

{p 4 4 2}
Programmers will sometimes want to save a varlist in a characteristic and the
varlist might be long.  Stata saves characteristics in the Stata {cmd:.dta}
dataset and programmers save information in characteristics when they are a
property of the dataset rather than of the current session or the current
analysis.  A program providing data certification, for instance, might need to
save the names of the variables so that those names could later be compared
with the current names to determine whether any variables had been added or
dropped.

{p 4 4 2}
These functions provide the solution to the different-length problem.
Think of these functions as creating, reading, and writing 
{it:basename}{cmd:[}{it:charname}{cmd:]}, even though
these functions in fact 
create, read, and write 
{it:basename}{cmd:[}{it:charname}{cmd:1]}, 
{it:basename}{cmd:[}{it:charname}{cmd:2]}, ..., using however many 
separate characteristics are necessary to store what needs to be stored.

{p 4 4 2}
For the Mata programmer, 
{cmd:st_lchar(}{it:charname}{cmd:,} {it:basename}{cmd:,} {it:s}{cmd:)}
saves {it:s} in 
{it:basename}{cmd:[}{it:charname}{cmd:1]}, 
{it:basename}{cmd:[}{it:charname}{cmd:2]}, ....
{cmd:st_lchar(}{it:charname}{cmd:,} {it:basename}{cmd:)}
returns what was previously set in
{it:basename}{cmd:[}{it:charname}{cmd:1]}, 
{it:basename}{cmd:[}{it:charname}{cmd:2]}, ....

{p 4 4 2}
For the Stata ado-file programmer, the same features are provided, 
except that values are obtained from and stored in local macros.
{cmd:ado_intolchar(}{it:basename}{cmd:,} {it:charname}{cmd:,}
{it:macname}{cmd:)} saves the contents of {it:macname}
into 
{it:basename}{cmd:[}{it:charname}{cmd:1]},
{it:basename}{cmd:[}{it:charname}{cmd:2]}, ....
{cmd:ado_fromlchar(}{it:macname}{cmd:,} 
{it:basename}{cmd:,}
{it:charname}{cmd:)} retrieves the contents of 
{it:basename}{cmd:[}{it:charname}{cmd:1]},
{it:basename}{cmd:[}{it:charname}{cmd:2]}, ..., and stores the 
result in {it:macname}.

{p 4 4 2}
In all of these functions, you do not have to keep track of how many 
characteristics are actually used.  Think of the functions and storing
in, fetching from, and deleting {it:basename}{cmd:[}{it:charname}{cmd:]},
even though that is not literally true
and, in fact, {it:basename}{cmd:[}{it:charname}{cmd:]} is never 
created.  The actual characteristics are 
{it:basename}{cmd:[}{it:charname}{cmd:1]}, 
{it:basename}{cmd:[}{it:charname}{cmd:2]}, ....


{marker remarks2}{...}
{title:Example 1 -- Ado-file usage}

{p 4 4 2}
In an ado-file, you want to save the contents of local macro {cmd:varlist} in
characteristic {cmd:_dta[datacert_vl]}.  Ordinarily you would code

		{cmd:char _dta[datacert_vl] `varlist'}

{p 4 4 2}
but you are worried that {cmd:`varlist'} might 
be too long for {cmd:_dta[datacert_vl]}.  The solution is to code

		{cmd:mata:  ado_intolchar("_dta", "datacert_vl", "varlist")}

{p 4 4 2}
There are no typographic errors in the above.  You pass the names of the 
entities -- including the macro -- and not their contents.

{p 4 4 2}
In another part of the code, you want to pull back into macro {cmd:baselist}
what was stored in {cmd:_dta[datacert_vl]}.  Ordinarily you would code

		{cmd:local baselist `_dta[datacert_vl]'}

{p 4 4 2}
but, because you used {cmd:st_intolchar()}, you must not do that.
Instead, you code

		{cmd:mata:  ado_fromlchar("baselist", "_dta", "datacert_vl")}

{p 4 4 2}
In yet another part of the program, you want to clear the characteristics.
To clear {cmd:_dta[datacert_vl]}, ordinarily you would code

		{cmd:char _dta[datacert_vl]}

{p 4 4 2}
but, because you used {cmd:st_intolchar()}, you must not do that.
Instead, you code

		{cmd:mata:  st_lchar("_dta", "datacert_vl", "")}


{marker remarks3}{...}
{title:Example 2 -- Mata usage}

{p 4 4 2}
In Mata code, you wish to set {cmd:_dta[datacert_vl]} to contain 
the contents of string scalar {cmd:s}.  You code

		{cmd:st_lchar("_dta", "datacert_vl", s)}

{p 4 4 2}
To read back into {cmd:s} what is stored in {cmd:_dta[datacert_vl]},
you code

		{cmd:s = st_lchar("_dta", "datacert_vl")}

{p 4 4 2}
To delete the characteristic {cmd:_dta[datacert_vl]}, you code

		{cmd:st_lchar("_dta", "datacert_vl", "")}


{marker conformability}{...}
{title:Conformability}

    {cmd:st_lchar(}{it:basename}{cmd:,} {it:charname}{cmd:,} {it:s}{cmd:)}:
	 {it:basename}:  1 {it:x} 1
	 {it:charname}:  1 {it:x} 1
		{it:s}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:st_lchar(}{it:basename}{cmd:,} {it:charname}{cmd:)}:
	 {it:basename}:  1 {it:x} 1
	 {it:charname}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:ado_intolchar(}{it:basename}{cmd:,} {it:charname}{cmd:,} {it:macname}{cmd:)}:
	 {it:basename}:  1 {it:x} 1
	 {it:charname}:  1 {it:x} 1
	  {it:macname}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:ado_fromlchar(}{it:macname}{cmd:,} {it:basename}{cmd:,} {it:charname}{cmd:)}:
	  {it:macname}:  1 {it:x} 1
	 {it:basename}:  1 {it:x} 1
	 {it:charname}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions abort with error if names are malformed.  Requesting the
contents of a characteristic that does not exist returns "".  If {it:s} is
stored in a characteristic and read back, the original spacing (lack of
blanks, multiple blanks, etc.) of {it:s} is preserved.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view st_lchar.mata, adopath asis:st_lchar.mata}
{p_end}
