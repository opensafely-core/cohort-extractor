{smcl}
{* *! version 1.0.15  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi append" "mansection MI miappend"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] append" "help append"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi add" "help mi_add"}{...}
{vieweralsosee "[MI] mi merge" "help mi_merge"}{...}
{viewerjumpto "Syntax" "mi append##syntax"}{...}
{viewerjumpto "Menu" "mi append##menu"}{...}
{viewerjumpto "Description" "mi append##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_append##linkspdf"}{...}
{viewerjumpto "Options" "mi append##options"}{...}
{viewerjumpto "Remarks" "mi append##remarks"}{...}
{viewerjumpto "Stored results" "mi append##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi append} {hline 2}}Append mi data{p_end}
{p2col:}({mansection MI miappend:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi} {cmd:append} 
{cmd:using} {it:{help filename}}
[{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt:{opth gen:erate(newvar)}}create {it:newvar}; 0=master,
     1=using{p_end}
{synopt:{cmdab:nol:abel}}do not copy value labels from using{p_end}
{synopt:{cmdab:nonote:s}}do not copy notes from using{p_end}
{synopt:{cmd:force}}string <-> numeric not type mismatch error{p_end}

{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 8 2}
Notes:

{p 8 14 2}
    1.  Jargon:{break}
        master = data in memory{break}
        {bind: }using = data on disk ({it:filename})

{p 8 12 2}
    2.  Master must be {cmd:mi} {cmd:set};
        using may be {cmd:mi} {cmd:set}.

{p 8 12 2}
    3.  {cmd:mi} {cmd:append} is logically
        equivalent to {bf:{help append:append}}.
        The resulting data have {it:M} = max({it:M_master}, {it:M_using)}, 
        not their sum.  See {bf:{help mi_add:[MI] mi add}} to append
        imputations holding {it:m}=0 constant.

{p 8 12 2}
    4.  {cmd:mi} {cmd:append} syntactically differs from {cmd:append} in
        that multiple using files may not be specified and the
        {cmd:keep(}{it:varlist}{cmd:)} option is not allowed.

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
{cmd:mi} {cmd:append} is {cmd:append} for {cmd:mi} data;
see {bf:{help append:[D] append}} for a description of appending datasets.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miappendRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{opth generate(newvar)}
    specifies that new variable {it:newvar} be created containing 0 for
    observations from the master and 1 for observations from the using.

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
{cmd:force}
    allows string variables to be appended to numeric variables and 
    vice versa.  The results of such type mismatches are, of course, missing 
    values.  Default behavior is to issue an error message rather than 
    append datasets with such violently differing types.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Use {cmd:mi} {cmd:append} when you would use {cmd:append} if the data were not
{cmd:mi}.

{p 4 4 2}
Remarks are presented under the following headings:

	{it:{help mi_append##ex1:Adding new observations}}
        {it:{help mi_append##ex2:Adding new observations and imputations}}
	{it:{help mi_append##ex3:Adding new observations and imputations, M unequal}}
	{it:{help mi_append##treatment:Treatment of registered variables}}


{marker ex1}{...}
{title:Adding new observations}

{p 4 4 2}
Assume that 
file {cmd:mymi.dta} contains data on three-quarters of the patients in 
the ICU.  The data are {cmd:mi} {cmd:set} and {it:M}=5.  
File {cmd:remaining.dta} arrives containing the remaining patients.
The data are not {cmd:mi} {cmd:set}.  To combine the datasets, you type 

	. {cmd:use mymi, clear}

	. {cmd:mi append using remaining}

{p 4 4 2}
The original {cmd:mi} data had {it:M}=5 imputations, and so do the 
resulting data.  If the new data contain no missing values of the 
imputed variables, you are ready to go.  Otherwise, you will need to 
impute values for the new data.


{marker ex2}{...}
{title:Adding new observations and imputations}

{p 4 4 2}
Assume that file {cmd:westwing.dta} contains data on patients in the west wing
of the ICU.  File {cmd:eastwing.dta} contains data on patients in the east
wing of the ICU.  Both datasets are {cmd:mi} {cmd:set} with {it:M}=5.
You originally intended to analyze the datasets separately, but you now wish 
to combine them.  You type 

        . {cmd:use westwing, clear}

	. {cmd:mi append using eastwing}

{p 4 4 2}
The original data had {it:M}=5 imputations, and so do the resulting 
data.  

{p 4 4 2}
The data for {it:m}=0 are the result of running an ordinary {cmd:append} 
on the two {it:m}=0 datasets.

{p 4 4 2}
The data for {it:m}=1 are also the result of running an ordinary {cmd:append},
this time on the two {it:m}=1 datasets.  Thus the result is a combination of
observations of {cmd:westwing.dta} and {cmd:eastwing.dta} in the same way
that {it:m}=0 is.  Imputations for observations that previously existed 
are obtained from {cmd:westwing.dta}, and imputations for the newly 
appended observations are obtained from {cmd:eastwing.dta}.


{marker ex3}{...}
{title:Adding new observations and imputations, M unequal}

{p 4 4 2}
Consider the same situation as above, but this time assume {it:M}=5 
in {cmd:westwing.dta} and {it:M}=4 in {cmd:eastwing.dta}.  The combined result 
will still have {it:M}=5.  Imputed values in {it:m}=5 will be missing for 
imputed variables from observations in {cmd:westwing.dta}.


{marker treatment}{...}
{title:Treatment of registered variables}

{p 4 4 2}
It is possible that the two datasets will have variables registered
inconsistently.

{p 4 4 2}
Variables registered as imputed in either dataset will be registered as
imputed in the final result regardless of how they were registered (or
unregistered) in the other dataset.

{p 4 4 2}
Barring that, variables registered as passive in either dataset will be
registered as passive in the final result.

{p 4 4 2}
Barring that, variables registered as regular in either dataset will be 
registered as regular in the final result.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi append} stores the following in {cmd:r()}:

	Scalars
	    {cmd:r(N_master)}  number of observations in {it:m}=0 in master
	    {cmd:r(N_using)}   number of observations in {it:m}=0 in using
	    {cmd:r(M_master)}  number of imputations ({it:M}) in master
	    {cmd:r(M_using)}   number of imputations ({it:M}) in using 

	Macros
	    {cmd:r(newvars)}   new variables added

{p 4 4 2}
Thus values in the resulting data are 

	{it:N} = # of observations in {it:m}=0 
	  = {cmd:r(N_master) + r(N_using)}

	{it:k} = # of variables 
          = {it:k_master} {cmd:+ `:word count `r(newvars)''}

	{it:M} = # of imputations
          = {cmd:max(r(M_master), r(M_using))}
