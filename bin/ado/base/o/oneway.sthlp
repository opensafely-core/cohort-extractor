{smcl}
{* *! version 1.1.12  20aug2018}{...}
{viewerdialog oneway "dialog oneway"}{...}
{vieweralsosee "[R] oneway" "mansection R oneway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[R] loneway" "help loneway"}{...}
{vieweralsosee "[PSS-2] power oneway" "help power oneway"}{...}
{viewerjumpto "Syntax" "oneway##syntax"}{...}
{viewerjumpto "Menu" "oneway##menu"}{...}
{viewerjumpto "Description" "oneway##description"}{...}
{viewerjumpto "Links to PDF documentation" "oneway##linkspdf"}{...}
{viewerjumpto "Options" "oneway##options"}{...}
{viewerjumpto "Examples" "oneway##examples"}{...}
{viewerjumpto "Video example" "oneway##video"}{...}
{viewerjumpto "Stored results" "oneway##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] oneway} {hline 2 }}One-way analysis of variance{p_end}
{p2col:}({mansection R oneway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:on:eway}
{it:response_var}
{it:factor_var}
{ifin}
[{it:{help oneway##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt b:onferroni}}Bonferroni multiple-comparison test{p_end}
{synopt :{opt sc:heffe}}Scheffe multiple-comparison test{p_end}
{synopt :{opt si:dak}}Sidak multiple-comparison test{p_end}
{synopt :{opt t:abulate}}produce summary table{p_end}
{synopt :[{cmdab:no:}]{opt me:ans}}include or suppress means;
default is {opt means}{p_end}
{synopt :[{cmdab:no:}]{opt st:andard}}include or suppress standard deviations;
default is {opt standard}{p_end}
{synopt :[{cmdab:no:}]{opt f:req}}include or suppress frequencies;
default is {opt freq}{p_end}
{synopt :[{cmdab:no:}]{opt o:bs}}include or suppress number of obs;
default is {opt obs} if data are weighted
{p_end}
{synopt :{opt noa:nova}}suppress the ANOVA table{p_end}
{synopt :{opt nol:abel}}show numeric codes, not labels{p_end}
{synopt :{opt w:rap}}do not break wide tables{p_end}
{synopt :{opt mi:ssing}}treat missing values as categories{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > ANOVA/MANOVA > One-way ANOVA}


{marker description}{...}
{title:Description}

{pstd}
The {opt oneway} command reports one-way analysis-of-variance (ANOVA) models
and performs multiple-comparison tests.

{pstd}
If you wish to fit more complicated ANOVA layouts or wish to fit
analysis-of-covariance (ANOCOVA) models, see {manhelp anova R}.

{pstd}
See {manhelp encode D} for examples of fitting ANOVA models on string variables.

{pstd}
See {manhelp loneway R} for an alternative {opt oneway} command with slightly
different features.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R onewayQuickstart:Quick start}

        {mansection R onewayRemarksandexamples:Remarks and examples}

        {mansection R onewayMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt bonferroni} reports the results of a Bonferroni
multiple-comparison test.

{phang}{opt scheffe} reports the results of a Scheffe multiple-comparison
test.

{phang}{opt sidak} reports the results of a Sidak multiple-comparison test.

{phang}{marker tabulate}{opt tabulate} produces a table of summary statistics
of the {it:response_var} by levels of the {it:factor_var}.  The table includes
the mean, standard deviation, frequency, and, if the data are weighted, the
number of observations.  Individual elements of the table may be included or
suppressed by using the [{opt no}]{opt means}, [{opt no}]{opt standard},
[{opt no}]{opt freq}, and [{opt no}]{opt obs} options.  For example, typing

{pin2}{cmd:oneway response factor, tabulate means standard}

{pmore}produces a summary table that contains only the means and
standard deviations.  You could achieve the same result by typing

{pin2}{cmd:oneway response factor, tabulate nofreq}

{phang}
[{opt no}]{opt means} includes or suppresses only the means from
the table produced by the {opt tabulate} option.
See {helpb oneway##tabulate:tabulate} above.

{phang}
[{opt no}]{opt standard} includes or suppresses only the standard
deviation from the table produced by the {opt tabulate} option.
See {helpb oneway##tabulate:tabulate} above.

{phang}
[{opt no}]{opt freq} includes or suppresses only the frequencies
from the table produced by the {opt tabulate} option.
See {helpb oneway##tabulate:tabulate} above.

{phang}
[{opt no}]{opt obs} includes or suppresses only the reported
number of observations from the table produced by the {opt tabulate} option.
If the data are not weighted, only the frequency is reported.  If the data are
weighted, the frequency refers to the sum of the weights.
See {helpb oneway##tabulate:tabulate} above.

{phang}{opt noanova} suppresses the display of the ANOVA table.

{phang}{opt nolabel} causes the numeric codes to be displayed rather than the
value labels in the ANOVA and multiple-comparison test tables.

{phang}{opt wrap} requests that Stata not break up wide tables to make
them more readable.

{phang}{opt missing} requests that missing values of {it:factor_var} be
treated as a category rather than as observations to be omitted from the
analysis.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse apple}{p_end}
{phang2}{cmd:. oneway weight treatment}{p_end}

{phang}Obtaining observed means{p_end}
{phang2}{cmd:. oneway weight treatment, tabulate}{p_end}

{phang}Bonferroni multiple-comparison test{p_end}
{phang2}{cmd:. oneway weight treatment, bonferroni}

{phang}Scheffe multiple-comparison test{p_end}
{phang2}{cmd:. oneway weight treatment, scheffe}

    {hline}
    Setup
{phang2}{cmd:. webuse census8}{p_end}

{phang}With weighted data{p_end}
{phang2}{cmd:. oneway drate region [w=pop]}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=XEFGGkFRdD4":One-way ANOVA in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:oneway} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(df_r)}}within-group degrees of freedom{p_end}
{synopt:{cmd:r(mss)}}between-group sum of squares{p_end}
{synopt:{cmd:r(df_m)}}between-group degrees of freedom{p_end}
{synopt:{cmd:r(rss)}}within-group sum of squares{p_end}
{synopt:{cmd:r(chi2bart)}}Bartlett's chi-squared{p_end}
{synopt:{cmd:r(df_bart)}}Bartlett's degrees of freedom{p_end}
{p2colreset}{...}
