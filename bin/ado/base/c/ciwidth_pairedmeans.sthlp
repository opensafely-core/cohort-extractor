{smcl}
{* *! version 1.0.0  27feb2019}{...}
{viewerdialog "specify correlation" "dialog ciwidth_pairedmeans_corr"}{...}
{viewerdialog "specify standard deviation difference" "dialog ciwidth_pairedmeans_sddiff"}{...}
{vieweralsosee "[PSS-3] ciwidth pairedmeans" "mansection PSS-3 ciwidthpairedmeans"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-3] ciwidth, graph" "help ciwidth graph"}{...}
{vieweralsosee "[PSS-3] ciwidth, table" "help ciwidth table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power pairedmeans" "help power pairedmeans"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{vieweralsosee "[R] ztest" "help ztest"}{...}
{viewerjumpto "Syntax" "ciwidth pairedmeans##syntax"}{...}
{viewerjumpto "Menu" "ciwidth pairedmeans##menu"}{...}
{viewerjumpto "Description" "ciwidth pairedmeans##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth pairedmeans##linkspdf"}{...}
{viewerjumpto "Options" "ciwidth pairedmeans##options"}{...}
{viewerjumpto "Examples" "ciwidth pairedmeans##examples"}{...}
{viewerjumpto "Stored results " "ciwidth pairedmeans##results"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[PSS-3] ciwidth pairedmeans} {hline 2}}Precision analysis for a
paired-means-difference CI{p_end}
{p2col:}({mansection PSS-3 ciwidthpairedmeans:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:ciwidth} {cmdab:pairedm:eans,}
{help ciwidth_pairedmeans##corrspec:{it:corrspec}}
{opth w:idth(numlist)}
{opth probw:idth(numlist)}
[{help ciwidth pairedmeans##options_table:{it:options}}]


{pstd}
Compute CI width

{p 8 16 2}
{opt ciwidth} {cmdab:pairedm:eans,}
{help ciwidth_pairedmeans##corrspec:{it:corrspec}}
{opth probw:idth(numlist)}
{opth n(numlist)}
[{help ciwidth pairedmeans##options_table:{it:options}}]


{pstd}
Compute probability of CI width

{p 8 16 2}
{opt ciwidth} {cmdab:pairedm:eans,}
{help ciwidth_pairedmeans##corrspec:{it:corrspec}}
{opth w:idth(numlist)}
{opth n(numlist)}
[{help ciwidth pairedmeans##options_table:{it:options}}]


{marker corrspec}{...}
{pstd}
where {it:corrspec} is one of

        {cmd:sddiff()}
	{cmd:corr()} [{cmd:sd()}]
	{cmd:corr()} [{cmd:sd1()} {cmd:sd2()}]

{marker options_table}{...}
{synoptset 30 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab:Main}
INCLUDE help ciw_ciopts
INCLUDE help ciw_nopt
INCLUDE help ciw_nfracopt
{p2coldent:* {opth sddiff(numlist)}}standard deviation {it:sigma_d} of the
differences; may not be combined with {cmd:corr()}{p_end}
{p2coldent:* {opth corr(numlist)}}correlation between paired
observations; required unless {cmd:sddiff()} is specified{p_end}
{p2coldent:* {opth sd(numlist)}}common standard deviation; default is
{cmd:sd(1)} and requires {cmd:corr()}{p_end}
{p2coldent:* {opth sd1(numlist)}}standard deviation of the pretreatment group;
requires {cmd:corr()}{p_end}
{p2coldent:* {opth sd2(numlist)}}standard deviation of the posttreatment group;
requires {cmd:corr()}{p_end}
{synopt :{opt knownsd}}request computation assuming a known standard
deviation {it:sigma_d}; default is to assume an unknown standard deviation{p_end}
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
{help ciwidth_pairedmeans##column:{it:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]]
[{cmd:,} {help ciwidth table##tableopts:{it:tableopts}}]

{pstd}
{it:column} is one of the columns defined
{help ciwidth_pairedmeans##column:below}, and {it:label} is a column label (may
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
{synopt :{cmd:sd_d}}standard deviation of the differences{p_end}
{synopt :{cmd:sd}}common standard deviation{p_end}
{synopt :{cmd:sd1}}standard deviation of the pretreatment group{p_end}
{synopt :{cmd:sd2}}standard deviation of the posttreatment group{p_end}
{synopt :{cmd:corr}}correlation between paired observations{p_end}
{synopt :{cmd:fpc}}FPC{p_end}
{* without the symbol, it does not make sense to have population size and}{...}
{* sampling rate like manual}{...}
{synopt :{cmd:_all}}display all supported columns{p_end}
{synoptline}
{p 4 6 2}Column {cmd:alpha} is shown in the default table in place of column
{cmd:level} if {cmd:alpha()} is specified.{p_end}
{p 4 6 2}Columns {cmd:sd}, {cmd:sd1}, {cmd:sd2}, {cmd:corr}, and {cmd:fpc} are
shown in the default table if the corresponding options are specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:ciwidth pairedmeans} computes sample size, CI width, and probability of
CI width for a CI for the difference between two means from paired samples.
It can compute sample size for a given CI width and probability of CI width.
Alternatively, it can compute CI width for a given sample size and probability
of CI width.  It can also compute probability of CI width for a given sample
size and CI width.  Also see {helpb ciwidth:[PSS-3] ciwidth} for PrSS analysis
for other CI methods.

{pstd}
For power and sample-size analysis for a two-sample paired-means test, see
{helpb power pairedmeans:[PSS-2] power pairedmeans}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidthpairedmeansRemarksandexamples:Remarks and examples}

        {mansection PSS-3 ciwidthpairedmeansMethodsandformulas:Methods and formulas}

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
{opth sddiff(numlist)} specifies the standard deviation {it:sigma_d} of the
differences.  Either {cmd:sddiff()} or {cmd:corr()} must be specified.

{phang}
{opth corr(numlist)} specifies the correlation between paired, pretreatment
and posttreatment, observations.  This option along with {cmd:sd1()} and
{cmd:sd2()} or {cmd:sd()} is used to compute the standard deviation of the
differences unless that standard deviation is supplied directly in the
{cmd:sddiff()} option.  Either {cmd:corr()} or {cmd:sddiff()} must be
specified.

{phang}
{opth sd(numlist)} specifies the common standard deviation of the pretreatment
and posttreatment groups.  Specifying {opt sd(#)} implies that both
{cmd:sd1()} and {cmd:sd2()} are equal to {it:#}.  Options {cmd:corr()} and
{cmd:sd()} are used to compute the standard deviation of the differences
unless that standard deviation is supplied directly with the {cmd:sddiff()}
option.  The default is {cmd:sd(1)}.

{phang}
{opth sd1(numlist)} specifies the standard deviation of the pretreatment
group.  Options {cmd:corr()}, {cmd:sd1()}, and {cmd:sd2()} are used to compute
the standard deviation of the differences unless that standard deviation is
supplied directly with the {cmd:sddiff()} option.

{phang}
{opth sd2(numlist)} specifies the standard deviation of the posttreatment
group.  Options {cmd:corr()}, {cmd:sd1()}, and {cmd:sd2()} are used to compute
the standard deviation of the differences unless that standard deviation is
supplied directly with the {cmd:sddiff()} option.

{phang}
{opt knownsd} requests that the standard deviation of the differences
{it:sigma_d} be treated as known in the computation.  By default, the standard
deviation is treated as unknown, and the computation is performed for a
Student's t-based CI.  If {cmd:knownsd} is specified, the computation is
performed for a normal-based CI.  {cmd:knownsd} may not be combined with
{cmd:probwidth()} and is not allowed when computing the probability of CI
width.

{phang}
{opth fpc(numlist)} requests that a finite population correction be used in
the computation.  If {cmd:fpc()} has values between 0 and 1, it is interpreted
as a sampling rate, n/N, where N is the total number of units in the
population.  When sample size n is specified, if {cmd:fpc()} has values
greater than n, it is interpreted as a population size, but it is an error to
have values between 1 and n.  For sample-size determination, {cmd:fpc()} with
a value greater than 1 is interpreted as a population size.  It is an error
for {cmd:fpc()} to have a mixture of sampling rates and population sizes.

INCLUDE help ciw_sideoptsdes

INCLUDE help ciw_tableoptsdes

INCLUDE help ciw_graphoptsdes
Also see the {mansection PSS-3 ciwidthpairedmeansSyntaxcolumn:column} table in
{bf:[PSS-3] ciwidth pairedmeans} for a list of symbols used by the graphs.

INCLUDE help ciw_initoptdes

INCLUDE help ciw_iteroptsdes

{pstd}
The following option is available with {cmd:ciwidth pairedmeans} but is not shown
in the dialog box:

INCLUDE help ciw_nodboptdes


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required for a two-sided 95% CI 
    (the default) for the difference between two means from
    paired samples to have a width no larger than 8 with a 
    probability of 90%; assume the standard deviation for 
    the differences is 24{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) probwidth(0.9)}
       {cmd:sddiff(24)}

{pstd}
    Compute sample size, assuming known standard deviation 
    of the difference{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) sddiff(24) knownsd}

{pstd}
    Same as above, using a lower one-sided confidence 
    interval{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) sddiff(24)}
       {cmd:knownsd lower}

{pstd}
    Same as first example, knowing the population size is 
    500{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) probwidth(0.9)}
       {cmd:sddiff(24) fpc(500)}

{pstd}
    Same as first example, but allowing for fractional 
    sample sizes{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) probwidth(0.9)} 
       {cmd:sddiff(24) nfractional}

{pstd}
    Compute sample size as in the first example, except that 
    the correlation between the paired observations is 0.7; 
    assume a pretreatment standard deviation of 22 
    and posttreatment standard deviation of 29{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) probwidth(0.9)}
       {cmd:corr(.7) sd1(22) sd2(29)}

{pstd}
    Same as above, assuming a common standard deviation 
    of 25{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) probwidth(0.9)}
       {cmd:corr(.7) sd(25)}


    {title:Examples: Computing CI width}

{pstd}
    Suppose we have a sample of 100 subjects and we want to 
    compute the width of a two-sided 95% CI (the default) for 
    the difference between paired means; assume the standard 
    deviation for the differences is 24, and that we want to be 
    96% certain that the CI width in a future study will be no 
    larger than the estimated width{p_end}
{phang2}{cmd:. ciwidth pairedmeans, n(100) probwidth(0.96) sddiff(24)}

{pstd}
    Same as above, except that the correlation between the paired 
    observations is 0.7; assume a pretreatment standard deviation of 
    20 and a posttreatment standard deviation of 24{p_end}
{phang2}{cmd:. ciwidth pairedmeans, n(100) probwidth(0.96) sd1(20)}
       {cmd:sd2(24) corr(.7)}

{pstd}
    Compute CI width for a range of sample sizes, graphing the 
    results{p_end}
{phang2}{cmd:. ciwidth pairedmeans, n(70(10)100) probwidth(0.96)}
       {cmd:sddiff(24) graph}

{pstd}
    Same as above, but with tabular output{p_end}
{phang2}{cmd:. ciwidth pairedmeans, n(70(10)100) probwidth(0.96)}
       {cmd:sddiff(24) graph table}


    {title:Examples: Computing probability of CI width}

{pstd}
    Suppose that we have a sample of 80 subjects and we want to 
    compute the probability of obtaining a CI width no larger than 8 
    for a two-sided 95% CI (the default) for the difference between 
    paired means; assume the standard deviation for the 
    differences is 18{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) n(80) sddiff(18)}

{pstd}
    Same as above, assuming the correlation between the paired 
    observations is 0.7 and a common standard deviation of 
    22{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) n(80) corr(0.7) sd(22)}

{pstd}
    Compute probability of CI width for several alternative sample 
    sizes{p_end}
{phang2}{cmd:. ciwidth pairedmeans, width(8) n(50(10)80) corr(0.7) sd(22)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ciwidth pairedmeans} stores the following in {cmd:r()}:

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
{synopt :{cmd:r(corr)}}correlation between paired observations{p_end}
{synopt :{cmd:r(sd_d)}}standard deviation of the differences{p_end}
{synopt :{cmd:r(sd1)}}standard deviation of the pretreatment group{p_end}
{synopt :{cmd:r(sd2)}}standard deviation of the posttreatment group{p_end}
{synopt :{cmd:r(sd)}}common standard deviation{p_end}
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
{synopt :{cmd:r(method)}}{cmd:pairedmeans}{p_end}
{synopt :{cmd:r(onesidedci)}}{cmd:upper} or {cmd:lower} (for a one-sided CI){p_end}
{synopt :{cmd:r(columns)}}displayed table columns{p_end}
{synopt :{cmd:r(labels)}}table column labels{p_end}
{synopt :{cmd:r(widths)}}table column widths{p_end}
{synopt :{cmd:r(formats)}}table column formats{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
