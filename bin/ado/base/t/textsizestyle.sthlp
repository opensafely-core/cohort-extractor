{smcl}
{* *! version 1.1.8  16apr2019}{...}
{vieweralsosee "[G-4] textsizestyle" "mansection G-4 textsizestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_label_options" "help marker_label_options"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{vieweralsosee "[G-4] text" "help text"}{...}
{viewerjumpto "Syntax" "textsizestyle##syntax"}{...}
{viewerjumpto "Description" "textsizestyle##description"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-4]} {it:textsizestyle} {hline 2}}Choices for the size of text{p_end}
{p2col:}({mansection G-4 textsizestyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:textsizestyle}}Description{p_end}
{p2line}
{p2col:{cmd:zero}}no size whatsoever, vanishingly small{p_end}

{p2col:{cmd:minuscule}}smallest{p_end}
{p2col:{cmd:quarter_tiny}}{p_end}
{p2col:{cmd:third_tiny}}{p_end}
{p2col:{cmd:half_tiny}}{p_end}
{p2col:{cmd:tiny }}{p_end}
{p2col:{cmd:vsmall}}{p_end}
{p2col:{cmd:small}}{p_end}
{p2col:{cmd:medsmall}}{p_end}
{p2col:{cmd:medium}}{p_end}
{p2col:{cmd:medlarge}}{p_end}
{p2col:{cmd:large}}{p_end}
{p2col:{cmd:vlarge}}{p_end}
{p2col:{cmd:huge}}{p_end}
{p2col:{cmd:vhuge}}largest{p_end}

{p2col:{cmd:tenth}}one-tenth the size of the graph{p_end}
{p2col:{cmd:quarter}}one-fourth the size of the graph{p_end}
{p2col:{cmd:third}}one-third the size of the graph{p_end}
{p2col:{cmd:half}}one-half the size of the graph{p_end}
{p2col:{cmd:full}}text the size of the graph{p_end}

{p2col:{it:{help size}}}any size you want{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:textsizestyles} may be available; type

	    {cmd:.} {bf:{stata graph query textsizestyle}}

{pstd}
to obtain the complete list of {it:textsizestyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:textsizestyle} specifies the size of the text.

{pstd}
{it:textsizestyle} is specified inside options such as the {cmd:size()}
suboption of {cmd:title()} (see {manhelpi title_options G-3}):

{phang2}
	{cmd:. graph} ...{cmd:, title("My title", size(}{it:textsizestyle}{cmd:))} ...

{pstd}
Also see {manhelpi textbox_options G-3} for information on other
characteristics of text.
{p_end}
