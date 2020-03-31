{smcl}
{* *! version 1.0.3  07jan2019}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] irtgraph iif" "mansection IRT irtgraphiif"}{...}
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
{vieweralsosee "[IRT] irtgraph tif" "help irtgraph tif"}{...}
{viewerjumpto "Syntax" "irtgraph iif##syntax"}{...}
{viewerjumpto "Menu" "irtgraph iif##menu_irt"}{...}
{viewerjumpto "Description" "irtgraph iif##description"}{...}
{viewerjumpto "Links to PDF documentation" "irtgraph_iif##linkspdf"}{...}
{viewerjumpto "Options" "irtgraph iif##options"}{...}
{viewerjumpto "Examples" "irtgraph iif##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[IRT] irtgraph iif} {hline 2}}Item information function plot{p_end}
{p2col:}({mansection IRT irtgraphiif:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 16 2}
{cmd:irtgraph iif}
	[{varlist}]
	[{cmd:,} {it:options}]


{phang}
Full syntax

{p 8 16 2}
{cmd:irtgraph iif}
	{cmd:(}[{it:#}{cmd::}] {varlist} [{cmd:,}
	{it:{help line_options}}]{cmd:)}
	{cmd:(}[{it:#}{cmd::}] {varlist} [{cmd:,} 
	{it:{help line_options}}]{cmd:)}
	[...]
	[{cmd:,} {it:options}]


{phang}
{it:varlist} is a list of items from the currently fitted IRT model.{p_end}
{phang}
{it:#}{cmd::} selects items in {varlist} for the specified group.{p_end}

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Plots}
{synopt: {opt ra:nge(# #)}}plot over theta = {it:#} to {it:#}{p_end}

{syntab:Line}
{synopt: {it:{help line_options}}}affect rendition of the plotted IIFs{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the IIF plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}

{syntab:Data}
{synopt :{opt n(#)}}evaluate IIFs at {it:#} points; default is {cmd:n(300)}{p_end}
{synopt :{cmd:data(}{it:filename}[{cmd:, replace}]{cmd:)}}save plot data to a file{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:line_options} in {cmd:(}{it:varlist}{cmd:,} {it:line_options}{cmd:)}
override the same options specified in {it:options}.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{opt irtgraph iif} plots item information functions (IIFs) for items in the
currently fitted IRT model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irtgraphiifQuickstart:Quick start}

        {mansection IRT irtgraphiifRemarksandexamples:Remarks and examples}

        {mansection IRT irtgraphiifMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Plots}

{phang}
{opt range(# #)}
	specifies the range of values for theta.  This option requires 
        a pair of numbers identifying the minimum and maximum.
        The default is {cmd:range(-4 4)}.

{dlgtab:Line}

{phang}
{it:line_options} affect the rendition of the plotted IIFs;
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
{opt n(#)} specifies the number of points at which the IIFs
are to be evaluated.  The default is {cmd:n(300)}.

{phang}
{cmd:data(}{it:filename}[{cmd:,} {cmd:replace}]{cmd:)} saves the plot data to
a Stata data file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}{p_end}
{phang2}{cmd:. irt 2pl q1-q9}

{pstd}Use the 2PL parameters to plot the IIF for all items in the model{p_end}
{phang2}{cmd:. irtgraph iif}

{pstd}Same as above, but add options to make the difficult item stand
out{p_end}
{phang2}{cmd:. irtgraph iif (q1-q4 q6-q9, lcolor(red) lpattern(dash))}
        {cmd:(q5, lcolor(black) lwidth(thick)), legend(off)}{p_end}
