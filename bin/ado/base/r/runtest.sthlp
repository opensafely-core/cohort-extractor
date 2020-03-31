{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog runtest "dialog runtest"}{...}
{vieweralsosee "[R] runtest" "mansection R runtest"}{...}
{viewerjumpto "Syntax" "runtest##syntax"}{...}
{viewerjumpto "Menu" "runtest##menu"}{...}
{viewerjumpto "Description" "runtest##description"}{...}
{viewerjumpto "Links to PDF documentation" "runtest##linkspdf"}{...}
{viewerjumpto "Options" "runtest##options"}{...}
{viewerjumpto "Examples" "runtest##examples"}{...}
{viewerjumpto "Stored results" "runtest##results"}{...}
{viewerjumpto "Reference" "runtest##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] runtest} {hline 2}}Test for random order{p_end}
{p2col:}({mansection R runtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:runtest} {varname} [{it:{help in}}] 
[{cmd:,} {it:options}] 

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt c:ontinuity}}continuity correction{p_end}
{synopt :{opt d:rop}}ignore values equal to the threshold{p_end}
{synopt :{opt s:plit}}randomly split values equal to the threshold as above 
or below the threshold; default is to count as below{p_end}
{synopt :{opt m:ean}}use mean as threshold; default is median{p_end}
{synopt :{opt t:hreshold(#)}}assign arbitrary threshold; default is
median{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
          {bf:Test for random order}


{marker description}{...}
{title:Description}

{pstd}
{cmd:runtest} tests whether the observations of {varname} are serially
independent -- that is, whether they occur in a random order -- by
counting how many runs there are above and below a threshold.  By default, the
median is used as the threshold.  A small number of runs indicates positive
serial correlation; a large number indicates negative serial correlation.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R runtestQuickstart:Quick start}

        {mansection R runtestRemarksandexamples:Remarks and examples}

        {mansection R runtestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt continuity} specifies a continuity correction that may be helpful in
small samples.  If there are fewer than 10 observations either above or below
the threshold, however, the tables in 
{help runtest##SE1943:Swed and Eisenhart (1943)} provide more reliable
critical values.  By default, no continuity correction is used.

{phang}
{opt drop} directs {cmd:runtest} to ignore any values of {varname} that are
equal to the threshold value when counting runs and tabulating observations.
By default, {cmd:runtest} counts a value as being above the threshold when it
is strictly above the threshold and as being below the threshold when it is
less than or equal to the threshold.

{phang}
{opt split} directs {cmd:runtest} to randomly split values of {varname} that
are equal to the threshold.  In other words, when {it:varname} is equal
to threshold, a "coin" is flipped.  If it comes up heads, the value is counted
as above the threshold.  If it comes up tails, the value is counted as below
the threshold.

{phang}
{opt mean} directs {cmd:runtest} to tabulate runs above and below the mean
rather than the median.

{phang}
{opt threshold(#)} specifies an arbitrary threshold to use in counting runs.
For example, if {varname} has already been coded as a 0/1 variable, the median
generally will not be a meaningful separating value.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress mpg weight foreign}{p_end}
{phang2}{cmd:. predict resid, resid}{p_end}

{pstd}Test residuals for serial correlation{p_end}
{phang2}{cmd:. runtest resid}{p_end}

{pstd}Same as above, but use 0 as the threshold{p_end}
{phang2}{cmd:. runtest resid, threshold(0)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse additive, clear}{p_end}
{phang2}{cmd:. sort miles}{p_end}

{pstd}Test {cmd:additive} for serial correlation and use 1 as the
threshold{p_end}
{phang2}{cmd:. runtest additive, threshold(1)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:runtest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_below)}}number below the threshold{p_end}
{synopt:{cmd:r(N_above)}}number above the threshold{p_end}
{synopt:{cmd:r(mean)}}expected number of runs{p_end}
{synopt:{cmd:r(p)}}p-value of z{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(n_runs)}}number of runs{p_end}
{synopt:{cmd:r(Var)}}variance of the number of runs{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker SE1943}{...}
{phang}
Swed, F. S., and C. Eisenhart. 1943. Tables for testing randomness of grouping
in a sequence of alternatives. {it:Annals of Mathematical Statistics} 14:
66-87.
{p_end}
