{smcl}
{* *! version 1.0.0  30apr2019}{...}
{viewerdialog cmsample "dialog cmsample"}{...}
{vieweralsosee "[CM] cmsample" "mansection CM cmsample"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmchoiceset" "help cmchoiceset"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] cmsummarize" "help cmsummarize"}{...}
{vieweralsosee "[CM] cmtab" "help cmtab"}{...}
{viewerjumpto "Syntax" "cmsample##syntax"}{...}
{viewerjumpto "Menu" "cmsample##menu"}{...}
{viewerjumpto "Description" "cmsample##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmsample##linkspdf"}{...}
{viewerjumpto "Options" "cmsample##options"}{...}
{viewerjumpto "Examples" "cmsample##examples"}{...}
{viewerjumpto "Stored results" "cmsample##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[CM] cmsample} {hline 2}}Display reasons for sample exclusion{p_end}
{p2col:}({mansection CM cmsample:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmsample}
[{varlist}] {ifin}
[{help cmsample##weight:{it:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:varlist} is a list of alternative-specific numeric variables.

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt choice(choicevar)}}0/1 variable indicating the chosen
alternatives{p_end}
{synopt :{cmdab:casev:ars(}{varlist}_c{cmd:)}}case-specific variables{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}
{synopt :{opt ranks}}allow {it:choicevar} to be ranks{p_end}
{synopt :{cmdab:gen:erate(}{newvar}[{cmd:, replace}]{cmd:)}}create new variable
containing reasons for omitting observations and for error messages;
optionally replace existing variable{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmsample}; see
{manhelp cmset CM}.{p_end}
{p 4 6 2}
{it:varlist} and {it:varlist}_c may contain factor variables; see
{help fvvarlists}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see {help weights}.
Weights are checked for missing values and other errors but are not used for 
the tabulation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Setup and utilities > Display reasons for sample exclusion}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmsample} displays a table with the reasons why observations in a
choice model were dropped from the estimation sample.  It also flags
choice-model data errors, such as errors in the alternatives variable, 
dependent variable, or case-specific variables.  With the use of its
{cmd:generate()} option, observations that were dropped or led to an
error message can be identified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmsampleQuickstart:Quick start}

        {mansection CM cmsampleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt choice(choicevar)} specifies a 0/1 variable indicating the 
chosen alternatives.  Typically, it is a dependent variable in the 
choice model.

{phang}
{cmd:casevars(}{varlist}_c{cmd:)} specifies case-specific numeric variables.
These are variables that are constant for each case.

{phang}
{cmd:altwise} specifies that alternativewise deletion be used when omitting
observations due to missing values in your variables.  The default is to use
casewise deletion; that is, the entire group of observations making up a case
is omitted if any missing values are encountered.  This option does not apply
to observations that are excluded by the {cmd:if} or {cmd:in} qualifier; these
observations are always handled alternativewise regardless of whether
{cmd:altwise} is specified.

{phang}
{cmd:ranks} allows {it:choicevar} to be ranks.  Any numeric value 
in {it:choicevar} is allowed.

{phang}
{cmd:generate(}{newvar}[{cmd:, replace}]{cmd:)}
creates a new variable containing categories of the reasons for omitting
observations and for error messages.  The variable {it:newvar} is numeric and
potentially valued 0, 1, 2, ..., 16.  The value 0 indicates the observation is
to be included in the estimation sample.  The values 1-16 indicate cases and
observations that were either marked out or would generate error messages.
See the
{mansection CM cmsampleRemarksandexamplesmiss_category:table of reasons for omitting observations and error messages} 
for the list of values and their meaning.  Specifying {cmd:replace} allows any
existing variable named {it:newvar} to be replaced.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}
{phang2}{cmd:. set seed 1}{p_end}
{phang2}{cmd:. replace dealers = . if runiform() < 0.05}{p_end}

{pstd}Display reasons observations will be excluded with casewise deletion (the default){p_end}
{phang2}{cmd:. cmsample dealers, choice(purchase)}{p_end}

{pstd}Display reasons observations will be excluded with alternativewise deletion{p_end}
{phang2}{cmd:. cmsample dealers, choice(purchase) altwise}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice_missing, clear}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}An error message is produced with {cmd:cmset}; 
rerun the command with the {cmd:force} option{p_end}
{phang2}{cmd:. cmset consumerid car, force}{p_end}

{pstd}Display reason for error message and why cases will be dropped{p_end}
{phang2}{cmd:. cmsample}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmsample} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations both included and excluded{p_end}
{synopt :{cmd:r(N_included)}}number of observations included{p_end}
{synopt :{cmd:r(nc_included)}}number of cases included{p_end}
{synopt :{cmd:r(N_ex_if_in)}}number of observations excluded by {cmd:if} or
{cmd:in}{p_end}
{synopt :{cmd:r(N_ex_caseid)}}number of observations excluded: case ID
variable missing{p_end}
{synopt :{cmd:r(N_ex_size_1)}}number of observations excluded because of
choice sets of size 1{p_end}
{synopt :{cmd:r(nc_ex_size_1)}}number of cases excluded because of choice
sets of size 1{p_end}
{synopt :{cmd:r(N_ex_altvar)}}number of observations excluded because
alternatives variable missing{p_end}
{synopt :{cmd:r(nc_ex_altvar)}}number of cases excluded because alternatives
variable missing{p_end}
{synopt :{cmd:r(N_err_altvar)}}number of observations with repeated
alternatives within case (error){p_end}
{synopt :{cmd:r(nc_err_altvar)}}number of cases with repeated alternatives
within case (error){p_end}
{synopt :{cmd:r(N_ex_varlist)}}number of observations excluded because {it:varlist} missing{p_end}
{synopt :{cmd:r(nc_ex_varlist)}}number of cases excluded because {it:varlist}
missing{p_end}
{synopt :{cmd:r(N_ex_wt)}}number of observations excluded because weight
missing{p_end}
{synopt :{cmd:r(nc_ex_wt)}}number of cases excluded because weight
missing{p_end}
{synopt :{cmd:r(N_err_wt_nc)}}number of observations with weight not constant
within case (error){p_end}
{synopt :{cmd:r(nc_err_wt_nc)}}number of cases with weight not constant
within case (error){p_end}
{synopt :{cmd:r(N_ex_choice)}}number of observations excluded because {it:choicevar} missing{p_end}
{synopt :{cmd:r(nc_ex_choice)}}number of cases excluded because {it:choicevar} missing{p_end}
{synopt :{cmd:r(N_ex_choice_0)}}number of observations excluded because {it:choicevar} all 0 for case{p_end}
{synopt :{cmd:r(nc_ex_choice_0)}}number of cases excluded because {it:choicevar} all 0 for case{p_end}
{synopt :{cmd:r(N_ex_choice_1)}}number of observations excluded because {it:choicevar} all 1 for case{p_end}
{synopt :{cmd:r(nc_ex_choice_1)}}number of cases excluded because {it:choicevar} all 1 for case{p_end}
{synopt :{cmd:r(N_ex_choice_011)}}number of observations excluded because
{it:choicevar} has multiple 1s for case{p_end}
{synopt :{cmd:r(nc_ex_choice_011)}}number of cases excluded because {it:choicevar} has multiple 1s for case{p_end}
{synopt :{cmd:r(N_err_choice)}}number of observations with {it:choicevar} not
0/1 (error){p_end}
{synopt :{cmd:r(nc_err_choice)}}number of cases with {it:choicevar} not 0/1
(error){p_end}
{synopt :{cmd:r(N_ex_casevar)}}number of observations excluded because {it:casevars} missing{p_end}
{synopt :{cmd:r(nc_ex_casevar)}}number of cases excluded because {it:casevars} missing{p_end}
{synopt :{cmd:r(N_err_casevar_nc)}}number of observations with {it:casevars}
not constant within case (error){p_end}
{synopt :{cmd:r(nc_err_casevar_nc)}}number of cases with {it:casevars} not
constant within case (error){p_end}
{synopt :{cmd:r(N_ex_time)}}number of observations excluded because {it:timevar} missing{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt :{cmd:r(caseid)}}name of case ID variable{p_end}
{synopt :{cmd:r(altvar)}}name of alternatives variable (if set){p_end}
{synopt :{cmd:r(timevar)}}name of time variable (if panel data){p_end}
{synopt :{cmd:r(marktype)}}{cmd:casewise} or {cmd:altwise}, type of
markout{p_end}
{p2colreset}{...}
