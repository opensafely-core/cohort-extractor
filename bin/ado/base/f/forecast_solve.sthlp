{smcl}
{* *! version 1.0.8  12feb2019}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast solve" "mansection TS forecastsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast adjust" "help forecast adjust"}{...}
{vieweralsosee "[TS] forecast drop" "help forecast drop"}{...}
{vieweralsosee "[R] set seed" "help set seed"}{...}
{viewerjumpto "Syntax" "forecast_solve##syntax"}{...}
{viewerjumpto "Description" "forecast_solve##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_solve##linkspdf"}{...}
{viewerjumpto "Options" "forecast_solve##options"}{...}
{viewerjumpto "Examples" "forecast_solve##examples"}{...}
{viewerjumpto "Stored results" "forecast_solve##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[TS] forecast solve} {hline 2}}Obtain static and dynamic
forecasts{p_end}
{p2col:}({mansection TS forecastsolve:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:s:olve}
[{cmd:,}
{c -(} {cmdab:pre:fix(}{it:stub}) | {cmdab:suf:fix(}{it:stub}) {c )-}
{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt pre:fix(string)}}specify prefix for forecast
variables{p_end}
{p2coldent :* {opt suf:fix(string)}}specify suffix for forecast
variables{p_end}
{synopt :{opt b:egin(time_constant)}}specify period to begin
forecasting{p_end}
{p2coldent :+ {opt e:nd(time_constant)}}specify period to end
forecasting{p_end}
{p2coldent :+ {opt per:iods(#)}}specify number of periods to forecast{p_end}
{synopt : {opt do:uble}}store forecast variables as {cmd:double}s instead of
as {cmd:float}s{p_end}
{synopt :{opt st:atic}}produce static forecasts instead of dynamic
forecasts{p_end}
{synopt :{opt ac:tuals}}use actual values if available instead of
forecasts{p_end}

{syntab:Simulation}
{synopt :{cmdab:sim:ulate(}{help forecast solve##sim_technique:{it:sim_technique}}{cmd:,} {help forecast solve##sim_statistic:{it:sim_statistic}} {help forecast solve##sim_options:{it:sim_options}}{cmd:)}}specify
   simulation technique and options{p_end}

{syntab:Reporting}
{synopt :{opt log(log_level)}}specify level of logging display;
{it:log_level} may be {opt de:tail},  {opt on}, {opt br:ief}, or {opt of:f}{p_end}

{syntab:Solver}
{synopt: {opt vtol:erance(#)}}specify tolerance for forecast values{p_end}
{synopt: {opt ztol:erance(#)}}specify tolerance for function zero{p_end}
{synopt: {opt iter:ate(#)}}specify maximum number of iterations{p_end}
{synopt: {opt tech:nique(technique)}}specify solution method; may be 
{opt dam:pedgaussseidel} {it:#},
{opt gau:ssseidel},
{opt bro:ydenpowell}, or 
{opt new:tonraphson}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* You can specify {cmd:prefix()} or {cmd:suffix()} but not both.{p_end}
{p 4 6 2}
+ You can specify {cmd:end()} or {cmd:periods()} but not both.{p_end}

{marker sim_technique}
{synoptset 26}{...}
{synopthdr:sim_technique}
{synoptline}
{synopt :{opt be:tas}}draw multivariate-normal parameter vectors{p_end}
{synopt :{opt er:rors}}draw additive errors from multivariate normal
distribution{p_end}
{synopt :{opt re:siduals}}draw additive residuals based on static forecast
errors{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You can specify one or two {it:sim_methods} separated by a space, though you
cannot specify both {cmd:errors} and {cmd:residuals}.{p_end}

{marker sim_statistic}
{pstd}
{it:sim_statistic} is

{phang2}
{cmdab:stat:istic(}{helpb forecast solve##statistic:{it:statistic}}{cmd:,}{...}
	{c -(}{opt pre:fix(string)} | {opt suf:fix(string)}{c )-}{cmd:)}

{pstd}
and may be repeated up to three times.

{marker statistic}
{synoptset 26}{...}
{synopthdr:statistic}
{synoptline}
{synopt :{opt m:ean}}record the mean of the simulation forecasts{p_end}
{synopt :{opt v:ariance}}record the variance of the simulation
forecasts{p_end}
{synopt :{opt s:tddev}}record the standard deviation of the simulation
forecasts{p_end}
{synoptline}

{marker sim_options}
{synopthdr:sim_options}
{synoptline}
{synopt :{opt sa:ving(filename, ...)}}save results to file; save statistics in
double precision; save results to filename every {it:#} replications{p_end}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt r:eps(#)}}perform {it:#} replications; default is
{cmd:reps(50)}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast} {cmd:solve} computes static or dynamic forecasts based on the
model currently in memory.  Before you can solve a model, you must first
create a new model using {cmd:forecast} {cmd:create} and add equations and
variables to it using the commands summarized in
{helpb forecast:[TS] forecast}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastsolveQuickstart:Quick start}

        {mansection TS forecastsolveRemarksandexamples:Remarks and examples}

        {mansection TS forecastsolveMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt prefix(string)} and {opt suffix(string)} specify a
name prefix or suffix that will be used to name the variables holding the
forecast values of the variables in the model.  You may specify {cmd:prefix()}
or {cmd:suffix()} but not both.  Sometimes, it is more convenient to have all
forecast variables start with the same set of characters, while other times, it
is more convenient to have all forecast variables end with the same set of
characters.

{pmore}
If you specify {cmd:prefix(f_)}, then the forecast values of endogenous
variables {cmd:x}, {cmd:y}, and {cmd:z} will be stored in new variables
{cmd:f_x}, {cmd:f_y}, and {cmd:f_z}.  

{pmore} 
If you specify {cmd:suffix(_g)}, then the forecast values of endogenous
variables {cmd:x}, {cmd:y}, and {cmd:z} will be stored in new variables
{cmd:x_g}, {cmd:y_g}, and {cmd:z_g}.

{phang}
{opt begin(time_constant)} requests that {cmd:forecast} begin
forecasting at period {it:time_constant}.  By default, {cmd:forecast}
determines when to begin forecasting automatically.

{phang}
{opt end(time_constant)} requests that {cmd:forecast} end forecasting
at period {it:time_constant}.  By default, {cmd:forecast} produces forecasts
for all periods on or after {cmd:begin()} in the dataset.

{phang}
{opt periods(#)} specifies the number of periods after {cmd:begin()}
to forecast.  By default, {cmd:forecast} produces forecasts for all periods on
or after {cmd:begin()} in the dataset.

{phang}
{opt double} requests that the forecast and simulation variables be stored in
double precision.  The default is to use single-precision {opt float}s.  See
{helpb data_types:[D] Data types} for more information. 

{phang}
{cmd:static} requests that static forecasts be produced.  Actual values of
variables are used wherever lagged values of the endogenous variables appear
in the model.  By default, dynamic forecasts are produced, which use the
forecast values of variables wherever lagged values of the endogenous
variables appear in the model.  Static forecasts are also called
one-step-ahead forecasts.

{phang}
{opt actuals} specifies how nonmissing values of endogenous variables in the
forecast horizon are treated.  By default, nonmissing values are ignored, and
forecasts are produced for all endogenous variables.  When you specify
{opt actuals}, {opt forecast} sets the forecast values equal to the actual
values if they are nonmissing.  The forecasts for the other endogenous
variables are then conditional on the known values of the endogenous variables
with nonmissing data.

{dlgtab:Simulation}

{phang}
{opt simulate(sim_technique, sim_statistic sim_options)}
allows you to simulate your model to obtain measures of uncertainty
surrounding the point forecasts produced by the model.  Simulating a model
involves repeatedly solving the model, each time accounting for the
uncertainty associated with the error terms and the estimated coefficient
vectors.

{phang2}
{it:sim_technique} can be {cmd:betas}, {cmd:errors}, or {cmd:residuals}, or
you can specify both {cmd:betas} and one of {cmd:errors} or {cmd:residuals}
separated by a space.  You cannot specify both {cmd:errors} and
{cmd:residuals}.  The {it:sim_technique} controls how uncertainty is
introduced into the model.

{phang2}
{it:sim_statistic} specifies a summary statistic to summarize the
forecasts over all the simulations.  {it:sim_statistic} takes the form

{pmore3}
{cmd:statistic(}{it:statistic}{cmd:,} {c -(}{opt prefix(string)} | 
        {opt suffix(string)}{c )-}{cmd:)}

{pmore2}
where {it:statistic} may be {opt mean}, {opt variance}, or {opt stddev}.  You
may specify either the prefix or the suffix that will be used to name
the variables that will contain the requested {it:statistic}.  You may
specify up to three {it:sim_statistic}s, allowing you to track the mean,
variance, and standard deviations of your forecasts.

{phang2}
{it:sim_options} include
{opt saving(filename, [suboptions])},
{opt nodots},
and
{opt reps(#)}.

{phang3}
{opt saving(filename, [suboptions])} creates a Stata data
file ({cmd:.dta} file) consisting of (for each endogenous variable in the
model) a variable containing the simulated values.

{pmore3}
{opt double} specifies that the results for each replication be saved as
doubles, meaning 8-byte reals.  By default, they are saved as floats, meaning
4-byte reals.

{pmore3} 
{opt replace} specifies that {it:filename} be overwritten if it exists.

{pmore3}
{opt every(#)} specifies that results be written to disk every {it:#}th
replication.  {cmd:every()} should be specified only in conjunction with
{cmd:saving()} when the command takes a long time for each replication.  This
will allow recovery of partial results should some other software crash your
computer.  See {helpb postfile:[P] postfile}.

{phang3}
{opt nodots} suppresses display of the replication dots.  By default, one dot
character is displayed for each successful replication.  If during a
replication convergence is not achieved, {cmd:forecast} {cmd:solve} exits with
an error message.

{phang3}
{opt reps(#)} requests that {cmd:forecast} {cmd:solve} perform {it:#}
replications; the default is {cmd:reps(50)}.  

{dlgtab:Reporting}

{phang}
{opt log(log_level)} specifies the level of logging provided while
solving the model.  {it:log_level} may be {cmd:detail}, {cmd:on}, {cmd:brief},
or {cmd:off}.

{pmore}
{cmd:log(detail)} provides a detailed iteration log including the current
values of the convergence criteria for each period in each panel (in the case
of panel data) for which the model is being solved.

{pmore}
{cmd:log(on)}, the default, provides an iteration log showing the current
panel and period for which the model is being solved as well as a sequence of
dots for each period indicating the number of iterations.

{pmore}
{cmd:log(brief)}, when used with a time-series dataset, is equivalent to
{cmd:log(on)}.  When used with a panel dataset, {cmd:log(brief)} produces an
iteration log showing the current panel being solved but does not show which
period within the current panel is being solved.

{pmore}
{cmd:log(off)} requests that no iteration log be produced.

{dlgtab:Solver}

{phang}
{opt vtolerance(#)}, {opt ztolerance(#)}, and {opt iterate(#)} control when
the solver of the system of equations stops.  {cmd:ztolerance()} is
ignored if either {cmd:technique(dampedgaussseidel} {it:#}{cmd:)} or
{cmd:technique(gaussseidel)} is specified.  These options are seldom used.  See
{helpb mf_solvenl:[M-5] solvenl()}.

{phang}
{opt technique(technique)} specifies the technique to use to solve the
system of equations.  {it:technique} may be
{cmd:dampedgaussseidel} {it:#}, {cmd:gaussseidel},
{cmd:broydenpowell}, or {cmd:newtonraphson},
where 0 < # < 1 specifies the amount of damping with smaller numbers
indicating less damping.  The default is {cmd:technique(dampedgaussseidel}
{cmd:0.2)}, which works well in most situations.  If you have convergence
issues, first try continuing to use {cmd:dampedgaussseidel} {it:#} but with
a larger damping factor.  Techniques {cmd:broydenpowell} and
{cmd:newtonraphson} usually work well, but because they require the
computation of numerical derivatives, they tend to be much slower.  See
{helpb mf_solvenl:[M-5] solvenl()}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gdpoil}{p_end}

{pstd}Fit the VAR model and store the estimation results{p_end}
{phang2}{cmd:. var gdp oil, lags(1 2)}{p_end}
{phang2}{cmd:. estimates store var}

{pstd}Extend the dataset three years to 2010{p_end}
{phang2}{cmd:. tsappend, add(12)}

{pstd}Create a forecast model and obtain baseline forecasts{p_end}
{phang2}{cmd:. forecast create oilmodel}{p_end}
{phang2}{cmd:. forecast estimates var}{p_end}
{phang2}{cmd:. forecast solve, prefix(bl_)}{p_end}

{pstd}Fill in {cmd:oil} with our hypothesized price path{p_end}
{phang2}{cmd:. replace oil = 10 if qdate == tq(2008q1)}{p_end}
{phang2}{cmd:. replace oil = 10 if qdate == tq(2008q2)}{p_end}
{phang2}{cmd:. replace oil = 10 if qdate == tq(2008q3)}{p_end}
{phang2}{cmd:. replace oil = 0 if qdate > tq(2008q3)}{p_end}

{pstd}Obtain forecasts conditional on the {cmd:oil} variable, using
the prefix {cmd:alt_} for these forecast variables{p_end}
{phang2}{cmd:. forecast solve, prefix(alt_) actuals}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. webuse klein2}{p_end}
{phang2}{cmd:. reg3 (c p L.p w) (i p L.p L.k) (wp y L.y yr), endog(w p y)}
        {cmd:exog(t wg g)}{p_end}
{phang2}{cmd:. estimates store klein}{p_end}
{phang2}{cmd:. forecast create kleinmodel}{p_end}
{phang2}{cmd:. forecast estimates klein}{p_end}
{phang2}{cmd:. forecast identity y = c + i + g}{p_end}
{phang2}{cmd:. forecast identity p = y - t - wp}{p_end}
{phang2}{cmd:. forecast identity k = L.k + i}{p_end}
{phang2}{cmd:. forecast identity w = wg + wp}{p_end}
{phang2}{cmd:. forecast exogenous wg}{p_end}
{phang2}{cmd:. forecast exogenous g}{p_end}
{phang2}{cmd:. forecast exogenous t}{p_end}
{phang2}{cmd:. forecast exogenous yr}{p_end}

{pstd}Set the {help set seed:random-number seed} so the results can be
replicated{p_end}
{phang2}{cmd:. set seed 1}

{pstd}Solve the model, using the prefix {cmd:d_} for the forecast variables
and the prefix {cmd:sd_} for the standard deviations of the forecasts{p_end}
{phang2}{cmd:. forecast solve, prefix(d_) begin(1936)}
        {cmd:simulate(betas, statistic(stddev, prefix(sd_)) reps(100))}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:forecast solve} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(first_obs)}}first observation in forecast horizon{p_end}
{synopt:{cmd:r(last_obs)}}last observation in forecast horizon (of first panel
if forecasting panel data){p_end}
{synopt:{cmd:r(Npanels)}}number of panels forecast{p_end}
{synopt:{cmd:r(Nvar)}}number of forecast variables{p_end}
{synopt:{cmd:r(vtolerance)}}tolerance for forecast values{p_end}
{synopt:{cmd:r(ztolerance)}}tolerance for function zero{p_end}
{synopt:{cmd:r(iterate)}}maximum number of iterations{p_end}
{synopt:{cmd:r(sim_nreps)}}number of simulations{p_end}
{synopt:{cmd:r(damping)}}damping parameter for damped Gauss-Seidel{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(prefix)}}forecast variable prefix{p_end}
{synopt:{cmd:r(suffix)}}forecast variable suffix{p_end}
{synopt:{cmd:r(actuals)}}{cmd:actuals}, if specified{p_end}
{synopt:{cmd:r(static)}}{cmd:static}, if specified{p_end}
{synopt:{cmd:r(double)}}{cmd:double}, if specified{p_end}
{synopt:{cmd:r(technique)}}solution method{p_end}
{synopt:{cmd:r(sim_technique)}}specified {it:sim_technique}{p_end}
{synopt:{cmd:r(logtype)}}{cmd:on}, {cmd:off}, {cmd:brief}, or {cmd:detail}{p_end}
