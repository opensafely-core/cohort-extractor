{smcl}
{* *! version 1.1.14  19oct2017}{...}
{viewerdialog "tssmooth ma" "dialog tssmooth_ma"}{...}
{vieweralsosee "[TS] tssmooth ma" "mansection TS tssmoothma"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "tssmooth ma##syntax"}{...}
{viewerjumpto "Menu" "tssmooth ma##menu"}{...}
{viewerjumpto "Description" "tssmooth ma##description"}{...}
{viewerjumpto "Links to PDF documentation" "tssmooth_ma##linkspdf"}{...}
{viewerjumpto "Options" "tssmooth ma##options"}{...}
{viewerjumpto "Examples" "tssmooth ma##examples"}{...}
{viewerjumpto "Video example" "tssmooth ma##video"}{...}
{viewerjumpto "Stored results" "tssmooth ma##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TS] tssmooth ma} {hline 2}}Moving-average filter{p_end}
{p2col:}({mansection TS tssmoothma:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Moving average with uniform weights

{p 8 23 2}
{cmd:tssmooth} {cmd:ma} {dtype} {newvar} {cmd:=} {it:{help exp}} {ifin}{cmd:,} 
{opt w:indow}{cmd:(}{it:#l}[{it:#c}[{it:#f}]]{cmd:)} [{cmd:replace}]


{phang}
Moving average with specified weights

{p 8 23 2}
{cmd:tssmooth} {cmd:ma} {dtype} {newvar} {cmd:=} {it:{help exp}} {ifin}{cmd:,}
{opt we:ights}{cmd:(}[{it:{help numlist:numlist_l}}] {cmd:<}{it:#c}{cmd:>}
   [{it:{help numlist:numlist_f}}]{cmd:)} [{cmd:replace}]


{p 4 6 2}You must {cmd:tsset} your data before using 
{cmd:tssmooth ma}; {helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:exp} may contain time-series operators; see 
{help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Smoothers/univariate forecasters >}
    {bf:Moving-average filter}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tssmooth ma} creates a new series in which each observation is an average
of nearby observations in the original series.  The moving average may be
calculated with uniform or user-specified weights.  Missing periods are
excluded from calculations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssmoothmaQuickstart:Quick start}

        {mansection TS tssmoothmaRemarksandexamples:Remarks and examples}

        {mansection TS tssmoothmaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:window(}{it:#l}[{it:#c}[{it:#f}]]{cmd:)} describes the span of the
uniformly weighted moving average.

{pmore}
{it:#l} specifies the number of lagged terms to be included, 
{bind:0 {ul:<} {it:#l} {ul:<} one-half} the number of observations in the
sample.

{pmore}
{it:#c} is optional and specifies whether to include the current observation
in the filter.  A 0 indicates exclusion and 1, inclusion.  The current
observation is excluded by default.

{pmore}
{it:#f} is optional and specifies the number of forward terms to be included, 
{bind:0 {ul:<} {it:#f} {ul:<} one-half} the number of observations in the
sample.

{phang}
{cmd:weights(}[{it:{help numlist:numlist_l}}] {cmd:<}{it:#_c}{cmd:>}
[{it:numlist_f}]{cmd:)}
is required for the weighted moving average and describes the span of
the moving average, as well as the weights to be applied
to each term in the average.  The middle term literally is
surrounded by {cmd:<} and {cmd:>}, so you might type 
{cmd:weights(1/2 <3> 2/1)}.

{pmore}
{it:numlist_l} is optional and specifies the weights to be applied
to the lagged terms when computing the moving average.

{pmore}
{it:#_c} is required and specifies the weight to be applied to the current
term.

{pmore}
{it:numlist_f} is optional and specifies the weights to be applied
to the forward terms when computing the moving average.

{pmore}
The number of elements in each {it:numlist} is limited to one-half the
number of observations in the sample.

{phang}
{opt replace} replaces {newvar} if it already exists.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sales1}{p_end}
{phang2}{cmd:. tsset}{p_end}

{pstd}Create uniformly weighted moving average of {cmd:sales} using 2 lagged
terms, 3 forward terms, and the current observation in the filter
{p_end}
{phang2}{cmd:. tssmooth ma sm1=sales, window(2 1 3)}

{pstd}Create weighted moving average of {cmd:sales} using 1 and 2 as the
weights for the lagged terms, 3 as the weight for the current term, and 2
and 1 as the weights for the forward terms{p_end}
{phang2}{cmd:. tssmooth ma sm2=sales, weights(1/2 <3> 2/1)}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=KRhroFkSviw":Moving-average smoothers}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tssmooth ma} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(w0)}}weight on the current observation{p_end}
{synopt:{cmd:r(wlead}{it:#}{cmd:)}}weight on lead {it:#}, if leads are specified{p_end}
{synopt:{cmd:r(wlag}{it:#}{cmd:)}}weight on lag {it:#}, if lags are specified{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}smoothing method{p_end}
{synopt:{cmd:r(exp)}}expression specified{p_end}
{synopt:{cmd:r(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:r(panelvar)}}panel variable specified in {cmd:tsset}{p_end}
{p2colreset}{...}
