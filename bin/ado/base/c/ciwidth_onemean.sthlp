{smcl}
{* *! version 1.0.0  27feb2019}{...}
{viewerdialog "ciwidth" "dialog ciwidth_onemean"}{...}
{vieweralsosee "[PSS-3] ciwidth onemean" "mansection PSS-3 ciwidthonemean"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-3] ciwidth, graph" "help ciwidth graph"}{...}
{vieweralsosee "[PSS-3] ciwidth, table" "help ciwidth table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power onemean" "help power onemean"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{viewerjumpto "Syntax" "ciwidth onemean##syntax"}{...}
{viewerjumpto "Menu" "ciwidth onemean##menu"}{...}
{viewerjumpto "Description" "ciwidth onemean##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth onemean##linkspdf"}{...}
{viewerjumpto "Options" "ciwidth onemean##options"}{...}
{viewerjumpto "Examples" "ciwidth onemean##examples"}{...}
{viewerjumpto "Stored results " "ciwidth onemean##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[PSS-3] ciwidth onemean} {hline 2}}Precision analysis for a one-mean 
CIs{p_end}
{p2col:}({mansection PSS-3 ciwidthonemean:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:ciwidth} {cmd:onemean,}
{opth w:idth(numlist)}
{opth probw:idth(numlist)}
[{help ciwidth onemean##options_table:{it:options}}]


{pstd}
Compute CI width

{p 8 16 2}
{opt ciwidth} {cmd:onemean,}
{opth probw:idth(numlist)}
{opth n(numlist)}
[{help ciwidth onemean##options_table:{it:options}}]


{pstd}
Compute probability of CI width

{p 8 16 2}
{opt ciwidth} {cmd:onemean,}
{opth w:idth(numlist)}
{opth n(numlist)}
[{help ciwidth onemean##options_table:{it:options}}]


{marker options_table}{...}
{synoptset 30 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab:Main}
INCLUDE help ciw_ciopts
INCLUDE help ciw_nopt
INCLUDE help ciw_nfracopt
{p2coldent:* {opth sd(numlist)}}standard deviation; default is {cmd:sd(1)}{p_end}
{synopt :{opt knownsd}}request computation assuming a known standard
deviation; default is to assume an unknown standard deviation{p_end}
{p2coldent:* {opth fpc(numlist)}}finite population correction (FPC) as a sampling rate or as a population size{p_end}
INCLUDE help ciw_sideopts

INCLUDE help ciw_tableopts

INCLUDE help ciw_graphopts

INCLUDE help ciw_iteropts
{synoptline}
INCLUDE help pss_numlist
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 8 16 2}
{help ciwidth_onemean##column:{it:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]]
[{cmd:,} {help ciwidth table##tableopts:{it:tableopts}}]

{pstd}
{it:column} is one of the columns defined
{help ciwidth_onemean##column:below}, and {it:label} is a column label (may
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
{synopt :{cmd:sd}}standard deviation{p_end}
{synopt :{cmd:fpc}}FPC{p_end}
{* without the symbol, it does not make sense to have population size and}{...}
{* sampling rate like manual}{...}
{synopt :{cmd:_all}}display all supported columns{p_end}
{synoptline}
{p 4 6 2}Column {cmd:alpha} is shown in the default table in place of column
{cmd:level} if {cmd:alpha()} is specified.{p_end}
{p 4 6 2}Column {cmd:fpc} is shown in the default table if {cmd:fpc()} is
specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:ciwidth onemean} computes sample size, CI width, and probability of CI
width for a CI for a population mean. It can compute sample size for a given
CI width and probability of CI width.  Alternatively, it can compute CI width
for a given sample size and probability of CI width. It can also compute
probability of CI width for a given sample size and CI width. Also see
{helpb ciwidth:[PSS-3] ciwidth} for PrSS analysis for other CI methods.

{pstd}
For power and sample-size analysis for a one-sample mean test, see
{helpb power onemean:[PSS-2] power onemean}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidthonemeanRemarksandexamples:Remarks and examples}

        {mansection PSS-3 ciwidthonemeanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mainopts}{...}
{dlgtab:Main}

{phang}
{opt level()}, {opt alpha()}, {opt probwidth()}, {opt width()}, {opt n()},
{opt nfractional}; see {helpb ciwidth:[PSS-3] ciwidth}.
{opt probwidth()} may not be combined with {opt knownsd}.
The {opt nfractional} option is allowed only for sample-size determination.

{phang}
{opth sd(numlist)} specifies the population standard deviation or its
estimate.  The default is {cmd:sd(1)}. By default, {opt sd()} specifies an
estimate for the unknown population standard deviation. If {opt knownsd} is
specified, {opt sd()} specifies the known value for the population standard
deviation.

{phang}
{opt knownsd} requests that the standard deviation be treated as known in the
computation.  By default, the standard deviation is treated as unknown, and
the computation is performed for a Student's t-based CI. If {opt knownsd} is
specified, the computation is performed for a normal-based CI. {opt knownsd}
may not be combined with {opt probwidth()} and is not allowed when computing
the probability of CI width.

{phang}
{opth fpc(numlist)} requests that a finite population correction be used in
the computation. If {opt fpc()} has values between 0 and 1, it is interpreted
as a sampling rate, n/N, where N is the total number of units in the
population.  When sample size n is specified, if {opt fpc()} has values
greater than n, it is interpreted as a population size, but it is an error to
have values between 1 and n.  For sample-size determination, {opt fpc()} with
a value greater than 1 is interpreted as a population size.  It is an error
for {opt fpc()} to have a mixture of sampling rates and population sizes.

INCLUDE help ciw_sideoptsdes

INCLUDE help ciw_tableoptsdes

INCLUDE help ciw_graphoptsdes
Also see the {mansection PSS-3 ciwidthonemeanSyntaxcolumn:column} table in
{bf:[PSS-3] ciwidth onemean} for a list of symbols used by the graphs.

INCLUDE help ciw_initoptdes

INCLUDE help ciw_iteroptsdes

{pstd}
The following option is available with {cmd:ciwidth onemean} but is not shown
in the dialog box:

INCLUDE help ciw_nodboptdes


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the required sample size for a two-sided 95% CI (the default) 
    for a population mean; assume a CI width of 6, a standard deviation of 
    8, and a 90% probability that the CI width will be no larger than 6 in a
    future study{p_end}
{phang2}{cmd:. ciwidth onemean, width(6) probwidth(0.9) sd(8)}

{pstd} 
    Same as above, but for an upper one-sided 90% confidence interval{p_end}
{phang2}{cmd:. ciwidth onemean, width(6) probwidth(0.9) sd(8) level(90) upper}

{pstd}
    Specify a list of alternative CI widths{p_end}
{phang2}{cmd:. ciwidth onemean, width(6 8 10) probwidth(0.9) sd(8)}

{pstd}
    Compute the required sample size, assuming a known population
    standard deviation of 8{p_end}
{phang2}{cmd:. ciwidth onemean, width(6) sd(8) knownsd}

{pstd}
    Same as above, but allowing for a fractional sample size{p_end}
{phang2}{cmd:. ciwidth onemean, width(6) sd(8) knownsd nfractional}


    {title:Examples: Computing CI width}

{pstd}
    Suppose we have a sample of 50 subjects and we want to compute the 
    width of a two-sided 95% CI (the default) for a population mean; assume 
    the standard deviation is 8, and we want to be 90% certain that the 
    CI width in a future study will be no larger than the estimated 
    width{p_end}
{phang2}{cmd:. ciwidth onemean, n(50) probwidth(0.9) sd(8)}

{pstd}
    Same as above, reporting output in a table{p_end}
{phang2}{cmd:. ciwidth onemean, n(50) probwidth(0.9) sd(8) table}

{pstd}
    Compute the CI width for several alternative sample sizes, graphing
    the results{p_end}
{phang2}{cmd:. ciwidth onemean, n(70(10)100) probwidth(0.9) sd(8) graph}


    {title:Examples: Computing probability of CI width}

{pstd}
    Suppose we have a sample of 80 subjects and we want to compute the
    probability that the width of a two-sided 95% CI (the default) for a 
    population mean will be no larger than 4; assume a standard deviation 
    of 8{p_end}
{phang2}{cmd:. ciwidth onemean, n(80) width(4) sd(8)}

{pstd}
    Compute probability of CI width for several alternative sample sizes 
    and CI widths{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)70) width(4 5 6) sd(10)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ciwidth onemean} stores the following in {cmd:r()}:

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
{synopt :{cmd:r(width_a)}}actual CI width (for sample-size determination when
{cmd:knownsd} specified){p_end}
{synopt :{cmd:r(sd)}}standard deviation{p_end}
{synopt :{cmd:r(knownsd)}}{cmd:1} if option {cmd:knownsd} is specified,
{cmd:0} otherwise{p_end}
{synopt :{cmd:r(fpc)}}finite population correction (if specified){p_end}
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
{synopt :{cmd:r(method)}}{cmd:onemean}{p_end}
{synopt :{cmd:r(onesidedci)}}{cmd:upper} or {cmd:lower} (for a one-sided CI){p_end}
{synopt :{cmd:r(columns)}}displayed table columns{p_end}
{synopt :{cmd:r(labels)}}table column labels{p_end}
{synopt :{cmd:r(widths)}}table column widths{p_end}
{synopt :{cmd:r(formats)}}table column formats{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
