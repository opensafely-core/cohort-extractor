{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog "tssmooth nl" "dialog tssmooth_nl"}{...}
{vieweralsosee "[TS] tssmooth nl" "mansection TS tssmoothnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "tssmooth nl##syntax"}{...}
{viewerjumpto "Menu" "tssmooth nl##menu"}{...}
{viewerjumpto "Description" "tssmooth nl##description"}{...}
{viewerjumpto "Links to PDF documentation" "tssmooth_nl##linkspdf"}{...}
{viewerjumpto "Options" "tssmooth nl##options"}{...}
{viewerjumpto "Examples" "tssmooth nl##examples"}{...}
{viewerjumpto "Stored results" "tssmooth nl##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TS] tssmooth nl} {hline 2}}Nonlinear filter{p_end}
{p2col:}({mansection TS tssmoothnl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:tssmooth} {cmd:nl} {dtype} {newvar} {cmd:=} {it:{help exp}} {ifin}{cmd:,} 
{opt sm:oother}{cmd:(}{it:smoother}[{cmd:,} {opt t:wice} ]{cmd:)}
[{cmd:replace}]

{pstd}
where {it:smoother} is specified as {it:Sm}[{it:Sm}[{it:...}]] and {it:Sm} is
one of{p_end}

	{c -(}{cmd:1}|{cmd:2}|{cmd:3}|{cmd:4}|{cmd:5}|{cmd:6}|{cmd:7}|{cmd:8}|{cmd:9}{c )-}[{cmd:R}]
	{cmd:3}[{cmd:R}]{cmd:S}[{cmd:S}|{cmd:R}][{cmd:S}|{cmd:R}]{it:...}
	{cmd:E}
	{cmd:H}

{pstd}
The numbers specified in {it:smoother} represent the span of a running median
smoother.  For example, a number 3 specifies that each value be replaced by
the median of the point and the two adjacent data values.  The letter {cmd:H}
indicates that a Hanning linear smoother, which is a span-3 smoother with
binomial weights, be applied.

{pstd}
The letters {cmd:E}, {cmd:S}, and {cmd:R} are three refinements that can be
combined with the running median and Hanning smoothers.  First, the end points
of a smooth can be given special treatment.  This is specified by the {cmd:E}
operator.  Second, smoothing by 3, the span-3 running median, tends to produce
flat-topped hills and valleys.  The splitting operator, {cmd:S}, "splits" these
repeated values, applies the end-point operator to them, and then "rejoins"
the series.  Third, it is sometimes useful to repeat an odd-span median
smoother or the splitting operator until the smooth no longer changes.
Following a digit or an {cmd:S} with an {cmd:R} specifies this type of
repetition.

{pstd}
Finally, the {cmd:twice} operator specifies that after smoothing, the smoother
be reapplied to the resulting rough, and any recovered signal be added back to
the original smooth.

{pstd}
Letters may be specified in lowercase, if preferred.  Examples of
{bind:{it:smoother}[{cmd:, twice}]} include

{p 8 8 2}{cmd:3RSSH} {space 2} {cmd:3RSSH,twice} {space 2} {cmd:4253H} {space 2} {cmd:4253H,twice} {space 2} {cmd:43RSR2H,twice}{p_end}
{p 8 8 2}{cmd:3rssh} {space 2} {cmd:3rssh,twice} {space 2} {cmd:4253h} {space 2} {cmd:4253h,twice} {space 2} {cmd:43rsr2h,twice}

{p 4 6 2}You must {cmd:tsset} your data before using 
{cmd:tssmooth nl}; see {helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:exp} may contain time-series operators; see 
{help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Smoothers/univariate forecasters >}
    {bf:Nonlinear filter}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tssmooth nl} uses nonlinear smoothers to identify the underlying trend in
a series.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssmoothnlQuickstart:Quick start}

        {mansection TS tssmoothnlRemarksandexamples:Remarks and examples}

        {mansection TS tssmoothnlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:smooth(}{it:smoother}[{cmd:, twice}]{cmd:)} is required; it specifies the
nonlinear smoother to be used.

{phang}
{opt replace} replaces {newvar} if it already exists.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sales2}

{pstd}Perform nonlinear smoothing to {cmd:sales} using a median smoother of
span 5{p_end}
{phang2}{cmd:. tssmooth nl nl1=sales, smoother(5)}

{pstd}Perform nonlinear smoothing to {cmd:sales} by applying span-3 median
smoother twice, then applying the split operator to repeated values twice, and
finally applying a Hanning smoother{p_end}
{phang2}{cmd:. tssmooth nl nl2=sales, smoother(3RSSH)}

{pstd}Same as above, except after smoothing, reapply the smoother to the
resulting rough, and add any recovered signal back to the original
smooth{p_end}
{phang2}{cmd:. tssmooth nl nl3=sales, smoother(3RSSH, twice)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tssmooth nl} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}{cmd:nl}{p_end}
{synopt:{cmd:r(smoother)}}specified smoother{p_end}
{synopt:{cmd:r(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:r(panelvar)}}panel variable specified in {cmd:tsset}{p_end}
{p2colreset}{...}
