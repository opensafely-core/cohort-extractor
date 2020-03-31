{smcl}
{* *! version 1.0.0  27feb2019}{...}
{viewerdialog "variance scale" "dialog ciwidth_onevar_var"}{...}
{viewerdialog "standard deviation scale" "dialog ciwidth_onevar_sd"}{...}
{vieweralsosee "[PSS-3] ciwidth onevariance" "mansection PSS-3 ciwidthonevariance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-3] ciwidth, graph" "help ciwidth graph"}{...}
{vieweralsosee "[PSS-3] ciwidth, table" "help ciwidth table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power onevariance" "help power onevariance"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{viewerjumpto "Syntax" "ciwidth onevariance##syntax"}{...}
{viewerjumpto "Menu" "ciwidth onevariance##menu"}{...}
{viewerjumpto "Description" "ciwidth onevariance##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth onevariance##linkspdf"}{...}
{viewerjumpto "Options" "ciwidth onevariance##options"}{...}
{viewerjumpto "Examples" "ciwidth onevariance##examples"}{...}
{viewerjumpto "Stored results " "ciwidth onevariance##results"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[PSS-3] ciwidth onevariance} {hline 2}}Precision analysis for a
one-variance CI{p_end}
{p2col:}({mansection PSS-3 ciwidthonevariance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 6 43 2}
Variance scale

{p 8 43 2}
{cmd:ciwidth} {cmdab:onevar:iance} {it:v}{cmd:,}
{opth w:idth(numlist)}
{opth probw:idth(numlist)}
[{help ciwidth onevariance##options_table:{it:options}}]

{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{cmd:ciwidth} {cmdab:onevar:iance} {it:s}{cmd:,}
{opt sd}
{opth w:idth(numlist)}
{opth probw:idth(numlist)}
[{help ciwidth onevariance##options_table:{it:options}}]


{pstd}
Compute CI width

{p 6 43 2}
Variance scale

{p 8 43 2}
{opt ciwidth} {cmdab:onevar:iance} {it:v}{cmd:,}
{opth probw:idth(numlist)}
{opth n(numlist)}
[{help ciwidth onevariance##options_table:{it:options}}]

{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{opt ciwidth} {cmdab:onevar:iance} {it:s}{cmd:,}
{opt sd}
{opth probw:idth(numlist)}
{opth n(numlist)}
[{help ciwidth onevariance##options_table:{it:options}}]


{pstd}
Compute probability of CI width

{p 6 43 2}
Variance scale

{p 8 43 2}
{opt ciwidth} {cmdab:onevar:iance} {it:v}{cmd:,}
{opth w:idth(numlist)}
{opth n(numlist)}
[{help ciwidth onevariance##options_table:{it:options}}]

{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{opt ciwidth} {cmdab:onevar:iance} {it:s}{cmd:,}
{opt sd}
{opth w:idth(numlist)}
{opth n(numlist)}
[{help ciwidth onevariance##options_table:{it:options}}]


{phang}
where {it:v} and {it:s} are variance and standard deviation, respectively.
Each argument may be specified either as one number or as a list of values in
parentheses (see {help numlist}).

{marker options_table}{...}
{synoptset 30 tabbed}{...}
{synopthdr :options}
{synoptline}
{synopt: {opt sd}}request computation using the standard-deviation scale;
default is the variance scale{p_end}
{syntab:Main}
INCLUDE help ciw_ciopts
INCLUDE help ciw_nopt
INCLUDE help ciw_nfracopt
INCLUDE help ciw_sideopts

INCLUDE help ciw_tableopts

INCLUDE help ciw_graphopts

INCLUDE help ciw_iteropts
{synoptline}
INCLUDE help pss_numlist
{p 4 6 2}{cmd:sd} does not appear in the dialog box; specification of {cmd:sd}
is done automatically by the dialog box selected.{p_end}
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 8 16 2}
{help ciwidth_onevariance##column:{it:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]]
[{cmd:,} {help ciwidth table##tableopts:{it:tableopts}}]

{pstd}
{it:column} is one of the columns defined
{help ciwidth_onevariance##column:below}, and {it:label} is a column label (may
contain quotes and compound quotes).

{marker column}{...}
{synoptset 28}{...}
{synopthdr :column}
{synoptline}
{synopt :{cmd:level}}confidence level{p_end}
{synopt :{cmd:alpha}}significance level{p_end}
{synopt :{cmd:N}}number of subjects{p_end}
{synopt :{cmd:Pr_width}}probability of CI width{p_end}
{synopt :{cmd:width}}CI width{p_end}
{synopt :{cmd:v}}variance{p_end}
{synopt :{cmd:s}}standard deviation{p_end}
{synopt :{cmd:_all}}display all supported columns{p_end}
{synoptline}
{p 4 6 2}Column {cmd:alpha} is shown in the default table in place of column
{cmd:level} if {cmd:alpha()} is specified.{p_end}
{p 4 6 2}Column {cmd:s} is shown in the default table in place of column
{cmd:v} if option {cmd:sd} is specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:ciwidth onevariance} computes sample size, CI width, and probability of
CI width for a CI for a population variance. It can compute sample size for a
given CI width and probability of CI width.  Alternatively, it can compute CI
width for a given sample size and probability of CI width. It can also compute
probability of CI width for a given sample size and CI width. The computation
is available for the variance or the standard deviation. Also see
{helpb ciwidth:[PSS-3] ciwidth} for PrSS analysis for other CI methods.

{pstd}
For power and sample-size analysis for a one-sample variance test, see
{helpb power onevariance:[PSS-2] power onevariance}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidthonevarianceRemarksandexamples:Remarks and examples}

        {mansection PSS-3 ciwidthonevarianceMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mainopts}{...}
{phang}
{opt sd} specifies that the computation be performed using the
standard-deviation scale.  The default is to use the variance scale.
Specification of the {opt sd} option is done automatically when the dialog box
for standard deviation is selected.

{dlgtab:Main}

{phang}
{opt level()}, {opt alpha()}, {opt probwidth()}, {opt width()}, {opt n()},
{opt nfractional}; see {helpb ciwidth:[PSS-3] ciwidth}.
The {opt nfractional} option is allowed only for sample-size determination.

INCLUDE help ciw_sideoptsdes

INCLUDE help ciw_tableoptsdes

INCLUDE help ciw_graphoptsdes
Also see the {mansection PSS-3 ciwidthonevarianceSyntaxcolumn:column} table in
{bf:[PSS-3] ciwidth onevariance} for a list of symbols used by the graphs.

INCLUDE help ciw_initoptdes

INCLUDE help ciw_iteroptsdes

{pstd}
The following option is available with {cmd:ciwidth onevariance} but is not shown
in the dialog box:

INCLUDE help ciw_nodboptdes


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required for a two-sided 95% CI 
    (the default) for a population variance to have a width 
    no larger than 1 with a probability of 96%; assume the 
    population variance estimate is 2{p_end}
{phang2}{cmd:. ciwidth onevariance 2, width(1) probwidth(0.96)}

{pstd}
    Compute sample size for a 95% CI for the population standard 
    deviation rather than the variance; assume the 
    population standard deviation estimate is 1.5{p_end}
{phang2}{cmd:. ciwidth onevariance 1.5, width(1)}
       {cmd:probwidth(0.96) sd}

{pstd}
    Same as first example, but allowing for a fractional 
    sample size{p_end}
{phang2}{cmd:. ciwidth onevariance 2, width(1) probwidth(0.96)}
       {cmd:nfractional}

{pstd}
    Same as first example, but for an upper one-sided 90% 
    confidence interval{p_end}
{phang2}{cmd:. ciwidth onevariance 2, width(1) probwidth(0.96)}
       {cmd:upper level(90)}


    {title:Examples: Computing CI width}

{pstd}
    Suppose we have a sample of 90 subjects and we want to 
    compute the width of a two-sided 95% CI (the default) for 
    a population variance; assume we want to be 96% certain that 
    the CI width in a future study will be no larger than the
    estimated width, and the population-variance estimate 
    is 2{p_end}
{phang2}{cmd:. ciwidth onevariance 2, n(90) probwidth(0.96)}

{pstd}
    Compute the CI width for a standard deviation of 2{p_end}
{phang2}{cmd:. ciwidth onevariance 2, n(80) probwidth(0.96) sd}

{pstd}
    Compute the CI width for several alternative sample sizes{p_end}
{phang2}{cmd:. ciwidth onevariance 2, n(60(10)80) probwidth(0.96) sd}


    {title:Examples: Computing probability of CI width}

{pstd}
    Suppose that we have a sample of 100 subjects and we want 
    to compute the probability of obtaining a CI width no larger
    than 4 for a two-sided 95% CI (the default) for the population 
    variance; assume a population-variance estimate of 6{p_end}
{phang2}{cmd:. ciwidth onevariance 6, width(4) n(100)}

{pstd}
    Compute the probability of obtaining a CI width of 1 for a 
    95% CI for the standard deviation; assume a standard deviation
    of 4{p_end}
{phang2}{cmd:. ciwidth onevariance 4, width(1) n(100) sd}

{pstd}
    Same as first example, but for an upper one-sided 99% CI{p_end}
{phang2}{cmd:. ciwidth onevariance 6, width(4) n(100) level(99) upper}

{pstd}
    Compute probability of CI width for several alternative 
    sample sizes, graphing the results{p_end}
{phang2}{cmd:. ciwidth onevariance 6, width(4) n(80(5)100) graph}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ciwidth onevariance} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(level)}}confidence level{p_end}
{synopt :{cmd:r(alpha)}}significance level{p_end}
{synopt :{cmd:r(N)}}total sample size{p_end}
{synopt :{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified,
{cmd:0} otherwise{p_end}
{synopt :{cmd:r(onesided)}}{cmd:1} for a one-sided CI, {cmd:0} otherwise{p_end}
{synopt :{cmd:r(Pr_width)}}probability of CI width{p_end}
{synopt :{cmd:r(Pr_width_a)}}actual probability of CI width (for sample-size
determination when {cmd:probwidth()} specified){p_end}
{synopt :{cmd:r(width)}}CI width{p_end}
{synopt :{cmd:r(v)}}variance{p_end}
{synopt :{cmd:r(s)}}standard deviation{p_end}
{synopt :{cmd:r(separator)}}number of lines between separator lines in the
table{p_end}
{synopt :{cmd:r(divider)}}{cmd:1} if {cmd:divider} is requested in the table,
{cmd:0} otherwise{p_end}
{synopt :{cmd:r(init)}}initial value for sample size{p_end}
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
{synopt :{cmd:r(method)}}{cmd:onevariance}{p_end}
{synopt :{cmd:r(scale)}}{cmd:variance} or {cmd:standard deviation}{p_end}
{synopt :{cmd:r(onesidedci)}}{cmd:upper} or {cmd:lower} (for a one-sided CI){p_end}
{synopt :{cmd:r(columns)}}displayed table columns{p_end}
{synopt :{cmd:r(labels)}}table column labels{p_end}
{synopt :{cmd:r(widths)}}table column widths{p_end}
{synopt :{cmd:r(formats)}}table column formats{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
