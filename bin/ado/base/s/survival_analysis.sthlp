{smcl}
{* *! version 1.2.11  15oct2018}{...}
{vieweralsosee "[ST] Survival analysis" "mansection ST Survivalanalysis"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Description" "survival analysis##description"}{...}
{viewerjumpto "Links to PDF documentation" "survival_analysis##linkspdf"}{...}
{viewerjumpto "Reference" "survival analysis##reference"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[ST] Survival analysis} {hline 2}}Introduction to survival
analysis{p_end}
{p2col:}({mansection ST Survivalanalysis:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Stata's survival analysis routines are used to compute sample size,
power, and effect size and to declare, convert, manipulate, summarize, and
analyze survival data.  Survival data are time-to-event data, and survival
analysis is full of jargon: truncation, censoring, hazard rates, etc.  See
{helpb st_glossary:[ST] Glossary}.  For a good Stata-specific introduction to
survival analysis, see
{help survival analysis##CGM2016:Cleves, Gould, and Marchenko (2016)}.

{pstd}
To learn how to effectively analyze survival analysis data using
Stata, we recommend NetCourse 631,
{it:Introduction to Survival Analysis Using Stata}; see
{browse "https://www.stata.com/netcourse/nc631.html":https://www.stata.com/netcourse/nc631.html}.

{pstd}
All the commands documented in this manual are listed below, and they are
described in detail in their respective manual entries.  While most commands
for survival analysis are documented here, some are documented in other
manuals.  The commands for computing sample size, power, and effect size for
survival analysis are documented in the
{mansection PSS pssPower,Precision,andSampleSize:{it:Stata Power, Precision, and Sample-Size Reference Manual}}
with the other {cmd:power} commands.  The command for longitudinal or
panel-data survival analysis is documented with the other panel-data commands
in the
{mansection XT xtLongitudinalData/PanelData:{it:Stata Longitudinal-Data/Panel-Data Reference Manual}}.
The command for multilevel survival analysis is documented with the other
multilevel commands in the
{mansection ME meMultilevelMixedEffects:{it:Stata Multilevel Mixed-Effects Reference Manual}}.
The commands for estimating treatment effects from observational survival-time
data are documented in the
{mansection TE teTreatmentEffects:{it:Stata Treatment-Effects Reference Manual}}.


    {title:Declaring and converting count data}

{p2colset 9 30 32 2}{...}
{p2col :{helpb ctset}}Declare data to be count-time data{p_end}
{p2col :{helpb cttost}}Convert count-time data to survival-time data{p_end}


    {title:Converting snapshot data}

{p2colset 9 30 32 2}{...}
{p2col :{helpb snapspan}}Convert snapshot data to time-span data{p_end}


    {title:Declaring and summarizing survival-time data}

{p2colset 9 30 32 2}{...}
{p2col :{helpb stset}}Declare data to be survival-time data{p_end}
{p2col :{helpb stdescribe}}Describe survival-time data{p_end}
{p2col :{helpb stsum}}Summarize survival-time data{p_end}


    {title:Manipulating survival-time data}

{p2colset 9 30 32 2}{...}
{p2col :{helpb stvary}}Report variables that vary over time{p_end}
{p2col :{helpb stfill}}Fill in by carrying forward values of covariates{p_end}
{p2col :{helpb stgen}}Generate variables reflecting entire histories{p_end}
{p2col :{helpb stsplit}}Split time-span records{p_end}
{p2col :{helpb stjoin}}Join time-span records{p_end}
{p2col :{helpb stbase}}Form baseline dataset{p_end}


    {title:Obtaining summary statistics, confidence intervals, tables, etc.}

{p2colset 9 30 32 2}{...}
{p2col :{helpb sts}}Generate, graph, list, and test the survivor and cumulative hazard functions{p_end}
{p2col :{helpb stir}}Report incidence-rate comparison{p_end}
{p2col :{helpb stci}}Confidence intervals for means and percentiles of survival
time{p_end}
{p2col :{helpb strate}}Tabulate failure rate{p_end}
{p2col :{helpb stptime}}Calculate person-time, incidence rates, and SMR{p_end}
{p2col :{helpb stmh}}Calculate rate ratios with the Mantel-Haenszel method{p_end}
{p2col :{helpb stmc}}Calculate rate ratios with the Mantel-Cox method{p_end}
{p2col :{helpb ltable}}Display and graph life tables{p_end}


    {title:Fitting regression models}

{p2col :{helpb stcox}}Cox proportional hazards model{p_end}
{p2col :{helpb estat concordance}}Compute the concordance probability{p_end}
{p2col :{helpb estat phtest}}Test Cox proportional-hazards assumption{p_end}
{p2col :{helpb stphplot}}Graphically assess the Cox proportional-hazards assumption{p_end}
{p2col :{helpb stcoxkm}}Graphically assess the Cox proportional-hazards assumption{p_end}
{p2col :{helpb streg}}Parametric survival models{p_end}
{p2col :{helpb stintreg}}Parametric models for interval-censored survival-time data{p_end}
{p2col :{helpb estat gofplot}}Graphically assess goodness of fit of models for
interval-censored data{p_end}
{p2col :{helpb stcrreg}}Competing-risks regression{p_end}
{p2col :{helpb xtstreg}}Random-effects parametric survival models{p_end}
{p2col :{helpb mestreg}}Multilevel mixed-effects parametric survival
model{p_end}
{p2col :{helpb stcurve}}Plot survivor, hazard, cumulative hazard, or cumulative incidence function{p_end}
{p2col :{helpb stteffects}}Treatment-effects estimation for observational
survival-time data{p_end}
{p2col :{helpb fmm_streg:fmm: streg}}Finite mixtures of parametric survival
models{p_end}
{p2col :{helpb bayes_streg:bayes: streg}}Bayesian parametric survival
models{p_end}
{p2col :{helpb bayes_mestreg:bayes: mestreg}}Bayesian multilevel parametric
survival models{p_end}


    {title:Sample-size and power determination for survival analysis}

{p2col :{helpb power cox}}Sample size, power, and effect size for the Cox proportional hazards model{p_end}
{p2col :{helpb power exponential}}Sample size and power for the exponential test{p_end}
{p2col :{helpb power logrank}}Sample size, power, and effect size for the log-rank test{p_end}


    {title:Converting survival-time data}

{p2col :{helpb sttocc}}Convert survival-time data to case-control data{p_end}
{p2col :{helpb sttoct}}Convert survival-time data to count-time data{p_end}


    {title:Programmer's utilities}

{p2colset 9 30 32 2}{...}
{p2col :{helpb st_is}}Survival analysis subroutines for programmers{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST SurvivalanalysisRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker reference}{...}
{title:Reference} 

{marker CGM2016}{...}
{phang}Cleves, M. A., W. W. Gould, and Y. V. Marchenko. 2016. 
{browse "https://www.stata-press.com/books/saus3.html":{it:An Introduction to Survival Analysis Using Stata}.} 
Rev. 3rd ed. College Station, TX: Stata Press.{p_end}
