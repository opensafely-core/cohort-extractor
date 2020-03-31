{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway scatteri" "mansection G-2 graphtwowayscatteri"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 19 Immediate commands" "help immed"}{...}
{viewerjumpto "Syntax" "twoway_scatteri##syntax"}{...}
{viewerjumpto "Menu" "twoway_scatteri##menu"}{...}
{viewerjumpto "Description" "twoway_scatteri##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_scatteri##linkspdf"}{...}
{viewerjumpto "Options" "twoway_scatteri##options"}{...}
{viewerjumpto "Remarks" "twoway_scatteri##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway scatteri} {hline 2}}Scatter with immediate
arguments{p_end}
{p2col:}({mansection G-2 graphtwowayscatteri:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmdab:tw:oway}
{cmd:scatteri}
{it:immediate_values}
[{cmd:,}
{help twoway_scatteri##scatteri_options:{it:options}}]

{pstd}
where {it:immediate_values} is one or more of

	{it:#_y} {it:#_x} [{cmd:(}{it:#_clockposstyle}{cmd:)}] [{cmd:"}{it:text for label}{cmd:"}]

{pstd}
See {manhelpi clockposstyle G-4} for a description of {it:#_clockposstyle}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:scatteri} is an immediate version of
{helpb scatter:twoway scatter}; see {findalias frimmediate}
and {help immed}.  {cmd:scatteri} is intended for programmer use but can be
useful interactively.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayscatteriQuickstart:Quick start}

        {mansection G-2 graphtwowayscatteriRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{marker scatteri_options}
{it:options} are as defined in {manhelp scatter G-2:graph twoway scatter}, with
the following modifications:

{pmore}
    If {cmd:"}{it:text for label}{cmd:"} is specified among any of the
    immediate arguments, option {helpb marker_label_options:mlabel()} is
    assumed.

{pmore}
    If {cmd:(}{it:#_clockposstyle}{cmd:)} is specified among any of the
    immediate arguments, option {helpb marker_label_options:mlabvposition()} is
    assumed.


{marker remarks}{...}
{title:Remarks}

{pstd}
Immediate commands are commands that obtain data from numbers typed
as arguments.  Typing

	{cmd:. twoway scatteri 1 1  2 2,} {it:any_options}

{pstd}
produces the same graph as typing

	{cmd:. clear}

	{cmd:. input y x}
	     {txt}        y          x
	  1{cmd}. 1 1
	{txt}  2{cmd}. 2 2
	{txt}  3{cmd}. end
	{txt}
	{cmd:. twoway scatter y x,} {it:any_options}

{pstd}
{cmd:twoway} {cmd:scatteri} does not modify the data in memory.

{pstd}
{cmd:scatteri} is intended for programmer use but can be used
interactively.  In {manhelpi added_text_option G-3}, we demonstrated the
use of option {cmd:text()} to add text to a graph:


	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O)
			text(41 2040 "VW Diesel", place(e))
			text(28 3260 "Plymouth Arrow", place(e))
			text(35 2050 "Datsun 210 and Subaru", place(e)){txt}
	  {it:({stata `"gr_example auto: twoway qfitci mpg weight, stdf || scatter mpg weight, ms(O) text(41 2040 "VW Diesel", place(e)) text(28 3260 "Plymouth Arrow", place(e)) text(35 2050 "Datsun 210 and Subaru", place(e))"':click to run})}
{* graph atofig1, but do not repeat in manual version}{...}

{pstd}
Below we use {cmd:scatteri} to obtain similar results:

	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O) ||
		 scatteri 41 2040 (3) "VW Diesel"
			  28 3260 (3) "Plymouth Arrow"
			  35 2050 (3) "Datsun 210 and Subaru"
			  , msymbol(i){txt}
	  {it:({stata `"gr_example auto: twoway qfitci  mpg weight, stdf || scatter mpg weight, ms(O) || scatteri 41 2040 (3) "VW Diesel" 28 3260 (3) "Plymouth Arrow" 35 2050 (3) "Datsun 210 and Subaru" , ms(i)"':click to run})}
{* graph gtscatteri1}{...}

{pstd}
We translated {cmd:text(}...{cmd:, place(e))} to {cmd:(3)},
3 o'clock being the {it:clockposstyle} notation for the {cmd:e}ast
{it:compassdirstyle}.  Because labels are by default positioned at 3 o'clock,
we could omit {cmd:(3)} altogether:

	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O) ||
		 scatteri 41 2040 "VW Diesel"
			  28 3260 "Plymouth Arrow"
			  35 2050 "Datsun 210 and Subaru"
			  , msymbol(i){txt}

{pstd}
We specified {cmd:msymbol(i)} option to suppress displaying
the marker symbol.

{pin}
{it:Technical note:}{break}
Programmers:
Note carefully {cmd:scatter}'s {it:advanced_option} {cmd:recast()}; see
{manhelpi advanced_options G-3}.
It can be used to good effect, such as using {cmd:scatteri} to add
areas, bars, spikes, and dropped lines.
{p_end}
