{smcl}
{* *! version 1.2.2  19oct2017}{...}
{vieweralsosee "[G-2] palette" "mansection G-2 palette"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[G-2] graph query" "help graph_query"}{...}
{viewerjumpto "Syntax" "palette##syntax"}{...}
{viewerjumpto "Description" "palette##description"}{...}
{viewerjumpto "Links to PDF documentation" "palette##linkspdf"}{...}
{viewerjumpto "Options" "palette##options"}{...}
{viewerjumpto "Remarks" "palette##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[G-2] palette} {hline 2}}Display palettes of available selections{p_end}
{p2col:}({mansection G-2 palette:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:palette}
{cmd:color}
{it:{help colorstyle}}
[{it:{help colorstyle}}]
[{cmd:,}
{helpb scheme_option:{ul:sch}eme({it:schemename})}
{cmd:cmyk}]

{p 8 16 2}
{cmd:palette}
{cmdab:line:palette}
[{cmd:,}
{helpb scheme_option:{ul:sch}eme({it:schemename})}]

{p 8 16 2}
{cmd:palette}
{cmdab:symbol:palette}
[{cmd:,}
{helpb scheme_option:{ul:sch}eme({it:schemename})}]

{p 8 16 2}
{cmd:palette}
{cmdab:smcl:symbolpalette}
[{cmd:,}
{helpb scheme_option:{ul:sch}eme({it:schemename})}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:palette} produces graphs showing various selections available.

{pstd}
{cmd:palette} {cmd:color} shows how a particular color looks and allows
you to compare two colors; see {manhelpi colorstyle G-4}.

{pstd}
{cmd:palette} {cmd:linepalette} shows you the different
{it:linepatternstyles}; see {manhelpi linepatternstyle G-4}.

{pstd}
{cmd:palette} {cmd:symbolpalette} shows you the different
{it:symbolstyles}; see {manhelpi symbolstyle G-4}.

{pstd}
{cmd:palette} {cmd:smclsymbolpalette} shows you how Greek letters and other
symbols will render in the Graph window along with the SMCL name of each
symbol; see {manhelpi graph_text G-4:text}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 paletteQuickstart:Quick start}

        {mansection G-2 paletteRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:scheme(}{it:schemename}{cmd:)}
     specifies the scheme to be used to draw the graph.  With this command,
     {cmd:scheme()} is rarely specified.
     We recommend specifying {cmd:scheme(color)} if you plan to print the
     graph on a color printer; see {manhelpi scheme_option G-3}.

{phang}
{cmd:cmyk} specifies that the color value be reported in CMYK rather than in 
RGB; see {manhelpi colorstyle G-4}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:palette} command is more a part of the documentation of {cmd:graph}
than a useful command in its own right.
{p_end}
