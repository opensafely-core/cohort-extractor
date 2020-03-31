{smcl}
{* *! version 1.0.5  19oct2017}{...}
{viewerdialog acprplot "dialog acprplot"}{...}
{viewerdialog avplots "dialog avplot"}{...}
{viewerdialog cprplot "dialog cprplot"}{...}
{viewerdialog lvr2plot "dialog lvr2plot"}{...}
{viewerdialog rvfplot "dialog rvfplot"}{...}
{viewerdialog rvpplot "dialog rvpplot"}{...}
{vieweralsosee "[R] regress postestimation diagnostic plots" "mansection R regresspostestimationdiagnosticplots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] regress postestimation" "help regress postestimation"}{...}
{vieweralsosee "[R] regress postestimation ts" "help regress postestimation ts"}{...}
{viewerjumpto "Description" "regress postestimation plots##description"}{...}
{viewerjumpto "Links to PDF documentation" "regress_postestimation_plots##linkspdf"}{...}
{viewerjumpto "rvfplot" "regress postestimation plots##syntax_rvfplot"}{...}
{viewerjumpto "avplot" "regress postestimation plots##syntax_avplot"}{...}
{viewerjumpto "avplots" "regress postestimation plots##syntax_avplots"}{...}
{viewerjumpto "cprplot" "regress postestimation plots##syntax_cprplot"}{...}
{viewerjumpto "acprplot" "regress postestimation plots##syntax_acprplot"}{...}
{viewerjumpto "rvpplot" "regress postestimation plots##syntax_rvpplot"}{...}
{viewerjumpto "lvr2plot" "regress postestimation plots##syntax_lvr2plot"}{...}
{viewerjumpto "Examples" "regress postestimation plots##examples"}{...}
{viewerjumpto "Reference" "regress postestimation plots##reference"}{...}
{p2colset 1 48 50 2}{...}
{p2col:{bf:[R] regress postestimation diagnostic plots} {hline 2}}Postestimation plots
for regress{p_end}
{p2col:}({mansection R regresspostestimationdiagnosticplots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are of special interest after {cmd:regress}: 

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb regress postestimation plots##rvfplot:rvfplot}}residual-versus-fitted plot{p_end}
{synopt :{helpb regress postestimation plots##avplot:avplot}}added-variable plot{p_end}
{synopt :{helpb regress postestimation plots##avplots:avplots}}all added-variable plots in one image{p_end}
{synopt :{helpb regress postestimation plots##cprplot:cprplot}}component-plus-residual plot{p_end}
{synopt :{helpb regress postestimation plots##acprplot:acprplot}}augmented component-plus-residual plot{p_end}
{synopt :{helpb regress postestimation plots##rvpplot:rvpplot}}residual-versus-predictor plot{p_end}
{synopt :{helpb regress postestimation plots##lvr2plot:lvr2plot}}leverage-versus-squared-residual plot{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These commands are not appropriate after the {cmd:svy} prefix.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R regresspostestimationdiagnosticplotsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker rvfplot}{...}
{marker syntax_rvfplot}{...}
{title:Syntax for rvfplot}

{p 8 19 2}
{cmd:rvfplot} 
[{cmd:,} {it:rvfplot_options}]

{synoptset 23 tabbed}{...}
{synopthdr:rvfplot_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()}
 documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for rvfplot}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
        {bf:Residual-versus-fitted plot}


{title:Description for rvfplot}

{pstd}
{opt rvfplot} graphs a residual-versus-fitted plot, a graph of the residuals
against the fitted values.


{title:Options for rvfplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add plots to the generated graph.  
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker avplot}{...}
{marker syntax_avplot}{...}
{title:Syntax for avplot}

{p 8 18 2}
{cmd:avplot} {it:{help indepvars:indepvar}} [{cmd:,} {it:avplot_options}]

{synoptset 25 tabbed}{...}
{synopthdr:avplot_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference line
{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()}
  documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for avplot}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
      {bf:Added-variable plot}


{title:Description for avplot}

{pstd}
{opt avplot} graphs an added-variable plot (a.k.a. partial-regression leverage
plot, partial regression plot, or adjusted partial residual plot) after
{cmd:regress}.  {it:indepvar} may be an independent variable (a.k.a.
predictor, carrier, or covariate) that is currently in the model or not.


{title:Options for avplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line.  See 
{manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph.
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options
for titling the graph (see {manhelpi title_options G-3}) and for saving
the graph to disk (see {manhelpi saving_option G-3}).


{marker avplots}{...}
{marker syntax_avplots}{...}
{title:Syntax for avplots}

{p 8 18 2}
{cmd:avplots} [{cmd:,} {it:avplots_options}]

{synoptset 25 tabbed}{...}
{synopthdr:avplots_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt
{synopt :{it:combine_options}}any of the options
documented in {manhelp graph_combine G-2:graph combine}{p_end}

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()}
  documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for avplots}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
         {bf:Added-variable plot}


{title:Description for avplots}

{pstd}
{opt avplots} graphs all the added-variable plots in one image.


{title:Options for avplots}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{phang}
{it:combine_options} are any of the options documented in 
{helpb graph combine:[G-2] graph combine}.  These include options for titling
the graph (see {manhelpi title_options G-3}) and for saving the graph to disk
(see {manhelpi saving_option G-3}).

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line.  See 
{manhelpi cline_options G-3}.  

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options
for titling the graph (see {manhelpi title_options G-3}) and for saving
the graph to disk (see {manhelpi saving_option G-3}).


{marker cprplot}{...}
{marker syntax_cprplot}{...}
{title:Syntax for cprplot}

{p 8 18 2}
{cmd:cprplot} {it:{help indepvars:indepvar}} 
[{cmd:,} {it:cprplot_options}]

{synoptset 27 tabbed}{...}
{synopthdr:cprplot_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference 
line{p_end}

{syntab:Options}
{synopt :{opt low:ess}}add a lowess smooth of the plotted points{p_end}
{synopt :{opth lsop:ts(lowess:lowess_options)}}affect rendition of the lowess smooth
{p_end}
{synopt :{opt msp:line}}add median spline of the plotted points{p_end}
{synopt :{opth msop:ts(twoway_mspline:mspline_option)}}affect rendition of the spline{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
{manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for cprplot}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
        {bf:Component-plus-residual plot}


{title:Description for cprplot}

{pstd}
{opt cprplot} graphs a component-plus-residual plot (a.k.a. partial residual
plot) after {cmd:regress}.  {it:indepvar} must be an independent variable that
is currently in the model. 


{title:Options for cprplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line.  
See {manhelpi cline_options G-3}.

{dlgtab:Options}

{phang}
{opt lowess} adds a lowess smooth of the plotted points to assist in
detecting nonlinearities.

{phang}
{opt lsopts(lowess_options)} affects the rendition of the lowess smooth.  For
an explanation of these options, especially the {opt bwidth()} option, see
{manhelp lowess R}.  Specifying {opt lsopts()} implies the {opt lowess} option.

{phang}
{opt mspline} adds a median spline of the plotted points to assist in
detecting nonlinearities.

{phang}
{opt msopts(mspline_options)} affects the rendition of the spline.  For an
explanation of these options, especially the {opt bands()} option, see 
{manhelp twoway_mspline G-2:graph twoway mspline}.  Specifying {opt msopts()}
implies the {opt mspline} option.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph.  
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving 
the graph to disk (see {manhelpi saving_option G-3}).


{marker acprplot}{...}
{marker syntax_acprplot}{...}
{title:Syntax for acprplot}

{p 8 19 2}
{cmd:acprplot} {it:{help indepvars:indepvar}} [{cmd:,} {it:acprplot_options}]

{synoptset 27 tabbed}{...}
{synopthdr:acprplot_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt

{syntab:Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab:Options}
{synopt :{opt low:ess}}add a lowess smooth of the plotted points{p_end}
{synopt :{opth lsop:ts(lowess:lowess_options)}}affect rendition of the lowess
smooth{p_end}
{synopt :{opt msp:line}}add median spline of the plotted points{p_end}
{synopt :{opth msop:ts(twoway_mspline:mspline_options)}}affect rendition of the spline{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()}
  documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for acprplot}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
    {bf:Augmented component-plus-residual plot}


{title:Description for acprplot}

{pstd}
{opt acprplot} graphs an augmented component-plus-residual plot (a.k.a.
augmented partial residual plot) as described by 
{help regress postestimation##M1986:Mallows (1986)}.  This seems
to work better than the component-plus-residual plot for identifying
nonlinearities in the data.


{title:Options for acprplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line.
See {manhelpi cline_options G-3}.

{dlgtab:Options}

{phang}
{opt lowess} adds a lowess smooth of the plotted points to assist in
detecting nonlinearities.

{phang}
{opt lsopts(lowess_options)} affects the rendition of the lowess smooth.  For
an explanation of these options, especially the {opt bwidth()} option, see
{manhelp lowess R}.  Specifying {opt lsopts()} implies the {opt lowess} option.

{phang}
{opt mspline} adds a median spline of the plotted points to assist in
detecting nonlinearities.

{phang}
{opt msopts(mspline_options)} affects the rendition of the spline.  For an
explanation of these options, especially the {opt bands()} option, see 
{manhelp twoway_mspline G-2:graph twoway mspline}.  Specifying {opt msopts()}
implies the {opt mspline} option.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph.
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).


{marker rvpplot}{...}
{marker syntax_rvpplot}{...}
{title:Syntax for rvpplot}

{p 8 19 2}
{cmd:rvpplot} {it:{help indepvars:indepvar}}
[{cmd:,} {it:rvpplot_options}]

{synoptset 23 tabbed}{...}
{synopthdr:rvpplot_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()}
 documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for rvpplot}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
         {bf:Residual-versus-predictor plot}


{title:Description for rvpplot}

{pstd}
{opt rvpplot} graphs a residual-versus-predictor plot (a.k.a. independent
variable plot or carrier plot), a graph of the residuals against the specified
predictor.


{title:Options for rvpplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add plots to the generated graph.
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker lvr2plot}{...}
{marker syntax_lvr2plot}{...}
{title:Syntax for lvr2plot}

{p 8 20 2}
{cmd:lvr2plot} 
[{cmd:,} {it:lvr2plot_options}]

{synoptset 24 tabbed}{...}
{synopthdr:lvr2plot_options}
{synoptline}
{syntab:Plot}
INCLUDE help gr_markopt

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()}
   documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu for lvr2plot}

{phang}
{bf:Statistics > Linear models and related > Regression diagnostics >}
        {bf:Leverage-versus-squared-residual plot}


{title:Description for lvr2plot}

{pstd}
{opt lvr2plot} graphs a leverage-versus-squared-residual plot (a.k.a. L-R
plot).


{title:Options for lvr2plot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph.
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price weight foreign##c.mpg}{p_end}

{pstd}Residual-versus-fitted plot{p_end}
{phang2}{cmd:. rvfplot, yline(10)}{p_end}

{pstd}Added-variable plot{p_end}
{phang2}{cmd:. avplot mpg}{p_end}

{pstd}Added-variable plots for every regressor{p_end}
{phang2}{cmd:. avplots}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse auto1}{p_end}
{phang2}{cmd:. regress price mpg weight}{p_end}

{pstd}Component-plus-residual plot{p_end}
{phang2}{cmd:. cprplot mpg, mspline msopts(bands(13))}{p_end}

{pstd}Augmented component-plus-residual plot{p_end}
{phang2}{cmd:. acprplot mpg, mspline msopts(bands(13))}{p_end}

{pstd}Residual-versus-predictor plot{p_end}
{phang2}{cmd:. rvpplot mpg, yline(0)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price weight foreign##c.mpg}{p_end}

{pstd}Leverage-versus-residual-squared plot{p_end}
{phang2}{cmd:. lvr2plot}{p_end}

{pstd}Standardized residuals{p_end}
{phang2}{cmd:. predict esta if e(sample), rstandard}{p_end}

{pstd}Studentized residuals{p_end}
{phang2}{cmd:. predict estu if e(sample), rstudent}{p_end}

    {hline}


{marker reference}{...}
{title:Reference}

{marker M1986}{...}
{phang}
Mallows, C. L. 1986. Augmented partial residuals. {it:Technometrics} 28:
313-319.
{p_end}
