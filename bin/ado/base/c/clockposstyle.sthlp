{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-4] clockposstyle" "mansection G-4 clockposstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_label_options" "help marker_label_options"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] compassdirstyle" "help compassdirstyle"}{...}
{viewerjumpto "Syntax" "clockposstyle##syntax"}{...}
{viewerjumpto "Description" "clockposstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "clockposstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "clockposstyle##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-4]} {it:clockposstyle} {hline 2}}Choices for location:  Direction from central point{p_end}
{p2col:}({mansection G-4 clockposstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
{it:clockposstyle} is

	{it:#}                       0 <= {it:#} <= 12, {it:#} an integer


{marker description}{...}
{title:Description}

{pstd}
{it:clockposstyle} specifies a location or a direction.

{pstd}
{it:clockposstyle} is specified inside options such as
the {cmd:position()} {it:title_option} (see {manhelpi title_options G-3}) or
the {cmd:mlabposition()} {it:marker_label_option} (see
{manhelpi marker_label_options G-3}):

{p 8 16 2}
{cmd:. graph}
...{cmd:, title(}...{cmd:, position(}{it:clockposstyle}{cmd:))} ...

{p 8 16 2}
{cmd:. graph}
...{cmd:, mlabposition(}{it:clockposlist}{cmd:)} ...

{pstd}
In cases where a {it:clockposlist} is allowed, you may specify a sequence of
{it:clockposstyle} separated by spaces.  Shorthands are allowed to make
specifying the list easier; see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 clockposstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:clockposstyle} is used to specify a location around a central point:{cmd}

		     11  12  1
		    10         2
		     9    0    3
		     8         4
		       7  6  5

{pstd}
{txt}Sometimes the central position is a well-defined object (for example,
for {cmd:mlabposition()}, the central point is the marker
itself), and sometimes the central position is implied (for example,
for {cmd:position()}, the central point is the center of the plot region).

{pstd}
{it:clockposstyle} {cmd:0} is always allowed:  it refers to
the center.
{p_end}
