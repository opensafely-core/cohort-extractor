{smcl}
{* *! version 1.2.11  12mar2019}{...}
{viewerdialog power "dialog power_dlg"}{...}
{vieweralsosee "[PSS-2] power" "mansection PSS-2 power"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] Intro (power)" "mansection PSS-2 Intro(power)"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{viewerjumpto "Syntax" "power##syntax"}{...}
{viewerjumpto "Menu" "power##menu"}{...}
{viewerjumpto "Description" "power##description"}{...}
{viewerjumpto "Links to PDF documentation" "power##linkspdf"}{...}
{viewerjumpto "Options" "power##options"}{...}
{viewerjumpto "Examples" "power##examples"}{...}
{viewerjumpto "Stored results " "power##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[PSS-2] power} {hline 2}}Power and sample-size analysis for hypothesis tests{p_end}
{p2col:}({mansection PSS-2 power:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:power} {help power##method:{it:method}}
...
[{cmd:,} {opth p:ower(numlist)}
{help power##power_options:{it:power_options}} ...]


{pstd}
Compute power

{p 8 16 2}
{cmd:power} {help power##method:{it:method}}
...{cmd:,} {opth n(numlist)}
[{help power##power_options:{it:power_options}} ...]


{pstd}
Compute effect size and target parameter

{p 8 16 2}
{cmd:power} {help power##method:{it:method}}
    ...{cmd:,} {opth n:(numlist)} {opth p:ower(numlist)}
    [{help power##power_options:{it:power_options}} ...]


{marker method}{...}
{synoptset 30 tabbed}{...}
{synopthdr :method}
{synoptline}
{syntab:One sample}
{synopt :{helpb power onemean:onemean}}One-sample mean test (one-sample t
test){p_end}
{synopt :{helpb power oneproportion:{ul:oneprop}ortion}}One-sample proportion
test{p_end}
{synopt :{helpb power onecorrelation:{ul:onecorr}elation}}One-sample
correlation test{p_end}
{synopt :{helpb power onevariance:{ul:onevar}iance}}One-sample variance
test{p_end}

{syntab:Two independent samples}
{synopt :{helpb power twomeans:twomeans}}Two-sample means test (two-sample t
test){p_end}
{synopt :{helpb power twoproportions:{ul:twoprop}ortions}}Two-sample
proportions test{p_end}
{synopt :{helpb power twocorrelations:{ul:twocorr}elations}}Two-sample
correlations test{p_end}
{synopt :{helpb power twovariances:{ul:twovar}iances}}Two-sample variances
test{p_end}

{syntab:Two paired samples}
{synopt :{helpb power pairedmeans:{ul:pairedm}eans}}Paired-means test (paired
t test){p_end}
{synopt :{helpb power pairedproportions:{ul:pairedpr}oportions}}Paired-proportions test (McNemar's
test){p_end}

{syntab:Analysis of variance}
{synopt :{helpb power oneway:oneway}}One-way ANOVA{p_end}
{synopt :{helpb power twoway:twoway}}Two-way ANOVA{p_end}
{synopt :{helpb power repeated:repeated}}Repeated-measures ANOVA{p_end}

{syntab:Linear regression}
{synopt :{helpb power oneslope:oneslope}}Slope test in a simple linear regression{p_end}
{synopt :{helpb power rsquared:{ul:rsq}uared}}R^2 test in a multiple linear regression{p_end}
{synopt :{helpb power pcorr:pcorr}}Partial-correlation test in a multiple linear regression{p_end}

{syntab:Contingency tables}
{synopt :{helpb power cmh:cmh}}Cochran-Mantel-Haenszel test (stratified 2 x 2 tables){p_end}
{synopt :{helpb power mcc:mcc}}Matched case-control studies{p_end}
{synopt :{helpb power trend:trend}}Cochran-Armitage trend test (linear trend in J x 2 table){p_end}

{syntab:Survival analysis}
{synopt :{helpb power cox:cox}}Cox proportional hazards model{p_end}
{synopt :{helpb power exponential:{ul:exp}onential}}Two-sample exponential test{p_end}
{synopt :{helpb power logrank:{ul:log}rank}}Log-rank test{p_end}

{syntab:Cluster randomized design (CRD)}
{synopt :{helpb power onemean cluster:onemean, cluster}}One-sample mean test in a CRD{p_end}
{synopt :{helpb power oneproportion cluster:{ul:oneprop}ortion, cluster}}One-sample proportion test in a CRD{p_end}
{synopt :{helpb power twomeans cluster:twomeans, cluster}}Two-sample means test in a CRD{p_end}
{synopt :{helpb power twoproportions cluster:{ul:twoprop}ortions, cluster}}Two-sample proportions test in a CRD{p_end}
{synopt :{helpb power logrank cluster:{ul:log}rank, cluster}}Log-rank test in a CRD{p_end}

{syntab:User-defined methods}
{synopt :{help power usermethod:{it:usermethod}}}Add your own method to {cmd:power}{p_end}
{synoptline}


{marker power_options}{...}
{synopthdr :power_options}
{synoptline}
{syntab:Main}
INCLUDE help pss_twotestmainopts1
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
INCLUDE help pss_testmainopts3

{syntab:Table}
{synopt: [{cmd:{ul:no}}]{cmdab:tab:le}[{cmd:(}{it:{help power opttable##tablespec:tablespec}}{cmd:)}]}suppress table or
display results as a table; see {helpb power table:[PSS-2] power, table}{p_end}
INCLUDE help pss_otheropts

{syntab:Iteration}
{synopt :{opt init(#)}}initial value of the estimated parameter; default is
method specific{p_end}
INCLUDE help pss_iteropts

INCLUDE help pss_reportopts
{synoptline}
INCLUDE help pss_numlist
{p 4 6 2}
Options {cmd:n1()}, {cmd:n2()}, {cmd:nratio()}, and
{cmd:compute()} are available only for two-independent-samples methods.{p_end}
{p 4 6 2}
Iteration options are available only with computations requiring iteration.
{p_end}
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
The {cmd:power} command is useful for planning studies.  It performs power and
sample-size analysis for studies that use hypothesis testing to form
inferences about population parameters.  You can compute sample size given
power and effect size, power given sample size and effect size, or the minimum
detectable effect size and the corresponding target parameter given power and
sample size.  You can display results in a table
({helpb power_opttable:[PSS-2] power, table}) and on a graph
({helpb power_optgraph:[PSS-2] power, graph}).  

{pstd}
For precision and sample-size analysis for CIs, see
{helpb ciwidth:[PSS-3] ciwidth}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mainopts}{...}
{dlgtab:Main}

{phang}
{opth alpha(numlist)} sets the significance level of the test.  The
default is {cmd:alpha(0.05)}.

{phang}
{opth power(numlist)} sets the power of the test.  The default is
{cmd:power(0.8)}.  If {cmd:beta()} is specified, this value is set to be
1 - {cmd:beta()}.  Only one of {cmd:power()} or {cmd:beta()} may be
specified.

{phang}
{opth beta(numlist)} sets the probability of a type II error of the
test.  The default is {cmd:beta(0.2)}.  If {cmd:power()} is specified, this
value is set to be 1 - {cmd:power()}.  Only one of {cmd:beta()} or
{cmd:power()} may be specified.

INCLUDE help pss_twosamplesdes

{pmore}
Also see the description and the use of options {cmd:n()}, {cmd:n1()},
{cmd:n2()}, {cmd:nratio()}, and {cmd:compute()} for two-sample tests in
{manlink PSS-4 Unbalanced designs}.

{phang}
{cmd:direction(upper}|{cmd:lower)} specifies the direction of the effect for
effect-size determination.  For most methods, the default is
{cmd:direction(upper)}, which means that the postulated value of the parameter
is larger than the hypothesized value.  For survival methods, the default is
{cmd:direction(lower)}, which means that the postulated value is smaller than
the hypothesized value.

{phang}
{cmd:onesided} indicates a one-sided test.  The default is two sided.

{phang}
{cmd:parallel} requests that computations be performed in parallel over the
lists of numbers specified for at least two study parameters as command
arguments, starred options allowing {it:{help numlist}}, or both.  That is,
when {opt parallel} is specified, the first computation uses the first value
from each list of numbers, the second computation uses the second value, and
so on.  If the specified number lists are of different sizes, the last value
in each of the shorter lists will be used in the remaining computations.  By
default, results are computed over all combinations of the number lists.

{pmore}
For example, let a_1 and a_2 be the list of values for one study
parameter, and let b_1 and b_2 be the list of values for another study
parameter.  By default, {opt power} will compute results for all possible
combinations of the two values in the two study parameters: (a_1,b_1),
(a_1,b_2), (a_2,b_1), and (a_2,b_2).  If {opt parallel} is specified,
{opt power} will compute results for only two combinations: (a_1,b_1) and
(a_2,b_2).

{dlgtab:Table}

{phang}
{cmd:notable}, {cmd:table}, and {cmd:table()} control whether or not results
are displayed in a tabular format.  {cmd:table} is implied if any number list
contains more than one element.  {cmd:notable} is implied with graphical
output -- when either the {cmd:graph} or the {cmd:graph()} option is
specified.  {cmd:table()} is used to produce custom tables.  See
{helpb power_opttable:[PSS-2] power, table} for details.

{marker saving()}{...}
{phang}
{cmd:saving(}{it:{help filename}} [{cmd:, replace}]{cmd:)} creates a Stata data
file ({cmd:.dta} file) containing the table values with variable names
corresponding to the displayed  
{help power_opttable##column:{it:column}s}.
{cmd:replace} specifies that {it:filename} be overwritten if it exists.
{cmd:saving()} is only appropriate with tabular output.

{dlgtab:Graph}

{phang}
{cmd:graph} and {cmd:graph()} produce graphical output; see
{helpb power_optgraph:[PSS-2] power, graph} for details.

{pstd}
The following options control an iteration procedure used by the {cmd:power}
command for solving nonlinear equations.

{marker iteropts}{...}
{dlgtab:Iteration}

{phang}
{opt init(#)} specifies an initial value for the estimated parameter.  Each
{cmd:power} method sets its own default value.  See the documentation entry of
the method for details.

{phang}
{opt iterate(#)} specifies the maximum number of iterations for the
Newton method.  The default is {cmd:iterate(500)}.

{phang}
{opt tolerance(#)} specifies the tolerance used to determine whether
successive parameter estimates have converged.  The default is
{cmd:tolerance(1e-12)}.  See
{mansection M-5 solvenl()RemarksandexamplesConvergencecriteria:{it:Convergence criteria}} 
in {bf:[M-5] solvenl()} for details.

{phang}
{opt ftolerance(#)} specifies the tolerance used to determine whether the
proposed solution of a nonlinear equation is sufficiently close to 0 based on
the squared Euclidean distance.  The default is {cmd:ftolerance(1e-12)}.  See
{mansection M-5 solvenl()RemarksandexamplesConvergencecriteria:{it:Convergence criteria}}
in {bf:[M-5] solvenl()} for details.

{phang}
{cmd:log} and {cmd:nolog} specify whether an iteration log is to be displayed.
The iteration log is suppressed by default.  Only one of {cmd:log},
{cmd:nolog}, {cmd:dots}, or {cmd:nodots} may be specified.

{phang}
{cmd:dots} and {cmd:nodots} specify whether a dot is to be displayed for each
iteration.  The iteration dots are suppressed by default.  Only one of
{cmd:dots}, {cmd:nodots}, {cmd:log}, or {cmd:nolog} may be specified.

{marker reportopts}{...}
{pstd}
The following option is available with {cmd:power} but is not shown in the
dialog box:

{phang}
{cmd:notitle} prevents the command title from displaying.  


{marker examples}{...}
{title:Examples}

    {title:Examples: One-sample mean test}

{pstd}
    Compute the required sample size for a two-sided test of Ho: mu=2 versus 
    Ha: mu=2.5 assuming a standard deviation of 0.8, significance level of 
    5% (the default) and power of 0.80 (also the default){p_end}
{phang2}{cmd:. power onemean 2 2.5, sd(0.8)}
    
{pstd}
    Compute the power of the test in the previous example, assuming a sample
    size of 50{p_end}
{phang2}{cmd:. power onemean 2 2.5, sd(0.8) n(50)}
       
{pstd}
    Same as above, reporting output in a table{p_end}
{phang2}{cmd:. power onemean 2 2.5, sd(0.8) n(50) table}
       
{pstd}
    Produce a table showing the power of the test for sample sizes 25, 50, and
    100, using a significance level of 1% (0.01){p_end}
{phang2}{cmd:. power onemean 2 2.5, sd(0.8) n(25 50 100) alpha(0.01)}

{pstd}
    Compute the required sample size for a one-sided test{p_end}
{phang2}{cmd:. power onemean 2 2.5, sd(0.8) onesided}


    {title:Examples: Two-sample means test}

{pstd}
    Compute the required sample size for a two-sided two-sample means test
    assuming a control-group mean of 12, an experimental-group mean of 16,
    a significance level of 5%, and desired power of 80%; assume
    both groups have a standard deviation of 5{p_end}
{phang2}{cmd:. power twomeans 12 16, sd(5)}
       
{pstd}
    Same as above but assuming a control-group standard deviation of 5 and
    an experimental-group standard deviation of 7{p_end}
{phang2}{cmd:. power twomeans 12 16, sd1(5) sd2(7)}
       
{pstd}
    Same as above, assuming our experimental group is one-half the size of
    the control group{p_end}
{phang2}{cmd:. power twomeans 12 15, sd1(5) sd2(7) nratio(0.5)}
       
{pstd}
    Same as first example, using the {cmd:diff()} option to specify the mean
    difference under Ha{p_end}
{phang2}{cmd:. power twomeans 12, sd(5) diff(4)}


    {title:Examples: ANOVA}

{pstd}
    Consider power and sample-size analysis for an overall {it:F} test of the
    equality of group means for a three-group one-way ANOVA model.  For power
    and sample-size computations, the postulated group means are 260, 289,
    and 295; and the error variance is assumed to be 4900.  The significance
    level is set at 5%.

{pstd}
    Compute the required sample size given power of 80%, the default{p_end}
{phang2}{cmd:. power oneway 260 289 295, varerror(4900)}

{pstd}
    Compute power given a sample size of 300{p_end}
{phang2}{cmd:. power oneway 260 289 295, n(300) varerror(4900)}

{pstd}
    Compute the minimum effect size detectable with a power of 80% given a
    sample size of 300 equally allocated among 3 groups{p_end}
{phang2}{cmd:. power oneway, n(300) power(0.8) ngroups(3)}

{pstd}
    Specify error variance to compute the corresponding between-group
    variance{p_end}
{phang2}{cmd:. power oneway, n(300) power(0.8) ngroups(3) varerror(4900)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
INCLUDE help pss_rrestwotest_sc
INCLUDE help pss_rrestab_sc
{synopt:{cmd:r(init)}}initial value of the estimated parameter{p_end}
INCLUDE help pss_rresiter_sc

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}the name of the specified method{p_end}
INCLUDE help pss_rrestest_mac
INCLUDE help pss_rrestab_mac

{p2col 5 20 24 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat
{p2colreset}{...}

{pstd}
Also see {it:Stored results} in the method-specific manual entries for
the full list of stored results.
{p_end}
