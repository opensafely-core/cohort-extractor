{* *! version 1.0.7  14apr2011}{...}
{p 8 27 2}{cmd:cluster} {cmdab:dend:rogram} [{it:clname}] {ifin}
	[{cmd:,} {it:options} ]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt:{opt quick}}do not center parent branches{p_end}
{synopt:{opth la:bels(varname)}}name of variable containing leaf labels{p_end}
{synopt:{opt cutn:umber(#)}}display top # branches only{p_end}
{synopt:{opt cutv:alue(#)}}display branches above # (dis)similarity measure
only{p_end}
{synopt:{opt show:count}}display number of observations for each branch{p_end}
{synopt:{opth countp:refix(strings:string)}}prefix the branch count with {it:string};
default is ``n=''{p_end}
{synopt:{opth counts:uffix(strings:string)}}suffix the branch count with {it:string};
default is empty string{p_end}
{synopt:{opt counti:nline}}put branch count in line with branch label{p_end}
{synopt:{opt vert:ical}}orient dendrogram vertically (default){p_end}
{synopt:{opt hor:izontal}}orient dendrogram horizontally{p_end}

{syntab :Plot}
{synopt :{it:{help line_options}}}affect rendition of the plotted
lines{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the
dendrogram{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any option other than {opt by()}
documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
Note: {cmd:cluster} {cmdab:tr:ee} is a synonym for
{cmd:cluster} {cmd:dendrogram}.

{pstd}
In addition to the restrictions imposed by {cmd:if} and {cmd:in}, the
observations are automatically restricted to those that were used in the
cluster analysis.
{p_end}
