{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway line" "mansection G-2 graphtwowayline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "help twoway_fpfit"}{...}
{vieweralsosee "[G-2] graph twoway lfit" "help twoway_lfit"}{...}
{vieweralsosee "[G-2] graph twoway mband" "help twoway_mband"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "help twoway_mspline"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "help twoway_qfit"}{...}
{viewerjumpto "Syntax" "line##syntax"}{...}
{viewerjumpto "Menu" "line##menu"}{...}
{viewerjumpto "Description" "line##description"}{...}
{viewerjumpto "Links to PDF documentation" "line##linkspdf"}{...}
{viewerjumpto "Options" "line##options"}{...}
{viewerjumpto "Remarks" "line##remarks"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[G-2] graph twoway line} {hline 2}}Twoway line plots{p_end}
{p2col:}({mansection G-2 graphtwowayline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
[{cmdab:tw:oway}]
{cmd:line}
{it:varlist}
{ifin}
[{cmd:,}
{it:options}]

{pstd}
where {it:varlist} is 

		{it:y_1} [{it:y_2} [...]] {it:x}

{synoptset 22}
{p2col:{it:options}}Description{p_end}
{p2line}
INCLUDE help gr_conopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p 4 6 2}
{it:connect_options} discusses options for one {it:y} versus one {it:x};
see {it:{help scatter##connect_options:connect_options}} in 
{helpb scatter:[G-2] graph twoway scatter} when plotting
multiple {it:y}s against one {it:x}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:line} draws line plots.

{pstd}
{cmd:line} is a command and a {it:plottype} as defined in
{manhelp twoway G-2:graph twoway}.
Thus the syntax for {cmd:line} is

	{cmd:. graph twoway line} ...

	{cmd:. twoway line} ...

	{cmd:. line} ...

{pstd}
Being a plottype, {cmd:line} may be combined with other plottypes in the
{helpb twoway} family, as in

{phang2}
	{cmd:. twoway (line} ...{cmd:) (scatter} ...{cmd:) (lfit} ...{cmd:)} ...

{pstd}
which can equivalently be written as

{phang2}
	{cmd:. line} ... {cmd:|| scatter} ... {cmd:|| lfit} ... {cmd:||} ...


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaylineQuickstart:Quick start}

        {mansection G-2 graphtwowaylineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:connect_options} 
    specify how the points forming the line are connected and the look of the
    lines, including pattern, width, and color; 
    see {manhelpi connect_options G-3}.{p_end}

{pmore}
    {manhelpi connect_options G-3} discusses
    options for one {it:y} versus one {it:x}, see
    {it:connect_options} in
    {bf:{help scatter##connect_options:[G-2] graph twoway scatter}} when
    plotting multiple {it:y}s against one {it:x}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help line##remarks1:Oneway equivalency of line and scatter}
	{help line##remarks2:Typical use}
	{help line##remarks3:Advanced use}
	{help line##remarks4:Cautions}


{marker remarks1}{...}
{title:Oneway equivalency of line and scatter}

{pstd}
{cmd:line} is similar to {cmd:scatter}, the differences being that by default
the marker symbols are not displayed and the points are connected:

	Default {cmd:msymbol()} option:  {cmd:msymbol(none ...)}

	Default {cmd:connect()} option:  {cmd:connect(l ...)}

{pstd}
Thus you get the same results typing

	{cmd:. line yvar xvar}

{pstd}
as typing

{phang2}
	{cmd:. scatter yvar xvar, msymbol(none) connect(l)}

{pstd}
You can use {cmd:scatter} in place of {cmd:line}, but you may not use
{cmd:line} in place of {cmd:scatter}.  Typing

{phang2}
	{cmd:. line yvar xvar, msymbol(O) connect(none)}

{pstd}
will not achieve the same results as

	{cmd:. scatter yvar xvar}

{pstd}
because {cmd:line}, while it allows you to specify the {it:marker_option}
{helpb marker_options:msymbol()}, ignores its setting.


{marker remarks2}{...}
{title:Typical use}

{pstd}
{cmd:line} draws line charts:

	{cmd:. sysuse uslifeexp}

	{cmd:. line le year}
	  {it:({stata "gr_example uslifeexp: line le year":click to run})}
{* graph grline1}{...}

{pstd}
Line charts work well with time-series data.  With other datasets, lines
are often used to show predicted values and confidence intervals:

	{cmd}. sysuse auto, clear

	. quietly regress mpg weight

	. predict hat

	. predict stdf, stdf

	. generate lo = hat - 1.96*stdf

	. generate hi = hat + 1.96*stdf

{phang2}
	. scatter mpg weight || line hat lo hi weight, pstyle(p2 p3 p3) sort{txt}
{p_end}
	  {it:({stata "gr_example2 line1":click to run})}
{* graph line1}{...}

{pstd}
Do not forget to include the {cmd:sort} option when the data are not in the
order of the {it:x} variable, as they are not above.  We also included
{cmd:pstyle(p2 p3 p3)} to give the lower and upper confidence limit lines the
same look; see
{it:{help scatter##remarks19:Appendix: Styles and composite styles}} under
{it:Remarks} in {manhelp scatter G-2:graph twoway scatter}.

{pstd}
Because {cmd:line} is {cmd:scatter}, we can use any of the options allowed
by {cmd:scatter}.  Below we return to the U.S. life expectancy data
and graph black and white male life expectancies, along with the difference,
specifying many options to create an informative and visually pleasing
graph:

	{cmd}. sysuse uslifeexp, clear

	. generate diff = le_wm - le_bm

	. label var diff "Difference"

	.    line le_wm year, yaxis(1 2) xaxis(1 2)
	  || line le_bm year
	  || line diff  year
	  || lfit diff  year
	  ||,
	     ylabel(0(5)20, axis(2) gmin angle(horizontal))
	     ylabel(0 20(10)80,     gmax angle(horizontal))
	     ytitle("", axis(2))
	     xlabel(1918, axis(2)) xtitle("", axis(2))
	     ylabel(, axis(2) grid)
	     ytitle("Life expectancy at birth (years)")
	     title("White and black life expectancy")
	     subtitle("USA, 1900-1999")
	     note("Source: National Vital Statistics, Vol 50, No. 6"
		  "(1918 dip caused by 1918 Influenza Pandemic)"){txt}
	  {it:({stata gr_example2 line2:click to run})}
{* graph line2}{...}

{pstd}
See {manhelp scatter G-2:graph twoway scatter}.


{marker remarks3}{...}
{title:Advanced use}

{pstd}
The above graph would look better if we shortened the descriptive text
used in the keys.  Below we add

{phang2}
	{cmd:legend(label(1 "White males") label(2 "Black males"))}

{pstd}
to our previous command:{cmd}

	.    line le_wm year, yaxis(1 2) xaxis(1 2)
	  || line le_bm year
	  || line diff  year
	  || lfit diff  year
	  ||,
	     ylabel(0(5)20, axis(2) gmin angle(horizontal))
	     ylabel(0 20(10)80,     gmax angle(horizontal))
	     ytitle("", axis(2))
	     xlabel(1918, axis(2)) xtitle("", axis(2))
	     ylabel(, axis(2) grid)
	     ytitle("Life expectancy at birth (years)")
	     title("White and black life expectancy")
	     subtitle("USA, 1900-1999")
	     note("Source: National Vital Statistics, Vol 50, No. 6"
		  "(1918 dip caused by 1918 Influenza Pandemic)")
	     legend(label(1 "White males") label(2 "Black males")){txt}
	  {it:({stata gr_example2 line3:click to run})}

{pstd}
We might also consider moving the legend to the right of the graph, which
we can do by adding

	{cmd:legend(col(1) pos(3))}

{pstd}
resulting in{cmd}

	.    line le_wm year, yaxis(1 2) xaxis(1 2)
	  || line le_bm year
	  || line diff  year
	  || lfit diff  year
	  ||,
	     ylabel(0(5)20, axis(2) gmin angle(horizontal))
	     ylabel(0 20(10)80,     gmax angle(horizontal))
	     ytitle("", axis(2))
	     xlabel(1918, axis(2)) xtitle("", axis(2))
	     ylabel(, axis(2) grid)
	     ytitle("Life expectancy at birth (years)")
	     title("White and black life expectancy")
	     subtitle("USA, 1900-1999")
	     note("Source: National Vital Statistics, Vol 50, No. 6"
		  "(1918 dip caused by 1918 Influenza Pandemic)")
	     legend(label(1 "White males") label(2 "Black males"))
	     legend(col(1) pos(3)){txt}
	  {it:({stata gr_example2 line4:click to run})}
{* graph line4}{...}

{pstd}
See {manhelpi legend_options G-3} for more information about dealing with
legends.


{marker remarks4}{...}
{title:Cautions}

{pstd}
Be sure that the data are in the order of the {it:x} variable, or specify
{cmd:line}'s {cmd:sort} option.  If you do neither, you will get something
that looks like the scribblings of a child:

	{cmd:. sysuse auto, clear}

	{cmd:. line mpg weight}
	  {it:({stata "gr_example auto: line mpg weight":click to run})}
{* graph grline2}{...}
