{smcl}
{* *! version 1.2.14  23jan2019}{...}
{viewerdialog statsby "dialog statsby"}{...}
{vieweralsosee "[D] statsby" "mansection D statsby"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[D] by" "help by"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{vieweralsosee "[R] permute" "help permute"}{...}
{vieweralsosee "[P] postfile" "help postfile"}{...}
{viewerjumpto "Syntax" "statsby##syntax"}{...}
{viewerjumpto "Menu" "statsby##menu"}{...}
{viewerjumpto "Description" "statsby##description"}{...}
{viewerjumpto "Links to PDF documentation" "statsby##linkspdf"}{...}
{viewerjumpto "Options" "statsby##options"}{...}
{viewerjumpto "Examples" "statsby##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] statsby} {hline 2}}Collect statistics for a command across a by list{p_end}
{p2col:}({mansection D statsby:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:statsby}
	[{it:{help exp_list}}]
	[{cmd:,} {it:options} ]{cmd::}
	{it:command}

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent :* {cmd:by(}{help varlist:{it:varlist}} [{cmd:,} {cmdab:mis:sing}]{cmd:)}}equivalent to interactive use of {cmd:by} {it:varlist}{cmd::}{p_end}

{syntab :Options}
{synopt :{opt clear}}replace data in memory with results{p_end}
{synopt :{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:, ...)}}}save
	results to {it:filename}; save statistics in double precision; save
        results to {it:filename} every {it:#} replications{p_end}
{synopt :{opt t:otal}}include results for the entire dataset{p_end}
{synopt :{opt s:ubsets}}include all combinations of subsets of groups{p_end}

{syntab :Reporting}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}
{synopt :{opt noi:sily}}display any output from {it:command}{p_end}
{synopt :{opt tr:ace}}trace {it:command}{p_end}
{synopt :{opt nol:egend}}suppress table legend{p_end}
{synopt :{opt v:erbose}}display the full table legend{p_end}

{syntab :Advanced}
{synopt :{opt base:pop}{cmd:(}{it:{help exp}}{cmd:)}}restrict initializing 
	sample to {it:exp}; seldom used{p_end}
{synopt :{opt force}}do not check for {cmd:svy} commands; seldom used{p_end}
{synopt :{opt forcedrop}}retain only observations in by-groups when
	calling {it:command}; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt by()} is required on the dialog box because {cmd:statsby} is
useful to the interactive user only when using {opt by()}.{p_end}
{p 4 6 2}All weight types supported by {it:command} are allowed except {cmd:pweight}s; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Other > Collect statistics for a command across a by list}


{marker description}{...}
{title:Description}

{pstd}
{cmd:statsby} collects statistics from {it:command} across a by
list.  Typing

{phang2}
{cmd:. statsby} {it:exp_list} {cmd:,} {opt by(varname)}{cmd::} {it:command}

{pstd}
executes {it:command} for each group identified by {it:varname}, building a
dataset of the associated values from the expressions in {it:exp_list}.  The
resulting dataset replaces the current dataset, unless the {cmd:saving()}
option is supplied.  {it:varname} can refer to a numeric or a string
variable.

{pstd}
{it:command} defines the statistical command to be executed.
Most Stata commands and user-written programs can be used with
{cmd:statsby}, as long as they follow {help language:standard Stata syntax}
and allow the {bf:{help if}} qualifier.
The {cmd:by} prefix cannot be part of {it:command}.

{pstd}
{it:exp_list} specifies the statistics to be collected from the execution of
{it:command}.  The expressions in {it:exp_list} follow the grammar given in
{it:{help exp_list}}.
If no expressions are given, {it:exp_list} assumes a default depending upon
whether {it:command} changes results in {cmd:e()} and {cmd:r()}.  If
{it:command} changes results in {cmd:e()}, the default is {cmd:_b}.  If
{it:command} changes results in {cmd:r()} (but not {cmd:e()}), the default is
all the scalars posted to {cmd:r()}.  It is an error not to specify an
expression in {it:exp_list} otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D statsbyQuickstart:Quick start}

        {mansection D statsbyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:by(}{help varlist:{it:varlist}} [{cmd:, missing}]{cmd:)} specifies a list
of existing variables that would normally appear in the
{cmd:by} {it:varlist}{cmd::} section of the command if you were to issue the
command interactively.  By default, {cmd:statsby} ignores groups in which one
or more of the {cmd:by()} variables is missing.  Alternatively, {opt missing}
causes missing values to be treated like any other values in the by-groups, and
results from the entire dataset are included with use of the {opt subsets}
option.  If {cmd:by()} is not specified, {it:command} will be run on the entire
dataset. {it:varlist} can contain both numeric and string variables.

{dlgtab:Options}

{phang}
{opt clear} specifies that it is okay to replace the data in memory,
even though the current data have not been saved to disk.

INCLUDE help prefix_saving_option

{pmore}
See help {it:{help prefix_saving_option}}, for details about {it:suboptions}.

{phang}
{opt total} specifies that {it:command} be run on the entire dataset,
in addition to the groups specified in the {opt by()} option.

{phang}
{opt subsets} specifies that {it:command} be run for each group
defined by any combination of the variables in the {opt by()} option.

{dlgtab:Reporting}

{phang}
{opt nodots} and {opt dots(#)} specify whether to display replication dots.
By default, one dot character is displayed for each by-group.  A red `x' is
displayed if {it:command} returns an error or if any value in {it:exp_list} is
missing.  You can also control whether dots are printed using
{helpb set dots}.

{phang2}
{opt nodots} suppresses display of the replication dots. By default, one 

{phang2}
{opt dots(#)} displays dots every {it:#} replications.
{cmd:dots(0)} is a synonym for {cmd:nodots}.

{phang}
{opt noisily} causes the output of {it:command} to be displayed for each
by-group.  This option implies the {opt nodots} option.

{phang}
{opt trace} causes a trace of the execution of {it:command} to be displayed.
This option implies the {opt noisily} option.

{phang}
{opt nolegend} suppresses the display of the table legend, which identifies
the rows of the table with the expressions they represent.

{phang}
{opt verbose} requests that the full table legend be displayed.  By default,
coefficients and standard errors are not displayed.

{dlgtab:Advanced}

{phang}
{opt basepop}{cmd:(}{it:{help exp}}{cmd:)} specifies a base population that
        {cmd:statsby} uses to evaluate the {it:command} and to set up for
        collecting statistics.  The default base population is the entire
        dataset, or the dataset specified by any {bf:{help if}} or 
        {bf:{help in}} conditions specified on the {it:command}.

{pmore}
One situation where {cmd:basepop()} is useful is collecting statistics over
the panels of a panel dataset by using an estimator that works for time series,
but not panel data, for example,

{phang3}
	{cmd:. statsby, by(mypanels) basepop(mypanels==2): arima} {it:...}

{phang}
{opt force} suppresses the restriction that {it:command} not be a {cmd:svy}
command.  {cmd:statsby} does not perform subpopulation estimation for survey
data, so it should not be used with {cmd:svy}.  {cmd:statsby}
reports an error when it encounters {cmd:svy} in {it:command} if the
{cmd:force} option is not specified.  This option is seldom used, so use it
only if you know what you are doing.
	
{phang}
{opt forcedrop} forces {cmd:statsby} to drop all
        observations except those in each by-group before calling
        {it:command} for
        the group.  This allows {cmd:statsby} to work with user-written 
        programs that completely ignore {bf:{help if}} and {bf:{help in}} but
        do not return an error when either is specified.
        {cmd:forcedrop} is seldom used.


{marker examples}{...}
{title:Example: Collecting coefficients}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. statsby, by(foreign): regress mpg gear turn}{p_end}


{title:Example: Collecting both coefficients and standard errors using a time-series estimator with panel data}

{phang}{cmd:. webuse grunfeld, clear}{p_end}
{phang}{cmd:. tsset company year}{p_end}
{phang}{cmd:. statsby _b _se, basepop(company==1) by(company):}
              {cmd:arima invest mvalue kstock, ar(1)}


{title:Example: Collecting results stored in r-class macros}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. statsby mean=r(mean) sd=r(sd) size=r(N), by(rep78):}
              {cmd:summarize mpg}{p_end}
