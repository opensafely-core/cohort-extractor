{smcl}
{* *! version 1.1.13  14may2018}{...}
{viewerdialog symplot "dialog symplot"}{...}
{viewerdialog quantile "dialog quantile"}{...}
{viewerdialog qqplot "dialog qqplot"}{...}
{viewerdialog qnorm "dialog qnorm"}{...}
{viewerdialog pnorm "dialog pnorm"}{...}
{viewerdialog qchi "dialog qchi"}{...}
{viewerdialog pchi "dialog pchi"}{...}
{vieweralsosee "[R] Diagnostic plots" "mansection R Diagnosticplots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cumul" "help cumul"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[R] logistic postestimation" "help logistic_postestimation"}{...}
{vieweralsosee "[R] lv" "help lv"}{...}
{vieweralsosee "[R] regress postestimation diagnostic plots" "help regress_postestimation_plots"}{...}
{viewerjumpto "Syntax" "diagnostic plots##syntax"}{...}
{viewerjumpto "Menu" "diagnostic plots##menu"}{...}
{viewerjumpto "Description" "diagnostic plots##description"}{...}
{viewerjumpto "Links to PDF documentation" "diagnostic_plots##linkspdf"}{...}
{viewerjumpto "Options for symplot, quantile, and qqplot" "diagnostic plots##options_symplot"}{...}
{viewerjumpto "Options for qnorm and pnorm" "diagnostic plots##options_qnorm"}{...}
{viewerjumpto "Options for qchi and pchi" "diagnostic plots##options_qchi"}{...}
{viewerjumpto "Examples" "diagnostic plots##examples"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[R] Diagnostic plots} {hline 2}}Distributional diagnostic plots{p_end}
{p2col:}({mansection R Diagnosticplots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Symmetry plot

{phang2}
{cmd:symplot}
{varname} 
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options1:options1}}]


{phang}Ordered values of varname against quantiles of uniform distribution

{phang2}
{cmd:quantile} 
{varname} 
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options1:options1}}]


{phang}Quantiles of varname1 against quantiles of varname2

{phang2}{cmd:qqplot}
{it:{help varname:varname1}}
{it:{help varname:varname2}}
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options1:options1}}]


{phang}Quantiles of varname against quantiles of normal distribution

{phang2}{cmd:qnorm}
{varname}
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options2:options2}}]


{phang}Standardized normal probability plot

{phang2}{cmd:pnorm}
{varname}
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options2:options2}}]


{phang}Quantiles of varname against quantiles of chi-squared distribution

{phang2}{cmd:qchi}
{varname}
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options3:options3}}]


{phang}Chi-squared probability plot

{phang2}{cmd:pchi}
{varname}
{ifin}
[{cmd:,} {it:{help diagnostic_plots##options3:options3}}]


{synoptset 25 tabbed}{...}
{marker options1}{...}
{synopthdr :options1}
{synoptline}
{syntab :Plot}
INCLUDE help gr_markopt2

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference line{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25 tabbed}{...}
{marker options2}{...}
{synopthdr :options2}
{synoptline}
{syntab :Main}
{synopt :{opt g:rid}}add grid lines{p_end}

{syntab:Plot}
INCLUDE help gr_markopt2

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference line{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synoptline}


{synoptset 25 tabbed}{...}
{marker options3}{...}
{synopthdr :options3}
{synoptline}
{syntab:Main}
{synopt :{opt g:rid}}add grid lines{p_end}
{synopt :{opt df(#)}}degrees of freedom of chi-squared distribution; default is {cmd:df(1)}{p_end}

{syntab:Plot}
INCLUDE help gr_markopt2

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference line{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:symplot}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Distributional plots and tests > Symmetry plot}

    {title:quantile}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Distributional plots and tests > Quantiles plot}

    {title:qqplot}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Distributional plots and tests > Quantile-quantile plot}

    {title:qnorm}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Distributional plots and tests > Normal quantile plot}

    {title:pnorm}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Distributional plots and tests > Normal probability plot, standardized}

    {title:qchi}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Distributional plots and tests > Chi-squared quantile plot}

    {title:pchi}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
      {bf:Distributional plots and tests > Chi-squared probability plot}


{marker description}{...}
{title:Description}

{pstd}
{cmd:symplot} graphs a symmetry plot of {varname}.

{pstd}
{cmd:quantile} plots the ordered values of {it:varname} against the
quantiles of a uniform distribution.

{pstd}
{cmd:qqplot} plots the quantiles of {it:varname1} against the quantiles of
{it:varname2} (Q-Q plot).

{pstd}
{cmd:qnorm} plots the quantiles of {it:varname} against the quantiles of
the normal distribution (Q-Q plot).

{pstd}
{cmd:pnorm} graphs a standardized normal probability plot (P-P plot).

{pstd}
{cmd:qchi} plots the quantiles of {it:varname} against the quantiles of a
chi-squared distribution (Q-Q plot).

{pstd}
{cmd:pchi} graphs a chi-squared probability plot (P-P plot).

{pstd}
See {manhelp regress_postestimation_plots R:regress postestimation diagnostic plots}
for regression diagnostic plots and
{manhelp logistic_postestimation R:logistic postestimation} for logistic
regression diagnostic plots.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R DiagnosticplotsQuickstart:Quick start}

        {mansection R DiagnosticplotsRemarksandexamples:Remarks and examples}

        {mansection R DiagnosticplotsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_symplot}{...}
{title:Options for symplot, quantile, and qqplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affect the rendition of the reference line;
see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang} {it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include
options for titling the graph (see {manhelpi title_options G-3}) and for
saving the graph to disk (see {manhelpi saving_option G-3}).


{marker options_qnorm}{...}
{title:Options for qnorm and pnorm}

{dlgtab:Main}

{phang}
{opt grid} adds grid lines at the 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, and
0.95 quantiles when specified with {cmd:qnorm}.  With {cmd:pnorm},
{opt grid} is equivalent to {cmd:yline(.25, .5, .75)} 
{cmd:xline(.25, .5, .75)}. 

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affect the rendition of the reference line;
see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab :Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include
options for titling the graph (see {manhelpi title_options G-3}) and for
saving the graph to disk (see {manhelpi saving_option G-3}).


{marker options_qchi}{...}
{title:Options for qchi and pchi}

{dlgtab:Main}

{phang}
{opt grid} adds grid lines at the 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, and
0.95 quantiles when specified with {cmd:qchi}.  With {cmd:pchi},
{opt grid} is equivalent to {cmd:yline(.25, .5, .75)} 
{cmd:xline(.25, .5, .75)}.

{phang}
{opt df(#)} specifies the degrees of freedom of the chi-squared distribution.
The default is {cmd:df(1)}.

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affect the rendition of the reference line;
see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab :Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include
options for titling the graph (see {manhelpi title_options G-3}) and for
saving the graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Symmetry plot of {cmd:price}{p_end}
{phang2}{cmd:. symplot price}{p_end}

{pstd}Ordered values of {cmd:price} against quantiles of uniform
distribution{p_end}
{phang2}{cmd:. quantile price}{p_end}

{pstd}Quantiles of {cmd:weightd} against quantiles of {cmd:weightf}{p_end}
{phang2}{cmd:. generate weightd=weight if !foreign}{p_end}
{phang2}{cmd:. generate weightf=weight if foreign}{p_end}
{phang2}{cmd:. qqplot weightd weightf}{p_end}

{pstd}Quantiles of {cmd:price} against quantiles of normal distribution{p_end}
{phang2}{cmd:. qnorm price}{p_end}
{phang2}{cmd:. qnorm price, grid}{space 2}(add a grid background){p_end}

{pstd}Standardized normal probability plot of {cmd:price}{p_end}
{phang2}{cmd:. pnorm price}{p_end}
{phang2}{cmd:. pnorm price, grid}{space 2}(add a grid background){p_end}

{pstd}Quantiles of {cmd:ch} against quantiles of chi-squared
distribution{p_end}
{phang2}{cmd:. egen c1 = std(price)}{p_end}
{phang2}{cmd:. egen c2 = std(mpg)}{p_end}
{phang2}{cmd:. generate ch = c1^2 + c2^2}{p_end}
{phang2}{cmd:. qchi ch, df(2) grid}

{pstd}Chi-squared probability plot{p_end}
{phang2}{cmd:. pchi ch, df(2) grid}{p_end}
