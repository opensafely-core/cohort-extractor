{smcl}
{* *! version 1.0.0  27feb2019}{...}
{viewerdialog ciwidth "dialog ciwidth_dlg"}{...}
{vieweralsosee "[PSS-3] ciwidth" "mansection PSS-3 ciwidth"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] Intro (ciwidth)" "mansection PSS-3 Intro(ciwidth)"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{viewerjumpto "Syntax" "ciwidth##syntax"}{...}
{viewerjumpto "Menu" "ciwidth##menu"}{...}
{viewerjumpto "Description" "ciwidth##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth##linkspdf"}{...}
{viewerjumpto "Options" "ciwidth##options"}{...}
{viewerjumpto "Examples" "ciwidth##examples"}{...}
{viewerjumpto "Stored results " "ciwidth##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[PSS-3] ciwidth} {hline 2}}Precision and sample-size analysis for
CIs{p_end}
{p2col:}({mansection PSS-3 ciwidth:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:ciwidth} {help ciwidth##method:{it:method}}
...{cmd:,}
{opth w:idth(numlist)}
{opth probw:idth(numlist)}
[{help ciwidth##ciwidth_options:{it:ciwidth_options}}]


{pstd}
Compute CI width

{p 8 16 2}
{opt ciwidth} {help ciwidth##method:{it:method}}
...{cmd:,}
{opth probw:idth(numlist)}
{opth n(numlist)}
[{help ciwidth##ciwidth_options:{it:ciwidth_options}}]


{pstd}
Compute probability of CI width

{p 8 16 2}
{opt ciwidth} {help ciwidth##method:{it:method}}
...{cmd:,}
{opth w:idth(numlist)}
{opth n(numlist)}
[{help ciwidth##ciwidth_options:{it:ciwidth_options}}]


{marker method}{...}
{synoptset 30 tabbed}{...}
{synopthdr :method}
{synoptline}
{syntab:One sample}
{synopt :{helpb ciwidth onemean:onemean}}CI for one mean{p_end}
{synopt :{helpb ciwidth onevariance:{ul:onevar}iance}}CI for one
variance{p_end}

{syntab:Two independent samples}
{synopt :{helpb ciwidth twomeans:twomeans}}CI for comparing two means from
independent samples{p_end}

{syntab:Two paired samples}
{synopt :{helpb ciwidth pairedmeans:{ul:pairedm}eans}}CI for comparing two
means from paired samples{p_end}

{syntab:User-defined methods}
{synopt :{help ciwidth usermethod:{it:usermethod}}}Add your own method to {cmd:ciwidth}{p_end}
{synoptline}

{marker ciwidth_options}{...}
{synopthdr :ciwidth_options}
{synoptline}
{syntab:Main}
INCLUDE help ciw_ciopts
INCLUDE help ciw_nnumopts
INCLUDE help ciw_nfracopt
INCLUDE help ciw_sideopts

INCLUDE help ciw_tableopts

INCLUDE help ciw_graphopts

INCLUDE help ciw_iteropts
{synoptline}
INCLUDE help pss_numlist
{p 4 6 2}Options {cmd:n1()}, {cmd:n2()}, {cmd:nratio()}, and
{cmd:compute()} are available only for two-independent-samples
methods.{p_end}
{p 4 6 2}Iteration options are available only with computations requiring
iteration.{p_end}
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
The {cmd:ciwidth} command performs precision and sample-size analysis (PrSS)
for CIs.  You can compute sample size given CI width (or precision) and
probability of CI width.  Alternatively, you can compute CI width given sample
size and probability of CI width.  You can also compute probability of CI
width given sample size and CI width.  You can display results in a table
({helpb ciwidth_opttable:[PSS-3] ciwidth, table}) and on a graph
({helpb ciwidth_optgraph:[PSS-3] ciwidth, graph}).

{pstd}
For power and sample-size analysis for hypothesis tests, see
{manhelp power PSS-2}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidthRemarksandexamples:Remarks and examples}

        {mansection PSS-3 ciwidthMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mainopts}{...}
{dlgtab:Main}

{phang}
{opth level(numlist)} specifies the confidence level, as a percentage,
for CIs.  The default is {cmd:level(95)} or as set by
{helpb set level}.  If {cmd:alpha()} is specified,
this value is set to be 100(1-{cmd:alpha()}).  Only one of {cmd:level()} or
{cmd:alpha()} may be specified.

{phang}
{opth alpha(numlist)} sets the significance level.  Only one
of {cmd:level()} or {cmd:alpha()} may be specified.

{phang}
{opth probwidth(numlist)} specifies the probability of obtaining a CI with the
width no larger than a target CI width.  The target CI width is either computed
by the command or specified in option {cmd:width()}.  This option is required
to compute sample size and CI width.

{phang} 
{opth width(numlist)} specifies the target CI width, which represents the
precision of the CI.  This option is required to compute sample size and
probability of CI width.  For a two-sided CI, CI width is the
distance between the upper and lower limits.  For a one-sided CI, it is the
distance from the limit to the estimate of the parameter of interest, such as
a sample mean.

INCLUDE help ciw_twosamplesdes

{pmore}
Also see the description and the use of options {cmd:n()}, {cmd:n1()},
{cmd:n2()}, {cmd:nratio()}, and {cmd:nfractional} for two-sample CIs in
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}}
of {bf:[PSS] Unbalanced designs}.

{phang}
{opt lower} specifies a lower one-sided CI and may not be combined with 
option {opt upper}.  The default is a two-sided CI.

{phang}
{opt upper} specifies an upper one-sided CI and may not be combined with 
option {opt lower}.  The default is a two-sided CI.

{phang}
{opt onesided} is a synonym for {opt upper}, which specifies an upper
one-sided CI.

INCLUDE help ciw_paralleloptdes

{dlgtab:Table}

{phang}
{opt notable}, {opt table}, and {opt table()} control whether or not results
are displayed in a tabular format.  {opt table} is implied if any number list
contains more than one element.  {opt notable} is implied with graphical
output -- when either the {opt graph} or the {opt graph()} option is
specified.  {opt table()} is used to produce custom tables.  See
{helpb ciwidth table:[PSS-3] ciwidth, table} for details.

{phang}
{cmd:saving(}{it:{help filename}} [{cmd:, replace}]{cmd:)} creates a Stata
data file ({cmd:.dta} file) containing the table values with variable names
corresponding to the displayed {help ciwidth table##column:{it:columns}}.
{cmd:replace} specifies that {it:filename} be overwritten if it exists.
{cmd:saving()} is only appropriate with tabular output.
{p_end}

{dlgtab:Graph}

{phang}
{opt graph} and {opt graph()} produce graphical output; see
{helpb ciwidth_optgraph:[PSS-3] ciwidth, graph} for details.

{pstd}
The following options control an iteration procedure used by the {cmd:ciwidth}
command for solving nonlinear equations.

INCLUDE help ciw_initoptdes

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
{opt log} and {opt nolog} specify whether an iteration log is to be displayed.
The iteration log is suppressed by default.  Only one of {opt log},
{opt nolog}, {opt dots}, or {opt nodots} may be specified.

{phang}
{opt dots} and {opt nodots} specify whether a dot is to be displayed for each
iteration.  The iteration dots are suppressed by default.  Only one of
{opt dots}, {opt nodots}, {opt log}, or {opt nolog} may be specified.

{pstd}
The following option is available with {cmd:ciwidth} but is not shown in the
dialog box:

{phang}
{cmd:notitle} prevents the command title from displaying.


{marker examples}{...}
{title:Examples}

    {title:Examples: One-mean confidence interval}

{pstd}
    Compute the required sample size for a two-sided 95% CI (the default) 
    for a population mean; assume a CI width of 6, a standard deviation of 
    8, and a 90% probability that the CI width will be no larger than 6 
    in a future study{p_end}
{phang2}{cmd:. ciwidth onemean, width(6) probwidth(0.9) sd(8)}

{pstd}
    Compute the CI width for the parameters given in the previous example,
    assuming a sample size of 80{p_end}
{phang2}{cmd:. ciwidth onemean, n(80) probwidth(0.9) sd(8)}

{pstd}
    Same as above, reporting output in a table{p_end}
{phang2}{cmd:. ciwidth onemean, n(80) probwidth(0.9) sd(8) table}

{pstd}
   Produce a table showing the sample size required to obtain a CI width
   of 6, 8, and 10 with a 90% probability, assuming a standard deviation
   of 8{p_end}
{phang2}{cmd:. ciwidth onemean, width(6 8 10) probwidth(0.9) sd(8)}

{pstd}
    Compute the required sample size for an upper one-sided 99% CI{p_end}
{phang2}{cmd:. ciwidth onemean, width(6) probwidth(0.9) sd(8) upper level(99)}


    {title:Examples: Two-means-difference confidence interval}

{pstd}
    Compute the total sample size required for a two-sided 95% CI 
    (the default) for the difference between two means to have a width 
    no larger than 8 with a probability of 90%; assume that the standard 
    deviations of the two groups are both 4{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4)}

{pstd}
    Same as above, except specifying that the experimental group will
    have twice as many observations as the control group{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4) nratio(2)}

{pstd}
    Same as above, but allowing for fractional sample sizes{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4)}
       {cmd:nratio(2) nfractional}

{pstd}
    Compute the total sample size, assuming the standard deviations    
    are known to be 4 for the control group and 5 for the experimental
    group{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) sd1(4) sd2(5) knownsds}


    {title:Examples: Tabular output}

{pstd}
    Display results in a table{p_end}
{phang2}{cmd:. ciwidth onemean, n(80) width(4) sd(8) table}{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}


    {title:Examples: Graphical output}

{pstd}
    Display results in a graph{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) probwidth(0.9) sd(12) graph}{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) probwidth(0.8 0.85 0.9) sd(12) graph}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ciwidth} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(level)}}confidence level{p_end}
{synopt :{cmd:r(alpha)}}significance level{p_end}
{synopt :{cmd:r(N)}}total sample size{p_end}
{synopt :{cmd:r(N_a)}}actual sample size{p_end}
{synopt :{cmd:r(N1)}}sample size of the control group{p_end}
{synopt :{cmd:r(N2)}}sample size of the experimental group{p_end}
{synopt :{cmd:r(nratio)}}ratio of sample sizes, {cmd:N2/N1}{p_end}
{synopt :{cmd:r(nratio_a)}}actual ratio of sample sizes{p_end}
{synopt :{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified,
{cmd:0} otherwise{p_end}
{synopt :{cmd:r(onesided)}}{cmd:1} for a one-sided CI, {cmd:0} otherwise{p_end}
{synopt :{cmd:r(Pr_width)}}probability of CI width{p_end}
{synopt :{cmd:r(Pr_width_a)}}actual probability of CI width (for sample-size
determination when {cmd:probwidth()} specified){p_end}
{synopt :{cmd:r(width)}}CI width{p_end}
{synopt :{cmd:r(width_a)}}actual CI width (for sample-size determination of
some methods){p_end}
{synopt :{cmd:r(separator)}}number of lines between separator lines in the
table{p_end}
{synopt :{cmd:r(divider)}}{cmd:1} if {cmd:divider} is requested in the table,
{cmd:0} otherwise{p_end}
{synopt :{cmd:r(init)}}initial value for estimated parameter{p_end}
{synopt :{cmd:r(maxiter)}}maximum number of iterations{p_end}
{synopt :{cmd:r(iter)}}number of iterations performed{p_end}
{synopt :{cmd:r(tolerance)}}requested parameter tolerance{p_end}
{synopt :{cmd:r(deltax)}}final parameter tolerance achieved{p_end}
{synopt :{cmd:r(ftolerance)}}requested distance of the objective function from
zero{p_end}
{synopt :{cmd:r(function)}}final distance of the objective function from
zero{p_end}
{synopt :{cmd:r(converged)}}{cmd:1} if iteration algorithm converged, {cmd:0}
otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(type)}}{cmd:ci}{p_end}
{synopt :{cmd:r(method)}}the name of the specified {cmd:ciwidth} method{p_end}
{synopt :{cmd:r(onesidedci)}}{cmd:upper} or {cmd:lower} (for a one-sided CI){p_end}
{synopt :{cmd:r(columns)}}displayed table columns{p_end}
{synopt :{cmd:r(labels)}}table column labels{p_end}
{synopt :{cmd:r(widths)}}table column widths{p_end}
{synopt :{cmd:r(formats)}}table column formats{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}

{pstd}
Also see {it:Stored results} in the method-specific manual entries for
the full list of stored results.
{p_end}
