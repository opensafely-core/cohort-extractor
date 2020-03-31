{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog centile "dialog centile"}{...}
{vieweralsosee "[R] centile" "mansection R centile"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[D] pctile" "help pctile"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{viewerjumpto "Syntax" "centile##syntax"}{...}
{viewerjumpto "Menu" "centile##menu"}{...}
{viewerjumpto "Description" "centile##description"}{...}
{viewerjumpto "Links to PDF documentation" "centile##linkspdf"}{...}
{viewerjumpto "Options" "centile##options"}{...}
{viewerjumpto "Examples" "centile##examples"}{...}
{viewerjumpto "Stored results" "centile##results"}{...}
{viewerjumpto "Reference" "centile##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] centile} {hline 2}}Report centile and confidence
interval{p_end}
{p2col:}({mansection R centile:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:centile} [{varlist}] {ifin}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth c:entile(numlist)}}report specified centiles;
default is {cmd:centile(50)}{p_end}

{syntab:Options}
{synopt :{opt cc:i}}binomial exact; conservative confidence interval{p_end}
{synopt :{opt n:ormal}}normal, based on observed centiles{p_end}
{synopt :{opt m:eansd}}normal, based on mean and standard deviation{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} and {opt statsby} are allowed; see {help prefix}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Summary and descriptive statistics > Centiles with CIs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:centile} estimates specified centiles and calculates confidence
intervals. If no {varlist} is specified,
{cmd:centile} calculates centiles for all the variables in the dataset.
If no centiles are specified, medians are reported.

{pstd}
By default, {cmd:centile} uses a binomial method for obtaining confidence
intervals that makes no assumptions about the underlying distribution of the
variable.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R centileQuickstart:Quick start}

        {mansection R centileRemarksandexamples:Remarks and examples}

        {mansection R centileMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth centile(numlist)} specifies the centiles to be reported.
The default is to display the 50th centile.
Specifying
{cmd:centile(5)} requests that the fifth centile be reported.
Specifying {cmd:centile(5 50 95)} requests that the 5th, 50th, and 95th
centiles be reported.
Specifying {cmd:centile(10(10)90)} requests that the 10th, 20th, ..., 90th
centiles be reported.

{dlgtab:Options}

{phang}
{opt cci} (conservative confidence interval) forces the confidence limits to
fall exactly on sample values.  Confidence intervals displayed with the
{opt cci} option are slightly wider than those with the default ({opt nocci})
option.

{phang}
{opt normal} causes the confidence interval to be calculated by using a formula
for the standard error of a normal-distribution quantile given by
{help centile##KS1969:Kendall and Stuart (1969, 237)}. The {opt normal} option
is useful when you want empirical centiles -- that is, centiles based on sample
order statistics rather than on the mean and standard deviation -- and are
willing to assume normality.

{phang}
{opt meansd} causes the centile and confidence interval to be calculated based
on the sample mean and standard deviation, and it assumes normality.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Calculate the 50th centile for all variables in the dataset{p_end}
{phang2}{cmd:. centile}{p_end}

{pstd}Calculate the 50th centile for {cmd:price}{p_end}
{phang2}{cmd:. centile price}{p_end}

{pstd}Calculate the 50th centile for {cmd:price}, showing 99% CI{p_end}
{phang2}{cmd:. centile price, level(99)}{p_end}

{pstd}Calculate the 5th, 50th, and 95th centiles for {cmd:price}{p_end}
{phang2}{cmd:. centile price, centile(5 50 95)}{p_end}

{pstd}Calculate the 10th, 20, 30th, ..., 90th centiles for {cmd:price}{p_end}
{phang2}{cmd:. centile price, centile(10(10)90)}{p_end}

{pstd}Calculate the 10th centile for {cmd:price}, assuming normality{p_end}
{phang2}{cmd:. centile price, centile(10) normal}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:centile} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(n_cent)}}number of centiles requested{p_end}
{synopt:{cmd:r(c_}{it:#}{cmd:)}}value of {it:#} centile{p_end}
{synopt:{cmd:r(lb_}{it:#}{cmd:)}}{it:#}-requested centile lower confidence
	bound{p_end}
{synopt:{cmd:r(ub_}{it:#}{cmd:)}}{it:#}-requested centile upper confidence
	bound{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(centiles)}}centiles requested{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker KS1969}{...}
{phang}
Kendall, M. G., and A. Stuart. 1969.
{it:The Advanced Theory of Statistics, Vol. 1: Distribution Theory}. 3rd ed.
London: Griffin.
{p_end}
