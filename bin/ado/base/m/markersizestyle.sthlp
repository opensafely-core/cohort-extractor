{smcl}
{* *! version 1.1.8  16apr2019}{...}
{vieweralsosee "[G-4] markersizestyle" "mansection G-4 markersizestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_options" "help marker_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] markerstyle" "help markerstyle"}{...}
{vieweralsosee "[G-4] symbolstyle" "help symbolstyle"}{...}
{viewerjumpto "Syntax" "markersizestyle##syntax"}{...}
{viewerjumpto "Description" "markersizestyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "markersizestyle##linkspdf"}{...}
{viewerjumpto "Remarks" "markersizestyle##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[G-4]} {it:markersizestyle} {hline 2}}Choices for the size of markers{p_end}
{p2col:}({mansection G-4 markersizestyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:markersizestyle}}Description{p_end}
{p2line}
{p2col:{cmd:vtiny}}the smallest{p_end}
{p2col:{cmd:tiny}}{p_end}
{p2col:{cmd:vsmall}}{p_end}
{p2col:{cmd:small}}{p_end}
{p2col:{cmd:medsmall}}{p_end}
{p2col:{cmd:medium}}{p_end}
{p2col:{cmd:medlarge}}{p_end}
{p2col:{cmd:large}}{p_end}
{p2col:{cmd:vlarge}}{p_end}
{p2col:{cmd:huge}}{p_end}
{p2col:{cmd:vhuge}}{p_end}
{p2col:{cmd:ehuge}}the largest{p_end}

{p2col:{it:{help size}}}any size you want, including size modification{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:markersizestyles} may be available; type

	    {cmd:.} {bf:{stata graph query markersizestyle}}

{pstd}
to obtain the complete list of {it:markersizestyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Markers are the ink used to mark where points are on a plot; see 
{manhelpi marker_options G-3}.  {it:markersizestyle} specifies the size of the
markers.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 markersizestyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:markersizestyle} is specified inside the
{cmd:msize()} option:

{phang2}
	{cmd:. graph} ...{cmd:, msize(}{it:markersizestyle}{cmd:)} ...

{pstd}
Sometimes you will see that a {it:markersizestylelist} is allowed:

{phang2}
	{cmd:. scatter} ...{cmd:, msymbol(}{it:markersizestylelist}{cmd:)} ...

{pstd}
A {it:markersizestylelist} is a sequence of {it:markersizestyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.
{p_end}
