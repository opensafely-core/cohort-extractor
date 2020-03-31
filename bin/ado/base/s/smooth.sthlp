{smcl}
{* *! version 1.1.11  19oct2017}{...}
{viewerdialog smooth "dialog smooth"}{...}
{vieweralsosee "[R] smooth" "mansection R smooth"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lowess" "help lowess"}{...}
{vieweralsosee "[R] lpoly" "help lpoly"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "smooth##syntax"}{...}
{viewerjumpto "Menu" "smooth##menu"}{...}
{viewerjumpto "Description" "smooth##description"}{...}
{viewerjumpto "Links to PDF documentation" "smooth##linkspdf"}{...}
{viewerjumpto "Option" "smooth##option"}{...}
{viewerjumpto "Technical note" "smooth##technote"}{...}
{viewerjumpto "Examples" "smooth##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] smooth} {hline 2}}Robust nonlinear smoother{p_end}
{p2col:}({mansection R smooth:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:smooth}
{it:smoother}
[{cmd:,} {opt t:wice}]
{varname}
{ifin}
{cmd:,}
{opth g:enerate(newvar)}

{pstd}where {it:smoother} is specified as
	{it:Sm}[{it:Sm}[{it:...}]]
and {it:Sm} is one of {p_end}

	{c -(}{cmd:1}|{cmd:2}|{cmd:3}|{cmd:4}|{cmd:5}|{cmd:6}|{cmd:7}|{cmd:8}|{cmd:9}{c )-}[{cmd:R}]
	{cmd:3}[{cmd:R}]{cmd:S}[{cmd:S}|{cmd:R}][{cmd:S}|{cmd:R}]{it:...}
	{cmd:E}
	{cmd:H}

{pstd}
The numbers specified in {it:smoother} represent the span of a running median
smoother.  For example, a number 3 specifies that each value be replaced by
the median of the point and the two adjacent data values.  The letter H
indicates that a Hanning linear smoother, which is a span-3 smoother with
binomial weights, be applied.

{pstd}
The letters E, S, and R are three refinements that can be combined with the
running median and Hanning smoothers.  First, the endpoints of a smooth can
be given special treatment.  This is specified by the E operator.  Second,
smoothing by 3, the span-3 running median, tends to produce flat-topped hills
and valleys.  The splitting operator, S, "splits" these repeated values,
applies the endpoint operator to them, and then "rejoins" the series.  Third,
it is sometimes useful to repeat an odd-span median smoother or the splitting
operator until the smooth no longer changes.  Following a digit or an S with
an R specifies this type of repetition.

{pstd}
Finally, the {cmd:twice} operator specifies that after smoothing, the smoother
be reapplied to the resulting rough and that any recovered signal be added
back to the original smooth.

{pstd}
Letters may be specified in lowercase if preferred.  Examples of
{bind:{it:smoother} [{cmd:,twice}]} include

{pmore}
{cmd:3RSSH} {space 2} {cmd:3RSSH,twice} {space 2} {cmd:4253H} {space 2} {cmd:4253H,twice} {space 2} {cmd:43RSR2H,twice}{p_end}

{pmore}
{cmd:3rssh} {space 2} {cmd:3rssh,twice} {space 2} {cmd:4253h} {space 2} {cmd:4253h,twice} {space 2} {cmd:43rsr2h,twice}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Robust nonlinear smoother}


{marker description}{...}
{title:Description}

{pstd}
{opt smooth} applies the specified resistant, nonlinear smoother to {varname}
and stores the smoothed series in {newvar}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R smoothQuickstart:Quick start}

        {mansection R smoothRemarksandexamples:Remarks and examples}

        {mansection R smoothMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opth generate(newvar)} is required; it specifies the name of the new variable
that will contain the smoothed values.


{marker technote}{...}
{title:Technical note}

{pstd}
{cmd:smooth} allows missing values at the beginning and end of the series,
but missing values in the middle are not allowed.  Leading and trailing missing
values are ignored.  If you wish to ignore missing values in the middle of the
series, you must {cmd:drop} the missing observations before using
{cmd:smooth}.  Doing so, of course, would violate {cmd:smooth}'s assumption
that observations are equally spaced -- each observation represents
a year, a quarter, or a month (or a 1-year birth-rate category).  In
practice, {cmd:smooth} produces good results as long as the spaces between
adjacent observations do not vary too much.

{pstd}
Smoothing is usually applied to time series, but any variable with a natural
order can be smoothed.  For example, a smoother might be applied to the birth
rate recorded by the age of the mothers (birth rate for 17-year-olds, birth
rate for 18-year-olds, and so on).


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse air2}{p_end}

{pstd}A median smoother of span 5{p_end}
{phang2}{cmd:. smooth 5 air, gen(smair)}{p_end}

{pstd}A median smoother of span 4 followed by a median smoother of span 6{p_end}
{phang2}{cmd:. smooth 46 air, gen(smair2)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse turksales, clear}{p_end}

{pstd}A sequence of three median smoothers with odd numbered spans, for
example, 7,5,3 followed by a sequence of four median smoothers with even
numbered spans, for example, 8,6,4,2 with the endpoint operator applied
followed by a span-3 Hanning linear smooth with the same smoother applied to
the resulting rough{p_end}
{phang2}{cmd:. smooth  7538642eh,twice sales , gen(smsales)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse fishdata, clear}{p_end}

{pstd}Four median smoothers of spans 4,2,5, and three followed by the endpoint
operator and a span-3 Hanning linear linear smooth with the same smoother
applied to the resulting rough{p_end}
{phang2}{cmd:. smooth 4253eh,twice freq, gen(sfreq)}{p_end}
    {hline}
