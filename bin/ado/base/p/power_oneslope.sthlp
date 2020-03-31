{smcl}
{* *! version 1.0.11  21mar2019}{...}
{viewerdialog power "dialog power_oneslope"}{...}
{vieweralsosee "[PSS-2] power oneslope" "mansection PSS-2 poweroneslope"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power pcorr" "help power pcorr"}{...}
{vieweralsosee "[PSS-2] power rsquared" "help power rsquared"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "power_oneslope##syntax"}{...}
{viewerjumpto "Menu" "power_oneslope##menu"}{...}
{viewerjumpto "Description" "power_oneslope##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_oneslope##linkspdf"}{...}
{viewerjumpto "Options" "power_oneslope##options"}{...}
{viewerjumpto "Remarks: Using power oneslope" "power_oneslope##remarks"}{...}
{viewerjumpto "Examples" "power_oneslope##examples"}{...}
{viewerjumpto "Stored results" "power_oneslope##stored_results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[PSS-2] power oneslope} {hline 2}}Power analysis for a slope test
in a simple linear regression{p_end}
{p2col:}({mansection PSS-2 poweroneslope:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size 

{p 8 43 2}
{opt power} {opt oneslope} {it:b0} {it:ba} 
[, {opth p:ower(numlist)}  {it:{help power_oneslope##synoptions:options}}]


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt oneslope} {it:b0} {it:ba}{cmd:,}
{opth n(numlist)} [{it:{help power_oneslope##synoptions:options}}]


{phang}
Compute effect size and target slope 

{p 8 43 2}
{opt power} {opt oneslope} {it:b0}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)}  [{it:{help power_oneslope##synoptions:options}}]


{phang}
where {it:b0} is the null (hypothesized) slope or the value of the slope
coefficient under the null hypothesis and {it:ba} is the alternative (target)
slope or the value of the slope coefficient under the alternative hypothesis.
{it:b0} and {it:ba} may each be specified either as one number or as a list of
values in parentheses (see {it:{help numlist}}).{p_end}


{synoptset 28 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the alternative slope and
the null slope coefficients, {it:ba}-{it:b0}; specify instead of the alternative
slope {it:ba}{p_end}
{p2coldent:* {opth sdx(numlist)}}standard deviation of the covariate of
interest; default is {cmd:sdx(1)}{p_end}
{p2coldent:* {opth sderr:or(numlist)}}standard deviation of the error term of
the regression model; may not be combined with {opt sdy()} or {opt corr()};
default is {cmd:sderror(1)}{p_end}
{p2coldent:* {opth sdy(numlist)}}standard deviation of the dependent variable;
may not be combined with {opt sderror()} or {opt corr()}{p_end}
{p2coldent:* {opth corr(numlist)}}correlation between the response variable and
the covariate of interest; may not be combined with {opt sderror()} or 
{opt sdy()}{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_oneslope##tablespec:tablespec}}{cmd:)}]}suppress table or display
results as a table; see {manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or slope{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_oneslope##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 28}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}number of subjects{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt b0}}null slope coefficient{p_end}
{synopt :{opt ba}}alternative slope coefficient{p_end}
{synopt :{opt diff}}difference between alternative and null slope
coefficients{p_end}
{synopt :{opt sdx}}standard deviation of covariate{p_end}
{synopt :{opt sderror}}standard deviation of error term{p_end}
{synopt :{opt sdy}}standard deviation of dependent variable{p_end}
{synopt :{opt corr}}correlation between dependent variable and covariate{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:ba}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:diff}, {cmd:sdy}, and {cmd:corr} are shown in the default
table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:oneslope} computes sample size, power, or the target slope
coefficient for  a test of a slope in a simple linear regression. By default,
it computes sample size given power and the slope coefficient.  Alternatively,
it computes power given sample size and the slope coefficient, or it computes
the target slope coefficient given sample size, power, and the coefficient
under the null.  See {manhelp power PSS-2} for a general introduction to the
{cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweroneslopeQuickstart:Quick start}

        {mansection PSS-2 poweroneslopeRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweroneslopeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; see
{manhelp power##mainopts PSS-2:power}.
The {opt nfractional} option is allowed only for sample-size determination.

{phang}
{opth diff(numlist)} specifies the difference between the alternative slope and
the null slope coefficients, {it:ba} - {it:b0}.  You can specify either the
alternative slope {it:ba} as a command argument or the difference between the
two slopes in {cmd:diff()}.  If you specify {opt diff(#)}, the alternative
slope is computed as {it:ba} = {it:b0} + {it:#}.  This option is not allowed
with the effect-size determination.

{phang}
{opth sdx(numlist)} specifies the standard deviation of the covariate 
of interest.  The default is {cmd:sdx(1)}. 

{phang}
{opth sderror(numlist)} specifies the standard deviation of the error term of
the regression model.  The default is {cmd:sderror(1)}.  This option may not
be combined with {cmd:sdy()} or {cmd:corr()}. 

{phang}
{opth sdy(numlist)} specifies the standard deviation of the dependent variable
in the regression model.  This option may not be combined with {cmd:sderror()}
or {cmd:corr()}. 

{phang}
{opth corr(numlist)} specifies the correlation between the covariate of
interest and the dependent variable.  This option may not be combined with
{cmd:sderror()} or {cmd:sdy()}. 

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweroneslopeSyntaxcolumn:column} table in
{bf:[PSS-2] power oneslope} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the slope for the effect-size
determination.  The default is to use a closed-form normal approximation to
compute an initial value for the sample size and a bisection search method to
compute an initial value for the effect size.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power oneslope} but is not shown
in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power oneslope}

{pstd}
{cmd:power oneslope} computes sample size, power, or target slope for a
test of slope in a simple linear regression.  By default, all computations are
performed for a two-sided hypothesis test where the significance level is set
to 0.05.  You can change the significance level by specifying the
{cmd:alpha()} option.  You can request a one-sided test by specifying the
{cmd:onesided} option.

{pstd}
By default, all computations use one as the standard deviation of the
covariate of interest and as the standard deviation of the error.  You can
change these values by specifying the {cmd:sdx()} and {cmd:sderror()} options.
Instead of the {cmd:sderror()} option, you can combine the {cmd:sdx()} option
with the {cmd:sdy()} option to specify the standard deviation of the dependent
variable or combine the {cmd:sdx()} option with the {cmd:corr()} option to
specify the correlation between the covariate and the dependent variable.

{pstd}
To compute sample size, you must specify the slopes under the null hypothesis
({it:b0} and the slope under the alternative hypothesis ({it:ba}), and you may
specify the power of the test in the {cmd:power()} option.  The default power
is set to 0.8.

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option, 
the null slope {it:b0}, and the alternative slope {it:ba}.

{pstd}
When computing sample size or power, you may specify the difference
between the alternative slope and null slope, {it:ba} - {it:b0}, in the
{cmd:diff()} option instead of specifying the alternative slope.

{pstd}
To compute effect size, you must specify the sample size in the {cmd:n()}
option, the power in the {cmd:power()} option, and the null slope {it:b0}, and
you may specify the direction of the effect.  {it:delta} is defined as the
difference between the alternative and null values of the slope multiplied by
the ratio of standard deviation of the covariate to that of the error term.
The direction is upper by default, {cmd:direction(upper)}, which means that
the target slope is assumed to be larger than the specified null value.  This
is also equivalent to the assumption of a positive effect size.  You may
change the direction to lower by specifying the {cmd:direction(lower)} option,
which means that the target slope is assumed to be smaller than the specified
null value.  This is equivalent to assuming a negative effect size.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in 
{bf:[PSS-4] Unbalanced designs} for an example.  The
{cmd:nfractional} option is allowed only for sample-size determination.

{pstd}
{cmd:power oneslope}'s computations of sample size and effect size require
iteration.  A noncentral Student's t distribution is used for the
computations.  The degrees of freedom depends on the sample size, and the
noncentrality parameter depends on the sample size and effect size.  The
default initial value of the sample size is obtained using a closed-form
normal approximation.  The default initial value of the effect size is
obtained using a bisection search method.  The default initial values may be
changed by specifying the {cmd:init()} option.  See {helpb power:[PSS-2] power}
for the descriptions of other options that control the iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
Compute sample size required to detect a slope coefficient of 0.5 when the
value under the null hypothesis is 0 for a two-sided test with 80%
power and a 5% significance level.  The standard deviation of the covariate 
and the error are known to be
1.{p_end}
{phang2}
{cmd:. power oneslope 0 0.5}

{pstd}
Same as above, using the {cmd:diff()} option to specify the difference in
slopes under the null and alternative hypotheses{p_end}
{phang2}{cmd:. power oneslope 0, diff(0.5)}

{pstd}
Same as the first example, using a power of 90%{p_end}
{phang2}{cmd:. power oneslope 0 0.5, power(0.9)}

{pstd}
Same as above, knowing the standard deviation of the error is 2{p_end}
{phang2}{cmd:. power oneslope 0 0.5, power(0.9) sderror(2)}

{pstd}
Same as above, knowing the standard deviation of the covariate is 0.5{p_end}
{phang2}{cmd:. power oneslope 0 0.5, power(0.9) sderror(2) sdx(0.5)}

{pstd}
Same as first example, using a one-sided test with a 1% significance level
{p_end}
{phang2}{cmd:. power oneslope 0 0.5, alpha(0.01) onesided}

{pstd}
Specify a list of alternative slopes and two power levels, graphing the
results{p_end}
{phang2}{cmd:. power oneslope 0 (0.25(0.05)0.5), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
Compute the power of a one-sided test for a sample size of 75 and a 5% 
significance level.  The
value of the slope coefficients under the null and the alternative hypothesis
are known to be 0 and 0.5, respectively.  Use a default value of 1 as the
standard deviation of the covariate and the error.{p_end}
{phang2}{cmd:. power oneslope 0 0.5, n(75)}{p_end}

{pstd}
Same as above, knowing the standard deviation of the dependent variable is
2{p_end}
{phang2}{cmd:. power oneslope 0 0.5, n(75) sdy(2)}

{pstd}
Same as the first example, knowing the correlation between the covariate and
the dependent variable is 0.3{p_end}
{phang2}{cmd:. power oneslope 0 0.5, n(75) corr(0.3)}

{pstd}
Compute powers for several alternative slopes and sample sizes, graphing the
results{p_end}
{phang2}{cmd:. power oneslope 0 (0.1 0.3 0.6), n(20(1)35) graph}


    {title:Examples: Computing target slope}

{pstd}
Compute the minimum value of the slope exceeding 0 that can be detected using a
two-sided hypothesis test with 50 observations and a power of 80%; assume a 5%
significance level, and a standard deviation of 1 for the covariate and the
error (the defaults).{p_end}
{phang2}{cmd:. power oneslope 0, n(50) power(0.8)}

{pstd}
Same as above{p_end}
{phang2}{cmd:. power oneslope 0, n(50) power(0.8) direction(upper)}

{pstd}
Compute the maximum slope value below 0 that can be detected{p_end}
{phang2}{cmd:. power oneslope 0, n(50) power(0.8) direction(lower)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power oneslope} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(b0)}}slope coefficient under the null hypothesis{p_end}
{synopt:{cmd: r(ba)}}slope coefficient under the alternative hypothesis{p_end}
{synopt:{cmd: r(diff)}}difference between the alternative and null slopes{p_end}
{synopt:{cmd: r(sdx)}}standard deviation of the covariate of interest{p_end}
{synopt:{cmd: r(sderror)}}standard deviation of the error term of the
regression model{p_end}
{synopt:{cmd: r(sdy)}}standard deviation of the dependent variable{p_end}
{synopt:{cmd: r(corr)}}correlation between the covariate of interest and the
response variable{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or for slope{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:oneslope}
{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
