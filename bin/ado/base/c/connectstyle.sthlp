{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] connectstyle" "mansection G-4 connectstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] connect_options" "help connect_options"}{...}
{viewerjumpto "Syntax" "connectstyle##syntax"}{...}
{viewerjumpto "Description" "connectstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "connectstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "connectstyle##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-4]} {it:connectstyle} {hline 2}}Choices for how points are connected{p_end}
{p2col:}({mansection G-4 connectstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:connectstyle}     Synonym     Description
	{hline 65}
	{cmd:none}                {cmd:i}        do not connect
	{cmd:direct}              {cmd:l}        connect with straight lines
	{cmd:ascending}           {cmd:L}        {cmd:direct}, but only if x[j+1] > x[j]
	{cmd:stairstep}           {cmd:J}        flat, then vertical
	{cmd:stepstair}                    vertical, then flat
	{hline 65}

{pin}
Other {it:connectstyles} may be available; type

		{cmd:.} {bf:{stata graph query connectstyle}}

{pin}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:connectstyle} specifies if and how points in a scatter are to be
connected, for example, via straight lines or stairsteps.

{pstd}
{it:connectstyle} is specified inside the {cmd:connect()} option which is
allowed, for instance, with {cmd:scatter}:

	{cmd:. scatter} ...{cmd:, connect(}{it:connectstylelist}{cmd:)} ...

{pstd}
Here a {it:connectstylelist} is allowed.
A {it:connectstylelist} is a sequence of {it:connectstyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 connectstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Points are connected in the order of the data, so be sure that data are
in the desired order (which is usually ascending value of {it:x}) before
specifying the {cmd:connect(}{it:connectstyle}{cmd:)} option.
Commands that provide {cmd:connect()} also provide a {cmd:sort}
option, which will sort by the {it:x} variable for you.

{pstd}
{cmd:connect(l)} is the most common choice.

{pstd}
{cmd:connect(J)} is the appropriate way to connect the points of empirical
cumulative distribution functions (CDFs).
{p_end}
