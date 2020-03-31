{smcl}
{* *! version 1.0.17  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi merge" "mansection MI mimerge"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] merge" "help merge"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi append" "help mi_append"}{...}
{viewerjumpto "Syntax" "mi_merge##syntax"}{...}
{viewerjumpto "Menu" "mi_merge##menu"}{...}
{viewerjumpto "Description" "mi_merge##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_merge##linkspdf"}{...}
{viewerjumpto "Options" "mi_merge##options"}{...}
{viewerjumpto "Remarks" "mi_merge##remarks"}{...}
{viewerjumpto "Stored results" "mi_merge##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[MI] mi merge} {hline 2}}Merge mi data{p_end}
{p2col:}({mansection MI mimerge:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi} {cmd:merge} {cmd:1:1} 
{varlist} {cmd:using} {it:{help filename}} [{cmd:,} {it:options}]

{p 8 12 2}
{cmd:mi} {cmd:merge} {cmd:m:1} 
{varlist} {cmd:using} {it:{help filename}} [{cmd:,} {it:options}]

{p 8 12 2}
{cmd:mi} {cmd:merge} {cmd:1:m} 
{varlist} {cmd:using} {it:{help filename}} [{cmd:,} {it:options}]

{p 8 12 2}
{cmd:mi} {cmd:merge} {cmd:m:m} 
{varlist} {cmd:using} {it:{help filename}} [{cmd:,} {it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt:{cmdab:gen:erate(}{newvar}{cmd:)}}create {it:newvar} recording how
   observations matched{p_end}
{synopt:{cmdab:nol:abel}}do not copy value-label definitions from using{p_end}
{synopt:{cmdab:nonote:s}}do not copy notes from using{p_end}
{synopt:{cmdab:norep:ort}}do not display result summary table{p_end}
{synopt:{cmdab:force}}allow string/numeric variable type mismatch without error
{p_end}

{syntab:Results}
{synopt:{cmd:assert(}{it:results}{cmd:)}}require observations to match as
    specified{p_end}
{synopt:{cmd:keep(}{it:results}{cmd:)}}results to keep{p_end}

{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}
{p_end}
{synoptline}
{p2colreset}{...}


{p 4 8 2}
Notes:

{p 8 14 2}
1.  Jargon:{break}
    match variables = {it:varlist}, variables on which match performed{break}
    {bind:         }master = data in memory{break}
    {bind:          }using = data on disk ({it:filename})

{p 8 12 2}
2.  Master must be {cmd:mi} {cmd:set}; using may be {cmd:mi} {cmd:set}.

{p 8 12 2}
3.  {cmd:mi} {cmd:merge} is syntactically and logically equivalent to 
    {bf:{help merge:merge}}.  

{p 8 12 2}
4.  {cmd:mi} {cmd:merge} syntactically differs from {cmd:merge} 
    in that the {cmd:nogenerate}, {cmd:sorted}, {cmd:keepusing()}, 
    {cmd:update}, and {cmd:replace} options
    are not allowed.  Also, 
    no {cmd:_merge} variable is created unless the {cmd:generate()} option
    is specified.

{p 8 12 2}
5.  {it:filename} must be enclosed in double quotes if {it:filename}
    contains blanks or other special characters.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:merge} is {cmd:merge} for {cmd:mi} data;
see {bf:{help merge:[D] merge}} for a description of merging datasets.

{p 4 4 2}
It is recommended that the match variables ({varlist} in the syntax
diagram) not include imputed or passive variables, or any varying or
super-varying variables.  If they do, the values of the match variables in
{it:m}=0 will be used to control the merge even in {it:m}=1, {it:m}=2, ...,
{it:m}={it:M}.  Thus {it:m}=0, {it:m}=1, ..., {it:m}={it:M} will all be merged
identically, and there will continue to be a one-to-one correspondence between
the observations in {it:m}=0 with the observations in each of {it:m}>0.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mimergeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{p 4 8 2}
{cmd:generate(}{newvar}{cmd:)}
    creates new variable {it:newvar} containing the match status 
    of each observation in the resulting data.  The codes are 
    {cmd:1}, {cmd:2}, and {cmd:3} from the table below.

{p 4 8 2}
{cmd:nolabel}
    prevents copying the value-label definitions from the using data
    to the master.  Even if you do not specify this option, label definitions
    from the using never replace those of the master.

{p 4 8 2}
{cmd:nonotes}
    prevents any notes in the using from being incorporated into
    the master; see {bf:{help notes:[D] notes}}.

{p 4 8 2}
{cmd:noreport}
    suppresses the report that {cmd:mi} {cmd:merge} ordinarily presents.

{phang}
{opt force} allows string/numeric variable type mismatches, resulting in
missing values from the using dataset.  If omitted, {cmd:mi merge} issues an
error message; if specified, {cmd:mi merge} issues a warning message.

{dlgtab: Results}

{p 4 8 2}
{cmd:assert(}{it:results}{cmd:)}
    specifies how observations should match.  If results are not as you 
    expect, an error message will be issued and the master data 
    left unchanged.

            Code      Word           Description
           {hline 63}
              {cmd:1}       {cmdab:mas:ter}         observation appeared in master only
              {cmd:2}       {cmdab:us:ing}          observation appeared in using only
              {cmd:3}       {cmdab:mat:ch}          observation appeared in both
           {hline 63}
	   (Numeric codes and words are equivalent; you may use either.)

{p 8 8 2}
    {cmd:assert(match)} specifies that all observations 
    in both the master and the using are expected to match, and if that is not 
    so, an error message is to be issued.  
    {cmd:assert(match} {cmd:master)} means that all observations match 
    or originally appeared only in the master.
    See {bf:{help merge:[D] merge}} for more information.

{p 4 8 2}
{cmd:keep(}{it:results}{cmd:)}
    specifies which observations are to be kept from the merged dataset.
    {cmd:keep(match)} would specify that only matches are to be kept.
    
{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.
    

{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Use {cmd:mi} {cmd:merge} when you would use {cmd:merge} if the data were not
{cmd:mi}.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_merge##nonmi:Merging with non-mi data}
	{help mi_merge##mi:Merging with mi data}
	{help mi_merge##overlap:Merging with mi data containing overlapping variables}


{marker nonmi}{...}
{title:Merging with non-mi data}

{p 4 4 2}
Assume that 
file {cmd:ipats.dta} contains data on the patients in the ICU of a
local hospital.  The data are {cmd:mi} {cmd:set}, {it:M}=5, and missing
values have been imputed.  File {cmd:nurses.dta} contains information 
on nurses and is not {cmd:mi} data.  You wish to add the 
relevant nurse information to each patient.  Type

	. {cmd:use ipats, clear}
	. {cmd:mi merge m:1 nurseid using nurses, keep(master)}

{p 4 4 2}
The resulting data are still {cmd:mi} {cmd:set} with {it:M}=5.  The 
new variables are unregistered.


{marker mi}{...}
{title:Merging with mi data}

{p 4 4 2}
Now assume the same
situation as above except this time {cmd:nurses.dta} is
{cmd:mi} data.  Some of the nurse variables have missing values, and those
values have been imputed.  {it:M} is 6.  To combine the datasets, you type the
same as you would have typed before: 

	. {cmd:use ipats, clear}
	. {cmd:mi merge m:1 nurseid using nurses, keep(master)}

{p 4 4 2}
Remember, {it:M}=5 in {cmd:ipats.dta} and {it:M}=6 in {cmd:nurses.dta}.
The resulting data have {it:M}=6, the larger value.  There are missing values 
in the patient variables in {it:m}=6, so we need to either impute 
them or drop the extra imputation by typing {cmd:mi} {cmd:set} {cmd:M} 
{cmd:=} {cmd:5}.


{marker overlap}{...}
{title:Merging with mi data containing overlapping variables}

{p 4 4 2}
Now assume the situation as directly above
but this time
{cmd:nurses.dta} contains variables other than 
{cmd:nurseid} that also appear in {cmd:ipats.dta}.  Such variables --
variables in common that are not used as matching variables -- are 
called overlapping variables.  
Assume {cmd:seniornurse} is such a variable.
Let's imagine that {cmd:seniornurse} has no missing 
values and is unregistered in {cmd:ipats.dta}, but does have missing 
values and is registered as imputed in {cmd:nurses.dta}.

{p 4 4 2}
You will want {cmd:seniornurse} registered as imputed if merging
{cmd:nurses.dta} adds new observations that have {cmd:seniornurse} equal to
missing.  On the other hand, if none of the added observations has
{cmd:seniornurse} equal to missing, then you will want the variable left
unregistered.
And that is exactly what {cmd:mi} {cmd:merge} does.
That is, 

{p 8 12 2}
o  Variables unique to the master will be registered according to 
    how they were registered in the master.

{p 8 12 2}
o  Variables unique to the using will be registered according 
    to how they were registered in the using.

{p 8 12 2}
o  Variables that overlap will be registered according to how they 
    were in the master if there are no unmatched using observations in 
    the final result. 

{p 8 12 2}
o  If there are such unmatched using observations in the final result, 
    then the unique variables that do not contain missing in the
    unmatched-and-kept observations will be registered according to how they
    were registered in the master.  So will all variables registered as imputed
    in the master.

{p 8 12 2}
o  Variables that do contain missing in the unmatched-and-kept observations
    will be registered as imputed if they were registered as imputed in the
    using data or as passive if they were registered as passive in the using
    data.

{p 4 4 2}
Thus variables might be registered differently if we typed 

	. {cmd:mi merge m:1 nurseid using nurses, keep(master)}

{p 4 4 2}
rather than 

	. {cmd:mi merge m:1 nurseid using nurses, gen(howmatch)}
	. {cmd:keep if howmatch==3}

{p 4 4 2}
If you want to keep the matched observations, it is better to specify
{cmd:merge}'s {cmd:keep()} option.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi merge} stores the following in {cmd:r()}:

	Scalars
	    {cmd:r(N_master)}	number of observations in {it:m}=0 in master
	    {cmd:r(N_using)}	number of observations in {it:m}=0 in using
	    {cmd:r(N_result)}	number of observations in {it:m}=0 in result

	    {cmd:r(M_master)}	number of imputations ({it:M}) in master
	    {cmd:r(M_using)}	number of imputations ({it:M}) in using 
	    {cmd:r(M_result)}	number of imputations ({it:M}) in result 

	Macros
	    {cmd:r(newvars)}        new variables added

{p 4 4 2}
Thus values in the resulting data are 

	{it:N} = # of observations in {it:m}=0 
	  = {cmd:r(N_result)}

	{it:k} = # of variables 
          = {it:k_master} {cmd:+ `:word count `r(newvars)''}

	{it:M} = # of imputations
          = {cmd:max(r(M_master), r(M_using))}
          = {cmd:r(M_result)}
