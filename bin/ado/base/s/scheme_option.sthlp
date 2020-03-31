{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[G-3] scheme_option" "mansection G-3 scheme_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] set scheme" "help set_scheme"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{viewerjumpto "Syntax" "scheme_option##syntax"}{...}
{viewerjumpto "Description" "scheme_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "scheme_option##linkspdf"}{...}
{viewerjumpto "Option" "scheme_option##option"}{...}
{viewerjumpto "Remarks" "scheme_option##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:scheme_option} {hline 2}}Option for specifying scheme{p_end}
{p2col:}({mansection G-3 scheme_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:scheme_option}}Description{p_end}
{p2line}
{p2col:{cmdab:sch:eme:(}{it:{help scheme intro:schemename}}{cmd:)}}specify scheme to be used{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
{cmd:scheme()} is {it:unique}; see {help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
Option {cmd:scheme()} specifies the graphics scheme to be used.
The scheme specifies the overall look of the graph.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 scheme_optionQuickstart:Quick start}

        {mansection G-3 scheme_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:scheme(}{it:schemename}{cmd:)} specifies the scheme to be used.  If
{cmd:scheme()} is not specified the default scheme is used; see
{manhelp schemes G-4:Schemes intro}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp schemes G-4:Schemes intro}.
{p_end}
