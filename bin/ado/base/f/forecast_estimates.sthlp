{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast estimates" "mansection TS forecastestimates"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "[R] predict" "help predict"}{...}
{viewerjumpto "Syntax" "forecast_estimates##syntax"}{...}
{viewerjumpto "Description" "forecast_estimates##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_estimates##linkspdf"}{...}
{viewerjumpto "Options" "forecast_estimates##options"}{...}
{viewerjumpto "Examples" "forecast_estimates##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[TS] forecast estimates} {hline 2}}Add estimation results to a
forecast model{p_end}
{p2col:}({mansection TS forecastestimates:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Add estimation result currently in memory to model

{p 8 15 2}
{cmdab:fore:cast} {cmdab:est:imates}
{it:name}
[{cmd:,} {it:{help forecast estimates##opt_table:options}}]

{phang}
{it:name} is the name of a stored estimation result; see
{helpb estimates store:[R] estimates store}.


{pstd}
Add estimation result currently saved on disk to model

{p 8 15 2}
{cmdab:fore:cast} {cmdab:est:imates} 
{cmd:using} {it:filename}
[{cmd:,}
{opt nu:mber(#)}
{it:{help forecast estimates##opt_table:options}}]

{phang}
{it:filename} is an estimation results file created by {cmd:estimates save};
see {helpb estimates save:[R] estimates save}.  If no file extension is
specified, {cmd:.ster} is assumed.


{marker opt_table}{...}
{synoptset 26}{...}
{synopthdr}
{synoptline}
{synopt:{opt pr:edict(p_options)}}call {cmd:predict} using
{it:p_options}{p_end}
{synopt:{cmdab:na:mes(}{it:namelist}[{cmd:, replace}]{cmd:)}}use {it:namelist}
for names of left-hand-side variables{p_end}
{synopt:{opt ad:vise}}advise whether estimation results can be dropped from
memory{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast} {cmd:estimates} adds estimation results to the forecast
model currently in memory.  You must first create a new model using
{cmd:forecast} {cmd:create} before you can add estimation results with
{cmd:forecast} {cmd:estimates}.  After estimating the parameters of an
equation or set of equations, you must use {cmd:estimates} {cmd:store} to
store the estimation results in memory or use {cmd:estimates} {cmd:save} to
save them on disk before adding them to the model.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastestimatesQuickstart:Quick start}

        {mansection TS forecastestimatesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt predict(p_options)} specifies the {cmd:predict} options to use
when predicting the dependent variables.  For a single-equation estimation
command, you simply specify the appropriate options to pass to
{cmd:predict}.  If multiple options are required, enclose them in quotation
marks:

{phang2}
{cmd:. forecast estimates ..., predict("pr outcome(#1)")}

{pmore}
For a multiple-equation estimation command, you can either specify one set of
options that will be applied to all equations or specify {it:p} options,
where {it:p} is the number of endogenous variables being added.  If multiple
options are required for each equation, enclose each equation's options in
quotes:

{phang2}
{cmd:. forecast estimates ..., predict("pr eq(#1)" "pr eq(#2)")}

{pmore}
If you do not specify the {cmd:eq()} option for any of the equations, 
{cmd:forecast} automatically includes it for you.

{pmore}
If you are adding results from a linear estimation command that {cmd:forecast}
recognizes as one whose predictions can be calculated as x_t'b,
do not specify the {cmd:predict()} option, because this will slow
{cmd:forecast}'s computation time substantially.  Use the {cmd:advise} option
to determine whether {cmd:forecast} needs to call {cmd:predict}.

{pmore}
If you do not specify any {cmd:predict} options, {cmd:forecast} uses the
default type of prediction for the command whose results are being added.

{phang}
{cmd:names(}{it:namelist}[{cmd:, replace}]{cmd:)}
instructs {cmd:forecast} {cmd:estimates} to use {it:namelist} as the names of
the left-hand-side variables in the estimation result being added.  You must
use this option if any of the left-hand-side variables contains time-series
operators.  By default, {cmd:forecast} {cmd:estimates} uses the names stored
in the {cmd:e(depvar)} macro of the results being added.

{pmore}
{cmd:forecast estimates} creates a new variable in the dataset for each
element of {it:namelist}.  If a variable of the same name already exists in
your dataset, {cmd:forecast} {cmd:estimates} exits with an error unless you
specify the {cmd:replace} option, in which case existing variables are
overwritten.

{phang}
{cmd:advise} requests that {cmd:forecast} {cmd:estimates} report a message
indicating whether the estimation results being added can be removed from
memory.  This option is useful if you expect your model to contain more than
300 sets of estimation results, the maximum number that Stata allows you to
store in memory; see {helpb limits}.  This option also provides an
indication of the speed with which the model can be solved: {cmd:forecast}
executes much more slowly with estimation results that must remain in memory. 

{phang}
{opt number(#)}, for use with {cmd:forecast} {cmd:estimates} {cmd:using},
specifies that the {it:#}th set of estimation results from {it:filename} be
loaded.  This assumes that multiple sets of estimation results have been saved
in {it:filename}.  The default is {cmd:number(1)}.  See
{helpb estimates save:[R] estimates save} for more information on saving
multiple sets of estimation results in a single file.   


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse klein2}{p_end}
{phang2}{cmd:. reg3 (c p L.p w) (i p L.p L.k) (wp y L.y yr)}
        {cmd:if year < 1939, endog(w p y) exog(t wg g)}{p_end}
{phang2}{cmd:. estimates store klein}{p_end}

{pstd}Create a new forecast model{p_end}
{phang2}{cmd:. forecast create kleinmodel}

{pstd}Add the stochastic equations fit using {cmd:reg3} to the
{cmd:kleinmodel}{p_end}
{phang2}{cmd:. forecast estimates klein}{p_end}

{pstd}Add the {cmd:advise} to the above command to display special code to
obtain fast predictions for the {cmd:reg3} results{p_end}
{phang2}{cmd:. forecast estimates klein, advise}{p_end}
