{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog stbase "dialog stbase"}{...}
{vieweralsosee "[ST] stbase" "mansection ST stbase"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stfill" "help stfill"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "stbase##syntax"}{...}
{viewerjumpto "Menu" "stbase##menu"}{...}
{viewerjumpto "Description" "stbase##description"}{...}
{viewerjumpto "Links to PDF documentation" "stbase##linkspdf"}{...}
{viewerjumpto "Options" "stbase##options"}{...}
{viewerjumpto "Examples" "stbase##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] stbase} {hline 2}}Form baseline dataset{p_end}
{p2col:}({mansection ST stbase:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:stbase} {ifin} [{cmd:,} {it:options}]

{synoptset 14 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt at(#)}}convert single/multiple-record st data to cross-sectional dataset at time {it:#}{p_end}
{synopt :{opth g:ap(newvar)}}name of variable containing gap time; default is {opt gap} or {opt gaptime}{p_end}
{synopt :{opt replace}}overwrite current data in memory{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}

{synopt :{opt nopre:serve}}programmer's option; see
          {it:{help stbase##nopreserve:Options}} below{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:stset} your data before using {cmd:stbase}; see 
{manhelp stset ST}.{p_end}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s may be 
specified using {cmd:stset}; see {manhelp stset ST}.{p_end}
{p 4 6 2}{opt nopreserve} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities > Form baseline dataset}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stbase} without the {opt at()} option converts multiple-record st data
to st data with every variable set to its value at baseline, defined as the
earliest time at which each subject was observed.  {cmd:stbase} without
{opt at()} does nothing to single-record st data.

{pstd}
{cmd:stbase, at()} converts single- or multiple-record st data to a
cross-sectional dataset (not st data), recording the number of failures at the
specified time.  All variables are given their values at baseline -- the
earliest time at which each subject was observed.  In this form, single-failure
data could be analyzed by logistic regression and multiple-failure data by 
Poisson regression, for instance.

{pstd}
{cmd:stbase} can be used with single- or multiple-record or single- or 
multiple-failure st  data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stbaseQuickstart:Quick start}

        {mansection ST stbaseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt at(#)} changes what {cmd:stbase} does.  Without the
{opt at()} option, {cmd:stbase} produces another related st dataset.  With
the {opt at()} option, {cmd:stbase} produces a related cross-sectional dataset.

{phang}
{opth gap(newvar)} is allowed only with {opt at()}; it specifies the name of a 
new variable to be added to the data containing the amount of 
time the subject was not at risk after entering and before {it:#} as specified
in {opt at()}.  If {opt gap()} is not specified, the new variable will be named
{opt gap} or {opt gaptime}, depending on which name does not already exist in
the data.

{phang}
{opt replace} specifies that it is okay to change the data in memory,
even though the dataset has not been saved to disk in its current form.

{phang}
{opt noshow} prevents {cmd:stbase} from showing the key st variables.  This
option is rarely used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set once and for all whether they want to see these
variables mentioned at the top of the output of every st command; see 
{manhelp stset ST}. 

{pstd}
The following option is available with {cmd:stbase} but is not shown in the 
dialog box:

{phang}
{marker nopreserve}
{opt nopreserve} is for use by programmers using {cmd:stbase} as a
subroutine.  It specifies that {cmd:stbase} not preserve the original dataset 
so that it can be restored should an error be detected or should the user 
press {hi:Break}.  Programmers would specify this option if, in their program,
they had already preserved the original data.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfail}

{pstd}Display st settings{p_end}
{phang2}{cmd:. stset}

{pstd}Fit Cox proportional hazards model{p_end}
{phang2}{cmd:. stcox x1 x2}

{pstd}Form baseline dataset{p_end}
{phang2}{cmd:. stbase, replace}

{pstd}Fit Cox model again, using the values of {cmd:x1} and {cmd:x2} at
baseline{p_end}
{phang2}{cmd:. stcox x1 x2}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stbasexmpl, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, id(id) fail(death) time0(time0) exit(time .)}

{pstd}List the data{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Form baseline dataset{p_end}
{phang2}{cmd:. stbase, replace}

{pstd}List the data{p_end}
{phang2}{cmd:. list, sepby(id)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stbasexmpl2, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, id(id) fail(death) time0(time0)}

{pstd}List the data{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Form cross-sectional dataset recording the status of each subject at
time 5{p_end}
{phang2}{cmd:. stbase, at(5) replace}

{pstd}List the data{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}
