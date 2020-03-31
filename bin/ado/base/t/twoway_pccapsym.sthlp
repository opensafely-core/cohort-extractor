{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway pccapsym" "mansection G-2 graphtwowaypccapsym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway pcarrow" "help twoway_pcarrow"}{...}
{vieweralsosee "[G-2] graph twoway pci" "help twoway_pci"}{...}
{vieweralsosee "[G-2] graph twoway pcscatter" "help twoway_pcscatter"}{...}
{vieweralsosee "[G-2] graph twoway pcspike" "help twoway_pcspike"}{...}
{viewerjumpto "Syntax" "twoway_pccapsym##syntax"}{...}
{viewerjumpto "Menu" "twoway_pccapsym##menu"}{...}
{viewerjumpto "Description" "twoway_pccapsym##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_pccapsym##linkspdf"}{...}
{viewerjumpto "Options" "twoway_pccapsym##options"}{...}
{viewerjumpto "Remarks" "twoway_pccapsym##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway pccapsym} {hline 2}}Paired-coordinate plot
with spikes and marker symbols{p_end}
{p2col:}({mansection G-2 graphtwowaypccapsym:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:pccapsym}
{it:y1var} {it:x1var} {it:y2var} {it:x2var}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
INCLUDE help gr_blspike2
INCLUDE help gr_markopt
INCLUDE help gr_headlabopt

INCLUDE help gr_hvpcopt
INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p 4 6 2}
All explicit options are {it:rightmost}, except {cmd:headlabel},
{cmd:vertical}, and {cmd:horizontal}, which are {it:unique}; see 
{help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
A paired-coordinate capped-symbol plot draws a spike (or line) for each
observation in the dataset and caps these spikes with a marker symbol at each
end.  The line starts at the coordinate ({it:y1var},{it:x1var}) and ends at
the coordinate ({it:y2var},{it:x2var}), and both coordinates are designated
with a marker.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaypccapsymQuickstart:Quick start}

        {mansection G-2 graphtwowaypccapsymRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

INCLUDE help gr_blspikef2

{phang}
{it:marker_options}
    specify how the markers look, including
    shape, size, color, and outline;
    see {manhelpi marker_options G-3}.  The same marker is used on both ends of
    the spikes.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

INCLUDE help gr_headlaboptf

INCLUDE help gr_hvpcoptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_pccapsym##basic_use:Basic use 1}
	{help twoway_pccapsym##basic_use2:Basic use 2}


{marker basic_use}{...}
{title:Basic use 1}

{pstd}
We have longitudinal data from 1968 and 1988 on the earnings and total
experience of U.S. women by occupation.

	{cmd:. sysuse nlswide1}

	{cmd:. list occ wage68 ttl_exp68 wage88 ttl_exp88}
{txt}
	     {c TLC}{hline 61}{c TRC}
	     {c |} {res}           occ         wage68  ttl_e~68    wage88  ttl_e~88 {txt}{c |}
	     {c LT}{hline 61}{c RT}
	  1. {c |} {res}Professionals        6.121874   .860618  10.94776  14.11177 {txt}{c |}
	  2. {c |} {res}     Managers        5.426208  1.354167  11.53928  13.88886 {txt}{c |}
	  3. {c |} {res}        Sales        4.836701  .9896552  7.290306  12.62823 {txt}{c |}
	  4. {c |} {res} Clerical/unskilled  4.088309   .640812  9.612672  11.08019 {txt}{c |}
	  5. {c |} {res}    Craftsmen        4.721373  1.091346  7.839769  12.64364 {txt}{c |}
	     {c LT}{hline 61}{c RT}
	  6. {c |} {res}   Operatives        4.364782  .7959284  5.893025  11.99362 {txt}{c |}
	  7. {c |} {res}    Transport        1.987857  .5247414  3.200494  8.710394 {txt}{c |}
	  8. {c |} {res}     Laborers        3.724821   .775966  5.264415  10.56182 {txt}{c |}
	  9. {c |} {res}        Other         5.58524  .8278245  8.628641  12.78389 {txt}{c |}
	     {c BLC}{hline 61}{c BRC}
{txt}

{pstd}
We graph a spike with symbols capping the end to show the movement from 1968
values to 1988 values for each observation (each occupation):

	{cmd:. twoway pccapsym wage68 ttl_exp68 wage88 ttl_exp88}
	  {it:({stata "gr_example nlswide1: twoway pccapsym wage68 ttl_exp68 wage88 ttl_exp88":click to run})}
{* graph gtpccapsym1}{...}

{pstd}
For a better presentation of these data, see 
{it:{help twoway_pcspike##advanced_use:Advanced use}} in
{manhelp twoway_pcspike G-2:graph twoway pcspike}; 
the comments there about combining plots apply equally well to
{cmd:pccapsym} plots.


{marker basic_use2}{...}
{title:Basic use 2}

{pstd}
We can draw both the edges and nodes of network diagrams by using
{cmd:twoway pccapsym}. 

	{cmd:. sysuse network1}

	{cmd:. twoway pccapsym y_c x_c y_l x_l}
	  {it:({stata "gr_example network1: twoway pccapsym y_c x_c y_l x_l":click to run})}
{* graph gtpccapsym2}{...}

{pstd}
Again, a better presentation of these data can be found in
{manhelp twoway_pcspike G-2:graph twoway pcspike}
under {it:{help twoway_pcspike##advanced_use2:Advanced use 2}}.
{p_end}
