{smcl}
{* *! version 1.0.16  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi passive" "mansection MI mipassive"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi reset" "help mi_reset"}{...}
{vieweralsosee "[MI] mi xeq" "help mi_xeq"}{...}
{viewerjumpto "Syntax" "mi_passive##syntax"}{...}
{viewerjumpto "Menu" "mi_passive##menu"}{...}
{viewerjumpto "Description" "mi_passive##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_passive##linkspdf"}{...}
{viewerjumpto "Options" "mi_passive##options"}{...}
{viewerjumpto "Remarks" "mi_passive##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi passive} {hline 2}}Generate/replace and register passive
     variables{p_end}
{p2col:}({mansection MI mipassive:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:mi} {opt pas:sive}{cmd::}
{c -(}{helpb generate:{ul:g}enerate}
|
{bf:{help egen}}
|
{bf:{help replace}}{c )-} ...

{p 8 16 2}
{cmd:mi} {opt pas:sive}{cmd::} {cmd:by} {varlist}{cmd::}
{c -(}{helpb generate:{ul:g}enerate}
|
{bf:{help egen}}
|
{bf:{help replace}}{c )-} ...


{p 4 4 2}
The full syntax is

{p 8 16 2}
{cmd:mi} {opt pas:sive}[{cmd:,} {it:options}]{cmd::} [{cmd:by}
{varlist} [{cmd:(}{varlist}{cmd:)}]{cmd::}]
{p_end}
{right:{c -(}{helpb generate:{ul:g}enerate} | {bf:{help egen}} | {bf:{help replace}}{c )-} ...}

{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}

{synopt:{cmd:nopreserve}}do not first {cmd:preserve}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 4 2}
Also see {bf:{help generate:[D] generate}} and {bf:{help egen:[D] egen}}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:passive} creates and registers passive variables or replaces
the contents of existing passive variables.

{p 4 4 2}
More precisely, 
{cmd:mi} {cmd:passive} executes the specified {cmd:generate}, {cmd:egen}, or
{cmd:replace} command on each of {it:m}=0, {it:m}=1, ..., {it:m}={it:M};
see {manhelp generate D}, {manhelp egen D}, and {manhelp replace D}.
If the command is {cmd:generate} or {cmd:egen}, then
{cmd:mi} {cmd:passive} registers the new variable as passive.
If the command is {cmd:replace}, then {cmd:mi} {cmd:passive}
verifies that the variable is already registered as passive.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mipassiveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.

{p 4 8 2}
{cmd:nopreserve} is a programmer's option.  It specifies that
    {cmd:mi} {cmd:passive} is not to {cmd:preserve} the data if 
    it ordinarily would.  This is used by programmers who have 
    already preserved the data before calling {cmd:mi} {cmd:passive}.
 

{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

        {help mi_passive##basics:mi passive basics}
	{help mi_passive##by:mi passive works with the by prefix}
	{help mi_passive##wide:mi passive works fastest with the wide style}
	{help mi_passive##varying:mi passive and super-varying variables}
	{help mi_passive##renaming:Renaming passive variables}
	{help mi_passive##dropping:Dropping passive variables}
	{help mi_passive##recreating:Update passive variables when imputed values change}
	{help mi_passive##alternatives:Alternatives to mi passive}


{marker basics}{...}
{title:mi passive basics}

{p 4 4 2}
A passive variable is a variable that is a function of imputed variables or of
other passive variables.  For instance, if variable {cmd:age} were imputed and
you created {cmd:lnage} from it, the {cmd:lnage} variable would be passive.
The right way to create {cmd:lnage} is to type

	. {cmd:mi passive: generate lnage = ln(age)}

{p 4 4 2}
Simply typing 

	. {cmd:generate lnage = ln(age)} 

{p 4 4 2}
is not sufficient because that would create {cmd:lnage} in the 
{it:m}=0 data, and {cmd:age}, being imputed, varies across {it:m}.  There are
situations where omitting the {cmd:mi} {cmd:passive} prefix would be almost
sufficient, namely, when the data are mlong or flong style, but even then
you would need to follow up by typing {cmd:mi} {cmd:register}
{cmd:passive} {cmd:lnage}. 

{p 4 4 2}
To create passive variables or to change the values of existing passive
variables, use {cmd:mi} {cmd:passive}.  Passive variables cannot be
super-varying; see 
{help mi_passive##varying:mi passive and super-varying variables}.


{marker by}{...}
{title:mi passive works with the by prefix}

{p 4 4 2}
You can use {cmd:mi} {cmd:passive} with the {cmd:by} prefix.  For instance, 
you can type 

        . {cmd:mi passive: by person: generate totaltodate = sum(amount)}

{p 4 4 2}
or 

	. {cmd:mi passive: by sex: egen avg = mean(income)}

{p 4 4 2}
You do not need to sort the data before issuing either of these commands, 
nor are you required to specify {cmd:by}'s {cmd:sort} option.  {cmd:mi}
{cmd:passive} handles sorting issues for you.

{p 4 4 2}
Use {cmd:by}'s parenthetical syntax to specify the order within {cmd:by}, 
if that is necessary.  For instance, 

	. {cmd:mi passive: by person (time): generate lastamount = amount[_n-1]}

{p 4 4 2}
Do not omit the parenthetical {cmd:time} and instead attempt to sort the data
yourself:

	. {cmd:sort person time}
	. {cmd:mi passive: by person: generate lastamount = amount[_n-1]}

{p 4 4 2}
Sorting the data yourself will work if your data happen to be wide style;
it will not work in general.


{marker wide}{...}
{title:mi passive works fastest with the wide style}

{p 4 4 2}
{cmd:mi} {cmd:passive} works with any {help mi_glossary##def_style:style}, 
but it works
fastest when then data are wide style.  If you are going to issue multiple 
{cmd:mi} {cmd:passive} commands, you can usually speed execution by 
first converting your data to the wide style;
see {bf:{help mi_convert:[MI] mi convert}}.


{marker varying}{...}
{title:mi passive and super-varying variables}

{pstd}
You should be careful not to mistakenly use {cmd:mi} {cmd:passive} to create
{help mi_glossary##def_varying:super-varying variables}.
Super-varying variables cannot be passive variables because the values of a
super-varying variable differ not only in the incomplete observations but also
in the complete observations across imputations.

{pstd}
As noted in {manhelp mi_set MI:mi set}, super-varying variables should never
be registered.  If a super-varying variable is registered as passive, it will
be converted to a {help mi_glossary##def_varying:varying variable}.  All
complete observations of the super-varying variable in each imputation will be
replaced with their values from {it:m}=0.

{pstd}
{cmd:mi} {cmd:passive} registers the created variable as passive.  Even if the
command you use with {cmd:mi} {cmd:passive} creates a super-varying variable,
{cmd:mi} {cmd:passive} will convert it to varying, as described above.

{pstd}
You can use {cmd:mi} {cmd:passive} with any function that produces values that
solely depend on values within the observation.  In general, you cannot use
{cmd:mi} {cmd:passive} with functions that produce values that depend on
groups of observations.

{pstd}
For example, most {cmd:egen} functions result in super-varying variables.  In
such cases, you should use {cmd:mi} {cmd:xeq:} {cmd:egen} to create them and
leave them unregistered; see {manhelp mi_xeq MI:mi xeq}.  You might thus
conclude that you should never use {cmd:mi} {cmd:passive} with {cmd:egen}.
That is not true, but it is nearly true.  You may use {cmd:mi} {cmd:passive}
with {cmd:egen}'s {cmd:rowmean()} function, for instance, because it produces
values that depend only on one observation at a time.


{marker renaming}{...}
{title:Renaming passive variables}

{p 4 4 2}
Use {bf:{help mi_rename:mi rename}} to rename all variables, not just 
passive variables:

        . {cmd:mi rename} {it:oldname} {it:newname}

{p 4 4 2}
{helpb rename} is insufficient for renaming passive variables regardless
of the style of your data.


{marker dropping}{...}
{title:Dropping passive variables}

{p 4 4 2}
Use {helpb drop} command to drop variables (or observations), 
but run 
{bf:{help mi_update:mi update}} afterward.

	. {cmd:drop} {it:var_or_vars}

	. {cmd:mi update}

{p 4 4 2}
This advice applies for all variables, not just passive ones.


{marker recreating}{...}
{title:Update passive variables when imputed values change}

{p 4 4 2}
Passive variables are not automatically updated when the values of the 
underlying imputed variables change.

{p 4 4 2}
If imputed values change or if you add more imputations, you must update
or re-create the passive variables.  If you have several passive variables, we
suggest you make a do-file to create them.  You can run
the do-file again whenever necessary.  A do-file to create {cmd:lnage} and
{cmd:totaltodate} might read

	{hline 39} begin cr_passive.do {hline 4}
	{cmd:use} {it:mydata}{cmd:, clear}

	{cmd:capture drop lnage}
	{cmd:capture drop totaltodate}
	{cmd:mi update}

	{cmd:mi passive: generate lnage = ln(age)}
        {cmd:mi passive: by person (time): generate totaltodate = sum(amount)}
	{hline 39} end cr_passive.do {hline 6}


{marker alternatives}{...}
{title:Alternatives to mi passive}

{p 4 4 2}
{cmd:mi} {cmd:passive} can run any {cmd:generate}, {cmd:replace}, or 
{cmd:egen} command.
If that is not sufficient to create the variable you need, you will have 
to create the variable for yourself.  Here is how you do that:

{p 8 12 2}
1.  If your data are wide or mlong, use 
    {bf:{help mi_convert:mi convert}} to convert them to one of the fully 
    long styles, flong or flongsep, and then continue with the appropriate
    step below.

{p 8 12 2}
2.  If your data are flong, {cmd:mi} system variable {cmd:_mi_m} 
    records {it:m}.  Create your new variable by using standard Stata commands, 
    but do that {cmd:by} {cmd:_mi_m}.  After creating the variable, 
    {cmd:mi} {cmd:register} it as passive;
    see {bf:{help mi_set:[MI] mi set}}.

{p 8 12 2}
3.  If your data are flongsep, create the new variable in each of the 
    {it:m}=0, {it:m}=1, ..., {it:m}={it:M} datasets, and then register 
    the result.  Start by working with a copy of your data:

		. {cmd:mi copy} {it:newname}

{p 12 12 2}
    The data in memory at this point correspond to {it:m}=0.  Create 
    the new variable and then save the data:

		. {it:(create new_variable)}

		. {cmd:save} {it:newname}{cmd:, replace}

{p 12 12 2}
    Now use the {it:m}=1 data and repeat the process: 

		. {cmd:use _1_}{it:newname}

		. {it:(create new_variable)}
		
		. {cmd:save _1_}{it:newname}{cmd:, replace}

{p 12 12 2}
    Repeat for {it:m}=2, {it:m}=3, ..., {it:m}={it:M}.  

{p 12 12 2}
    At this point, the new variable is created but not yet registered.
    Reload the original {it:m}=0 data, register the new variable as
    passive, and run {bf:{help mi_update:mi update}}:

		. {cmd:use} {it:newname}

		. {cmd:register passive} {it:new_variable}

		. {cmd:mi update}

{p 12 12 2}
     Finally, copy the result back to your original flongsep data,

		. {cmd:mi copy} {it:name}{cmd:, replace}

{p 12 12 2}
     or if you started with mlong, flong, or wide data, then convert the data 
     back to your preferred style:

		. {cmd:mi convert} {it:original_style}

{p 12 12 2}
     Either way, erase the {it:newname} flongsep dataset collection:

		. {cmd:mi erase} {it:newname}

{p 4 4 2}
The third procedure can be tedious and error-prone if {it:M} is large.
We suggest that you make a do-file to create the variable and then 
run it on each of the {it:m}=0, {it:m}=1, ..., {it:m}={it:M} datasets:

	. {cmd:mi copy} {it:newname}

	. {cmd:do} {it:mydofile}

	. {cmd:save} {it:newname}{cmd:, replace}

	. {cmd:forvalues m=1(1)20 {c -(}}             // we assume {it:M}=20
	>    {cmd:use _`m'_}{it:newname}
	>    {cmd:do} {it:mydofile}
        >    {cmd:save _`m'_}{it:newname}{cmd:, replace}
        > {cmd:{c )-}}

	. {cmd:use} {it:newname}

	. {cmd:register passive} {it:new_variable}

	. {cmd:mi update}
