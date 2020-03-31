{smcl}
{* *! version 1.0.1  05mar2019}{...}
{viewerdialog "ciwidth" "dialog ciwidth_twomeans"}{...}
{vieweralsosee "[PSS-3] ciwidth twomeans" "mansection PSS-3 ciwidthtwomeans"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-3] ciwidth, graph" "help ciwidth graph"}{...}
{vieweralsosee "[PSS-3] ciwidth, table" "help ciwidth table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power twomeans" "help power twomeans"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{vieweralsosee "[R] ztest" "help ztest"}{...}
{viewerjumpto "Syntax" "ciwidth twomeans##syntax"}{...}
{viewerjumpto "Menu" "ciwidth twomeans##menu"}{...}
{viewerjumpto "Description" "ciwidth twomeans##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth twomeans##linkspdf"}{...}
{viewerjumpto "Options" "ciwidth twomeans##options"}{...}
{viewerjumpto "Examples" "ciwidth twomeans##examples"}{...}
{viewerjumpto "Stored results " "ciwidth twomeans##results"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[PSS-3] ciwidth twomeans} {hline 2}}Precision analysis for a two-means-difference CI{p_end}
{p2col:}({mansection PSS-3 ciwidthtwomeans:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:ciwidth} {cmd:twomeans,}
{opth w:idth(numlist)}
{opth probw:idth(numlist)}
[{help ciwidth twomeans##options_table:{it:options}}]


{pstd}
Compute CI width

{p 8 16 2}
{opt ciwidth} {cmd:twomeans,}
{opth probw:idth(numlist)}
{opth n(numlist)}
[{help ciwidth twomeans##options_table:{it:options}}]


{pstd}
Compute probability of CI width

{p 8 16 2}
{opt ciwidth} {cmd:twomeans,}
{opth w:idth(numlist)}
{opth n(numlist)}
[{help ciwidth twomeans##options_table:{it:options}}]


{marker options_table}{...}
{synoptset 30 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab:Main}
INCLUDE help ciw_ciopts
{p2coldent:* {opth n(numlist)}}total sample size; required to compute CI width and probability of CI width{p_end}
{p2coldent:* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent:* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, {cmd:N2/N1};
default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt: {cmd:compute(N2}|{cmd:N2)}}solve for {cmd:N1} given {cmd:N2} or for
{cmd:N2} given {cmd:N1}{p_end}
INCLUDE help ciw_nfracopt
{p2coldent:* {opth sd(numlist)}}common standard deviation of the control and
the experimental groups assuming equal standard deviations in
both groups; default is {cmd:sd(1)}{p_end}
{p2coldent:* {opth sd1(numlist)}}standard deviation of the control group;
requires {cmd:sd2()} and {cmd:knownsds}{p_end}
{p2coldent:* {opth sd2(numlist)}}standard deviation of the experimental group;
requires {cmd:sd1()} and {cmd:knownsds}{p_end}
{synopt :{opt knownsds}}request computation assuming known standard
deviations for both groups; default is to assume unknown standard deviations{p_end}
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
{help ciwidth_twomeans##column:{it:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]]
[{cmd:,} {help ciwidth table##tableopts:{it:tableopts}}]

{pstd}
{it:column} is one of the columns defined
{help ciwidth_twomeans##column:below}, and {it:label} is a column label (may
contain quotes and compound quotes).

{marker column}{...}
{synoptset 28}{...}
{synopthdr :column}
{synoptline}
{synopt :{cmd:level}}confidence level{p_end}
{synopt :{cmd:alpha}}significance level{p_end}
{synopt :{cmd:N}}total number of subjects{p_end}
{synopt :{cmd:N1}}number of subjects in the control group{p_end}
{synopt :{cmd:N2}}number of subjects in the experimental group{p_end}
{synopt :{cmd:nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt :{cmd:Pr_width}}probability of CI width{p_end}
{synopt :{cmd:width}}CI width{p_end}
{synopt :{cmd:sd}}common standard deviation{p_end}
{synopt :{cmd:sd1}}control-group standard deviation{p_end}
{synopt :{cmd:sd2}}experimental-group standard deviation{p_end}
{synopt :{cmd:_all}}display all supported columns{p_end}
{synoptline}
{p 4 6 2}Column {cmd:alpha} is shown in the default table in place of column
{cmd:level} if {cmd:alpha()} is specified.{p_end}
{p 4 6 2}Columns {cmd:nratio}, {cmd:sd}, {cmd:sd1}, and {cmd:sd2} are shown in
the default table if the corresponding options are specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:ciwidth twomeans} computes sample size, CI width, and probability of CI
width for a CI for a difference between two means from independent samples. It
can compute sample size for a given CI width and probability of CI width.
Alternatively, it can compute CI width for a given sample size and probability
of CI width. It can also compute probability of CI width for a given sample
size and CI width. Also see {helpb ciwidth:[PSS-3] ciwidth} for PrSS analysis
for other CI methods.

{pstd}
For power and sample-size analysis for a two-sample mean test, see
{helpb power_twomeans:[PSS-2] power twomeans}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidthtwomeansRemarksandexamples:Remarks and examples}

        {mansection PSS-3 ciwidthtwomeansMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mainopts}{...}
{dlgtab:Main}

{phang}
{opt level()}, {opt alpha()}, {opt probwidth()}, {opt width()}, {opt n()},
{opt n1()}, {opt n2()}, {opt nratio()}, {opt compute()},
{opt nfractional}; see {helpb ciwidth:[PSS-3] ciwidth}.
{opt probwidth()} may not be combined with {opt sd1()}, {opt sd2()}, and
{opt knownsds}.

{phang}
{opth sd(numlist)} specifies the common standard deviation of the control and
the experimental groups assuming equal standard deviations in both groups. The
default is {cmd:sd(1)}.

{phang}
{opth sd1(numlist)} specifies the standard deviation of the control group. If
you specify {opt sd1()}, you must also specify {opt sd2()} and {opt knownsds}.
{opt sd1()} may not be combined with {opt probwidth()}.

{phang}
{opth sd2(numlist)} specifies the standard deviation of the experimental
group.  If you specify {opt sd2()}, you must also specify {opt sd1()} and
{opt knownsds}.  {opt sd2()} may not be combined with {opt probwidth()}.

{phang}
{opt knownsds} requests that standard deviations of each group be treated as
known in the computation.  By default, standard deviations are treated as
unknown, and the computation is performed for a Student's t-based CI. If
{opt knownsds} is specified, the computation is performed for a normal-based
CI.  {opt knownsds} may not be combined with {opt probwidth()} and is not
allowed when computing the probability of CI width.

INCLUDE help ciw_sideoptsdes

INCLUDE help ciw_tableoptsdes

INCLUDE help ciw_graphoptsdes
Also see the {mansection PSS-3 ciwidthtwomeansSyntaxcolumn:column} table in
{bf:[PSS-3] ciwidth twomeans} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated sample size for
sample-size determination.  The estimated sample size is either the
control-group size n1 or, if {cmd:compute(N2)} is specified, the
experimental-group size n2.  The default is to use a closed-form normal
approximation to compute an initial sample size.

INCLUDE help ciw_iteroptsdes

{pstd}
The following option is available with {cmd:ciwidth twomeans} but is not shown
in the dialog box:

INCLUDE help ciw_nodboptdes


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the total sample size required for a two-sided 95% CI 
    (the default) for the difference between two means to have a width 
    no larger than 8 with a probability of 90%; assume equal group 
    sizes and that the standard deviations of the two groups are 
    both 4{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4)}

{pstd}
    Same as above, but for a lower one-sided CI{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4) lower}

{pstd}
    Compute the total sample size, assuming the standard deviations 
    are known to be 4 for the control group and 5 for the experimental
    group{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) sd1(4) sd2(5) knownsds}

{pstd}
    Same as first example, except specifying that the experimental 
    group will have twice as many observations as the control group{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4) nratio(2)}

{pstd}
    Same as above, but allowing for fractional sample sizes{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4)}
	{cmd:nratio(2) nfractional}

{pstd}
    Using the same parameters as the first example, find the sample 
    size required for the experimental group if the control group is 
    known to have 25 observations{p_end}
{phang2}{cmd:. ciwidth twomeans, width(6) probwidth(0.9) sd(4) n1(25)}
       {cmd:compute(N2)}


    {title:Examples: Computing CI width}

{pstd}
    Suppose we have a total sample size of 80 and we want to compute 
    the width of a two-sided 95% CI (the default) for a difference in 
    means, assuming a 90% probability that the CI width will be no 
    larger than the estimated value, equal sample sizes, and a common 
    standard deviation of 12{p_end}
{phang2}{cmd:. ciwidth twomeans, n(80) probwidth(0.9) sd(12)}

{pstd}
    Same as above, assuming the control group has 30 observations and
    the experimental group has 50 observations{p_end}
{phang2}{cmd:. ciwidth twomeans, n1(30) n2(50) probwidth(0.9) sd(12)}

{pstd}
    Compute CI width for a range of sample sizes, graphing the 
    results{p_end}
{phang2}{cmd:. ciwidth twomeans, n(50(10)80) probwidth(0.9) sd(12) graph}


    {title:Examples: Computing probability of CI width}

{pstd}
    Suppose that we have a sample of 60 subjects and we want to compute 
    the probability of obtaining a CI width no larger than 12 for a 
    two-sided 95% CI (the default) for the difference between the means 
    of the experimental and control groups; assume both groups have the
    same number of observations and a standard deviation of 10{p_end}
{phang2}{cmd:. ciwidth twomeans, width(12) n(60) sd(10)}

{pstd}
    Same as above, but for a range of sample sizes{p_end}
{phang2}{cmd:. ciwidth twomeans, width(12) n(40(2)60) sd(10)}

{pstd}
    Using the same parameters as the first example, but assuming the
    control group has 25 observations and the experimental group has
    35 observations{p_end}
{phang2}{cmd:. ciwidth twomeans, width(12) n1(25) n2(35) sd(10)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ciwidth twomeans} stores the following in {cmd:r()}:

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
{synopt :{cmd:r(width_a)}}actual CI width (for sample-size determination when
{cmd:knownsds} specified){p_end}
{synopt :{cmd:r(sd)}}common standard deviation of the control and experimental
groups{p_end}
{synopt :{cmd:r(sd1)}}standard deviation of the control group{p_end}
{synopt :{cmd:r(sd2)}}standard deviation of the experimental group{p_end}
{synopt :{cmd:r(knownsds)}}{cmd:1} if option {cmd:knownsds} is specified,
{cmd:0} otherwise{p_end}
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
{synopt :{cmd:r(method)}}{cmd:twomeans}{p_end}
{synopt :{cmd:r(onesidedci)}}{cmd:upper} or {cmd:lower} (for a one-sided CI){p_end}
{synopt :{cmd:r(columns)}}displayed table columns{p_end}
{synopt :{cmd:r(labels)}}table column labels{p_end}
{synopt :{cmd:r(widths)}}table column widths{p_end}
{synopt :{cmd:r(formats)}}table column formats{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
