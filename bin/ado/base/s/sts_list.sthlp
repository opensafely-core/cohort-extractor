{smcl}
{* *! version 1.2.14  19sep2018}{...}
{viewerdialog "sts list" "dialog sts_list"}{...}
{vieweralsosee "[ST] sts list" "mansection ST stslist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] sts generate" "help sts_generate"}{...}
{vieweralsosee "[ST] sts graph" "help sts_graph"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "sts_list##syntax"}{...}
{viewerjumpto "Menu" "sts_list##menu"}{...}
{viewerjumpto "Description" "sts_list##description"}{...}
{viewerjumpto "Links to PDF documentation" "sts_list##linkspdf"}{...}
{viewerjumpto "Options" "sts_list##options"}{...}
{viewerjumpto "Examples" "sts_list##examples"}{...}
{viewerjumpto "Video example" "sts_list##video"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ST] sts list} {hline 2}}List the survivor or cumulative hazard function{p_end}
{p2col:}({mansection ST stslist:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}{cmd:sts} {opt l:ist} {ifin} [{cmd:,} {it:options}]

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt sur:vival}}report Kaplan-Meier survivor function; the default
{p_end}
{synopt :{opt f:ailure}}report Kaplan-Meier failure function{p_end}
{synopt :{opt cumh:az}}report Nelson-Aalen cumulative hazard function{p_end}
{synopt :{opth by(varlist)}}estimate separate functions for each group formed by {it:varlist}{p_end}
{synopt :{opth ad:justfor(varlist)}}adjust the estimates to zero values of {it:varlist}{p_end}
{synopt :{opth st:rata(varlist)}}stratify on different groups of {it:varlist}{p_end}

{syntab:Options}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{cmd:at(}{it:#}|{it:{help numlist}}{cmd:)}}report estimated survivor/cumulative hazard function at specified times; default is to report at all unique time values{p_end}
{synopt :{opt e:nter}}report number lost as pure censored instead of censored minus lost{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt c:ompare}}report groups of survivor/cumulative hazard functions side by side{p_end}
{synopt :{cmdab:sav:ing:(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)}}save results to {it:filename}; use {opt replace} to overwrite existing {it:filename}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:sts list}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using {cmd:stset}; see {manhelp stset ST}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
      {bf:List survivor and cumulative hazard functions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sts list} lists the estimated survivor (failure) or the Nelson-Aalen
estimated cumulative (integrated) hazard function.  See {manhelp sts ST} for an
introduction to this command.

{pstd}
{cmd:sts list} can be used with single- or multiple-record or single- or
multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stslistQuickstart:Quick start}

        {mansection ST stslistRemarksandexamples:Remarks and examples}

        {mansection ST stslistMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt survival}, {opt failure}, and {opt cumhaz} specify the function to
report.

{phang2}
{opt survival} specifies that the Kaplan-Meier survivor function be listed.
This option is the default if a function is not specified.

{phang2}
{opt failure} specifies that the Kaplan-Meier failure function 1 - S(t+0) be
listed.

{phang2}
{opt cumhaz} specifies that the Nelson-Aalen estimate of the cumulative
hazard function be listed.

{phang}
{opth by(varlist)} estimates a separate function for each by-group.  By-groups
are identified by equal values of the variables in {it:varlist}. {opt by()} may
not be combined with {opt strata()}.

{phang}
{opth adjustfor(varlist)} adjusts the estimate of the survivor (failure)
function to that for 0 values of {it:varlist}.  This option is
not available with the Nelson-Aalen function.  See
{manhelp sts_graph ST:sts graph} for an example of how to adjust for values
different from 0.

{pmore}
If you specify {opt adjustfor()} with {opt by()}, {cmd:sts} fits separate Cox
regression models for each group, using the {opt adjustfor()} variables as
covariates.  The separately calculated baseline survivor functions are then
retrieved.

{pmore}
If you specify {opt adjustfor()} with {opt strata()}, {cmd:sts} fits a
stratified-on-group Cox regression model, using the {opt adjustfor()} variables
as covariates.  The stratified, baseline survivor function is then
retrieved.

{phang}
{opth strata(varlist)} requests estimates of the survivor (failure) function
stratified on variables in {it:varlist}. It requires specifying
{opt adjustfor()} and may not be combined with {opt by()}.

{dlgtab:Options}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for the
Greenwood pointwise confidence interval of the survivor (failure) or for the
pointwise confidence interval of the Nelson-Aalen cumulative hazard function;
see {manhelp level R}.

{phang}
{cmd:at(}{it:#}|{it:{help numlist}}{cmd:)} specifies the time values at which
the estimated survivor (failure) or cumulative hazard function is to be listed.

{pmore}
The default is to list the function at all the unique time values in
the data, or if functions are being compared, at about 10 times chosen over
the observed interval.  In any case, you can control the points chosen.

{pmore}
{cmd:at(5 10 20 30 50 90)} would display the function at the designated
times.

{pmore}
{cmd:at(10 20 to 100)} would display the function at times 10, 20, 30, 40, ...,
100.

{pmore}
{cmd:at(0 5 10 to 100 200)} would display the function at times 0, 5, 10, 15,
..., 100, and 200.

{pmore}
{cmd:at(20)} would display the curve at (roughly) 20 equally spaced times over
the interval observed in the data.  We say roughly because Stata may choose to
increase or decrease your number slightly if that would result in rounder
values of the chosen times.

{phang}
{opt enter} specifies that the table contain the number who enter and,
correspondingly, that the number lost be displayed as the pure number censored
rather than censored minus entered. The logic underlying this is explained in
{manlink ST sts}.

{phang}
{opt noshow} prevents {cmd:sts list} from showing the key st variables.
This option is seldom used because most people type {cmd:stset, show} or
{cmd:stset, noshow} to set whether they want to see these variables mentioned
at the top of the output of every st command; see {manhelp stset ST}.

{phang}
{opt compare} is specified only with {opt by()} or {opt strata()}.  It
compares the survivor (failure) or cumulative hazard functions and lists them
side by side rather than first one and then the next.

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} saves the
results in a Stata data file ({opt .dta} file).

{pmore}
{cmd:replace} specifies that {it:filename} be overwritten if it exists. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Suppress showing st settings{p_end}
{phang2}{cmd:. stset, noshow}

{pstd}List the survivor function{p_end}
{phang2}{cmd:. sts list}

{pstd}List the survivor functions for the two categories of
{cmd:posttran}{p_end}
{phang2}{cmd:. sts list, by(posttran)}

{pstd}Same as above, but list at the specified times{p_end}
{phang2}{cmd:. sts list, at(10 40 to 160) by(posttran)}

{pstd}List the cumulative hazard functions at the specified times for the two
categories of {cmd:posttran}{p_end}
{phang2}{cmd:. sts list, cumhaz at(10 40 to 160) by(posttran)}

{pstd}List the survivor function for the two categories of {cmd:posttran} side
by side, using the specified comparison times{p_end}
{phang2}{cmd:. sts list, at(10 40 to 160) by(posttran) compare}

{pstd}List the cumulative hazard functions for the two categories of
{cmd:posttran} side by side, using the specified comparison times{p_end}
{phang2}{cmd:. sts list, cumhaz at(10 40 to 160) by(posttran) compare}{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=9XZR32zElZ8&list=UUVk4G4nEtBS4tLOyHqustDA":How to calculate the Kaplan-Meier survivor and Nelson-Aalen cumulative hazard functions}
{p_end}
