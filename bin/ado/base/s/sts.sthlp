{smcl}
{* *! version 1.1.9  20sep2018}{...}
{viewerdialog generate "dialog sts_generate"}{...}
{viewerdialog graph "dialog sts_graph"}{...}
{viewerdialog list "dialog sts_list"}{...}
{viewerdialog test "dialog sts_test"}{...}
{vieweralsosee "[ST] sts" "mansection ST sts"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stci" "help stci"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts generate" "help sts_generate"}{...}
{vieweralsosee "[ST] sts graph" "help sts_graph"}{...}
{vieweralsosee "[ST] sts list" "help sts_list"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] Survival analysis" "help survival_analysis"}{...}
{viewerjumpto "Syntax" "sts##syntax"}{...}
{viewerjumpto "Description" "sts##description"}{...}
{viewerjumpto "Links to PDF documentation" "sts##linkspdf"}{...}
{viewerjumpto "Examples" "sts##examples"}{...}
{viewerjumpto "Video examples" "sts##video"}{...}
{viewerjumpto "Stored results" "sts##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[ST] sts} {hline 2}}Generate, graph, list, and test the survivor and cumulative hazard functions{p_end}
{p2col:}({mansection ST sts:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:sts} [{opt g:raph}] {ifin} [{cmd:,} ...]

{p 8 21 2}
{cmd:sts} {opt l:ist} {ifin} [{cmd:,} ...]

{p 8 21 2}
{cmd:sts} {opt t:est} {varlist} {ifin} [{cmd:,} ...]

{p 8 21 2}
{cmd:sts} {opt gen:erate} {newvar} {cmd:=} ... {ifin} [{cmd:,} ...]

{pstd}
You must {cmd:stset} your data before using {cmd:sts}; see
{manhelp stset ST}.{p_end}
{pstd}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified
using {cmd:stset}; see {manhelp stset ST}.

{pstd}
See {manhelp sts_graph ST:sts graph}, {manhelp sts_list ST:sts list},
{manhelp sts_test ST:sts test}, and {manhelp sts_generate ST:sts generate} for
details of syntax.


{marker description}{...}
{title:Description}

{pstd}
{cmd:sts} reports and creates variables containing the estimated survivor and
related functions, such as the Nelson-Aalen cumulative hazard function. 
For the survivor function, {cmd:sts} tests and produces Kaplan-Meier
estimates or, via Cox regression, adjusted estimates.

{pmore}
{cmd:sts graph} is equivalent to typing {cmd:sts} by itself -- it graphs the
survivor function.

{pmore}
{cmd:sts list} lists the estimated survivor and related functions.

{pmore}
{cmd:sts test} tests the equality of the survivor function across groups.

{pmore}
{cmd:sts generate} creates new variables containing the estimated survivor
function, the Nelson-Aalen cumulative hazard function, or related functions.

{pmore}
{cmd:sts} can be used with single- or multiple-record or single- or
multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stsRemarksandexamples:Remarks and examples}

        {mansection ST stsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Example: Listing, graphing, and generating variables}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Suppress showing of st settings{p_end}
{phang2}{cmd:. stset, noshow}

{pstd}List the survivor function{p_end}
{phang2}{cmd:. sts list}

{pstd}Graph the survivor function{p_end}
{phang2}{cmd:. sts graph}

{pstd}Create {cmd:survf} containing the survivor function{p_end}
{phang2}{cmd:. sts gen survf = s}

{pstd}Sort on the time variable{p_end}
{phang2}{cmd:. sort t1}

{pstd}List part of the data{p_end}
{phang2}{cmd:. list t1 survf in 1/10}


{title:Example: Comparing survivor or cumulative hazard functions}

{pstd}Graph the survivor functions for the two categories of
{cmd:posttran}, showing results on one graph{p_end}
{phang2}{cmd:. sts graph, by(posttran)}

{pstd}Graph the Nelson-Aalen cumulative hazard functions for the two
categories of {cmd:posttran}{p_end}
{phang2}{cmd:. sts graph, cumhaz by(posttran)}

{pstd}List the survivor functions for the two categories of {cmd:posttran},
including a number-who-enter column{p_end}
{phang2}{cmd:. sts list, by(posttran) enter}

{pstd}List the two categories of {cmd:posttran} side by side for the survivor
function, selecting a subset of comparison times{p_end}
{phang2}{cmd:. sts list, by(posttran) compare}

{pstd}List the two categories of {cmd:posttran} side by side for the
cumulative hazard function, selecting a subset of comparison times{p_end}
{phang2}{cmd:. sts list, cumhaz by(posttran) compare}

{pstd}List the two categories of {cmd:posttran} side by side for the survivor
function, using the specified comparison times{p_end}
{phang2}{cmd:. sts list, by(posttran) compare at(0 100 to 1700)}


{title:Example: Testing equality of survivor functions}

{pstd}Perform log-rank test for equality of survivor functions{p_end}
{phang2}{cmd:. sts test posttran}

{pstd}Perform Wilcoxon test for equality of survivor functions{p_end}
{phang2}{cmd:. sts test posttran, wilcoxon}


{title:Example: Adjusted estimates}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse drug2, clear}

{pstd}Suppress displaying of st settings{p_end}
{phang2}{cmd:. stset, noshow}

{pstd}Describe survival-time data{p_end}
{phang2}{cmd:. stdescribe}

{pstd}Show st settings{p_end}
{phang2}{cmd:. st}

{pstd}Summarize {cmd:age} and {cmd:drug}{p_end}
{phang2}{cmd:. summarize age drug}

{pstd}Graph the survivor functions for the two categories of {cmd:drug}{p_end}
{phang2}{cmd:. sts graph, by(drug)}

{pstd}Create variable containing the difference in age from 50{p_end}
{phang2}{cmd:. generate age50 = age - 50}

{pstd}Graph the survivor functions for the two categories of {cmd:drug}
adjusting for age by scaling to age 50{p_end}
{phang2}{cmd:. sts graph, by(drug) adjustfor(age50)}

{pstd}List the information that {cmd:sts graph} just plotted, selecting a
subset of comparison times{p_end}
{phang2}{cmd:. sts list, by(drug) adjustfor(age50) compare}

{pstd}Same as above, but adjust for age, not scaled to age 50{p_end}
{phang2}{cmd:. sts list, by(drug) adjustfor(age) compare}

{pstd}Same as above, but constrain the effect of {cmd:age50} to be the same
across strata{p_end}
{phang2}{cmd:. sts list, by(drug) adjustfor(age50) compare}


{title:Example: Counting the number lost due to censoring}

{pstd}List the survivor function{p_end}
{phang2}{cmd:. sts list}

{pstd}Graph the survivor function, showing the number lost as small numbers on
the plot{p_end}
{phang2}{cmd:. sts graph, lost}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3, clear}

{pstd}Suppress showing of st settings{p_end}
{phang2}{cmd:. stset, noshow}

{pstd}List the survivor functions for the two categories of {cmd:posttran},
including a number-who-enter column{p_end}
{phang2}{cmd:. sts list, by(posttran) enter}

{pstd}Same as above, but do not include the number-who-enter column{p_end}
{phang2}{cmd:. sts list, by(posttran)}

{pstd}List the survivor function, including a number-who-enter column{p_end}
{phang2}{cmd:. sts list, enter}

{pstd}List the survivor function, but do not include the number-who-enter
column{p_end}
{phang2}{cmd:. sts list}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=3MoWoZQCrUI&list=UUVk4G4nEtBS4tLOyHqustDA":How to graph survival curves}

{phang}
{browse "https://www.youtube.com/watch?v=9XZR32zElZ8&list=UUVk4G4nEtBS4tLOyHqustDA":How to calculate the Kaplan-Meier survivor and Nelson-Aalen cumulative hazard functions}

{phang}
{browse "https://www.youtube.com/watch?v=W1uympJV7Ko&list=UUVk4G4nEtBS4tLOyHqustDA":How to test the equality of survivor functions using nonparametric tests}


{marker results}{...}
{title:Stored results}

{pstd}
See {helpb sts test} for stored results details.
{p_end}
