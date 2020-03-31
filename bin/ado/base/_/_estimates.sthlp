{smcl}
{* *! version 1.1.11  14may2018}{...}
{vieweralsosee "[P] _estimates" "mansection P _estimates"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "[P] makecns" "help makecns"}{...}
{vieweralsosee "[P] mark" "help mark"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "[R] Stored results" "help stored results"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (estimation)" "help estcom"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (postestimation)" "help postest"}{...}
{viewerjumpto "Syntax" "_estimates##syntax"}{...}
{viewerjumpto "Description" "_estimates##description"}{...}
{viewerjumpto "Links to PDF documentation" "_estimates##linkspdf"}{...}
{viewerjumpto "Options" "_estimates##options"}{...}
{viewerjumpto "Examples" "_estimates##examples"}{...}
{viewerjumpto "Stored results" "_estimates##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] _estimates} {hline 2}}Manage estimation results{p_end}
{p2col:}({mansection P _estimates:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Move estimation results into holdname

{p 8 19 2}{cmdab:_est:imates} {cmdab:h:old} {it:holdname} [{cmd:,} {cmdab:c:opy}
{cmdab:r:estore} {cmdab:n:ullok} {opth var:name(newvar)}]


    Restore estimation results

{p 8 19 2}{cmdab:_est:imates} {cmdab:u:nhold} {it:holdname} [{cmd:, not}]


    List names holding estimation results

{p 8 19 2}{cmdab:_est:imates dir}


    Eliminate estimation results

{p 8 19 2}{cmdab:_est:imates clear}

 
    Eliminate specified estimation results

{p 8 19 2}{cmdab:_est:imates drop} {c -(} {it:holdnames} | {cmd:_all} {c )-}


{pstd}
where {it:holdname} is the name under which estimation results will be held.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_estimates hold}, {cmd:_estimates unhold}, {cmd:_estimates dir},
{cmd:_estimates clear}, and
{cmd:_estimates drop} provide a low-level mechanism for setting aside and later
restoring up to 300 estimation results.

{pstd}
{cmd:_estimates hold} moves, or copies if the {cmd:copy} option is specified,
all information associated with the last estimation command into
{it:holdname}. If {it:holdname} is a temporary name, it will automatically be
deleted when you exit from the current program.

{pstd}
{cmd:_estimates unhold} restores the information from the estimation command
previously moved into {it:holdname} and eliminates {it:holdname}.

{pstd}
{cmd:_estimates dir} lists the {it:holdnames} under which estimation results
are currently held.

{pstd}
{cmd:_estimates clear} eliminates all set aside results.  Also, if the
{cmd:restore} option is specified when the estimates are held, those estimates
will be automatically restored when the program concludes.  It is not
necessary to perform an {cmd:_estimates unhold} in that case.

{pstd}
{cmd:_estimates drop} eliminates the estimation results stored under the
specified {it:holdnames}.

{pstd}
{cmd:_estimates} is a programmer's command designed to be used within
programs.  {cmd: estimates} is a user's command to manage multiple estimation
results.  {cmd:estimates} uses {cmd:_estimates} to hold and unhold results,
and it adds features such as model-selection indices and looping over results.
Postestimation commands, such as {cmd:suest} and {cmd:lrtest}, assume that
estimation results are stored using {cmd:estimates} rather than
{cmd:_estimates}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P _estimatesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{cmd:copy} requests that all information associated with the last
estimation command be copied into {it:holdname}.  By default, it is moved,
meaning that the estimation results temporarily disappear.  The default action
is faster and uses less memory.

{phang}{cmd:restore} requests that the information in {it:holdname} be
automatically restored when the program ends, regardless of whether that
occurred because the program exited normally, the user pressed {hi:Break}, or
there was an error.

{phang}{cmd:nullok} specifies that it is valid to store null results.  After
restoring a null result, no estimation results are active.

{phang}{opth varname(newvar)} specifies the variable name under which
{cmd:esample()} will be held.  If {cmd:varname()} is not specified,
{it:holdname} is used.  If the variable already exists in the data, an error
message is shown.  This variable is visible to users.  If it is
dropped, {cmd:_estimates unhold} will not be able to restore the estimation
sample {cmd:e(sample)} and sets {cmd:e(sample)} to 1.

{phang}{cmd:not} specifies that the previous {cmd:_estimates hold, restore}
request for automatic restoration be canceled.  The previously held estimation
results are discarded from memory without restoration, now or later.


{marker examples}{...}
{title:Examples}

{p 4 35 2}{cmd:. regress y x1 x2 x3} {space 8} (fit first model){p_end}

{p 4 35 2}{cmd:. _estimates hold model1} {space 4} (and hold on to it){p_end}

{p 4 35 2}{cmd:. regress y x1 x2 x3 x4} {space 5} (fit the second model){p_end}

{p 4 35 2}{cmd:. _estimates hold model2} {space 4} (and hold on to it, too){p_end}

{p 4 35 2}{cmd:. use newdata} {space 15} (use another dataset){p_end}

{p 4 35 2}{cmd:. _estimates dir} {space 12} (see what models are currently held){p_end}

{p 4 35 2}{cmd:. _estimates unhold model1} {space 2} (get the first model){p_end}

{p 4 35 2}{cmd:. predict yhat1} {space 13} (predict using first regression){p_end}

{p 4 35 2}{cmd:. _estimates unhold model2} {space 2} (get the second model){p_end}

{p 4 35 2}{cmd:. predict yhat2} {space 13} (predict using second regression)


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_estimates hold} removes the estimation results -- {cmd:e()} items.

{pstd}
{cmd:_estimates unhold} restores the previously held {cmd:e()} results.

{pstd}
{cmd:_estimates clear} permanently removes all held {cmd:e()} results.

{pstd}
{cmd:_estimates dir} returns the names of the held estimation results in the
local {cmd:r(names)}, separated by single spaces.

{pstd}
{cmd:_estimates dir} also returns {cmd:r(varnames)}, which has the
corresponding variable names for {cmd:esample()}. 
{p_end}
