{smcl}
{* *! version 1.0.3  07jan2019}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] irtgraph tcc" "mansection IRT irtgraphtcc"}{...}
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
{vieweralsosee "[IRT] irtgraph icc" "help irtgraph icc"}{...}
{viewerjumpto "Syntax" "irtgraph tcc##syntax"}{...}
{viewerjumpto "Menu" "irtgraph tcc##menu_irt"}{...}
{viewerjumpto "Description" "irtgraph tcc##description"}{...}
{viewerjumpto "Links to PDF documentation" "irtgraph_tcc##linkspdf"}{...}
{viewerjumpto "Options" "irtgraph tcc##options"}{...}
{viewerjumpto "Examples" "irtgraph tcc##examples"}{...}
{viewerjumpto "Stored results" "irtgraph tcc##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[IRT] irtgraph tcc} {hline 2}}Test characteristic curve plot{p_end}
{p2col:}({mansection IRT irtgraphtcc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:irtgraph tcc} [{cmd:,} {it:options}]

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Plots}
{synopt :{opt sc:orelines}{cmd:(}[{it:#}{cmd::}]{it:{help numlist}} [{cmd:,} {help irtgraph_tcc##refopts:{it:refopts}}]{cmd:)}}add x and y reference lines at each score value in {it:numlist}{p_end}
{synopt :{opt th:etalines}{cmd:(}[{it:#}{cmd::}]{it:{help numlist}} [{cmd:,} {help irtgraph_tcc##refopts:{it:refopts}}]{cmd:)}}add x and y reference lines at each theta value in {it:numlist}{p_end}
{synopt :{opt ra:nge(# #)}}plot over theta = {it:#} to {it:#}{p_end}

{syntab:Add plots}
{synopt :{opth addplot:(addplot_option:plot)}}add other plots to the TCC plot{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}

{syntab:Data}
{synopt :{opt n(#)}}evaluate curves at {it:#} points; default is {cmd:n(300)}{p_end}
{synopt :{cmd:data(}{it:filename}[{cmd:, replace}]{cmd:)}}save plot data to a file{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt scorelines()} and {opt thetaline()} can be specified multiple
times.{p_end}
{p 4 6 2}
{it:#}{cmd::} plots lines for the specified group; allowed only after a group
IRT model.

{marker refopts}{...}
{synoptset 33}{...}
{synopthdr:refopts}
{synoptline}
{synopt: {it:{help line_options}}}affect rendition of the plotted expected score and theta lines{p_end}
{synopt: {opt noxlines}}suppress the corresponding reference lines for theta values{p_end}
{synopt: {opt noylines}}suppress the corresponding reference lines for score values{p_end}
{synoptline}


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{opt irtgraph tcc} plots the test characteristic curve (TCC) for
the currently fitted IRT model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irtgraphtccQuickstart:Quick start}

        {mansection IRT irtgraphtccRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Plots}

{phang}
{cmd:scorelines(}[{it:#}{cmd::}]{it:{help numlist}} [{cmd:,} {it:refopts}]{cmd:)}
adds x and y reference lines at each score value in {it:numlist}.

{pmore}
For group IRT models, reference lines are plotted for all groups.
You can specify the optional {it:#}{cmd::} to restrict reference lines
to a specific group.

{phang}
{cmd:thetalines(}[{it:#}{cmd::}]{it:{help numlist}} {cmd:,} {it:refopts}]{cmd:)}
adds x and y reference lines at each theta value in {it:numlist}.

{pmore}
For group IRT models, reference lines are plotted for all groups.
You can specify the optional {it:#}{cmd::} to restrict reference lines
to a specific group.

{phang2}
{it:refopts} affect the rendering of expected score and theta
lines:

{phang3}
{it:line_options} specify how the expected score and theta lines
are rendered; see {manhelpi line_options G-3}.

{phang3}
{cmd:noxlines} suppresses the corresponding reference line for theta.

{phang3}
{cmd:noylines} suppresses the corresponding reference line for scores.

{phang}
{opt range(# #)}
	specifies the range of values for theta.  This option requires 
        a pair of numbers identifying the minimum and maximum.
        The default is {cmd:range(-4 4)}.

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
{opt n(#)} specifies the number of points at which the TCCs are
to be evaluated.  The default is {cmd:n(300)}.

{phang}
{cmd:data(}{it:filename}[{cmd:,} {cmd:replace}]{cmd:)} saves the plot data to a
Stata data file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}{p_end}
{phang2}{cmd:. irt 2pl q1-q9}

{pstd}Use the 2PL parameters to plot the test characteristic curves for all
items in the model{p_end}
{phang2}{cmd:. irtgraph tcc}

{pstd}Same as above, but plot the expected scores corresponding to the latent
trait level -3 to 3 in steps of 1{p_end}
{phang2}{cmd:. irtgraph tcc, thetalines(-3/3)}

{pstd}Same as above, but plot the specified latent trait values{p_end}
{phang2}{cmd:. irtgraph tcc, scorelines(2 4 6 7.5)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irtgraph tcc} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(xvals)}}values used to label the x axis{p_end}
{synopt:{cmd:r(yvals)}}values used to label the y axis{p_end}
{p2colreset}{...}
