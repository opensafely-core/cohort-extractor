{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway pcscatter" "mansection G-2 graphtwowaypcscatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway pcarrow" "help twoway_pcarrow"}{...}
{vieweralsosee "[G-2] graph twoway pccapsym" "help twoway_pccapsym"}{...}
{vieweralsosee "[G-2] graph twoway pci" "help twoway_pci"}{...}
{vieweralsosee "[G-2] graph twoway pcspike" "help twoway_pcspike"}{...}
{viewerjumpto "Syntax" "twoway_pcscatter##syntax"}{...}
{viewerjumpto "Menu" "twoway_pcscatter##menu"}{...}
{viewerjumpto "Description" "twoway_pcscatter##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_pcscatter##linkspdf"}{...}
{viewerjumpto "Options" "twoway_pcscatter##options"}{...}
{viewerjumpto "Remarks" "twoway_pcscatter##remarks"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[G-2] graph twoway pcscatter} {hline 2}}Paired-coordinate plot 
	with markers{p_end}
{p2col:}({mansection G-2 graphtwowaypcscatter:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:pcscatter}
{it:y1var} {it:x1var} {it:y2var} {it:x2var}
{ifin}
[{cmd:,}
{it:options}]


{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
INCLUDE help gr_markopt
INCLUDE help gr_headlabopt

INCLUDE help gr_hvpcopt
INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p 4 6 2}
All explicit options are {it:unique}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway pcscatter} draws markers for each point designated by 
({it:y1var}, {it:x1var}) and for each point designated by 
({it:y2var}, {it:x2var}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaypcscatterQuickstart:Quick start}

        {mansection G-2 graphtwowaypcscatterRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:marker_options}
    specify how the markers look, including
    shape, size, color, and outline;
    see {manhelpi marker_options G-3}.  The same marker is used for both sets of
    points.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

INCLUDE help gr_headlaboptf

INCLUDE help gr_hvpcoptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Visually, there is no difference between

	{cmd:. twoway pcscatter} {it:y1var} {it:x1var} {it:y2var} {it:x2var}

{pstd}
and

	{cmd:. twoway scatter} {it:y1var} {it:x1var} {cmd:||} {...}
{cmd:scatter} {it:y2var} {it:x2var}{cmd:, pstyle(p1)}

{pstd}
though in some cases the former is more convenient and better represents the
conceptual structure of the data.

{pstd}
The two scatters are presented in the same overall style,
meaning that the markers (symbol shape and color)
are the same.
{p_end}
