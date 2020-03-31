{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway pcspike" "mansection G-2 graphtwowaypcspike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway pcarrow" "help twoway_pcarrow"}{...}
{vieweralsosee "[G-2] graph twoway pccapsym" "help twoway_pccapsym"}{...}
{vieweralsosee "[G-2] graph twoway pci" "help twoway_pci"}{...}
{vieweralsosee "[G-2] graph twoway pcscatter" "help twoway_pcscatter"}{...}
{viewerjumpto "Syntax" "twoway_pcspike##syntax"}{...}
{viewerjumpto "Menu" "twoway_pcspike##menu"}{...}
{viewerjumpto "Description" "twoway_pcspike##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_pcspike##linkspdf"}{...}
{viewerjumpto "Options" "twoway_pcspike##options"}{...}
{viewerjumpto "Remarks" "twoway_pcspike##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway pcspike} {hline 2}}Paired-coordinate plot with spikes{p_end}
{p2col:}({mansection G-2 graphtwowaypcspike:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{* index twoway pcspike tt}{...}
{* index paired-coordinate plots, pcspike}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:pcspike}
{it:y1var} {it:x1var} {it:y2var} {it:x2var}
{ifin}
[{cmd:,}
{it:options}]


{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
INCLUDE help gr_blspike2

INCLUDE help gr_hvpcopt
INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p 4 6 2}
All explicit options are {it:rightmost}, except {cmd:vertical}
and {cmd:horizontal}, which are {it:unique}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
A paired-coordinate spike plot draws a spike (or line) for each observation in
the dataset.  The line starts at the coordinate ({it:y1var},{it:x1var}) and
ends at the coordinate ({it:y2var},{it:x2var}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaypcspikeQuickstart:Quick start}

        {mansection G-2 graphtwowaypcspikeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

INCLUDE help gr_blspikef2

INCLUDE help gr_hvpcoptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_pcspike##basic_use:Basic use}
	{help twoway_pcspike##advanced_use:Advanced use}
	{help twoway_pcspike##advanced_use2:Advanced use 2}

{marker basic_use}{...}
{title:Basic use}

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
We graph a spike showing the movement from 1968 values to 1988 values for each
observation (each occupation):

	{cmd:. twoway pcspike wage68 ttl_exp68 wage88 ttl_exp88}
	  {it:({stata "gr_example nlswide1: twoway pcspike wage68 ttl_exp68 wage88 ttl_exp88":click to run})}
{* graph gtpcspike1}{...}


{marker advanced_use}{...}
{title:Advanced use}

{pstd}
{cmd:twoway} {cmd:pcspike} can be usefully combined
with other {helpb twoway} plottypes.  Here we add markers and labeled markers
along with titles and such to improve the graph:

{cmd}{...}
	. twoway pcspike wage68 ttl_exp68 wage88 ttl_exp88	||
		 scatter wage68 ttl_exp68, msym(O)		||
		 scatter wage88 ttl_exp88, msym(O) pstyle(p4)
		 mlabel(occ) xscale(range(17))
		 title("Change in US Women's Experience and Earnings")
		 subtitle("By Occupation -- 1968 to 1988")
		 ytitle(Earnings) xtitle(Total experience)
		 note("Source: National Longitudinal Survey of Young Women")
		 legend(order(2 "1968" 3 "1988"))
{txt}{...}
	  {it:({stata "gr_example2 twopcspike1":click to run})}
{* graph gtpcspike2}{...}


{marker advanced_use2}{...}
{title:Advanced use 2}

{pstd}
Drawing the edges of network diagrams is often easier with 
{cmd:twoway pcspike} than with other plottypes. 

	{cmd:. sysuse network1}

	{cmd:. twoway pcspike y_c x_c y_l x_l}
	  {it:({stata "gr_example network1: twoway pcspike y_c x_c y_l x_l":click to run})}
{* graph gtpcspike3}{...}

{pstd}
As with our first example, this graph can be made prettier by combining 
{cmd:twoway pcspike} with other plottypes.  

{cmd}{...}
	. sysuse network1a

	. twoway pcspike y_c x_c y_l x_l, pstyle(p3)		    ||
		 pcspike y_c x_c y_r x_r, pstyle(p4)		    ||
		 scatter y_l x_l, pstyle(p3) msize(vlarge) msym(O)
				  mlabel(lab_l) mlabpos(9)	    ||
		 scatter y_c x_c, pstyle(p5) msize(vlarge) msym(O)  ||
		 scatter y_r x_r, pstyle(p4) msize(vlarge) msym(O)
				  mlabel(lab_r) mlabpos(3)
	       yscale(off) xscale(off) ylabels(, nogrid) legend(off)
	       plotregion(margin(30 15 3 3))
{txt}{...}
	  {it:({stata "gr_example2 twopcspike2":click to run})}
{* graph gtpcspike4}{...}
