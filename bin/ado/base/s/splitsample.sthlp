{smcl}
{* *! version 1.0.1  17jul2019}{...}
{viewerdialog splitsample "dialog splitsample"}{...}
{vieweralsosee "[D] splitsample" "mansection D splitsample"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] sample" "help sample"}{...}
{viewerjumpto "Syntax" "splitsample##syntax"}{...}
{viewerjumpto "Menu" "splitsample##menu"}{...}
{viewerjumpto "Description" "splitsample##description"}{...}
{viewerjumpto "Links to PDF documentation" "splitsample##linkspdf"}{...}
{viewerjumpto "Options" "splitsample##options"}{...}
{viewerjumpto "Examples" "splitsample##examples"}{...}
{viewerjumpto "Stored results" "splitsample##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[D] splitsample} {hline 2}}Split data into random samples{p_end}
{p2col:}({mansection D splitsample:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:splitsample}
[{varlist}]
{ifin}{cmd:,}
{opt gen:erate}{cmd:(}{newvar}[{cmd:,} {opt replace}]{cmd:)} 
[{it:options}]

{phang}
{it:varlist} is checked for missing values, and the sample ID variable 
{it:newvar} is set to missing for observations where any variable in 
{it:varlist} is missing.  {cmd:_all} or {cmd:*} may be specified for 
{it:varlist}.

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent:* {opt gen:erate}{cmd:(}{newvar}[{cmd:,} {cmd:replace}]{cmd:)}}create new sample ID variable; optionally replace
existing variable{p_end}
{synopt :{opt nsplit(#)}}split into {it:#} random samples of equal size{p_end}
{synopt :{opth split(numlist)}}specify {it:numlist} of proportions or ratios
for the split{p_end}
{synopt :{opt rround}}randomly round sample sizes when an exact split cannot
be made{p_end}
{synopt :{opth values(numlist)}}specify {it:numlist} of values for sample ID
variable{p_end}
{synopt :{opt cl:uster(clustvar)}}split by clusters defined by {it:clustvar},
not observations{p_end}
{synopt :{opt bal:ance(balvars)}}split each group defined by the distinct
values of {it:balvars} independently based on the specified sample
proportions{p_end}

{syntab:Advanced}
{synopt :{opt strok}}evaluate string variables in {varlist} for missing
values; by default, string variables are ignored{p_end}
{synopt :{opt rseed(#)}}specify random-number seed{p_end}
{synopt :{opt show}}display a table showing the sample sizes of the
split{p_end}
{synopt :{opt percent}}display percentages in the table showing the
split{p_end}
{synoptline}
{p 4 6 2}
* {cmd:generate()} is required.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands}
     {bf:> Split data into random samples}


{marker description}{...}
{title:Description}

{pstd}
{cmd:splitsample} splits data into random samples based on a specified number
of samples and specified proportions for each sample.  Splitting can also be
done based on clusters.  Sample splitting can also be balanced across
specified variables.  Balanced splitting can be used for matched treatment
assignment.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D splitsampleQuickstart:Quick start}

        {mansection D splitsampleRemarksandexamples:Remarks and examples}

        {mansection D splitsampleMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt generate}{cmd:(}{newvar}[{cmd:,} {cmd:replace}]{cmd:)} creates a new
variable containing ID values for the random samples.  The variable
{it:newvar} is valued 1, 2, ... by default.  The option {opth values(numlist)}
can be used to specify different ID values.  {cmd:generate()} is required.

{pmore}
{opt replace} allows any existing variable named {it:newvar} to be replaced.

{phang}
{opt nsplit(#)} splits the data into {it:#} random samples of equal size, or
as close to equal as possible.  If neither {cmd:nsplit()} nor {cmd:split()} is
specified, the data are split into two samples.

{phang}
{opth split(numlist)} is an alternative to {cmd:nsplit()} for specifying the
split.  This option splits the data into samples whose sizes are proportional
to the values of {it:numlist}.  The values of {it:numlist} can be any positive
number.  You can specify proportions that sum to 1, or you can specify integers
that define ratios for the sample sizes.  Regardless of whether you specify
decimals less than 1 or integers, the proportions of the split are given by
the values in {it:numlist} divided by their sum.

{phang}
{opt rround} specifies that sample sizes be randomly rounded when an exact
split cannot be made.  When an exact split can be made, this option does
nothing.  When {opth split(numlist)} is specified with {cmd:rround},
{it:numlist} must consist of integers, and the integers should contain no
common factors.  For instance, use {cmd:split(1 1 2)}, not
{cmd:split(25 25 50)}.  See
{mansection D splitsampleMethodsandformulas:{it:Methods and formulas}} for an
explanation.

{pmore}
By default, the sample sizes of the splits are calculated using a
deterministic rounding formula.  That is, if you repeat the splitting with a
different random-number seed, you will get exactly the same sample sizes.
Specifying {cmd:rround} creates randomly rounded sample sizes such that the
expected values of the sample sizes match the specified split proportions
exactly.

{pmore}
The option {cmd:rround} is designed for use with the {cmd:balance()} option
when the number of observations in each of the balance groups is small.  When
group sizes are small (especially when smaller than the number of  splits),
{cmd:rround} ensures that the overall actual sample split proportions closely
match the specified split proportions.

{phang}
{opth values(numlist)} specifies that {it:numlist} be used for the values of
the sample ID variable rather than the default of 1, 2, ....  The number of
values in {it:numlist} must correspond to the number of samples into which the
data are split and must be ascending nonnegative integers.

{phang}
{opt cluster(clustvar)} specifies that the data be split by the clusters
defined by {it:clustvar}.  That is, all observations in a cluster are kept
together in the same split sample.  The proportions of the split are based on
numbers of clusters, not numbers of observations.  {it:clustvar} can be a
numeric or string variable.

{phang}
{opt balance(balvars)} specifies that each group defined by the distinct
values of {it:balvars} be split independently based on the specified sample
proportions.  This ensures a balanced, or roughly balanced, distribution of
the {it:balvars} values across the split samples.  When the number of
observations (or clusters) in each group is about the same as (or smaller
than) the number of split samples, the option {cmd:rround} is recommended.
{it:balvars} can be numeric or string variables.

{dlgtab:Advanced}

{phang}
{opt strok} (applies only when a {varlist} is specified) specifies to check
any string variables in {it:varlist} for missing values.  For observations
with missing values, the generated sample ID variable is set to missing.  By
default, string variables in {it:varlist} are ignored.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results.  {opt rseed(#)} is equivalent to typing {cmd:set}
{cmd:seed} {it:#} prior to running {cmd:splitsample}.  See
{helpb set_seed:[R] set seed}.

{phang}
{opt show} displays a table showing the sample sizes of the split.  When
{cmd:cluster()} is specified, it shows the numbers of clusters in the samples.
When {opt balance(balvars)} is specified, it displays a table in which each
row corresponds to a distinct set of values of {it:balvars} and shown across
the columns are the numbers of observations (or clusters) belonging to each
split sample for that balance group.

{phang}
{opt percent} specifies to display percentages rather than the number of
observations (or clusters) in the table.  {opt percent} can only be specified
with the option {opt show}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. set obs 101}{p_end}

{pstd}Split the 101 observations into random samples, using {cmd:svar}
as the newly generated variable{p_end}
{phang2}{cmd:. splitsample, generate(svar)}

{pstd}Tabulate {cmd:svar}{p_end}
{phang2}{cmd:. tabulate svar}

{pstd}Split the data above into three samples, replacing the {cmd:svar}
variable{p_end}
{phang2}{cmd:. splitsample, generate(svar, replace) nsplit(3)}

{pstd}Split the data above with 25% of the observations in sample 1, 25%
in sample 2, and 50% in sample 3 and display a table showing the sample sizes
of the split, replacing the {cmd:svar} variable{p_end}
{phang2}{cmd:. splitsample, generate(svar, replace) split(0.25 0.25 0.50) show}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:splitsample} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}total number of observations{p_end}
{synopt:{cmd:r(N_clust)}}total number of clusters{p_end}
{synopt:{cmd:r(n_samples)}}number of split samples{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:r(balancevars)}}names of balance variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{p2colreset}{...}
