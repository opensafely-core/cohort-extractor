{smcl}
{* *! version 1.1.0  22nov2016}{...}
{vieweralsosee "[G-2] graph7" "help graph7"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{viewerjumpto "Low-level graphics" "gph##low_level"}{...}
{viewerjumpto "Description" "gph##description"}{...}
{title:Out-of-date command}

{p 4 4 2}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {manhelp graph G-2} for the modern version.

{p 4 4 2}
{cmd:gph} is no longer a command of Stata.  Stata, however, still runs
{cmd:gph} whenever {cmd:gph} is invoked
under version control (see {manhelp version P}).


{marker low_level}{...}
{title:Low-level graphics}

{p 4 4 2}
{cmd:gph} is a programmer's command for constructing graphs.
In the diagrams below, {it:V} stands for {it:varname}.

{p 8 30 2}{cmd:version 7: gph open} {space 1} [{cmd:,} {cmd:saving(}{it:filename}{cmd:)}
{cmdab:xsiz:e:(}{it:#}{cmd:)} {cmdab:ysiz:e:(}{it:#}{cmd:)}]

	{cmd:version 7: gph close}

{p 8 30 2}{cmd:version 7: gph clear}{space 2}{it:#r1 #c1 #r2 #c2}

{p 8 30 2}{cmd:version 7: gph pen} {space 2} {it:#}

{p 8 30 2}{cmd:version 7: gph text} {space 1} {it:#r #c #rotation #alignment text}

{p 8 30 2}{cmd:version 7: gph font} {space 1} {it:#delta_r #delta_c}

{p 8 30 2}{cmd:version 7: gph vtext}{space 2}{it:Vr Vc V_str}
[{cmd:if} {it:exp}] [{cmd:in} {it:range}]

{p 8 30 2}{cmd:version 7: gph line} {space 1} {it:#r1 #c1 #r2 #c2}

{p 8 30 2}{cmd:version 7: gph vline}{space 2}{it:Vr Vc}
[{cmd:if} {it:exp}] [{cmd:in} {it:range}]

{p 8 30 2}{cmd:version 7: gph vpoly}{space 2}{it:Vr1 Vc1  Vr2 Vc2 ... Vrp Vcp}
[{cmd:if} {it:exp}] [{cmd:in} {it:range}]

{p 8 30 2}{cmd:version 7: gph box} {space 2} {it:#r1 #c1 #r2 #c2 #shade}

{p 8 30 2}{cmd:version 7: gph point}{space 2}{it:#r #c #delta_c #symbol}

{p 8 30 2}{cmd:version 7: gph vpoint} {it:Vr Vc} [{it:Vdelta_c Vsymbol}]
[{cmd:if} {it:exp}] [{cmd:in} {it:range}]
[{cmd:,} {cmd:size(}{it:#delta_c}{cmd:)} {cmd:symbol(}{it:#symbol}{cmd:)} ]

{p 8 30 2}{cmd:version 7: gph arc} {space 2} {it:#r #c #delta_c #phi1 #phi2 #shade}

{p 8 30 2}{cmdab:gr:aph} {it:...} [{cmd:,}
{cmd:bbox(}{it:bounding_box}{cmd:)} {it:...}]


{p 4 4 2}The graphics screen is

{center:(r_min,c_min)   (r_min,c_max)}
{center:(0,0)               (0,32000)}
{center:  {c TLC}{hline 23}{c TRC}  }
{center:  {c |}{space 23}{c |}  }
{center:  {c |}{space 23}{c |}  }
{center:  {c |}{space 23}{c |}  }
{center:  {c |}{space 23}{c |}  }
{center:  {c |}{space 23}{c |}  }
{center:  {c BLC}{hline 23}{c BRC}  }
{center:(23063,0)       (23063,32000)}
{center:(r_max,c_min)   (r_max,c_max)}


{p 4 4 2}
A {it:bounding_box} is defined as 7 comma-separated integers

{p 8 8 2}{it:#}{cmd:,} {it:#}{cmd:,} {it:#}{cmd:,} {it:#}{cmd:,}
{it:#}{cmd:,} {it:#}{cmd:,} {it:#}

{p 4 4 2}with the interpretation

{p 8 8 2}r_top,c_lft, r_bot,r_rgt, text height, text width, rotation


{p 4 4 2}
A mapping is defined as (y_min,y_max,x_min,x_max,a_y,b_y,a_x,b_x) such
that the value (y,x) is mapped to screen coordinates (r,c) via

{center:r = a_y*y + b_y    if y_min <= y <= y_max}
{center:c = a_x*x + b_x    if x_min <= x <= x_max}


    Rotation {it:#}'s are
	    {cmd:0}  horizontal
	    {cmd:1}  vertical

    Alignment {it:#}'s are
	   {cmd:-1}  left justified
	    {cmd:0}  centered
	    {cmd:1}  right justified

{p 4 4 2}
{it:#}'s for textsizes are recommended to be such that
{it:#delta_r}/{it:#delta_c} = 2.  The recommended text size is
{it:#delta_r}={cmd:923} and {it:#delta_c}={cmd:444}.

    The symbol {it:#}'s are
	    {cmd:0}  dot
	    {cmd:1}  large circle
	    {cmd:2}  square
	    {cmd:3}  triangle
	    {cmd:4}  small circle
	    {cmd:5}  diamond
	    {cmd:6}  plus
	    {cmd:7}  x
	    {cmd:8}  arrow
	    {cmd:9}  arrowf
	   {cmd:10}  pipe
	   {cmd:11}  v

{p 4 4 2}
The larger the size parameter {it:#delta_c}, the larger the symbol.
{it:#delta_c}={cmd:275} is recommended.

{p 4 4 2}
{it:#}'s for shading are the integers {cmd:0} to {cmd:4}, where 4 is the
darkest shading.

{p 4 4 2}
{it:#}'s for angles are measured from {cmd:0} to {cmd:32767}, clockwise.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:gph} provides programmers with access to Stata's low-level graphic
routines.  With these, virtually any graph can be programmed.

{p 4 4 2}
In addition, the high-level {cmd:graph} command has option
{cmd:bbox(}{it:bounding_box}{cmd:)} that instructs {cmd:graph} to place its
graphical output in the portion of the screen specified.  Thus, programmers
may use any high-level {cmd:graph} command as a subroutine.

{p 4 4 2}
{cmd:gph} commands may appear only inside a {cmd:program define}; {cmd:gph}
commands may not be typed interactively.
{p_end}
