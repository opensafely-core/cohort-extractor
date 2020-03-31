{smcl}
{* *! version 1.1.7  15jun2019}{...}
{viewerdialog sample "dialog sample"}{...}
{vieweralsosee "[D] sample" "mansection D sample"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bsample" "help bsample"}{...}
{vieweralsosee "[D] splitsample" "help splitsample"}{...}
{viewerjumpto "Syntax" "sample##syntax"}{...}
{viewerjumpto "Menu" "sample##menu"}{...}
{viewerjumpto "Description" "sample##description"}{...}
{viewerjumpto "Links to PDF documentation" "sample##linkspdf"}{...}
{viewerjumpto "Options" "sample##options"}{...}
{viewerjumpto "Examples" "sample##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] sample} {hline 2}}Draw random sample{p_end}
{p2col:}({mansection D sample:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:sample}
{it:#}
{ifin}
[{cmd:,} {opt c:ount} {opth by:(varlist:groupvars)}]

{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Resampling > Draw random sample}


{marker description}{...}
{title:Description}

{pstd}
{opt sample} draws random samples of the data in memory.  "Sampling" here is
defined as drawing observations without replacement; see {manhelp bsample R}
for sampling with replacement.

{pstd}
The size of the sample to be drawn can be specified as a percentage or as a
count:

{pin}
    {opt sample} without the {opt count} option draws a {it:#}%
    pseudorandom sample of the data in memory, thus discarding
    (100 - {it:#})% of the observations.

{pin}
    {opt sample} with the {opt count} option draws a {it:#}-observation
    pseudorandom sample of the data in memory, thus discarding {cmd:_N} - {it:#}
    observations.  {it:#} can be larger than {help _N}, in which case all
    observations are kept.

{pstd}
In either case, observations not meeting the optional {opt if} and {opt in}
criteria are kept (sampled at 100%).

{pstd}
If you are interested in reproducing results, you must first set the
random-number seed; see {manhelp set_seed R:set seed}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D sampleQuickstart:Quick start}

        {mansection D sampleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt count} specifies that {it:#} in {opt sample} {it:#} be
    interpreted as an observation count rather than as a percentage.  Typing
    {opt sample 5} without the {opt count} option means that a 5% sample be
    drawn; typing {opt sample 5, count}, however,
    would draw a sample of 5 observations.

{pmore}
    Specifying {it:#} as greater than the number of observations in the dataset
    is not considered an error.

{phang}
{opth by:(varlist:groupvars)} specifies that a {it:#}% sample be drawn within
    each set of values of {it:groupvars}, thus maintaining the proportion of
    each group.

{pmore}
    {opt count} may be combined with {opt by()}. For example, typing
    {bind:{cmd:sample 50, count by(sex)}} would draw a sample of size 50 for
    men and 50 for women.

{pmore}
    Specifying {bind:{cmd:by} {it:varlist}{cmd::} {cmd:sample} {it:#}} is
    equivalent to specifying
    {bind:{cmd:sample} {it:#}{cmd:,} {cmd:by(}{it:varlist}{cmd:)}}; use
    whichever syntax you prefer.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse nlswork}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe, short}

{pstd}Draw a 10% sample{p_end}
{phang2}{cmd:. sample 10}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe, short}

    {hline}
    Setup
{phang2}{cmd:. webuse nlswork, clear}

{pstd}Create a one-way table of frequency counts{p_end}
{phang2}{cmd:. tab race}

{pstd}Keep 100% of {cmd:race} != 1 women, but only 10% of {cmd:race} = 1
women{p_end}
{phang2}{cmd:. sample 10 if race == 1}

    {hline}
    Setup
{phang2}{cmd:. webuse nlswork, clear}

{pstd}Keep 10% of each of the three categories of {cmd:race}{p_end}
{phang2}{cmd:. sample 10, by(race)}

    {hline}
    Setup
{phang2}{cmd:. webuse nlswork, clear}

{pstd}Draw a sample of 2,500{p_end}
{phang2}{cmd:. sample 2500, count}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe, short}{p_end}
    {hline}
