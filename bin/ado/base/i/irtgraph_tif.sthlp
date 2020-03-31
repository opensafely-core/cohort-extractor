{smcl}
{* *! version 1.0.2  19oct2017}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] irtgraph tif" "mansection IRT irtgraphtif"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt 1pl" "help irt 1pl"}{...}
{vieweralsosee "[IRT] irt 2pl" "help irt 2pl"}{...}
{vieweralsosee "[IRT] irt 3pl" "help irt 3pl"}{...}
{vieweralsosee "[IRT] irt grm" "help irt grm"}{...}
{vieweralsosee "[IRT] irt hybrid" "help irt hybrid"}{...}
{vieweralsosee "[IRT] irt nrm" "help irt nrm"}{...}
{vieweralsosee "[IRT] irt pcm" "help irt pcm"}{...}
{vieweralsosee "[IRT] irt rsm" "help irt rsm"}{...}
{vieweralsosee "[IRT] irtgraph iif" "help irtgraph iif"}{...}
{viewerjumpto "Syntax" "irtgraph tif##syntax"}{...}
{viewerjumpto "Menu" "irtgraph tif##menu_irt"}{...}
{viewerjumpto "Description" "irtgraph tif##description"}{...}
{viewerjumpto "Links to PDF documentation" "irtgraph_tif##linkspdf"}{...}
{viewerjumpto "Options" "irtgraph tif##options"}{...}
{viewerjumpto "Examples" "irtgraph tif##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[IRT] irtgraph tif} {hline 2}}Test information function plot{p_end}
{p2col:}({mansection IRT irtgraphtif:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:irtgraph tif} [{cmd:,} {it:options}]

{synoptset 33 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Plots}
{synopt :{opt se}[{cmd:(}{it:{help line_options}}{cmd:)}]}plot the standard error of the TIF{p_end}
{synopt :{opt ra:nge(# #)}}plot over theta = {it:#} to {it:#}{p_end}

{syntab:Line}
{synopt :{it:{help line_options}}}affect rendition of the plotted TIF{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the TIF plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}

{syntab:Data}
{synopt :{opt n(#)}}evaluate TIF at {it:#} points; default is {cmd:n(300)}{p_end}
{synopt :{cmd:data(}{it:filename}[{cmd:, replace}]{cmd:)}}save plot data to a file{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{opt irtgraph tif} plots the test information function (TIF) for
the currently fitted IRT model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irtgraphtifQuickstart:Quick start}

        {mansection IRT irtgraphtifRemarksandexamples:Remarks and examples}

        {mansection IRT irtgraphtifMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Plots}

{phang}
{opt se}[{cmd:(}{it:{help line_options}}{cmd:)}]
requests the standard error of the TIF be plotted.
The optional {it:line_options} specify how the lines are rendered;
see {manhelpi line_options G-3}.

{phang}
{opt range(# #)}
	specifies the range of values for theta.  This option requires 
        a pair of numbers identifying the minimum and maximum.
        The default is {cmd:range(-4 4)}.

{dlgtab:Line}

{phang}
{it:line_options} affect rendition of the plotted TIF; 
see {manhelpi line_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} allows adding more {cmd:graph} {cmd:twoway}
plots to the graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}.
These include options for titling the graph (see {manhelpi title_options G-3})
and for saving the graph to disk (see {manhelpi saving_option G-3}).

{dlgtab:Data}

{phang}
{opt n(#)} specifies the number of points at which the plotted lines are
to be evaluated.  The default is {cmd:n(300)}.

{phang}
{cmd:data(}{it:filename}[{cmd:,} {cmd:replace}]{cmd:)} saves the plot data to
a Stata data file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}{p_end}
{phang2}{cmd:. irt 2pl q1-q9}

{pstd}Use the 2PL parameters to plot the TIF for all items in the model{p_end}
{phang2}{cmd:. irtgraph tif}

{pstd}Same as above, but also plot the standard error of the TIF{p_end}
{phang2}{cmd:. irtgraph tif, se}{p_end}
