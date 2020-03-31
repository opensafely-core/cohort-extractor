{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-3] std_options" "mansection G-3 std_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] name_option" "help name_option"}{...}
{vieweralsosee "[G-3] nodraw_option" "help nodraw_option"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "[G-3] scale_option" "help scale_option"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{viewerjumpto "Syntax" "std_options##syntax"}{...}
{viewerjumpto "Description" "std_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "std_options##linkspdf"}{...}
{viewerjumpto "Options" "std_options##options"}{...}
{viewerjumpto "Remarks" "std_options##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:std_options} {hline 2}}Options for use with graph construction commands{p_end}
{p2col:}({mansection G-3 std_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:std_options}}Description{p_end}
{p2line}
{p2col:{it:{help title_options}}}titles, subtitles, notes, captions{p_end}

{p2col:{help scale_option:{bf:scale(}{it:#}{bf:)}}}resize text and markers
      {p_end}
{p2col:{it:{help region_options}}}outlining, shading, graph size{p_end}
{p2col:{help scheme_option:{bf:scheme(}{it:schemename}{cmd:)}}}overall look
     {p_end}
{p2col:{help play_option:{bf:play(}{it:recordingname}{bf:)}}}play edits from
     {it:recordingname}{p_end}

{p2col:{help nodraw_option:{bf:nodraw}}}suppress display of graph{p_end}
{p2col:{help name_option:{bf:name(}{it:name}{bf:, ...)}}}specify name for
     graph{p_end}
{p2col:{help saving_option:{bf:saving(}{it:filename}{bf:, ...)}}}save graph in
     file{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The above options are allowed with

{synoptset 25}{...}
{p2col:Command}Manual entry{p_end}
{p2line}
{p2col:{cmd:graph bar} and {cmd:graph hbar}}{manhelp graph_bar G-2:graph bar}{p_end}
{p2col:{cmd:graph dot}}{manhelp graph_dot G-2:graph dot}{p_end}
{p2col:{cmd:graph box}}{manhelp graph_box G-2:graph box}{p_end}
{p2col:{cmd:graph pie}}{manhelp graph_pie G-2:graph pie}{p_end}
{p2line}
{p2colreset}{...}

{pstd}
See {manhelpi twoway_options G-3} for the standard options allowed with
{cmd:graph} {cmd:twoway}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 std_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:title_options}
    allow you to specify titles, subtitles, notes, and captions
    to be placed on the graph.  See {manhelpi title_options G-3}.

{phang}
{cmd:scale(}{it:#}{cmd:)}
    specifies a multiplier that affects the size of all text and
    markers in a graph.  {cmd:scale(1)} is the default, and {cmd:scale(1.2)}
    would make all text and markers 20% larger.
    See {manhelpi scale_option G-3}.

{phang}
{it:region_options}
    allow outlining the plot region (such as placing or suppressing a border
    around the graph), specifying a background shading for the region, and the
    controlling of the graph size.  See {manhelpi region_options G-3}.

{phang}
{cmd:scheme(}{it:schemename}{cmd:)}
    specifies the overall look of the graph;
    see {manhelpi scheme_option G-3}.

{phang}
INCLUDE help playopt_desc

{phang}
{cmd:nodraw}
    causes the graph to be constructed but not displayed;
    see {manhelpi nodraw_option G-3}.

{phang}
{cmd:name(}{it:name}[{cmd:, replace}]{cmd:)}
    specifies the name of the graph.  {cmd:name(Graph, replace)} is the default.
    See {manhelpi name_option G-3}.

{phang}
    {cmd:saving(}{it:filename}[{cmd:, asis replace}]{cmd:)}
    specifies that the graph be saved as {it:filename}.  If {it:filename}
    is specified without an extension, {cmd:.gph} is assumed.
    {cmd:asis} specifies that the graph be saved just as it is.
    {cmd:replace} specifies that, if the file already exists, it is okay
    to replace it.
    See {manhelpi saving_option G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The above options may be used with any of the {cmd:graph}
commands listed above.
{p_end}
