{smcl}
{* *! version 1.1.13  16apr2019}{...}
{viewerdialog "graph matrix" "dialog graph_matrix"}{...}
{vieweralsosee "[G-2] graph matrix" "mansection G-2 graphmatrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{viewerjumpto "Syntax" "graph_matrix##syntax"}{...}
{viewerjumpto "Menu" "graph_matrix##menu"}{...}
{viewerjumpto "Description" "graph_matrix##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_matrix##linkspdf"}{...}
{viewerjumpto "Options" "graph_matrix##options"}{...}
{viewerjumpto "Remarks" "graph_matrix##remarks"}{...}
{viewerjumpto "References" "graph_matrix##references"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-2] graph matrix} {hline 2}}Matrix graphs{p_end}
{p2col:}({mansection G-2 graphmatrix:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 43 2}
{cmdab:gr:aph}
{cmd:matrix}
{varlist}
{ifin}
[{it:{help graph matrix##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 30}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmd:half}}draw lower triangle only{p_end}

{p2col:{it:{help marker_options}}}look of markers{p_end}
{p2col:{it:{help marker_label_options}}}include labels on markers{p_end}
{p2col:{cmd:jitter(}{it:#}{cmd:)}}perturb location of markers{p_end}
{p2col:{cmd:jitterseed(}{it:#}{cmd:)}}random-number seed for {cmd:jitter()}
       {p_end}

{p2col:{cmdab:diag:onal:(}{it:stringlist}{cmd:,} ...{cmd:)}}override text on
       diagonal{p_end}
{p2col:{cmdab:diagopt:s(}{it:{help textbox_options}}{cmd:)}}rendition of text on
	diagonal

{p2col:{help scale_option:{bf:scale(}{it:#}{bf:)}}}overall size of symbols,
      labels, etc.{p_end}
{p2col:{cmd:iscale(}[{cmd:*}]{it:#}{cmd:)}}size of symbols, labels, within
       plots{p_end}

{p2col:{cmdab:max:es:(}{it:{help axis_scale_options}}}{p_end}
{p2col 15 37 39 2:{it:{help axis_label_options}}{cmd:)}}labels, ticks, grids, log scales, etc.{p_end}
{p2col:{it:{help axis_label_options}}}axis-by-axis control{p_end}

{p2col:{help by_option:{bf:by(}{it:varlist}{bf:, ...)}}}repeat for subgroups
        {p_end}

{p2col:{it:{help std_options}}}titles, aspect ratio, saving to disk{p_end}
{p2line}
{p2colreset}{...}
{phang}
All options allowed by
{cmd:graph} {cmd:twoway} {cmd:scatter} are also allowed, but they
are ignored.{p_end}
{phang}
{cmd:half},
{cmd:diagonal()},
{cmd:scale()}, and
{cmd:iscale()} are {it:unique};
{cmd:jitter()} and
{cmd:jitterseed()} 
are {it:rightmost} and
{cmd:maxes()} is {it:merged-implicit};
see {help repeated options}.

{pstd}
{it:stringlist}{cmd:,} ...,
the argument allowed by {cmd:diagonal()},
is defined

{pin}
[{c -(}{cmd:.}|{cmd:"}{it:string}{cmd:"}{c )-}]
[ {c -(}{cmd:.}|{cmd:"}{it:string}{cmd:"}{c )-} ... ]
[{cmd:,} {it:{help textbox_options}}]

{marker weight}{...}
{pstd}
{cmd:aweight}s,
{cmd:fweight}s, and
{cmd:pweight}s are allowed; see {help weight}.
Weights affect the size of the markers.
See {it:{help scatter##remarks14:Weighted markers}} in
{manhelp scatter G-2:graph twoway scatter}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Scatterplot matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:matrix}
draws scatterplot matrices.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphmatrixQuickstart:Quick start}

        {mansection G-2 graphmatrixRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:half}
    specifies that only the lower triangle of the scatterplot matrix be
    drawn.

{phang}
{it:marker_options}
    specify the look of the markers used to designate the location of the
    points.  The important {it:marker_options} are
    {cmd:msymbol()}, {cmd:mcolor()}, and {cmd:msize()}.

{pmore}
    The default symbol used is {cmd:msymbol(O)} -- solid circles.  You
    specify {cmd:msymbol(Oh)} if you want hollow circles (a recommended
    alternative).  If you have many observations, we recommend specifying
    {cmd:msymbol(p)}; see
    {it:{help graph matrix##remarks2:Marker symbols and the number of observations}}
    under {it:Remarks} below.  See {manhelpi symbolstyle G-4} for a list of
    marker symbol choices.

{pmore}
    The default {cmd:mcolor()} is dictated by the scheme; see 
    {manhelp schemes G-4:Schemes intro}.  See {manhelpi colorstyle G-4} for a
    list of color choices.

{pmore}
    Be careful specifying the {cmd:msize()} option.  In {cmd:graph}
    {cmd:matrix}, the size of the markers varies with the number of variables
    specified; see option {helpb graph matrix##iscale():iscale()} below.  If
    you specify {cmd:msize()}, that will override the automatic scaling.

{pmore}
    See {manhelpi marker_options G-3} for more information on markers.

{phang}
{it:marker_label_options}
    allow placing identifying labels on the points.  To obtain this, you
    specify the {it:marker_label_option} {cmd:mlabel(}{varname}{cmd:)}; see
    {manhelpi marker_label_options G-3}.  These options are of
    little use for scatterplot matrices because they make the graph
    seem too crowded.

{phang}
{cmd:jitter(}{it:#}{cmd:)}
    adds spherical random noise to the data before plotting.
    {it:#} represents the size of the noise as a percentage of the graphical
    area.  This is useful when plotting data which otherwise would
    result in points plotted on top of each other.  See
    {it:{help scatter##remarks15:Jittered markers}} in
    {manhelp scatter G-2:graph twoway scatter} for an
    explanation of jittering.

{phang}
{cmd:jitterseed(}{it:#}{cmd:)}
     specifies the seed for the random noise added by the {cmd:jitter()}
     option.  {it:#} should be specified as a positive integer.  Use this
     option to reproduce the same plotted points when the
     {cmd:jitter()} option is specified.

{phang}
{cmd:diagonal(}[{it:stringlist}][{cmd:,} {it:textbox_options}]{cmd:)}
    specifies text and its style to be displayed along the diagonal.
    This text serves to label the graphs (axes).
    By default, what appears along the diagonals are the variable labels
    of the variables of {varlist} or, if a variable has no variable
    label, its name.  Typing

{phang3}
	    {cmd:. graph matrix mpg weight displ, diag(. "Weight of car")}

{pmore}
    would change the text appearing in the cell corresponding to variable
    {cmd:weight}.  We specified period ({cmd:.}) to leave the text
    in the first cell unchanged, and we did not bother to type
    a third string or a period, so we left the third element unchanged, too.

{pmore}
    You may specify {it:textbox_options} following {it:stringlist} (which may
    itself be omitted) and a comma.  These options will modify the style in
    which the text is presented but are of little use here.  We
    recommend that you do not specify {cmd:diagonal(,size())} to override the
    default sizing of the text.  By default, the size of text varies with the
    number of variables specified; see option
    {helpb graph matrix##iscale():iscale()} below.
    Specifying {cmd:diagonal(,size())} will override the automatic size
    scaling.  See {manhelpi textbox_options G-3} for more information on
    textboxes.

{phang}
{opth diagopts:(textbox_options)} specify the look of text on the diagonal.
This option is a shortcut for
{cmd:diagonal(, }{it:textbox_options}{cmd:)}.

{phang}
{cmd:scale(}{it:#}{cmd:)}
    specifies a multiplier that affects the size of all text and
    markers in a graph.  {cmd:scale(1)} is the default, and {cmd:scale(1.2)}
    would make all text and markers 20% larger.
    See {manhelpi scale_option G-3}.

{marker iscale()}{...}
{phang}
{cmd:iscale(}{it:#}{cmd:)}
and
{cmd:iscale(*}{it:#}{cmd:)}
    specify an adjustment (multiplier) to be used to scale the markers,
    the text appearing along the diagonals, and the labels and ticks appearing
    on the axes.

{pmore}
    By default, {cmd:iscale()} gets smaller and smaller the larger
    {it:n} is, the number of variables specified in {varlist}.
    The default is parameterized as a multiplier
    f({it:n}) -- 0<f({it:n})<1, f'({it:n})<0 -- that is used as a
    multiplier for {cmd:msize()}, {cmd:diagonal(,size())},
    {cmd:maxes(labsize())}, and {cmd:maxes(tlength())}.

{pmore}
    If you specify {cmd:iscale(}{it:#}{cmd:)}, the number you specify is
    substituted for f({it:n}).  We recommend that you specify a number between
    0 and 1, but you are free to specify numbers larger than 1.

{pmore}
    If you specify {cmd:iscale(*}{it:#}{cmd:)}, the number you specify is
    multiplied by f({it:n}), and that product is used to scale text.
    Here you should specify {it:#}>0; {it:#}>1
    merely means you want the text to be bigger than {cmd:graph}
    {cmd:matrix} would otherwise choose.

{phang}
{cmd:maxes(}{it:axis_scale_options axis_label_options}{cmd:)}
    affect the scaling and look of the axes.  This is a case where you specify
    options within options.

{pmore}
    Consider the {it:axis_scale_options}
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(log)}, which produces logarithmic scales.
    Type {cmd:maxes(yscale(log)} {cmd:xscale(log))} to draw
    the scatterplot matrix by using log scales.  Remember to specify both
    {cmd:xscale(log)} and {cmd:yscale(log)}, unless you really
    want just the {it:y} axis or just the {it:x} axis logged.

{pmore}
    Or consider the {it:axis_label_options}
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label(,grid)}, which adds grid lines.
    Specify
    {cmd:maxes(ylabel(,grid))} to add grid lines across,
    {cmd:maxes(xlabel(,grid))} to add grid lines vertically,
    and both options to add grid lines in both directions.
    When using both, you can specify the {cmd:maxes()} option
    twice -- {cmd:maxes(ylabel(,grid)) maxes(xlabel(,grid))} -- or
    once combined -- {cmd:maxes(ylabel(,grid) xlabel(,grid))} -- it
    makes no difference because {cmd:maxes()} is {it:merged-implicit}; see
    {help repeated options}.

{pmore}
    See {manhelpi axis_scale_options G-3} and
    {manhelpi axis_label_options G-3} for the suboptions that may appear
    inside {cmd:maxes()}.  In reading those entries, ignore the
    {cmd:axis(}{it:#}{cmd:)} suboption; {cmd:graph} {cmd:matrix} will ignore
    it if you specify it.

{marker axis_label_options_desc}{...}
{phang}
{it:axis_label_options}
    allow you to assert axis-by-axis control over the labeling.  Do not
    confuse this with {cmd:maxes(}{it:axis_label_options}{cmd:)},
    which specifies options that affect all the axes.
    {it:axis_label_options} specified outside the {cmd:maxes()} option
    specify options that affect just one of the axes.  {it:axis_label_options}
    can be repeated for each axis.

{pmore}
    When you specify {it:axis_label_options} outside {cmd:maxes()},
    you must specify the axis-label suboption {cmd:axis(}{it:#}{cmd:)}.
    For instance, you might type

{phang3}
	    {cmd:. graph matrix mpg weight displ, ylabel(0(5)40, axis(1))}

{pmore}
    The effect of that would be to label the specified values on the
    first {it:y} axis (the one appearing on the far right).
    The axes are numbered as follows:

			       {it:x}               {it:x}
			     {cmd:axis(2)}         {cmd:axis(4)}
		    {c TLC}{hline 7}{c TT}{hline 7}{c TT}{hline 7}{c TT}{hline 7}{c TT}{hline 7}{c TRC}
{...}
		    {c |}       {c |} v1/v2 {c |} v1/v3 {c |} v1/v4 {c |} v1/v5 {c |}  {it:y} {cmd:axis(1)}
{...}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c RT}
{...}
	  {it:y} {cmd:axis(2)} {c |} v2/v1 {c |}       {c |} v2/v3 {c |} v2/v4 {c |} v2/v5 {c |}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c RT}
{...}
		    {c |} v3/v1 {c |} v3/v2 {c |}       {c |} v3/v4 {c |} v3/v5 {c |}  {it:y} {cmd:axis(3)}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c RT}
{...}
	  {it:y} {cmd:axis(4)} {c |} v4/v1 {c |} v4/v2 {c |} v4/v3 {c |}       {c |} v4/v5 {c |}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c RT}
{...}
		    {c |} v5/v1 {c |} v5/v2 {c |} v5/v3 {c |} v5/v4 {c |}       {c |}  {it:y} {cmd:axis(5)}
		    {c BLC}{hline 7}{c BT}{hline 7}{c BT}{hline 7}{c BT}{hline 7}{c BT}{hline 7}{c BRC}
		        {it:x               x               x}
		      {cmd:axis(1)         axis(3)         axis(5)}

{pmore}
and if {cmd:half} is specified, the numbering scheme is

		    {c TLC}{hline 7}{c TRC}
		    {c |}       {c |}
		    {c LT}{hline 7}{c +}{hline 7}{c TRC}
	  {it:y} {cmd:axis(2)} {c |} v2/v1 {c |}       {c |}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c TRC}
	  {it:y} {cmd:axis(3)} {c |} v3/v1 {c |} v3/v2 {c |}       {c |}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c TRC}
{...}
	  {it:y} {cmd:axis(4)} {c |} v4/v1 {c |} v4/v2 {c |} v4/v3 {c |}       {c |}
		    {c LT}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c +}{hline 7}{c TRC}
{...}
	  {it:y} {cmd:axis(5)} {c |} v5/v1 {c |} v5/v2 {c |} v5/v3 {c |} v5/v4 {c |}       {c |}
{...}
		    {c BLC}{hline 7}{c BT}{hline 7}{c BT}{hline 7}{c BT}{hline 7}{c BT}{hline 7}{c BRC}
{...}
		       {it:x       x       x       x       x}
		     {cmd:axis(1) axis(2) axis(3) axis(4) axis(5)}

{pmore}
    See {manhelpi axis_label_options G-3}; remember to specify the
    {cmd:axis(}{it:#}{cmd:)} suboption, and do not specify the
    {cmd:graph matrix} option {cmd:maxes()}.

{phang}
{cmd:by(}{varlist}{cmd:,} ...{cmd:)}
    allows drawing multiple graphs for each subgroup of the data.
    See {it:{help graph matrix##remarks6:Use with by()}} under {it:Remarks}
    below, and see {manhelpi by_option G-3}.

{phang}
{it:std_options}
    allow you to specify titles
    (see {it:{help graph matrix##remarks5:Adding titles}} under {it:Remarks} below,
    and see {manhelpi title_options G-3}), control the aspect ratio and
    background shading (see {manhelpi region_options G-3}), control the overall
    look of the graph (see {manhelpi scheme_option G-3}), and save the graph to
    disk (see {manhelpi saving_option G-3}).

{pmore}
    See {manhelpi std_options G-3} for an overview of the standard options.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph matrix##remarks1:Typical use}
	{help graph matrix##remarks2:Marker symbols and the number of observations}
	{help graph matrix##remarks3:Controlling the axes labeling}
	{help graph matrix##remarks4:Adding grid lines}
	{help graph matrix##remarks5:Adding titles}
	{help graph matrix##remarks6:Use with by()}
	{help graph matrix##remarks7:History}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:graph} {cmd:matrix} provides an excellent alternative to
correlation matrices (see {manhelp correlate R}) as a quick way to examine
the relationships among variables:

	{cmd:. sysuse lifeexp}

	{cmd:. graph matrix popgrowth-safewater}
	  {it:({stata "gr_example lifeexp: gr matrix popgrowth-safewater":click to run})}
{* graph grmatrix1}{...}

{pstd}
Seeing the above graph, we are tempted to transform {cmd:gnppc} into
log units:

	{cmd:. generate lgnppc = ln(gnppc)}

	{cmd:. graph matrix popgr lexp lgnp safe}
	  {it:({stata "gr_example2 matrix1":click to run})}
{* graph grmatrix2}{...}

{pstd}
Some people prefer showing just half the matrix, moving the "dependent"
variable to the end of the list:

	{cmd:. graph matrix popgr lgnp safe lexp, half}
	  {it:({stata "gr_example2 matrix2":click to run})}
{* graph grmatrix3}{...}


{marker remarks2}{...}
{title:Marker symbols and the number of observations}

{pstd}
The {cmd:msymbol()} option -- abbreviation {cmd:ms()} -- allows us to
control the marker symbol used; see {manhelpi marker_options G-3}.
Hollow symbols sometimes work better as the number of observations increases:

	{cmd:. sysuse auto, clear}

	{cmd:. graph mat mpg price weight length, ms(Oh)}
	  {it:({stata "gr_example auto: gr mat mpg price weight length, ms(Oh)":click to run})}
{* graph grmatrix4}{...}

{pstd}
Points work best when there are many data:

	{cmd:. sysuse citytemp, clear}

	{cmd:. graph mat heatdd-tempjuly, ms(p)}
	  {it:({stata "gr_example citytemp: gr mat heatdd-tempjuly, ms(p)":click to run})}
{* graph citytemp}{...}


{marker remarks3}{...}
{title:Controlling the axes labeling}

{pstd}
By default, approximately three values are labeled and ticked on the {it:y} and
{it:x} axes.  When graphing only a few variables, increasing this often works
well:

	{cmd:. sysuse citytemp, clear}

{phang2}
	{cmd:. graph mat heatdd-tempjuly, ms(p) maxes(ylab(#4) xlab(#4))}
{p_end}
	  {it:({stata "gr_example citytemp: gr mat heatdd-tempjuly, ms(p) maxes(ylab(#4) xlab(#4))":click to run})}
{* graph citytemp2}{...}

{pstd}
Specifying {cmd:#4} does not guarantee four labels; it specifies that
approximately four labels be used; see {manhelpi axis_label_options G-3}.  Also
see {help graph matrix##axis_label_options_desc:{it:axis_label_options}} under {it:Options} above for instructions on
controlling the axes individually.


{marker remarks4}{...}
{title:Adding grid lines}

{pstd}
To add horizontal grid lines, specify {cmd:maxes(ylab(,grid))},
and to add vertical grid lines,
specify {cmd:maxes(xlab(,grid))}.
Below we do both and specify that four values be labeled:

	{cmd:. sysuse lifeexp, clear}

	{cmd:. generate lgnppc = ln(gnppc)}

{phang2}
	{cmd:. graph matrix popgr lexp lgnp safe, maxes(ylab(#4, grid) xlab(#4, grid))}
{p_end}
	  {it:({stata "gr_example2 matrix3":click to run})}
{* graph matrix3}{...}


{marker remarks5}{...}
{title:Adding titles}

{pstd}
The standard title options may be used with {cmd:graph} {cmd:matrix}:

	{cmd:. sysuse lifeexp, clear}

	{cmd:. generate lgnppc = ln(gnppc)}

	{cmd:. label var lgnppc "ln GNP per capita"}

	{cmd:. graph matrix popgr lexp lgnp safe, maxes(ylab(#4, grid) xlab(#4, grid))}
	{cmd:                  subtitle("Summary of 1998 life-expectancy data")}
	{cmd:                  note("Source:  The World Bank Group")}
	  {it:({stata "gr_example2 matrix4":click to run})}
{* graph matrix4}{...}


{marker remarks6}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:matrix} may be used with {cmd:by()}:

	{cmd:. sysuse auto, clear}

	{cmd:. graph matrix mpg weight displ, by(foreign)}
	  {it:({stata "gr_example auto: gr matrix mpg weight displ, by(foreign)":click to run})}
{* graph grmatrix5}{...}

{pstd}
See {manhelpi by_option G-3}.


{* index histories}{...}
{* index Hartigan 1975}{...}
{* index Tukey and Tukey 1981}{...}
{* index Chambers et al. 1983}{...}
{* index Becker and Chambers 1984}{...}
{marker remarks7}{...}
{title:History}

{pstd}
The origin of the scatterplot matrix is unknown, although early written
discussions may be found in
{help graph matrix##H1975:Hartigan (1975)},
{help graph matrix##TT1981:Tukey and Tukey (1981)}, and
{help graph matrix##C1983:Chambers et al. (1983)}.  The scatterplot matrix has
also been called the {it:draftman's display} and {it:pairwise scatterplot}.
Regardless of the name used, we believe that the first "canned" implementation
was by Becker and Chambers in a system called S -- see
{help graph matrix##BC1984:Becker and Chambers (1984)} -- although S predates
1984.  We also believe that Stata provided the second implementation, in 1985.


{marker references}{...}
{title:References}

{marker BC1984}{...}
{phang}
Becker, R. A., and J. M. Chambers. 1984.
{it:S: An Interactive Environment for Data Analysis and Graphics}.
Belmont, CA: Wadsworth.

{marker C1983}{...}
{phang}
Chambers, J. M., W. S. Cleveland, B. Kleiner, and P. A. Tukey. 1983.
{it:Graphical Methods for Data Analysis}.
Belmont, CA: Wadsworth.

{marker H1975}{...}
{phang}
Hartigan, J. A. 1975. Printer graphics for clustering.
{it:Journal of Statistical Computation and Simulation} 4: 187-213.

{marker TT1981}{...}
{phang}
Tukey, P. A., and J. W. Tukey. 1981. Preparation; prechosen sequences of
views. In {it:Interpreting Multivariate Data}, ed. V. Barnett, 189-213.
Chichester, UK: Wiley.
{p_end}
