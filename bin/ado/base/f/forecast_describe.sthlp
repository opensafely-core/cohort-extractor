{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast describe" "mansection TS forecastdescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast list" "help forecast list"}{...}
{viewerjumpto "Syntax" "forecast_describe##syntax"}{...}
{viewerjumpto "Description" "forecast_describe##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_describe##linkspdf"}{...}
{viewerjumpto "Options" "forecast_describe##options"}{...}
{viewerjumpto "Examples" "forecast_describe##examples"}{...}
{viewerjumpto "Stored results" "forecast_describe##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[TS] forecast describe} {hline 2}}Describe features of the
forecast model{p_end}
{p2col:}({mansection TS forecastdescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Describe the current forecast model

{p 8 15 2}
{cmdab:fore:cast} {cmdab:d:escribe} 
[{cmd:,} {it:{help forecast_describe##opt_table:options}}]


{pstd}
Describe particular aspects of the current forecast model

{p 8 15 2}
{cmdab:fore:cast} {cmdab:d:escribe}
{it:{help forecast_describe##aspect:aspect}}
[{cmd:,} {it:{help forecast_describe##opt_table:options}}]


{marker aspect}{...}
{synoptset 26}{...}
{synopthdr:aspect}
{synoptline}
{synopt :{opt est:imates}}estimation results{p_end}
{synopt :{opt co:efvector}}coefficient vectors{p_end}
{synopt :{opt id:entity}}identities{p_end}
{synopt :{opt ex:ogenous}}declared exogenous variables{p_end}
{synopt :{opt ad:just}}adjustments to endogenous variables{p_end}
{synopt :{opt s:olve}}forecast solution information{p_end}
{synopt :{opt en:dogenous}}all endogenous variables{p_end}
{synoptline}

{marker opt_table}{...}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{synopt: {opt b:rief}}provide a one-line summary{p_end}
{p2coldent :* {opt d:etail}}provide more-detailed information{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Specifying {cmd:detail} provides no additional information with
    {it:aspect}s {cmd:exogenous}, {cmd:endogenous}, and {cmd:solve}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast describe} displays information about the forecast model
currently in memory.  For example, you can obtain information regarding all 
the endogenous or exogenous variables in the model, the adjustments used for
alternative scenarios, or the solution method used.  Typing {cmd:forecast}
{cmd:describe} without specifying a particular aspect of the model is
equivalent to typing {cmd:forecast} {cmd:describe} for every available aspect
and can result in more output than you want, particularly if you also request
a detailed description.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastdescribeQuickstart:Quick start}

        {mansection TS forecastdescribeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:brief} requests that {cmd:forecast describe} produce a one-sentence
summary of the aspect specified.  For example, {cmd:forecast} {cmd:describe}
{cmd:exogenous,} {cmd:brief} will tell you just the current forecast model's
name and the number of exogenous variables in the model.

{phang}
{cmd:detail} requests a more-detailed description of the aspect specified.
For example, typing {cmd:forecast} {cmd:describe} {cmd:estimates} lists all the
estimation results added to the model using {cmd:forecast} {cmd:estimates},
the estimation commands used, and the number of left-hand-side variables in
each estimation result.  When you specify {cmd:forecast} {cmd:describe}
{cmd:estimates,} {cmd:detail}, the output includes a list of all the
left-hand-side variables entered with {cmd:forecast} {cmd:estimates}.


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

{pstd}Specify the four identities that determine the other four
endogenous variables in our model{p_end}
{phang2}{cmd:. forecast identity y = c + i + g}{p_end}
{phang2}{cmd:. forecast identity p = y - t - wp}{p_end}
{phang2}{cmd:. forecast identity k = L.k + i}{p_end}
{phang2}{cmd:. forecast identity w = wg + wp}{p_end}

{pstd}Identify the four exogenous variables{p_end}
{phang2}{cmd:. forecast exogenous wg}{p_end}
{phang2}{cmd:. forecast exogenous g}{p_end}
{phang2}{cmd:. forecast exogenous t}{p_end}
{phang2}{cmd:. forecast exogenous yr}{p_end}

{pstd}Display information about all the endogenous variables{p_end}
{phang2}{cmd:. forecast describe endogenous}{p_end}

{pstd}Display information about the estimated equations{p_end}
{phang2}{cmd:. forecast describe estimates}{p_end}

{pstd}Obtain one-step-ahead forecasts{p_end}
{phang2}{cmd:. forecast solve, prefix(bl_) begin(1939)}{p_end}

{pstd}Display information about the solution above{p_end}
{phang2}{cmd:. forecast describe estimates}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
When you specify option {cmd:brief}, only a limited number of results are
stored.  In the tables below, a (B) indicates results that are
available even after {cmd:brief} is specified.  {cmd:forecast}
{cmd:coefvector} saves certain results only if {cmd:detail} is specified;
these are indicated by (D).  Typing {cmd:forecast} {cmd:describe}
without specifying an aspect does not return any results.


{pstd}
{cmd:forecast describe estimates} stores the following in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(n_estimates)} (B)}number of estimation results{p_end}
{synopt:{cmd:r(n_lhs)}}number of left-hand-side variables defined by
estimation results{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(lhs)}}left-hand-side variables{p_end}
{synopt:{cmd:r(estimates)}}names of estimation results{p_end}


{pstd}
{cmd:forecast} {cmd:describe} {cmd:identity} stores the following in {cmd:r()}:

{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(n_identities)} (B)}number of identities{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(lhs)}}left-hand-side variables{p_end}
{synopt:{cmd:r(identities)}}list of identities{p_end}


{pstd}
{cmd:forecast} {cmd:describe} {cmd:coefvector} stores the following in
{cmd:r()}:

{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(n_coefvectors)} (B)}number of coefficient vectors{p_end}
{synopt:{cmd:r(n_lhs)} (B)}number of left-hand-side variables defined by
coefficient vectors{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(lhs)}}left-hand-side variables{p_end}
{synopt:{cmd:r(rhs)} (D)}right-hand-side variables{p_end}
{synopt:{cmd:r(names)}}names of coefficient vectors{p_end}
{synopt:{cmd:r(Vnames)} (D)}names of variance matrices ("{cmd:.}" if not
specified){p_end}
{synopt:{cmd:r(Enames)} (D)}names of error variance matrices ("{cmd:.}" if not
specified){p_end}


{pstd}
{cmd:forecast describe exogenous} stores the following in {cmd:r()}:

{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(n_exogenous)} (B)}number of declared exogenous variables{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(exogenous)}}declared exogenous variables{p_end}


{pstd}
{cmd:forecast} {cmd:describe} {cmd:endogenous} stores the following in
{cmd:r()}:

{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(n_endogenous)} (B)}number of endogenous variables{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(varlist)}}endogenous variables{p_end}
{synopt:{cmd:r(source_list)}}sources of endogenous variables ({cmd:estimates},
 {cmd:identity}, {cmd:coefvector}){p_end}
{synopt:{cmd:r(adjust_cnt)}}number of adjustments per endogenous
variable{p_end}


{pstd}
{cmd:forecast} {cmd:describe} {cmd:solve} stores the following in {cmd:r()}:

{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(periods)}}number of periods forecast per panel{p_end}
{synopt:{cmd:r(Npanels)}}number of panels forecast{p_end}
{synopt:{cmd:r(Nvar)}}number of forecast variables{p_end}
{synopt:{cmd:r(damping)}}damping parameter for damped Gauss-Seidel{p_end}
{synopt:{cmd:r(maxiter)}}maximum number of iterations{p_end}
{synopt:{cmd:r(vtolerance)}}tolerance for forecast values{p_end}
{synopt:{cmd:r(ztolerance)}}tolerance for function zero{p_end}
{synopt:{cmd:r(sim_nreps)}}number of simulations{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(solved)} (B)}{cmd:solved}, if the model has been solved{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(actuals)}}{cmd:actuals}, if specified with {cmd:forecast}
{cmd:solve}{p_end}
{synopt:{cmd:r(double)}}{cmd:double}, if specified with {cmd:forecast}
{cmd:solve}{p_end}
{synopt:{cmd:r(static)}}{cmd:static}, if specified with {cmd:forecast}
{cmd:solve}{p_end}
{synopt:{cmd:r(begin)}}first period in forecast horizon{p_end}
{synopt:{cmd:r(end)}}last period in forecast horizon{p_end}
{synopt:{cmd:r(technique)}}solver technique{p_end}
{synopt:{cmd:r(sim_technique)}}specified {it:sim_technique}{p_end}
{synopt:{cmd:r(prefix)}}forecast variable prefix{p_end}
{synopt:{cmd:r(suffix)}}forecast variable suffix{p_end}
{synopt:{cmd:r(sim_prefix_}{it:i}{cmd:)}}{it:i}th simulation statistic
prefix{p_end}
{synopt:{cmd:r(sim_suffix_}{it:i}{cmd:)}}{it:i}th simulation statistic
suffix{p_end}
{synopt:{cmd:r(sim_stat_}{it:i}{cmd:)}}{it:i}th simulation statistic{p_end}


{pstd}
{cmd:forecast} {cmd:describe} {cmd:adjust} stores the following in {cmd:r()}:

{p2col 5 24 28 2: Scalars}{p_end}
{synopt:{cmd:r(n_adjustments)} (B)}total number of adjustments{p_end}
{synopt:{cmd:r(n_adjust_vars)} (B)}number of variables with adjustments{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt:{cmd:r(model)} (B)}name of forecast model, if named{p_end}
{synopt:{cmd:r(varlist)}}variables with adjustments{p_end}
{synopt:{cmd:r(adjust_cnt)}}number of adjustments per endogenous
variable{p_end}
{synopt:{cmd:r(adjust_list)}}list of adjustments{p_end}
