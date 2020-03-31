{smcl}
{* *! version 1.0.4  07jan2019}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] irtgraph icc" "mansection IRT irtgraphicc"}{...}
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
{vieweralsosee "[IRT] irtgraph tcc" "help irtgraph tcc"}{...}
{viewerjumpto "Syntax" "irtgraph icc##syntax"}{...}
{viewerjumpto "Menu" "irtgraph icc##menu_irt"}{...}
{viewerjumpto "Description" "irtgraph icc##description"}{...}
{viewerjumpto "Links to PDF documentation" "irtgraph_icc##linkspdf"}{...}
{viewerjumpto "Options" "irtgraph icc##options"}{...}
{viewerjumpto "Examples" "irtgraph icc##examples"}{...}
{viewerjumpto "Stored results" "irtgraph icc##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[IRT] irtgraph icc} {hline 2}}Item characteristic curve plot{p_end}
{p2col:}({mansection IRT irtgraphicc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 16 2}
{cmd:irtgraph icc}
	[{varlist}]
	[{cmd:,} {it:options}]


{phang}
Full syntax

{p 8 16 2}
{cmd:irtgraph icc}
	{cmd:(}[{it:#}{cmd::}] {varlist} [{cmd:,}
	{help irtgraph_icc##plot_options:{it:plot_options}}]{cmd:)}
	{cmd:(}[{it:#}{cmd::}] {varlist} [{cmd:,} 
	{help irtgraph_icc##plot_options:{it:plot_options}}]{cmd:)}
	[...]
	[{cmd:,} {it:options}]


{phang}
{it:varlist} is a list of items from the currently fitted IRT model.{p_end}
{phang}
{it:#}{cmd::} plots curves for the specified group; allowed only after a group
IRT model.

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Plots}
{synopt:{cmdab:blo:cation}[{cmd:(}{help line_options:{it:line_options}}{cmd:)}]}add vertical lines for
estimated item difficulties{p_end}
{synopt:{cmdab:plo:cation}[{cmd:(}{help line_options:{it:line_options}}{cmd:)}]}add horizontal lines for
midpoint probabilities{p_end}
{synopt: {opt bcc}}plot boundary characteristic curves for categorical
items{p_end}
{synopt :{opt ccc}}plot category characteristic curves{p_end}
{synopt: {opt ra:nge(# #)}}plot over theta = {it:#} to {it:#}{p_end}

{syntab:Line}
{synopt: {it:{help line_options}}}affect rendition of the plotted curves{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the ICC plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}

{syntab:Data}
{synopt :{opt n(#)}}evaluate curves at {it:#} points; default is {cmd:n(300)}{p_end}
{synopt :{cmd:data(}{it:filename}[{cmd:, replace}]{cmd:)}}save plot data to a file{p_end}
{synoptline}
{p2colreset}{...}

{marker plot_options}{...}
{synoptset 27 }{...}
{synopthdr:plot_options}
{synoptline}
{synopt :{opt blo:cation}[{cmd:(}{it:{help line_options}}{cmd:)}]}add vertical
lines for estimated item difficulties{p_end}
{synopt :{opt plo:cation}[{cmd:(}{it:{help line_options}}{cmd:)}]}add
horizontal lines for midpoint probabilities{p_end}
{synopt :{opt bcc}}plot boundary characteristic curves for categorical
items{p_end}
{synopt :{opt ccc}}plot category characteristic curves{p_end}
{synopt: {it:{help line_options}}}affect rendition of the plotted curves{p_end}
{synoptline}

{p 4 6 2}
{it:varlist} may use factor-variable notation; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:line_options} in {it:plot_options}
override the same options specified in {it:options}.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{opt irtgraph icc} plots item characteristic curves (ICCs) for
binary items and category characteristic curves (CCCs) for categorical
items for the currently fitted IRT model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irtgraphiccQuickstart:Quick start}

        {mansection IRT irtgraphiccRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Plots}

{phang}
{cmd:blocation}[{cmd:(}{it:{help line_options}}{cmd:)}]
specifies that for each ICC, a vertical line be drawn from the
estimated difficulty parameter on the x axis to the curve.
The optional {it:line_options} specify how the vertical lines are
rendered; see {manhelpi line_options G-3}.
This option implies option {opt bcc}.

{phang}
{cmd:plocation}[{cmd:(}{it:{help line_options}}{cmd:)}]
specifies that for each ICC, a horizontal line be drawn from the
midpoint probability on the y axis to the curve.
The optional {it:line_options} specify how the horizontal lines are
rendered; see {manhelpi line_options G-3}.
This option implies option {opt bcc}.

{phang}
{opt bcc} specifies that boundary characteristic curves (BCCs) be plotted
for categorical items.
The ICCs for the individual item categories are plotted by default.
This option has no effect on binary items.

{phang}
{opt ccc} specifies that category characteristic curves (CCCs) be plotted
for all items.
This is the default behavior for categorical items.
For binary items, this option will plot ICCs for both outcomes.

{phang}
{opt range(# #)}
	specifies the range of values for theta.  This option requires 
        a pair of numbers identifying the minimum and maximum.
        The default is {cmd:range(-4 4)}
        unless the estimated difficulty parameters exceed these values,
        in which case the range is extended.

{dlgtab:Line}

{phang}
{it:line_options} affect the rendition of the plotted ICCs;
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
{opt n(#)} specifies the number of points at which the ICCs,
CCCs, and BCCs are to be evaluated.  The default is {cmd:n(300)}.

{phang}
{cmd:data(}{it:filename}[{cmd:,} {cmd:replace}]{cmd:)} saves the plot data to a
Stata data file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}

{pstd}Fit a 1PL model to binary items {cmd:q1-q9}{p_end}
{phang2}{cmd:. irt 1pl q1-q9}

{pstd}Replay the table of estimated IRT parameters, sorting the output by
parameter instead of by item and in ascending order of difficulty{p_end}
{phang2}{cmd:. estat report, byparm sort(b)}

{pstd}Use the 1PL parameters to plot the item characteristic curves for all
items in the model{p_end}
{phang2}{cmd:. irtgraph icc}

{pstd}Same as above, but plot only specified items and shrink the legend and
move it inside the plot region{p_end}
{phang2}{cmd:. irtgraph icc q8 q3 q9 q1 q2 q4 q6 q7 q5,}
         {cmd:legend(pos(4) col(1) ring(0) size(small))}

{pstd}Use the 1PL parameters to plot the item characteristic curves, placing
the highest and lowest difficulty items in a one plotting group with
their difficulty locations plotted and the remaining items in another plotting
group{p_end}
{phang2}{cmd:. irtgraph icc (q5 q8, blocation) (q1-q4 q6 q7 q9), legend(off)}

{pstd}Same as above, but let's add options to make items {cmd:q5} and {cmd:q8}
stand out{p_end}
{phang2}{cmd:. irtgraph icc (q8 q5, lcolor(black) lwidth(thick)}
       {cmd:bloc(lcolor(black))) (q1-q4 q6 q7 q9, lpattern(dash)),}
       {cmd:range(-5 5) xlabel(-5 -2.41 0 1.65 5) legend(off) lcolor(red)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irtgraph icc} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:r(xvals)}}values used to label the x axis{p_end}
{synopt :{cmd:r(yvals)}}values used to label the y axis{p_end}
{p2colreset}{...}
