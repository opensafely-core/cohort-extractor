{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] areastyle" "mansection G-4 areastyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "[G-2] graph pie" "help graph_pie"}{...}
{vieweralsosee "[G-2] graph twoway area" "help twoway_area"}{...}
{vieweralsosee "[G-2] graph twoway bar" "help twoway_bar"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{viewerjumpto "Syntax" "areastyle##syntax"}{...}
{viewerjumpto "Description" "areastyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "areastyle##linkspdf"}{...}
{viewerjumpto "Remarks" "areastyle##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4]} {it:areastyle} {hline 2}}Choices for look of regions{p_end}
{p2col:}({mansection G-4 areastyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col : {it:areastyle}}Description{p_end}
{p2line}
{p2col : {cmd:background}}determined by scheme{p_end}
{p2col : {cmd:foreground}}determined by scheme{p_end}
{p2col : {cmd:outline}}{cmd:foreground} outline with no fill{p_end}
{p2col : {cmd:plotregion}}default for plot regions{p_end}
{p2col : {cmd:histogram}}default used for bars of histograms{p_end}
{p2col : {cmd:ci}}default used for confidence interval{p_end}
{p2col : {cmd:ci2}}default used for second confidence interval{p_end}
{p2col : {cmd:none}}no outline and no background color{p_end}

{p2col : {cmd:p1bar} - {cmd:p15bar}}used by first - fifteenth "bar" plot{p_end}
{p2col : {cmd:p1box} - {cmd:p15box}}used by first - fifteenth "box" plot{p_end}
{p2col : {cmd:p1pie} - {cmd:p15pie}}used by first - fifteenth "pie" plot{p_end}
{p2col : {cmd:p1area} - {cmd:p15area}}used by first - fifteenth "area" plot
      {p_end}
{p2col : {cmd:p1} - {cmd:p15}}used by first - fifteenth "other" plot{p_end}
{p2line}
{p2colreset}{...}

{p 4 4 2}
Other {it:areastyles} may be available; type

	    {cmd:.} {bf:{stata graph query areastyle}}

{p 4 4 2}
to obtain the complete list of {it:areastyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
The shape of the area is determined by context.  The {it:areastyle}
determines whether the area is to be outlined and filled and, if so, how and
in what color.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 areastyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help areastyle##remarks1:Overview of areastyles}
	{help areastyle##remarks2:Numbered styles}
	{help areastyle##remarks3:Using numbered styles}
	{help areastyle##remarks4:When to use areastyles}


{marker remarks1}{...}
{title:Overview of areastyles}

{pstd}
{it:areastyle} is used to determine the look of

{phang}
1.  the entire region in which the graph appears{break}
    (see option
    {helpb region_options##style():style({it:areastyle})} in 
    {manhelpi region_options G-3})

{phang}
2.  bars{break}
    (see option
    {helpb barlook_options##bstyle():bstyle({it:areastyle})} in
    {manhelpi barlook_options G-3})

{phang}
3.  an area filled under a curve{break}
    (see option
    {helpb barlook_options##bstyle():bstyle({it:areastyle})} in
    {manhelpi barlook_options G-3})

{phang}
4.  most other enclosed areas, such as the boxes in 
    {help graph box:box plots}

{pstd}
For an example of the use of the {it:areastyle} {cmd:none}, see
{it:{help region_options##remarks3:Suppressing the border around the plot region}}
in {manhelpi region_options G-3}.


{* index numbered styles}{...}
{marker remarks2}{...}
{title:Numbered styles}

{phang}
     {cmd:p1bar} - {cmd:p15bar} are the default styles used for bar charts, 
        including {helpb twoway bar:twoway bar} charts and 
        {help graph bar:bar charts}.  {cmd:p1bar} is used for filling and
        outlining the first set of bars, {cmd:p2bar} for the second, and so
        on.

{phang}
     {cmd:p1box} - {cmd:p15box} are the default styles used for 
        {help graph box:box charts}.  {cmd:p1box} is used for filling and
        outlining the first set of boxes, {cmd:p2box} for the second, and so
        on.

{phang}
     {cmd:p1pie} - {cmd:p15pie} are the default styles used for 
        {help graph pie:pie charts}.  {cmd:p1pie} is used for filling the
        first pie slice, {cmd:p2pie} for the second, and so on.

{phang}
     {cmd:p1area} - {cmd:p15area} are the default styles used for area charts,
        including {helpb twoway area:twoway area} charts and 
        {helpb twoway rarea:twoway rarea} charts.  {cmd:p1area} is used for
        filling and outlining the first filled area, {cmd:p2area} for the
        second, and so on.

{phang}
     {cmd:p1} - {cmd:p15} are the default area styles used for other plottypes,
        including
	{helpb twoway dropline} charts,
        {helpb twoway spike} charts,
        {helpb twoway rspike} charts,
        {helpb twoway rcap} charts,
        {helpb twoway rcapsym} charts, and
        {helpb twoway rline} charts.    
        {cmd:p1} is used for filling and outlining the first plot,
        {cmd:p2} for the second, and so on.  For all the plots
	listed above, only lines are drawn, so the shade settings have no
	effect.


{marker remarks3}{...}
{title:Using numbered styles}

{pstd}
        The look defined by a numbered style, such as {cmd:p1bar} and
        {cmd:p2area}, is determined by the {help schemes:scheme}
        selected.  By "look" we mean such things as color, width of lines,
        and patterns used.

{pstd}
        Numbered styles provide default "looks" that can be
        controlled by a scheme.  They can also be useful when you wish to
        make, say, the third element on a graph look like the first.  You can,
        for example, specify that the third bar on a bar graph be drawn with
        the style of the first bar by specifying the option 
        {cmd:barstyle(3, bstyle(p1bar))}.


{marker remarks4}{...}
{title:When to use areastyles}

{pstd}
You can often achieve an identical result by specifying an {it:areastyle}
or using more specific options, such as {cmd:fcolor()} or {cmd:lwidth()},
that change the components of an areastyle -- the fill color and outline
attributes.  You can even specify an {it:areastyle} as the base and then
modify the attributes by using more specific options.  It is often easiest to
specify options that affect only the fill color or one outline
characteristic rather than to specify an {it:areastyle}.  If, however, you are
trying to make many elements on a graph look the same, specifying the overall
{it:areastyle} may be preferred.
{p_end}
