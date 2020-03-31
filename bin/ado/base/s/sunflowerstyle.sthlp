{smcl}
{* *! version 1.0.8  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] sunflower" "help sunflower"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] areastyle" "help areastyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] markerstyle" "help markerstyle"}{...}
{viewerjumpto "Syntax" "sunflowerstyle##syntax"}{...}
{viewerjumpto "Description" "sunflowerstyle##description"}{...}
{title:Title}

{p2colset 5 29 31 2}{...}
{p2col :{hi:[G-4] {it:sunflowerstyle}} {hline 2}}Choices for overall look of
plot{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:sunflowerstyle}{col 30}Description
	{hline 57}
	{cmd:p1} - {cmd:p15}{...}
{col 30}used by first plot, second plot, ...
	{hline 57}

{p 8 8 2}
Other {it:sunflowerstyles} may be available; type

	    {cmd:.} {bf:{stata graph query sunflowerstyle}}

{p 8 8 2}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{p 4 4 2}
A {it:sunflowerstyle} -- always specified inside option
{cmd:pstyle(}{it:sunflowerstyle}{cmd:)} -- specifies the overall style
of a density-distribution sunflower plot and is
a composite of {it:{help pstyle}}, and multiple {it:{help linestyle}}s and
{it:{help areastyle}}s.
{p_end}
