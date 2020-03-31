{smcl}
{* *! version 1.1.21  14feb2019}{...}
{viewerdialog ci "dialog ci"}{...}
{viewerdialog "cii (normal mean)" "dialog cii, message(-normal-)"}{...}
{viewerdialog "cii (Poisson mean)" "dialog cii, message(-poisson-)"}{...}
{viewerdialog "cii (proportion)" "dialog cii, message(-prop-)"}{...}
{viewerdialog "cii (variance)" "dialog cii, message(-variance-)"}{...}
{viewerdialog "cii (standard deviation)" "dialog cii, message(-sd-)"}{...}
{vieweralsosee "[R] ci" "mansection R ci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ameans" "help ameans"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] centile" "help centile"}{...}
{vieweralsosee "[D] pctile" "help pctile"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "ci##syntax"}{...}
{viewerjumpto "Menu" "ci##menu"}{...}
{viewerjumpto "Description" "ci##description"}{...}
{viewerjumpto "Links to PDF documentation" "ci##linkspdf"}{...}
{viewerjumpto "Options for ci and cii means" "ci##options_means"}{...}
{viewerjumpto "Options for ci and cii proportions" "ci##options_props"}{...}
{viewerjumpto "Options for ci and cii variances" "ci##options_var"}{...}
{viewerjumpto "Examples" "ci##examples"}{...}
{viewerjumpto "Stored results" "ci##results"}{...}
{viewerjumpto "References" "ci##references"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] ci} {hline 2}}Confidence intervals for means, proportions, and variances{p_end}
{p2col:}({mansection R ci:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Confidence intervals for means, normal distribution

{p 8 11 2}
{cmd:ci} {cmdab:mean:s} [{varlist}] 
{ifin}
[{it:{help ci##weight:weight}}]
[{cmd:,}  {it:{help ci##options:options}}]

{p 8 12 2}
{cmd:cii} {cmdab:mean:s} {it:#obs} {it:#mean} {it:#sd}
[{cmd:,} {opt l:evel(#)}] 


{phang}Confidence intervals for means, Poisson distribution

{p 8 11 2}
{cmd:ci} {cmdab:mean:s} [{varlist}] 
{ifin}
[{it:{help ci##weight:weight}}]{cmd:,}
{opt pois:son}
[{opth exp:osure(varname)} {it:{help ci##options:options}}]

{p 8 12 2}
{cmd:cii}  {cmdab:mean:s} {it:#exposure} {it:#events}{cmd:,} 
{opt pois:son} [{opt l:evel(#)}] 


{phang}Confidence intervals for proportions

{p 8 11 2}
{cmd:ci } {cmdab:prop:ortions } [{varlist}] 
{ifin}
[{it:{help ci##weight:weight}}]
[{cmd:,}
{it:{help ci##prop_options:prop_options}}
{it:{help ci##options:options}}]

{p 8 12 2}
{cmd:cii} {cmdab:prop:ortions} {it:#obs} {it:#succ}
[{cmd:,}
{it:{help ci##prop_options:prop_options}}
{opt l:evel(#)}] 


{phang}Confidence intervals for variances  

{p 8 11 2}
{cmd:ci } {cmdab:var:iances}
[{varlist}] 
{ifin}
[{it:{help ci##weight:weight}}]
[{cmd:,}
{opt bon:ett}
{it:{help ci##options:options}}]

{p 8 12 2}
{cmd:cii} {cmdab:var:iances} {it:#obs} {it:#variance}
[{cmd:,} {opt l:evel(#)}] 

{p 8 12 2}
{cmd:cii} {cmdab:var:iances} {it:#obs} {it:#variance} {it:#kurtosis}{cmd:,} 
{opt bon:ett}
[{opt l:evel(#)}] 


{phang}Confidence intervals for standard deviations

{p 8 11 2}
{cmd:ci} {cmdab:var:iances}
[{varlist}] 
{ifin}
[{it:{help ci##weight:weight}}]{cmd:,}
{opt sd}
[{opt bon:ett} {it:{help ci##options:options}}]

{p 8 12 2}
{cmd:cii} {cmdab:var:iances} {it:#obs} {it:#sd}{cmd:,}
{opt sd}
[{opt l:evel(#)}] 

{p 8 12 2}
{cmd:cii} {cmdab:var:iances} {it:#obs} {it:#sd} {it:#kurtosis}{cmd:,}
{opt sd}
{opt bon:ett}
[{opt l:evel(#)}] 


{phang}
{it:#obs} must be a positive integer.  {it:#exposure}, {it:#sd}, and
{it:#variance} must be a positive number.  {it:#succ} and {it:#events} must be
a nonnegative integer or between 0 and 1.  If the number is between 0 and 1,
Stata interprets it as the fraction of successes or events and converts it to
an integer number representing the number of successes or events.  The
computation then proceeds as if two integers had been specified. If option
{opt bonett} is specified, you must additionally specify {it:#kurtosis} with
{cmd:cii variances}. 

{synoptset 21}{...}
{marker prop_options}{...}
{synopthdr :prop_options}
{synoptline}
{synopt :{opt exact}}calculate exact confidence intervals; the default{p_end}
{synopt :{opt wald}}calculate Wald confidence intervals{p_end}
{synopt :{opt wilson}}calculate Wilson confidence intervals{p_end}
{synopt :{opt agres:ti}}calculate Agresti-Coull confidence intervals{p_end}
{synopt :{opt jeff:reys}}calculate Jeffreys confidence intervals{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 21}{...}
{marker options}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt sep:arator(#)}}draw separator line after every {it:#} variables;
default is {cmd:separator(5)}{p_end}
{synopt :{opt total}}add output for all groups combined (for use with {opt by}
only){p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{opt by} and {opt statsby} are allowed with {cmd:ci}; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s are allowed with {cmd:ci means} for normal data, and
{opt fweight}s are allowed with all {cmd:ci} subcommands; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

    {title:ci} 

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Summary and descriptive statistics > Confidence intervals}

    {title:cii for a normal mean}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Summary and descriptive statistics > Normal mean CI calculator}

    {title:cii for a Poisson mean}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
        {bf:Summary and descriptive statistics > Poisson mean CI calculator}

    {title:cii for a proportion}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
       {bf:Summary and descriptive statistics > Proportion CI calculator}

    {title:cii for a variance}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
       {bf:Summary and descriptive statistics > Variance CI calculator}

    {title:cii for a standard deviation}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
       {bf:Summary and descriptive statistics > Standard deviation CI calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ci} computes confidence intervals for population means, proportions,
variances, and standard deviations.

{pstd}
{cmd:cii} is the immediate form of {cmd:ci}; see {help immed} for a general
discussion of immediate commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ciQuickstart:Quick start}

        {mansection R ciRemarksandexamples:Remarks and examples}

        {mansection R ciMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_means}{...}
{title:Options for ci and cii means}

{dlgtab:Main}

{phang}
{opt poisson} specifies that the variables (or numbers for {cmd:cii}) are
Poisson-distributed counts; exact Poisson confidence intervals will be
calculated. By default, confidence intervals for means are calculated based on
a normal distribution.

{phang}
{opth exposure(varname)} is used only with {opt poisson}.  You do not need
to specify {opt poisson} if you specify {opt exposure()};
{opt poisson} is assumed. {it:varname} contains the total exposure (typically a
time or an area) during which the number of events recorded in {varlist} was
observed.

INCLUDE help ci_opt


{marker options_props}{...}
{title:Options for ci and cii proportions}

{dlgtab:Main}

{phang}
{opt exact}, {opt wald}, {opt wilson}, {opt agresti}, and {opt jeffreys}
specify how binomial confidence intervals are to be calculated.

{pmore}
{opt exact} is the default and specifies exact (also known in the literature
as Clopper-Pearson [{help ci##CP1934:1934}]) binomial confidence intervals.

{pmore}
{opt wald} specifies calculation of Wald confidence intervals.

{pmore}
{opt wilson} specifies calculation of Wilson confidence intervals.

{pmore}
{opt agresti} specifies calculation of Agresti-Coull confidence intervals.

{pmore}
{opt jeffreys} specifies calculation of Jeffreys confidence intervals.

{pmore}
See {help ci##BCD2001:Brown, Cai, and DasGupta (2001)} for a discussion and
comparison of the different binomial confidence intervals.

INCLUDE help ci_opt


{marker options_var}{...}
{title:Options for ci and cii variances}

{dlgtab:Main}

{phang}
{opt sd} specifies that confidence intervals for standard deviations be
calculated. The default is to compute confidence intervals for variances.

{phang}
{opt bonett} specifies that Bonett confidence intervals be calculated.
The default is to compute normal-based confidence intervals, which assume
normality for the data.

INCLUDE help ci_opt


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Obtain 90% confidence intervals for means of
     normally distributed variables{p_end}
{phang2}{cmd:. ci means mpg price, level(90)}

   {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse petri}

{pstd}Obtain exact Poisson confidence interval for the mean of a count variable{p_end}
{phang2}{cmd:. ci means count, poisson}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse rm}{p_end}

{pstd}Obtain confidence interval for a rate based on total exposure{p_end}
{phang2}{cmd:. ci means deaths, exposure(pyears)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse promonone}

{pstd}Obtain various binomial confidence intervals for proportions{p_end}
{phang2}{cmd:. ci proportions promoted}{p_end}
{phang2}{cmd:. ci proportions promoted, wilson}{p_end}
{phang2}{cmd:. ci proportions promoted, agresti}{p_end}
{phang2}{cmd:. ci proportions promoted, jeffreys}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse peas_normdist}{p_end}

{pstd}Obtain confidence interval for the variance{p_end}
{phang2}{cmd:. ci variances weight}

{pstd}Obtain 90% Bonett confidence interval for the standard deviation {p_end}
{phang2}{cmd:. ci variances weight, sd bonett level(90)}
    
     {hline}
{pstd}Obtain confidence interval for mean for data with 166 observations,
mean=19509, and sd=4379{p_end}
{phang2}{cmd:. cii means 166 19509 4379}

{pstd}Same as above, but obtain 90% confidence interval{p_end}
{phang2}{cmd:. cii means 166 19509 4379, level(90)}

{pstd}Obtain Poisson confidence interval for data with 1 exposure and 27
events{p_end}
{phang2}{cmd:. cii means 1 27, poisson}{p_end}

{pstd}Obtain binomial confidence interval for data with 10 binomial events
and 1 observed success{p_end}
{phang2}{cmd:. cii proportions 10 1}

{pstd}Same as above, but obtain the Wilson confidence interval{p_end}
{phang2}{cmd:. cii proportions 10 1, wilson}

{pstd}Obtain a confidence interval for the variance based on a sample 
with 15 observations and sample variance of 2.1{p_end}
{phang2}{cmd:. cii variances 15 2.1}{p_end}

{pstd}Obtain 90% Bonett confidence interval for the standard deviation based
on a sample with 15 observations, sd = 0.7, and kurtosis = 5.2{p_end}
{phang2}{cmd:. cii variances 15 0.7 5.2, sd bonett level(90)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ci means} and {cmd:cii means} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations or, if {bf:poisson} is specified, exposure{p_end}
{synopt:{cmd:r(mean)}}mean{p_end}
{synopt:{cmd:r(se)}}estimate of standard error{p_end}
{synopt:{cmd:r(lb)}}lower bound of confidence interval{p_end}
{synopt:{cmd:r(ub)}}upper bound of confidence interval{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence interval{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(citype)}}{bf:normal} or {bf:poisson}; type of confidence interval{p_end}
{synopt:{cmd:r(exposure)}}name of exposure variable with {bf:poisson}{p_end}
{p2colreset}{...}

{pstd}
{cmd:ci proportions} and {cmd:cii proportions} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(proportion)}}proportion{p_end}
{synopt:{cmd:r(se)}}estimate of standard error{p_end}
{synopt:{cmd:r(lb)}}lower bound of confidence interval{p_end}
{synopt:{cmd:r(ub)}}upper bound of confidence interval{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence interval{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(citype)}}{bf:exact}, {bf:wald}, {bf:wilson}, {bf:agresti}, or {bf:jeffreys}; type of confidence interval{p_end}
{p2colreset}{...}

{pstd}
{cmd:ci variances} and {cmd:cii variances} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(Var)}}variance{p_end}
{synopt:{cmd:r(sd)}}standard deviation, if {opt sd} is specified{p_end}
{synopt:{cmd:r(kurtosis)}}kurtosis, only if {opt bonett} is specified{p_end}
{synopt:{cmd:r(lb)}}lower bound of confidence interval{p_end}
{synopt:{cmd:r(ub)}}upper bound of confidence interval{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence interval{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(citype)}}{bf:normal} or {bf:bonett}, type of confidence interval{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BCD2001}{...}
{phang}
Brown, L. D., T. T. Cai, and A. DasGupta. 2001.  
Interval estimation for a binomial proportion. 
{it:Statistical Science} 16: 101-133.

{marker CP1934}{...}
{phang}
Clopper, C. J., and E. S. Pearson. 1934.  The
use of confidence or fiducial limits illustrated in the case of the binomial.  
{it:Biometrika} 26: 404-413.
{p_end}
