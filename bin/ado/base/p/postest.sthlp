{smcl}
{* *! version 2.0.5  19oct2017}{...}
{vieweralsosee "[R] postest" "mansection R postest"}{...}
{viewerjumpto "Syntax" "postest##syntax"}{...}
{viewerjumpto "Menu" "postest##menu"}{...}
{viewerjumpto "Description" "postest##description"}{...}
{viewerjumpto "Links to PDF documentation" "postest##linkspdf"}{...}
{viewerjumpto "Remarks" "postest##remarks"}{...}
{viewerjumpto "Video example" "postest##video"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] postest} {hline 2}}Postestimation Selector{p_end}
{p2col:}({mansection R postest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:postest}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
Launch the Postestimation Selector window.  The window contains a list of all
postestimation features that are available for the currently active estimation
results.  To launch the dialog box for an item in the list, select an item and
click on {bf:Launch}.  The list is automatically updated when estimation
commands are run or estimates are restored from memory or disk.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R postestRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Stata uses an estimation followed by postestimation analysis paradigm.  You
type {cmd:regress} ... to fit a regression model, then you type {cmd:test}
... to test linear relationships among the estimated parameters, or you
type {cmd:contrast} ... to compare marginal means, or you type
{cmd:rvfplot} to see a residual-versus-fitted plot, or you type one of a
myriad of other postestimation commands.  This is an extension of Stata's
"type a little, get a little" concept.  The Postestimation Selector exposes
this type of postestimation analysis to those who prefer to use the dialog
boxes to fit and analyze models, or at least they sometimes prefer the dialogs
when exploring their data.  We might call this "click a little, get a
little".

{pstd}
The Postestimation Selector knows what is available after any estimation
command.  It shows the full list of postestimation features that are available
after any estimation, and it shows only those that are available.  For
example, if you fit a linear regression, you can choose from 59 postestimation
analyses, including "Likelihood-ratio test comparing models".  If, however,
you fit that linear regression using survey estimation, the likelihood-ratio
test is not available because that test has no meaning for survey estimation.
You will, however, see 8 new postestimation features for survey-data analysis,
including "Design and misspecification effects".

{pstd}
If you are using the menus and dialogs, we recommend you launch the
Postestimation Selector and just leave it up -- select {bf:Statistics}
{bf:> Postestimation}, or type {cmd:postest} at the command line.  All
available postestimation features for whatever model you are analyzing will
then be just a click away.


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=12eU7v2cgBs":Postestimation Selector}
{p_end}
