{smcl}
{* *! version 1.2.5  11dec2018}{...}
{viewerdialog estat "dialog exlogistic_estat"}{...}
{vieweralsosee "[R] exlogistic postestimation" "mansection R exlogisticpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] exlogistic" "help exlogistic"}{...}
{viewerjumpto "Postestimation commands" "exlogistic postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "exlogistic_postestimation##linkspdf"}{...}
{viewerjumpto "estat" "exlogistic postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "exlogistic postestimation##examples"}{...}
{viewerjumpto "Stored results" "exlogistic postestimation##results"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[R] exlogistic postestimation} {hline 2}}Postestimation tools for
exlogistic{p_end}
{p2col:}({mansection R exlogisticpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:exlogistic}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb exlogistic postestimation##estatpred:estat predict}}single-observation prediction{p_end}
{synopt :{helpb exlogistic postestimation##estatse:estat se}}report
ORs or coefficients and their asymptotic standard errors{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estimates
{synoptline}
{p2colreset}{...}
{pstd}
{cmd:estat summarize} is not allowed if the
{helpb exlogistic##binomial():binomial()} option was
specified in {cmd:exlogistic}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R exlogisticpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_estat}{...}
{marker estatpred}{marker estatse}{...}
{title:Syntax for estat}

{pstd}Single-observation prediction

{p 8 14 2}
{cmd:estat} {cmdab:pred:ict} [{cmd:,} {it:options}]


{pstd}Report ORs or coefficients and their asymptotic standard errors

{p 8 14 2}
{cmd:estat} {opt se}  
[{cmd:,} {cmd:coef}]


{synoptset 17}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt pr}}probability; the default{p_end}
{synopt :{opt xb}}linear effect{p_end}
{synopt :{opt at(atspec)}}use the specified values for the {indepvars} and {opt condvars()}{p_end}
{synopt :{opt l:evel(#)}}set confidence level for the predicted value; default is {cmd:level(95)}{p_end}
{synopt :{cmdab:mem:ory(}{it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}]{cmd:)}}set limit on memory usage; default is {cmd:memory(10m)}{p_end}
{synopt :[{cmd:no}]{cmd:log}}display or suppress the enumeration log; default
is to display{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}These statistics are available only for the estimation sample.


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat predict} computes a predicted probability (or linear predictor), 
its asymptotic standard error, and its exact confidence interval for 1 
observation.  Predictions are carried out by estimating the constant 
coefficient after shifting  the independent variables and conditioned variables
by the values specified in the {cmd: at()} option or by their medians.
Therefore, predictions must be done with the estimation sample in memory.  If a
different dataset is used or if the dataset is modified, then an error will
result.  

{pstd}
{cmd:estat se} reports odds ratio or coefficients and their asymptotic standard
errors.  The estimates are stored in the matrix {cmd:r(estimates)}.


{marker options_estat_predict}{...}
{title:Options for estat predict}

{phang}
{opt pr}, the default, calculates the probability.

{phang}
{opt xb} calculates the linear effect.

{phang}
{cmd: at(}{varname} {cmd:=} {it:#} [[{it:varname} {cmd:=} {it:#}]
[ ... ]]{cmd:)} specifies values 
to use in computing the predicted value.  Here {it: varname} is one of the
independent variables, {indepvars}, or the conditioned variables,
{cmd:condvars()}.  The default is to use the median of each independent and
conditioned variable.

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{phang} 
{cmd:memory(}{it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}]{cmd:)} sets a limit on
the amount of memory {cmd:estat predict} can use when generating the
conditional distribution of the constant parameter sufficient statistic.  The
default is {cmd:memory(10m)}, where {cmd:m} stands for megabyte, or 1,048,576
bytes.  The following are also available:  {cmd:b} stands for byte; {cmd:k}
stands for kilobyte, which is equal to 1,024 bytes; and {cmd:g} stands for
gigabyte, which is equal to 1,024 megabytes. The minimum setting allowed is 1m
and the maximum is 512m or 0.5g, but do not attempt to use more memory than is
available on your computer.  Also see
{it:{help exlogistic##enumerations:Remarks}}
in {helpb exlogistic} for details on enumerating the conditional distribution.

{phang}
{opt log} and {opt nolog} specify whether to display of the enumeration log,
which shows the progress of enumerating the
distribution of the observed successes conditioned on the independent
variables shifted by the values specified in {opt at()} (or by their medians).
See {mansection R exlogisticMethodsandformulas:{it:Methods and formulas}} in
{bf:[R] exlogistic} for details of the computations.
The enumeration log is displayed by default unless you used
{cmd:set iterlog off} to suppress it; see {cmd:set iterlog} in
{manhelpi set_iter R:set iter}.


{marker option_estat_se}{...}
{title:Option for estat se}

{phang}
{opt coef} requests that the estimated coefficients and their asymptotic
standard errors be reported. The default is to report the odds ratios and
their asymptotic standard errors.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hiv}{p_end}

{pstd}Perform exact logistic regression{p_end}
{phang2}{cmd:. exlogistic hiv cd4 cd8 [fw=f]}

{pstd}Report odds ratios and their asymptotic standard errors{p_end}
{phang2}{cmd:. estat se}

{pstd}Summarize estimation sample{p_end}
{phang2}{cmd:. estat summarize}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hiv_n2}{p_end}

{pstd}Perform exact logistic regression{p_end}
{phang2}{cmd:. exlogistic hiv cd4_0 cd4_1 cd8_0 cd8_1,}
        {cmd:terms(cd4=cd4_0 cd4_1, cd8=cd8_0 cd8_1) binomial(n)}{p_end}

{pstd}Compute predicted probability using specified values{p_end}
{phang2}{cmd:. estat predict, at(cd4_1=1 cd4_0=0 cd8_1=1 cd8_0=0)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{phang}
{cmd:estat predict} stores the following in {opt r()}:

{synoptset 15 tabbed}{...}
{syntab:Scalars}
{synopt:{hi:r(imue)}}{cmd:1} if {hi:r(pred)} is an MUE and {cmd:0} if it is a
     CMLE{p_end}
{synopt:{hi:r(pred)}}estimated probability or the linear effect{p_end}
{synopt:{hi:r(se)}}asymptotic standard error of {hi:r(pred)}{p_end}

{syntab:Macros}
{synopt:{hi:r(estimate)}}prediction type: {cmd:pr} or {cmd:xb}{p_end}
{synopt:{hi:r(level)}}confidence level{p_end}

{syntab:Matrices}
{synopt:{hi:r(ci)}}confidence interval{p_end}
{synopt:{hi:r(x)}}{it:indepvars} and {cmd:condvars()} values{p_end}
