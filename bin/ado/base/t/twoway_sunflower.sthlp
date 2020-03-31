{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[R] sunflower" "help sunflower"}{...}
{viewerjumpto "Syntax" "twoway_sunflower##syntax"}{...}
{viewerjumpto "Description" "twoway_sunflower##description"}{...}
{viewerjumpto "Options" "twoway_sunflower##options"}{...}
{title:Title}

{p 4 30 2}
{hi:[G-2] twoway sunflower} {hline 2} Density-distribution sunflower plots 


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}
{cmdab:tw:oway}
{cmd:sunflower} {it:yvar} {it:xvar}
	[{it:weight}] 
	[{cmd:if} {it:exp}] 
	[{cmd:in} {it:range}] [, 
		{it:{help sunflower:sunflower_options}}
		{it:{help scatter:scatter_options}} 
		{it:{help twoway_options}}]
 

{pstd}
{cmd:fweight}s, are allowed; see {help weights}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:sunflower} is a special type of {cmd:twoway} graph.  We
recommend the {cmd:sunflower} command over {cmd:twoway} {cmd:sunflower}; see
{manhelp sunflower R}.


{marker options}{...}
{title:Options}
 
{phang}
{it:sunflower_options} affect the rendition of the sunflowers and bins; see
{manhelp sunflower R}.

{phang}
{it:scatter_options} affect the rendition of the plotted points; see
{manhelp scatter G-2:graph twoway scatter}.

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}.  These include options for titling the graph
(see {manhelpi title_options G-3}), options for saving the graph to disk
(see {manhelpi saving_option G-3}), and the {cmd:by()} option (see
{manhelpi by_option G-3}).
{p_end}
