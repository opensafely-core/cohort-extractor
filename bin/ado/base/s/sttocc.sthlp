{smcl}
{* *! version 1.1.9  19sep2018}{...}
{viewerdialog sttocc "dialog sttocc"}{...}
{vieweralsosee "[ST] sttocc" "mansection ST sttocc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stbase" "help stbase"}{...}
{vieweralsosee "[ST] stdescribe" "help stdescribe"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stsplit" "help stsplit"}{...}
{viewerjumpto "Syntax" "sttocc##syntax"}{...}
{viewerjumpto "Menu" "sttocc##menu"}{...}
{viewerjumpto "Description" "sttocc##description"}{...}
{viewerjumpto "Links to PDF documentation" "sttocc##linkspdf"}{...}
{viewerjumpto "Options" "sttocc##options"}{...}
{viewerjumpto "Examples" "sttocc##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] sttocc} {hline 2}}Convert survival-time data to case-control data{p_end}
{p2col:}({mansection ST sttocc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:sttocc} [{varlist}] [{cmd:,} {it:options}]


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt m:atch(matchvarlist)}}match cases and controls on analysis time and specified categorical variables; default is to match on analysis time only{p_end}
{synopt :{opt n:umber(#)}}use {it:#} controls for each case; default is {cmd:number(1)}{p_end}
{synopt :{opt nodot:s}}suppress displaying dots during calculation{p_end}

{syntab:Options}
{synopt :{opt gen:erate(case set time)}}new variable names; default is {cmd:_case}, {cmd:_set}, and {cmd:_time}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:sttocc}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified
using {cmd:stset}; see {manhelp stset ST}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
      {bf:Convert survival-time data to case-control data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sttocc} generates a nested case-control study dataset from a cohort-study
dataset by sampling controls from the risk sets.  For each case, the controls
are chosen randomly from those members of the cohort who are at risk at the
failure time of the case.  That is, the resulting case-control sample is
matched with respect to analysis time -- the time scale used to compute risk
sets. The following variables are added to the dataset:

{p2colset 9 18 20 2}{...}
{p2col:{cmd:_case}}coded 0 for controls, 1 for cases{p_end}
{p2col:{cmd:_set}}case-control ID; matches cases and controls that belong
together{p_end}
{p2col:{cmd:_time}}analysis time of the case's failure{p_end}
{p2colreset}{...}

{pstd}
The names of these three variables can be changed by specifying the
{cmd:generate()} option.  {varlist} defines variables that, in addition
to those used in the creation of the case-control study, will be
retained in the final dataset. If {it:varlist} is not specified, all
variables are carried over into the resulting dataset.

{pstd}
When the resulting dataset is analyzed as a matched case-control
study, odds ratios will estimate corresponding rate-ratio parameters in the
proportional hazards model for the cohort study.

{pstd}
Randomness in the matching is obtained using Stata's {helpb runiform()}
function.  To ensure that the sample truly is random, you should set the
random-number seed; see {manhelp set_seed R:set seed}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST sttoccQuickstart:Quick start}

        {mansection ST sttoccRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt match(matchvarlist)} specifies more categorical variables for
matching controls to cases.  When {opt match()} is not specified, cases and
controls are matched with respect to time only.  If {opt match(matchvarlist)}
is specified, the cases will also be match by {it:matchvarlist}.

{phang}
{opt number(#)} specifies the number of controls to draw for each case.  The
default is 1, even though this is not a sensible choice.

{phang}
{opt nodots} requests that dots not be placed on the screen at the beginning
of each case-control group selection. By default, dots are displayed to
show progress.

{dlgtab:Options}

{phang}
{opt generate(case set time)} specifies variable names for the three
new variables; the default is {cmd:_case}, {cmd:_set}, and {cmd:_time}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dox, failure(fail) enter(time doe) id(id)}
             {cmd:origin(time dob) scale(365.25)}

{pstd}Convert survival-time data to case-control data, matching cases and
controls on both time and {cmd:job}{p_end}
{phang2}{cmd:. sttocc, match(job)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet, clear}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dox, failure(fail) enter(time doe) id(id)}
              {cmd:origin(time dob) scale(365.25)}

{pstd}Convert survival-time data to case-control data, matching cases and
controls on both time and {cmd:job} and using 5 controls for each case{p_end}
{phang2}{cmd:. sttocc, match(job) n(5)}{p_end}
    {hline}
