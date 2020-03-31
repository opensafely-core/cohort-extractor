{smcl}
{* *! version 1.1.12  15may2018}{...}
{vieweralsosee "[G-4] Scheme s2" "mansection G-4 Schemes2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] scheme_option" "help scheme_option"}{...}
{viewerjumpto "Syntax" "scheme_s2##syntax"}{...}
{viewerjumpto "Description" "scheme_s2##description"}{...}
{viewerjumpto "Links to PDF documentation" "scheme_s2##linkspdf"}{...}
{viewerjumpto "Remarks" "scheme_s2##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4] Scheme s2} {hline 2}}Scheme description:  s2 family{p_end}
{p2col:}({mansection G-4 Schemes2:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:schemename}{col 21}Foreground{col 34}Background{col 46}Description
	{hline 70}
	{cmd:s2color}{...}
{col 21}color{...}
{col 34}white{...}
{col 46}{bf:factory setting}
{...}
	{cmd:s2mono}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}{cmd:s2color} in monochrome
{...}
	{cmd:s2gcolor}{...}
{col 21}color{...}
{col 34}white{...}
{col 46}used in the Stata manuals
	{cmd:s2manual}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}{cmd:s2gcolor} in monochrome
	{cmd:s2gmanual}{...}
{col 21}monochrome{...}
{col 34}white{...}
{col 46}previously used in the [G] manual
	{hline 70}

{pstd}
For instance, you might type

{p 8 16 2}
{cmd:. graph}
...{cmd:,}
...
{cmd:scheme(s2mono)}

{p 8 16 2}
{cmd:. set}
{cmd:scheme}
{cmd:s2mono}
[{cmd:,}
{cmdab:perm:anently}]

{pstd}
See {manhelpi scheme_option G-3} and {manhelp set_scheme G-2:set scheme}.


{marker description}{...}
{title:Description}

{pstd}
Schemes determine the overall look of a graph; see
{manhelp schemes G-4:Schemes intro}.

{pstd}
The {cmd:s2} family of schemes is Stata's default scheme.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 Schemes2Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:s2} is the family of schemes that we like for displaying data.  It
provides a light background tint to give the graph better definition and make
it visually more appealing.  On the other hand, if you feel that the tinting
distracts from the graph, see {manhelp scheme_s1 G-4:Scheme s1}; the {cmd:s1}
family is nearly identical to {cmd:s2} but does away with the extra tinting.

{pstd}
In particular, we recommend that you consider scheme {cmd:s1rcolor}; see 
{manhelp scheme_s1 G-4:Scheme s1}.  {cmd:s1rcolor} uses a black background, and
for working at the monitor, it is difficult to find a better choice.

{pstd}
In any case, scheme {cmd:s2color} is Stata's default scheme.  It looks good on
the screen, good when printed on a color printer, and more than adequate when
printed on a monochrome printer.

{pstd}
Scheme {cmd:s2mono} has been optimized for printing on monochrome printers.
Also, rather than using the same symbol over and over and varying the
color, {cmd:s2mono} will vary the symbol's shape, and in connecting points,
{cmd:s2mono} varies the line pattern ({cmd:s2color} varies the color).

{pstd}
Scheme {cmd:s2gcolor} is the scheme used in the Stata manuals.  It
is the same scheme as {cmd:s2color} except the graph size is smaller.

{pstd}
Scheme {cmd:s2manual} is the scheme used in the Stata
manuals prior to Stata 13.  It is basically {cmd:s2mono}, but smaller.

{pstd}
Scheme {cmd:s2gmanual} is the scheme used in the Stata Graphics
manual prior to Stata 13.  It is similar to {cmd:s2manual} except that
connecting lines are solid and gray scales rather than patterned and black.

{pstd}
For an example, see
{mansection G-4 SchemesintroRemarksandexamplesExamplesofschemes:{it:Examples of schemes}} 
in {it:Remarks and examples} of {bf:[G-4] Schemes intro}.
{p_end}

{pin}
{it:Technical note:}{break}
The colors used in the {cmd:s2color} scheme were changed slightly after Stata
8 to improve printing on color inkjet printers and printing
presses -- the amount of cyan in the some colors was reduced to prevent
an unintended casting toward purple.  You probably will not notice the
difference, but if you want the original colors, they are available in the
scheme {cmd:s2color8}.
{p_end}
