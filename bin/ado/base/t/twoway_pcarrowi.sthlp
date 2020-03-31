{smcl}
{* *! version 1.1.9  20aug2018}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway pcarrowi" "mansection G-2 graphtwowaypcarrowi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatteri" "help twoway_scatteri"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway pcarrow" "help twoway_pcarrow"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 19 Immediate commands" "help immed"}{...}
{viewerjumpto "Syntax" "twoway_pcarrowi##syntax"}{...}
{viewerjumpto "Menu" "twoway_pcarrowi##menu"}{...}
{viewerjumpto "Description" "twoway_pcarrowi##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_pcarrowi##linkspdf"}{...}
{viewerjumpto "Options" "twoway_pcarrowi##options"}{...}
{viewerjumpto "Remarks" "twoway_pcarrowi##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway pcarrowi} {hline 2}}Twoway pcarrow with 
	immediate arguments{p_end}
{p2col:}({mansection G-2 graphtwowaypcarrowi:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmdab:tw:oway}
{cmd:pcarrowi}
{it:immediate_values}
[{cmd:,}
{help twoway_pcarrowi##options:{it:options}}]

{pstd}
where {it:immediate_values} is one or more of

	{it:#_y1} {it:#_x1} {it:#_y2} {it:#_x2} [{cmd:(}{it:#_clockposstyle}{cmd:)}] [{cmd:"}{it:text for label}{cmd:"}]

{pstd}
See {manhelpi clockposstyle G-4} for a description of {it:#_clockposstyle}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pcarrowi} is an immediate version of {helpb twoway pcarrow};
see {findalias frimmediate} and {help immed}.
{cmd:pcarrowi} is intended for programmer use but can be
useful interactively.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaypcarrowiQuickstart:Quick start}

        {mansection G-2 graphtwowaypcarrowiRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:options} are as defined in
{manhelp twoway_pcarrow G-2:graph twoway pcarrow}, with the following
modifications:

{pmore}
    If {cmd:"}{it:text for label}{cmd:"} is specified among any of the
    immediate arguments, option {cmd:mlabel()} is assumed.

{pmore}
    If {cmd:(}{it:#_clockposstyle}{cmd:)} is specified among any of the
    immediate arguments, option {cmd:mlabvposition()} is assumed.


{marker remarks}{...}
{title:Remarks}

{pstd}
Immediate commands are commands that obtain data from numbers typed
as arguments.  Typing

	{cmd:. twoway pcarrowi 1.1 1.2 1.3 1.4  2.1 2.2 2.3 2.4,} {it:any_options}

{pstd}
produces the same graph as typing

	{cmd:. clear}

	{cmd:. input y1 x1 y2 x2}
	     {txt}        y1         x1         y2         x2
	  1{cmd}. 1.1 1.2 1.3 1.4
	{txt}  2{cmd}. 2.1 2.2 2.3 2.4
	{txt}  3{cmd}. end
	{txt}
	{cmd:. twoway pcarrowi y x,} {it:any_options}

{pstd}
{cmd:twoway} {cmd:pcarrowi} does not modify the data in memory.

{pstd}
{cmd:pcarrowi} is intended for programmer use but can be used interactively.
In {it:{help twoway pcarrow##basic_use:Basic use}} of 
{manhelp twoway_pcarrow G-2:graph twoway pcarrow}, we drew
some simple clock hands from data that we input.  We can draw the same graph
by using {cmd:pcarrowi}.

	{cmd:. twoway pcarrowi 0  0  0  1  0  0  1  0}
	  {it:({stata `"twoway pcarrowi 0  0  0  1  0  0  1  0"':click to run})}
{* graph gtpcarrowi1}{...}

{pstd}
We can also draw the annotated second example,

{cmd}{...}
	. twoway pcarrowi 0  0  0  1  (3) "3 o'clock" 
	  		  0  0  1  0 (12) "12 o'clock",
			  aspect(1) headlabel plotregion(margin(vlarge))
{txt}{...}
	  {it:({stata `"twoway pcarrowi 0  0  0  1  (3) "3 o'clock" 0  0  1  0 (12) "12 o'clock", aspect(1) headlabel plotregion(margin(vlarge))"':click to run})}
{* graph gtpcarrowi2}{...}

{pstd}
As another example, 
in {manhelpi added_text_options G-3}, we demonstrated the
use of option {cmd:text()} to add text to a graph:


	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O)
			text(41 2040 "VW Diesel", place(e))
			text(28 3260 "Plymouth Arrow", place(e))
			text(35 2050 "Datsun 210 and Subaru", place(e)){txt}
	  {it:({stata `"gr_example auto: twoway qfitci mpg weight, stdf || scatter mpg weight, ms(O) text(41 2040 "VW Diesel", place(e)) text(28 3260 "Plymouth Arrow", place(e)) text(35 2050 "Datsun 210 and Subaru", place(e))"':click to run})}
{* graph atofig1, but do not repeat in manual version}{...}

{pstd}
Below we use {cmd:pcarrowi} to obtain similar results:

	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O) ||
		 pcarrowi 41 2200 41 2060 (3) "VW Diesel"
			  31 3460 28 3280 (3) "Plymouth Arrow"
			  35 2250 35 2070 (3) "Datsun 210 and Subaru",
			  legend(order(1 2 3))
{* graph gtpcarrowi3}{...}
	  {it:({stata "gr_example2 pcarrowi1":click to run})}
