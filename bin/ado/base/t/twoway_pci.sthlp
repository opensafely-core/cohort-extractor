{smcl}
{* *! version 1.1.11  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway pci" "mansection G-2 graphtwowaypci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatteri" "help twoway_scatteri"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway pcarrow" "help twoway_pcarrow"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 19 Immediate commands" "help immed"}{...}
{viewerjumpto "Syntax" "twoway_pci##syntax"}{...}
{viewerjumpto "Menu" "twoway_pci##menu"}{...}
{viewerjumpto "Description" "twoway_pci##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_pci##linkspdf"}{...}
{viewerjumpto "Options" "twoway_pci##options"}{...}
{viewerjumpto "Remarks" "twoway_pci##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-2] graph twoway pci} {hline 2}}Twoway paired-coordinate plot
     with immediate arguments{p_end}
{p2col:}({mansection G-2 graphtwowaypci:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmdab:tw:oway}
{cmd:pci}
{it:immediate_values}
[{cmd:,}
{help twoway_pci##options:{it:options}}]

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
{cmd:pci} is an immediate version of {helpb twoway pcspike}; 
see {findalias frimmediate} and {help immed}.
{cmd:pci} is intended for programmer use but can be
useful interactively.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaypciQuickstart:Quick start}

        {mansection G-2 graphtwowaypciRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:options} are as defined in
{manhelp twoway_pcspike G-2:graph twoway pcspike},
with the following modifications:

{pmore}
    If {cmd:"}{it:text for label}{cmd:"} is specified among any of the
    immediate arguments, option {helpb marker_label_options:mlabel()} is
    assumed.

{pmore}
    If {cmd:(}{it:#_clockposstyle}{cmd:)} is specified among any of the
    immediate arguments, option {helpb marker_label_options:mlabvposition()} is
    assumed.

{pmore}
    Also see the {it:marker_options} defined in
    {manhelp twoway_pccapsym G-2:graph twoway pccapsym} if the
    {cmd:recast()} option is used to change the spikes into a
    paired-coordinate plot that plots markers.


{marker remarks}{...}
{title:Remarks}

{pstd}
Immediate commands are commands that obtain data from numbers typed
as arguments.

{pstd}
{cmd:twoway} {cmd:pci} does not modify the data in memory.

{pstd}
{cmd:pci} is intended for programmer use but can be used interactively.  We
can combine a {cmd:pci} plot with other {cmd:twoway} plots to produce a quick
diagram.

{cmd}{...}
	  . twoway function  y = -x^2, range(-2 2) || 
   	        pci 0 1 0 -1			   ||
	        pcarrowi 1.2 .5 0 0
{txt}{...}
	  {it:({stata `"twoway function  y = -x^2, range(-2 2) || pci 0 1 0 -1 || pcarrowi 1.2 .5 0. 0"':click to run})}
{* graph gtpcarrowi1}{...}

{pstd}
We can improve the annotation with 

{cmd}{...}
	  . twoway function  y = -x^2, range(-2 2)  || 
	  	pci 0 1 0 -1 "Tangent", recast(pccapsym) msymbol(i) || 
		pcarrowi 1.2 .5 0.05 0 "Maximum at x=0",
		legend(off) title("Characteristics of y = -x{c -(}superscript:2{c )-}")
{txt}{...}
	  {it:({stata `"twoway function  y = -x^2, range(-2 2) || pci 0 1 0 -1 "Tangent", recast(pccapsym) msymbol(i) || pcarrowi 1.2 .5 0.05 0 "Maximum at x=0", legend(off) title("Characteristics of y = -x{superscript:2}")"':click to run})}
{* graph gtpcarrowi2}{...}

{pstd}
A slightly more whimsical example is

{cmd}{...}
	  . twoway pci 2 0 2 6  4 0 4 6  0 2 6 2  0 4 6 4 ||
	  	scatteri 5 1  3 3, msize(ehuge) ms(X)  ||
		scatteri 5 5  1 5, msize(ehuge) ms(Oh) legend(off)
{txt}{...}
	  {it:({stata `"twoway pci 2 0 2 6  4 0 4 6  0 2 6 2  0 4 6 4 || scatteri 5 1  3 3 , msize(ehuge) ms(X) || scatteri 5 5  1 5, msize(ehuge) ms(Oh) legend(off)"':click to run})}

{pstd}
{it:Technical note:}{break}
Programmers:
Note carefully {cmd:twoway}'s {it:advanced_option} {cmd:recast()}; see
{manhelpi advanced_options G-3}.
It can be used to good effect, such as using {cmd:pci} to add
marker labels.
{p_end}
