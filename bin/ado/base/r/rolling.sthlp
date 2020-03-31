{smcl}
{* *! version 1.2.9  23jan2019}{...}
{viewerdialog rolling "dialog rolling"}{...}
{vieweralsosee "[TS] rolling" "mansection TS rolling"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] statsby" "help statsby"}{...}
{vieweralsosee "[R] Stored results" "help stored results"}{...}
{viewerjumpto "Syntax" "rolling##syntax"}{...}
{viewerjumpto "Menu" "rolling##menu"}{...}
{viewerjumpto "Description" "rolling##description"}{...}
{viewerjumpto "Links to PDF documentation" "rolling##linkspdf"}{...}
{viewerjumpto "Options" "rolling##options"}{...}
{viewerjumpto "Examples" "rolling##examples"}{...}
{viewerjumpto "Stored results" "rolling##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] rolling} {hline 2}}Rolling-window and recursive estimation
{p_end}
{p2col:}({mansection TS rolling:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:rolling}
	[{it:{help exp_list}}]
	{ifin}
	{cmd:,} {opt w:indow(#)} [{it:options}]
	{cmd::}
	{it:command}


{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opt w:indow(#)}}number of consecutive data points in each sample{p_end}
{synopt:{opt r:ecursive}}use recursive samples{p_end}
{synopt:{opt rr:ecursive}}use reverse recursive samples{p_end}

{syntab:Options}
{synopt:{opt clear}}replace data in memory with results{p_end}
{synopt:{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:, ...)}}}save results to {it:filename}; save
statistics in double precision; save results to {it:filename} every {it:#}
replications{p_end}
{synopt:{opt step:size(#)}}number of periods to advance window{p_end}
{synopt:{opt st:art(time_constant)}}period at which rolling is to start{p_end}
{synopt:{opt e:nd(time_constant)}}period at which rolling is to end{p_end}
{synopt:{cmdab:k:eep(}{varname}[{cmd:,} {opt start}]{cmd:)}}save {it:varname} with results; optionally, use value at left edge of window{p_end}

{syntab:Reporting}
{synopt:{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}
{synopt:{opt noi:sily}}display any output from {it:command}{p_end}
{synopt:{opt tr:ace}}trace {it:command}'s execution{p_end}

{syntab:Advanced}
{synopt:{opth reject:(exp_list:exp)}}identify invalid results{p_end}
{synoptline}
{p 4 6 2}
* {opt window(#)} is required.{p_end}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt rolling}; see 
{helpb tsset:[TS] tsset}. {p_end}
{p 4 6 2}
{it:command} is any command that follows standard Stata syntax and
allows the {cmd:if} qualifier.  The {cmd:by} prefix cannot be part of
{it:command}.{p_end}
{p 4 6 2}
{opt aweight}s are allowed in {it:command} if {it:command} accepts
{cmd:aweight}s; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Rolling-window and recursive estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rolling} executes a command on each of a series of windows of
observations and stores the results.  {cmd:rolling} can perform what
are commonly called rolling regressions, recursive regressions, and 
reverse recursive regressions.  However, {cmd:rolling} is not limited 
to just linear regression analysis: any command that stores results in
{cmd:e()} or {cmd:r()} can be used with {cmd:rolling}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS rollingQuickstart:Quick start}

        {mansection TS rollingRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt window(#)} defines the window size used each time {it:command} is executed.
   The window size refers to calendar periods, not the number of
   observations.  If there are missing data (for example, because of weekends),
   the actual number of observations used by {it:command} may be less than
   {opt window(#)}.  {opt window(#)} is required.

{phang}
{opt recursive} specifies that a recursive analysis be done.  The starting
   period is held fixed, the ending period advances, and the window
   size grows.

{phang}
{opt rrecursive} specifies that a reverse recursive analysis be done.
   Here the ending period is held fixed, the starting period
   advances, and the window size shrinks.

{dlgtab:Options}

{phang}
{opt clear} specifies that Stata replace the data in memory
   with the collected statistics even though the current data in memory have
   not been saved to disk.

INCLUDE help prefix_saving_option

{phang2}
   {opt double} specifies that the results for each replication be saved as
   {opt double}s, meaning 8-byte reals.  By default, they are saved as
   {opt float}s, meaning 4-byte reals.

{phang2}
   {opt every(#)} specifies that results be written to disk every {it:#}th
   replication.  {opt every()} should be specified in conjunction with
   {opt saving()} only when {it:command} takes a long time for each replication.
   This will allow recovery of partial results should your computer crash.
   See {helpb post:[P] postfile}.

{phang}
{opt stepsize(#)} specifies the number of periods the window is to be advanced
   each time {it:command} is executed.

{phang}
{opt start(time_constant)} specifies the date on which {opt rolling} is to start.
   {opt start()} may be specified as an integer or as a date literal.

{phang}
{opt end(time_constant)} specifies the date on which {opt rolling} is to end.
   {opt end()} may be specified as an integer or as a date literal.

{phang}
{opt keep}{cmd:(}{varname}[{cmd:, start}]{cmd:)} specifies a variable to be
   posted along with the results.  The value posted is the value that
   corresponds to the right edge of the window.  Specifying the {opt start()}
   option requests that the value corresponding to the left edge of the window
   be posted instead.  This option is often used to record calendar dates.

{dlgtab:Reporting}

{phang}
{opt nodots} and {opt dots(#)} specify whether to display replication
dots.  By default, one dot character is displayed for each
window.  A red `x' is displayed if {it:command} returns an error or if
any value in {it:exp_list} is missing.  You can also control whether dots
are printed using {helpb set dots}.

{phang2}
{opt nodots} suppresses the display of the replication dot for each window
on which {it:command} is executed.

{phang2}
{opt dots(#)} displays dots every {it:#} replications.
{cmd:dots(0)} is a synonym for {cmd:nodots}.

{phang}
{opt noisily} causes the output of {it:command} to be displayed for each
   window on which {it:command} is executed.  This option implies the
   {opt nodots} option.

{phang}
{opt trace} causes a trace of the execution of {it:command} to be displayed.
This option implies the {opt noisily} and {opt nodots} options.

{dlgtab:Advanced}

{phang}
{opth reject(exp)} identifies an expression that indicates when results should
   be rejected.  When {it:exp} is true, the saved statistics are set to
   missing values.


{marker examples}{...}
{title:Example: Collecting coefficients}

{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. tsset qtr}{p_end}
{phang2}{cmd:. rolling _b, window(30): regress dln_inv dln_inc dln_consump}
{p_end}

{pstd}Same as above, {cmd:_b} is default for e-class commands{p_end}
{phang2}{cmd:. webuse lutkepohl2, clear}{p_end}
{phang2}{cmd:. tsset qtr}{p_end}
{phang2}{cmd:. rolling, window(30): regress dln_inv dln_inc dln_consump}
{p_end}
{phang2}{cmd:. list in 1/10, abbrev(14)}


{title:Example: Collecting standard errors}

{phang2}{cmd:. webuse lutkepohl2, clear}{p_end}
{phang2}{cmd:. tsset qtr}{p_end}
{phang2}{cmd:. rolling _se, window(10): regress dln_inv dln_inc dln_consump}
{p_end}
{phang2}{cmd:. list in 1/10, abbrev(14)}


{title:Example: Collecting stored results}

{phang2}{cmd:. webuse lutkepohl2, clear}{p_end}
{phang2}{cmd:. tsset qtr}{p_end}
{phang2}{cmd:. rolling mean=r(mean) median=r(p50), window(10): summarize inc,}
                {cmd:detail}{p_end}
{phang2}{cmd:. list in 1/10}

{phang2}{cmd:. webuse lutkepohl2, clear}{p_end}
{phang2}{cmd:. tsset qtr}{p_end}
{phang2}{cmd:. rolling ratio=(r(mean)/r(p50)), window(10): summarize inc,}
                {cmd:detail}{p_end}
{phang2}{cmd:. list in 1/10}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rolling} sets no r- or e-class macros. The results from the
command used with {cmd:rolling}, depending on the last window of data used,
are available after {cmd:rolling} has finished.
{p_end}
