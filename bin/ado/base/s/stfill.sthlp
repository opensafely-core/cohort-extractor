{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog stfill "dialog stfill"}{...}
{vieweralsosee "[ST] stfill" "mansection ST stfill"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stbase" "help stbase"}{...}
{vieweralsosee "[ST] stgen" "help stgen"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stvary" "help stvary"}{...}
{viewerjumpto "Syntax" "stfill##syntax"}{...}
{viewerjumpto "Menu" "stfill##menu"}{...}
{viewerjumpto "Description" "stfill##description"}{...}
{viewerjumpto "Links to PDF documentation" "stfill##linkspdf"}{...}
{viewerjumpto "Options" "stfill##options"}{...}
{viewerjumpto "Examples" "stfill##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] stfill} {hline 2}}Fill in by carrying forward values of covariates{p_end}
{p2col:}({mansection ST stfill:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmd:stfill} {varlist} {ifin} {cmd:,}
	{c -(}{opt b:aseline}|{opt f:orward}{c )-} [{it:options}]

{synoptset 13 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {opt b:aseline}}replace with values at baseline{p_end}
{p2coldent :* {opt f:orward}}carry forward values{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} * Either {opt baseline} or {opt forward} is required.{p_end}
{p 4 6 2} You must {cmd:stset} your data before using {cmd:stfill}; see
{manhelp stset ST}.{p_end}
{p 4 6 2} {opt fweight}s, {opt iweight}s, and {opt pweights} may be specified using {cmd:stset}; see {manhelp stset ST}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
        {bf:Fill forward with values of covariates}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stfill} is intended for use with multiple-record st data for which
{opt id()} has been {cmd:stset}.  {cmd:stfill} may be used with single-record
data, but it does nothing.  That is, {cmd:stfill} can be used with
multiple-record or single- or multiple-failure st data.

{pstd}
{cmd:stfill, baseline} changes variables to contain the value at the
earliest time each subject was observed, making the variable constant over
time.  {cmd:stfill, baseline} changes all subsequent values of the specified
variables to equal the first value, whether they originally contained missing
or not.

{pstd}
{cmd:stfill, forward} fills in missing values of each variable with that of
the most recent time at which the variable was last observed.  
{cmd:stfill, forward} changes only missing values.

{pstd}
You must specify either the {opt baseline} or the {opt forward} option.

{pstd}
{opt if} {it:exp} and {opt in} {it:range} operate slightly differently from
their usual definitions to work as you would expect.  {opt if} and {opt in} 
restrict where changes can be made to the data, but no matter what, all 
{cmd:stset} observations are used to provide the values to be carried forward. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stfillQuickstart:Quick start}

        {mansection ST stfillRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt baseline} specifies that values be replaced with the values at baseline, 
the earliest time at which the subject was observed.  All values of the 
specified variables are replaced, missing and nonmissing.

{phang}
{opt forward} specifies that values be carried forward and that previously 
observed, nonmissing values be used to fill in later values that are missing 
in the specified variables.

{phang}
{opt noshow} prevents {cmd:stfill} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mrecord}

{pstd}Prevent other st commands from showing st setting information{p_end}
{phang2}{cmd:. stset, noshow}

{pstd}Report whether variable {cmd:sex} varies over time and whether it is
missing{p_end}
{phang2}{cmd:. stvary sex}

{pstd}Fix problems with {cmd:sex} variable by changing {cmd:sex} to contain
the value at the earliest time{p_end}
{phang2}{cmd:. stfill sex, baseline}

{pstd}Report whether variable {cmd:sex} varies over time and whether it is
missing{p_end}
{phang2}{cmd:. stvary sex}

{pstd}Report whether variable {cmd:bp} varies over time and whether it is
missing{p_end}
{phang2}{cmd:. stvary bp}

{pstd}Fill in missing values of {cmd:bp} with the previous value of {cmd:bp}
{p_end}
{phang2}{cmd:. stfill bp, forward}

{pstd}Report whether {cmd:bp} varies over time and whether it is
missing{p_end}
{phang2}{cmd:. stvary bp}{p_end}
