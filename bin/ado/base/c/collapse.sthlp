{smcl}
{* *! version 1.3.7  11sep2019}{...}
{viewerdialog collapse "dialog collapse"}{...}
{vieweralsosee "[D] collapse" "mansection D collapse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] contract" "help contract"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "[D] statsby" "help statsby"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{viewerjumpto "Syntax" "collapse##syntax"}{...}
{viewerjumpto "Menu" "collapse##menu"}{...}
{viewerjumpto "Description" "collapse##description"}{...}
{viewerjumpto "Links to PDF documentation" "collapse##linkspdf"}{...}
{viewerjumpto "Options" "collapse##options"}{...}
{viewerjumpto "Weights" "collapse##weights"}{...}
{viewerjumpto "Examples" "collapse##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] collapse} {hline 2}}Make dataset of summary statistics{p_end}
{p2col:}({mansection D collapse:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:collapse}
{it:clist}
{ifin}
[{it:{help collapse##weight:weight}}]
[{cmd:,} {it:{help collapse##table_options:options}}]

{pstd}where {it:clist} is either

{p 8 17 2}
[{opt (stat)}]
{varlist}
[ [{opt (stat)}] {it:...} ]{p_end}

{p 8 17 2}
[{opt (stat)}] {it:target_var}{cmd:=}{varname}
        [{it:target_var}{cmd:=}{varname} {it:...}]
        [ [{opt (stat)}] {it:...}]

{p 4 4 2}or any combination of the {it:varlist} or {it:target_var} forms, and
{it:stat} is one of{p_end}

{p2colset 9 22 24 2}{...}
{p2col :{opt mean}}means (default){p_end}
{p2col :{opt median}}medians{p_end}
{p2col :{opt p1}}1st percentile{p_end}
{p2col :{opt p2}}2nd percentile{p_end}
{p2col :{it:...}}3rd{hline 1}49th percentiles{p_end}
{p2col :{opt p50}}50th percentile (same as {cmd:median}){p_end}
{p2col :{it:...}}51st{hline 1}97th percentiles{p_end}
{p2col :{opt p98}}98th percentile{p_end}
{p2col :{opt p99}}99th percentile{p_end}
{p2col :{opt sd}}standard deviations{p_end}
{p2col :{opt sem:ean}}standard error of the mean ({cmd:sd/sqrt(n)}){p_end}
{p2col :{opt seb:inomial}}standard error of the mean, binomial ({cmd:sqrt(p(1-p)/n)}){p_end}
{p2col :{opt sep:oisson}}standard error of the mean, Poisson ({cmd:sqrt(mean/n)}){p_end}
{p2col :{opt sum}}sums{p_end}
{p2col :{opt rawsum}}sums, ignoring optionally specified weight except
	observations with a weight of zero are excluded{p_end}
{p2col :{opt count}}number of nonmissing observations{p_end}
{p2col :{opt percent}}percentage of nonmissing observations{p_end}
{p2col :{opt max}}maximums{p_end}
{p2col :{opt min}}minimums{p_end}
{p2col :{opt iqr}}interquartile range{p_end}
{p2col :{opt first}}first value{p_end}
{p2col :{opt last}}last value{p_end}
{p2col :{opt firstnm}}first nonmissing value{p_end}
{p2col :{opt lastnm}}last nonmissing value{p_end}
{p2colreset}{...}

{pstd}
If {it:stat} is not specified, {opt mean} is assumed.

{synoptset 15 tabbed}{...}
{marker table_options}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth by(varlist)}}groups over which {it:stat} is to be calculated
{p_end}
{synopt :{opt cw}}casewise deletion instead of all possible observations
{p_end}

{synopt :{opt fast}}do not restore the original dataset should the
user press {hi:Break}; programmer's command{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist} and {it:varname} in {it:clist} may contain time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s, {opt fweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}, and see {help collapse##weights:Weights} below.
{opt pweight}s may not be used with {opt sd}, {opt semean}, 
{opt sebinomial}, or {opt sepoisson}.  {opt iweight}s may not be used with
{opt semean}, {opt sebinomial}, or {opt sepoisson}.  {opt aweight}s
may not be used with {opt sebinomial} or {opt sepoisson}.{p_end}
{p 4 6 2}
{opt fast} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Make dataset of means, medians, etc.}


{marker description}{...}
{title:Description}

{pstd}
{opt collapse} converts the dataset in memory into a dataset of means, sums,
medians, etc.  {it:clist} must refer to numeric variables exclusively.

{pstd}
Note: See {manhelp contract D} if you want to collapse to a dataset of
frequencies.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D collapseQuickstart:Quick start}

        {mansection D collapseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opth by(varlist)} specifies the groups over which the means, etc., are to be
calculated.  If this option is not specified, the resulting dataset will
contain 1 observation.  If it is specified, {it:varlist} may refer to either
string or numeric variables.

{phang}
{opt cw} specifies casewise deletion.  If {opt cw} is not specified, all
possible observations are used for each calculated statistic.

{pstd}The following option is available with {opt collapse} but is not shown
in the dialog box:

{phang}
{opt fast} specifies that {opt collapse} not restore the original dataset
should the user press {hi:Break}.  {opt fast} is intended for use by
programmers.


{marker weights}{...}
{title:Weights}

{pstd}
{opt collapse} allows all four weight types; the default is {opt aweight}s.
Weight normalization impacts only
the {opt sum}, {opt count}, {opt sd}, {opt semean}, and {opt sebinomial} statistics.

{pstd}
Let j index observations and i index by-groups.  Here are the definitions for
{opt count} and {opt sum} with weights:

{p2colset 9 37 39 2}{...}
{p2col 6 37 39 2 :{opt count}:}{p_end}
{p2col :unweighted:}N_i, the number of observations in group i{p_end}
{p2col :{opt aweight}:}N_i, the number of observations in group i{p_end}
{p2col :{opt fweight, iweight, pweight}:}sum(w_j), the sum of the weights over observations in group i{p_end}
{p2col 6 37 39 2 :{opt sum}:}{p_end}
{p2col :unweighted:}sum(x_j), the sum of x_j over observations in group i{p_end}
{p2col :{opt aweight}:}sum(v_j*x_j) over observations in group i; v_j = weights normalized to sum to N_i{p_end}
{p2col :{opt fweight, iweight, pweight}:}sum(w_j*x_j) over observations in group i{p_end}

{pstd}
When the {opt by()} option is not specified, the entire dataset is treated as
one group.

{pstd}
The {opt sd} statistic with weights returns the bias-corrected standard
deviation, which is based on the factor sqrt(N_i/(N_i-1)), where N_i is the
number of observations.  Statistics {opt sd}, {opt semean}, {opt sebinomial},
and {opt sepoisson} are not allowed with {opt pweight}ed data.  Otherwise, the
statistic is changed by the weights through the computation of the weighted
count, as outlined above.

{pstd}
For instance, consider a case in which there are 25 observations in the
dataset and a weighting variable that sums to 57.  In the unweighted case, the
weight is not specified, and the count is 25.  In the analytically weighted
case, the count is still 25; the scale of the weight is irrelevant.  In the
frequency-weighted case, however, the count is 57, the sum of the weights.

{pstd}
The {opt rawsum} statistic with {opt aweight}s ignores the
weight, with one exception:
observations with zero weight will not be included in the sum.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse college}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. list}

{pstd}Create dataset containing the 25th percentile of {cmd:gpa} for each
{cmd:year}{p_end}
{phang2}{cmd:. collapse (p25) gpa [fw=number], by(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse college, clear}

{pstd}Create dataset containing the mean and median of {cmd:gpa} and
{cmd:hour} for each {cmd:year}, and store median of {cmd:gpa} and {cmd:hour}
in {cmd:medgpa} and {cmd:medhour}, respectively{p_end}
{phang2}{cmd:. collapse (mean) gpa hour (median) medgpa=gpa medhour=hour}
     {cmd:[fw=number], by(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse college, clear}

{pstd}Create dataset containing the count of {cmd:gpa} and
{cmd:hour} and the minimums of {cmd:gpa} and {cmd:hour}, and store the
minimums in {cmd:mingpa} and {cmd:minhour}, respectively{p_end}
{phang2}{cmd:. collapse (count) gpa hour (min) mingpa=gpa minhour=hour}
     {cmd:[fw=number], by(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse college, clear}{p_end}
{phang2}{cmd:. replace gpa = . in 3}{p_end}

{pstd}Create dataset containing the percentage of observations in each
{cmd:year} where the totals are weighted counts of nonmissing {cmd:gpa} and
{cmd:hours}{p_end}
{phang2}{cmd:. collapse (percent) gpa hour [fw=number], by(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse college, clear}{p_end}
{phang2}{cmd:. replace gpa = . in 2/4}

{pstd}Create dataset containing the mean of {cmd:gpa} and
{cmd:hour} for each {cmd:year}, but ignore all observations that have missing
values when calculating the means{p_end}
{phang2}{cmd:. collapse (mean) gpa hour [fw=number], by(year) cw}

{pstd}List the result{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}
