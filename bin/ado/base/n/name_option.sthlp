{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[G-3] name_option" "mansection G-3 name_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph display" "help graph_display"}{...}
{vieweralsosee "[G-2] graph drop" "help graph_drop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph save" "help graph_save"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{viewerjumpto "Syntax" "name_option##syntax"}{...}
{viewerjumpto "Description" "name_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "name_option##linkspdf"}{...}
{viewerjumpto "Option" "name_option##option"}{...}
{viewerjumpto "Remarks" "name_option##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:name_option} {hline 2}}Option for naming graph in memory{p_end}
{p2col:}({mansection G-3 name_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:name_option}}Description{p_end}
{p2line}
{p2col:{cmd:name(}{it:name}[{cmd:, replace}]{cmd:)}}specify name{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}{cmd:name()} is {it:unique}; see {help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
Option {cmd:name()} specifies the name of the graph being created.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 name_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:name(}{it:name}[{cmd:, replace}]{cmd:)}
    specifies the name of the graph.
    If {cmd:name()} is not specified, {cmd:name(Graph, replace)} is assumed.

{pmore}
    In fact, {cmd:name(Graph)} has the same effect as
    {cmd:name(Graph, replace)} because {cmd:replace} is assumed
    when the name is {cmd:Graph}.
    For all other {it:names}, you must specify suboption
    {cmd:replace} if a graph under that name already exists.


{marker remarks}{...}
{title:Remarks}

{pstd}
When you type, for instance,

	{cmd:. scatter yvar xvar}

{pstd}
you see a graph.  The graph is also stored in
memory.  For instance, try the following:  close the Graph window, and then
type

	{cmd:. graph display}

{pstd}
Your graph will reappear.

{pstd}
Every time you draw a graph, that previously remembered graph is discarded,
and the new graph replaces it.

{pstd}
You can have more than one graph stored in memory.  When you do not specify
the name under which the graph is to be remembered, it is remembered under
the default name {cmd:Graph}.   For instance, if you were now to type

	{cmd:. scatter y2var xvar, name(g2)}

{pstd}
You would now have two graphs stored in memory:  {cmd:Graph} and {cmd:g2}.
If you typed

	{cmd:. graph display}
    or
	{cmd:. graph display Graph}

{pstd}
you would see your first graph.  Type

	{cmd:. graph display g2}

{pstd}
and you will see your second graph.

{pstd}
Do not confuse Stata's storing of graphs in memory with the saving of graphs to
disk.  Were you now to {cmd:exit} Stata, the graphs you have stored in memory
would be gone forever.  If you want to save your graphs, you want to specify
the {cmd:saving()} option (see {manhelpi saving_option G-3}) or you want to
use the {cmd:graph} {cmd:save} command
(see {manhelp graph_save G-2:graph save}); either results in the same outcome.

{pstd}
You can find out what graphs you have in memory by using {cmd:graph dir}, drop
them by using {cmd:graph drop}, rename them by using {cmd:graph rename}, and
so on, and of course, you can redisplay them by using {cmd:graph}
{cmd:display}.  See {manhelp graph_manipulation G-2:graph manipulation} for the
details on all of those commands.

{pstd}
You can drop all graphs currently stored in memory by using
{cmd:graph}
{cmd:drop}
{cmd:_all}
or {cmd:discard}; see
{manhelp graph_drop G-2:graph drop}.
{p_end}
