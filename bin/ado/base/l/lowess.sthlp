{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog lowess "dialog lowess"}{...}
{vieweralsosee "[R] lowess" "mansection R lowess"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] ipolate" "help ipolate"}{...}
{vieweralsosee "[R] lpoly" "help lpoly"}{...}
{vieweralsosee "[R] smooth" "help smooth"}{...}
{viewerjumpto "Syntax" "lowess##syntax"}{...}
{viewerjumpto "Menu" "lowess##menu"}{...}
{viewerjumpto "Description" "lowess##description"}{...}
{viewerjumpto "Links to PDF documentation" "lowess##linkspdf"}{...}
{viewerjumpto "Options" "lowess##options"}{...}
{viewerjumpto "Examples" "lowess##examples"}{...}
{viewerjumpto "Reference" "lowess##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] lowess} {hline 2}}Lowess smoothing{p_end}
{p2col:}({mansection R lowess:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:lowess} {it:yvar} {it:xvar} {ifin}
 [{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt m:ean}}running-mean smooth; default is running-line
least squares{p_end}
{synopt :{opt now:eight}}suppress weighted regressions; default is tricube
weighting function{p_end}
{synopt :{opt bw:idth(#)}}use {it:#} for the bandwidth; default is 
{cmd:bwidth(0.8)}{p_end}
{synopt :{opt lo:git}}transform dependent variable to logits{p_end}
{synopt :{opt a:djust}}adjust smoothed mean to equal mean of dependent
variable{p_end}
{synopt :{opt nog:raph}}suppress graph{p_end}
{synopt :{opth gen:erate(newvar)}}create {it:newvar} containing smoothed values
of {it:yvar}{p_end}

{syntab :Plot}
INCLUDE help gr_markopt2

{syntab :Smoothed line}
{synopt :{opth lineop:ts(cline_options)}}affect rendition of the smoothed line{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any of the options documented in 
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{it:yvar} and {it:xvar} may contain time-series operators; see 
{help tsvarlist}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Lowess smoothing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lowess} carries out a locally weighted regression of
{it:yvar} on
{it:xvar}, displays the graph, and optionally saves the smoothed variable.

{pstd}
Warning:  {cmd:lowess} is computationally intensive and may therefore
take a long time to run on a slow computer.  Lowess calculations on 1,000
observations, for instance, require performing 1,000 regressions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lowessQuickstart:Quick start}

        {mansection R lowessRemarksandexamples:Remarks and examples}

        {mansection R lowessMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt mean} specifies running-mean smoothing; the default is running-line
least-squares smoothing.

{phang}
{opt noweight} prevents the use of Cleveland's 
({help lowess##C1979:1979}) tricube weighting function; the default is to use
the weighting function.

{phang}
{opt bwidth(#)} specifies the bandwidth.  Centered subsets of
{opt bwidth()}*N observations are used for calculating smoothed values
for each point in the data except for end points, where smaller, uncentered
subsets are used.  The greater the {opt bwidth()}, the greater the smoothing.
The default is 0.8.

{phang}
{cmd:logit} transforms the smoothed {it:yvar} into logits.
Predicted values less than 0.0001 or greater than 0.9999 are set to 1/N and
1-1/N, respectively, before taking logits.

{phang}
{opt adjust} adjusts the mean of the smoothed {it:yvar} to equal
the mean of {it:yvar} by multiplying by an appropriate factor.  This option is
useful when smoothing binary (0/1) data.

{phang}
{opt nograph} suppresses displaying the graph.

{phang}
{opth generate(newvar)} creates {it:newvar} containing the smoothed values of
{it:yvar}.

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Smoothed line}

{phang}
{opt lineopts(cline_options)} affects the rendition of the lowess-smoothed 
line; see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph;
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}.  These include options for titling the graph 
(see {manhelpi title_options G-3}), options for saving the graph to disk (see 
{manhelpi saving_option G-3}), and the {opt by()} option (see 
{manhelpi by_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lowess1}{p_end}

{pstd}Perform locally weighted regression of {cmd:h1} on {cmd:depth} and 
display graph{p_end}
{phang2}{cmd:. lowess h1 depth}{p_end}

{pstd}Same as above, but use 0.4 as the bandwidth rather than the default of
0.8{p_end}
{phang2}{cmd:. lowess h1 depth, bwidth(.4)}

{pstd}Same as above, but save smoothed values of {cmd:h1} in {cmd:x1} and
suppress the graph{p_end}
{phang2}{cmd:. lowess h1 depth, bwidth(.4) gen(x1) nograph}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Perform locally weighted regression of {cmd:foreign} on
{cmd:mpg}, labeling y axis with Domestic for 0 and Foreign for 1{p_end}
{phang2}{cmd:. lowess foreign mpg, ylabel(0 "Domestic" 1 "Foreign")}

{pstd}Same as above, but adjust mean of smoothed {cmd:foreign} to equal mean
of {cmd:foreign}{p_end}
{phang2}{cmd:. lowess foreign mpg, ylabel(0 "Domestic" 1 "Foreign")}
              {cmd:adjust}{p_end}

{pstd}Perform locally weighted regression of {cmd:foreign} on {cmd:mpg},
transforming the smoothed {cmd:foreign} into logits and drawing a horizontal
line at 0{p_end}
{phang2}{cmd:. lowess foreign mpg, logit yline(0)}{p_end}
    {hline}


{marker reference}{...}
{title:Reference}

{marker C1979}{...}
{phang}
Cleveland, W. S. 1979. Robust locally weighted regression and smoothing
scatterplots. {it:Journal of the American Statistical Association} 74:
829-836.
{p_end}
