{smcl}
{* *! version 1.1.6  18feb2020}{...}
{viewerdialog marginsplot "dialog marginsplot"}{...}
{vieweralsosee "[R] marginsplot" "mansection R marginsplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] margins, contrast" "help margins_contrast"}{...}
{vieweralsosee "[R] margins, pwcompare" "help margins_pwcompare"}{...}
{vieweralsosee "[R] margins postestimation" "help margins_postestimation"}{...}
{viewerjumpto "Syntax" "marginsplot##syntax"}{...}
{viewerjumpto "Menu" "marginsplot##menu"}{...}
{viewerjumpto "Description" "marginsplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "marginsplot##linkspdf"}{...}
{viewerjumpto "Options" "marginsplot##options"}{...}
{viewerjumpto "Examples" "marginsplot##examples"}{...}
{viewerjumpto "Video examples" "marginsplot##video"}{...}
{viewerjumpto "Addendum: Advanced uses of dimlist" "marginsplot##dimlist2"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[R] marginsplot} {hline 2}}Graph results from margins 
   (profile plots, etc.){p_end}
{p2col:}({mansection R marginsplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}{cmd:marginsplot} [{cmd:,} {it:options}]

{synoptset 37 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{cmdab:x:dimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)}}use
	{it:dimlist} to define x axis{p_end}
{synopt:{cmdab:plot:dimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)}}create
	plots for groups in {it:dimlist}{p_end}
{synopt:{cmdab:by:dimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)}}create 
	subgraphs for groups in {it:dimlist}{p_end}
{synopt:{cmdab:gr:aphdimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)}}create 
	graphs for groups in {it:dimlist}{p_end}
{synopt:{opt horiz:ontal}}swap 
	x and y axes{p_end}
{synopt:{opt noci}}do 
	not plot confidence intervals{p_end}
{synopt:{opt derivlab:els}}use labels attached to marginal-effects variables{p_end}
{synopt:{cmd:name(}{it:name}|{it:stub} [{cmd:, replace}]{cmd:)}}name 
	of graph, or stub if multiple graphs{p_end}

{syntab:Labels}
{synopt:{opt allx:labels}}place 
	ticks and labels on the x axis for each value{p_end}
{synopt:{opt nolab:els}}label 
	groups with their values, not their labels{p_end}
{synopt:{opt allsim:plelabels}}forgo
	variable name and equal signs in all labels{p_end}
{synopt:{opt nosim:plelabels}}include
	variable name and equal signs in all labels{p_end}
{synopt:{opth sep:arator(strings:string)}}separator
	for labels when multiple variables are specified in a dimension{p_end}
{synopt:{opt nosep:arator}}do not use a separator{p_end}

{syntab:Plot}
{synopt :{cmdab:plotop:ts(}{it:{help marginsplot##plotopts:plot_options}}{cmd:)}}affect 
	rendition of all margin plots{p_end}
{synopt :{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help marginsplot##plotopts:plot_options}}{cmd:)}}affect 
        rendition of {it:#}th margin plot{p_end}
{synopt:{opth recast:(twoway:plottype)}}plot
	margins using {it:plottype}{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(rcap_options)}}affect 
	rendition of all confidence interval plots{p_end}
{synopt :{cmdab:ci:}{ul:{it:#}}{cmd:opts(}{it:{help rcap_options}}{cmd:)}}affect
        rendition of {it:#}th confidence interval plot{p_end}
{synopt:{opth recastci:(twoway:plottype)}}plot
	confidence intervals using {it:plottype}{p_end}
{synopt:{opth mcomp:are(marginsplot##method:method)}}adjust for multiple comparisons{p_end}
{synopt:{opt l:evel(#)}}set confidence level{p_end}

{syntab:Pairwise}
{synopt:{opt uniq:ue}}plot only unique pairwise comparisons{p_end}
{synopt:{opt csort}}sort comparison categories first{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the 
	graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any 
	options documented in {manhelpi twoway_options G-3}{p_end}
{synopt :{opth byop:ts(by_option:byopts)}}how 
	subgraphs are combined, labeled, etc.{p_end}
{synoptline}
{marker dimlist}{...}
{phang}
    where {it:dimlist} may be any of the dimensions across which margins were
    computed in the immediately preceding {helpb margins} command.  That is
    to say, {it:dimlist} may be any variable used in the {cmd:margins} command,
    including variables specified in the {cmd:at()}, {cmd:over()}, and
    {cmd:within()} options.  More advanced specifications of {it:dimlist} are
    covered in
    {it:{help marginsplot##dimlist2:Addendum: Advanced uses of dimlist}} below.

{marker dimopts}{...}
{synoptset 26}{...}
{synopthdr:dimopts}
{synoptline}
{synopt:{opt lab:els(lablist)}}list
	of quoted strings to label each level of the dimension{p_end}
{synopt:{opt elab:els(elablist)}}list of
	enumerated labels{p_end}
{synopt:{opt nolab:els}}label 
	groups with their values, not their labels{p_end}
{synopt:{opt allsim:plelabels}}forgo
	variable name and equal signs in all labels{p_end}
{synopt:{opt nosim:plelabels}}include
	variable name and equal signs in all labels{p_end}
{synopt:{opth sep:arator(strings:string)}}separator
	for labels when multiple variables are specified in the dimension{p_end}
{synopt:{opt nosep:arator}}do 
	not use a separator{p_end}
{synoptline}

{pstd}
where {it:lablist} is defined as

{p 8 16 2}
{cmd:"}{it:label}{cmd:"} [{cmd:"}{it:label}{cmd:"} [...]]

{pstd}
{it:elablist} is defined as

{p 8 16 2}
{it:#} {cmd:"}{it:label}{cmd:"} [{it:#} {cmd:"}{it:label}{cmd:"} [...]]

{pstd}
and the {it:#}s are the indices of the levels of the dimension -- 1 is the
first level, 2 is the second level, and so on.

{marker plotopts}{...}
{synoptset 25}{...}
{synopthdr:plot_options}
{synoptline}
INCLUDE help gr_markopt2
INCLUDE help gr_clopt
{synoptline}

{p2colreset}{...}
{marker method}{...}
{synoptset 25}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt noadj:ust}}do not adjust for multiple comparisons{p_end}
{synopt:{opt bon:ferroni} [{opt adjustall}]}Bonferroni's method; adjust across all terms{p_end}
{synopt:{opt sid:ak} [{opt adjustall}]}Sidak's method; adjust across all terms{p_end}
{synopt:{opt sch:effe}}Scheffe's method{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:marginsplot} graphs the results of the immediately preceding 
{helpb margins} command.  Common names for some of the graphs that
{cmd:marginsplot} can produce are profile plots and interaction plots.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R marginsplotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt xdimension()}, {opt plotdimension()}, {opt bydimension()}, and
        {opt graphdimension()} specify the variables from the preceding
        {cmd:margins} command whose group levels will be used for the graph's
        x axis, plots, {cmd:by()} subgraphs, and graphs.  
	
{pmore}
        {cmd:marginsplot} chooses default dimensions based on the
        {cmd:margins} command.  In most cases, the first variable appearing in
        an {cmd:at()} option and evaluated over more than one value is used
        for the x axis.  If no {cmd:at()} variable meets this condition,
        the first variable in the {it:marginlist} is usually used for the
        x axis and the remaining variables determine the plotted lines or
        markers.  Pairwise comparisons and graphs of marginal effects
        (derivatives) have different defaults.  In all cases, you may override
        the defaults and explicitly control which variables are used on each
        dimension of the graph by using these dimension options.

{pmore}
        Each of these options supports 
        {help marginsplot##dimopts:suboptions} that control the labeling of
        the dimension -- axis labels for {opt xdimension()}, plot labels for
        {opt plotdimension()}, subgraph titles for {opt bydimension()}, and
        graph titles for {opt graphdimension()} titles.

{pmore}
	For examples using the dimension options, see
	{it:{mansection R marginsplotRemarksandexamplesControllingthegraphsdimensions:Controlling the graph's dimensions}} in {bf:[R] marginsplot}.

{phang2}
{cmd:xdimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)} specifies
        the variables for the x axis in {it:dimlist} and controls the
        content of those labels with {it:dimopts}.

{phang2}
{cmd:plotdimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)} specifies
	in {it:dimlist} the variables whose group levels determine the plots
	and optionally specifies in {it:dimopts} the content of the plots'
	labels.

{phang2}
{cmd:bydimension(}{help marginsplot##dimlist:{it:dimlist}} [{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)} specifies
        in {it:dimlist} the variables whose group levels determine the
        {cmd:by()} subgraphs and optionally specifies in {it:dimopts} the
        content of the subgraphs' titles.  For an example using {cmd:by()},
        see {it:{mansection R marginsplotRemarksandexamplesThree-wayinteractions:Three-way interactions}} in {bf:[R] marginsplot}.

{phang2}
{cmd:graphdimension(}{help marginsplot##dimlist:{it:dimlist}}
[{cmd:,} {help marginsplot##dimopts:{it:dimopts}}]{cmd:)} specifies in
{it:dimlist} the variables whose group levels determine the graphs and
optionally specifies in {it:dimopts} the content of the graphs' titles.

{phang}
{opt horizontal} reverses the default x and y axes.  By default, the
	y axis represents the estimates of the margins and the x
	axis represents one or more factors or continuous covariates.
	Specifying {opt horizontal} swaps the axes so that the x axis
	represents the estimates of the margins.  This option can be useful if
	the labels on the factor or continuous covariates are long.  

{pmore}
	The horizontal option is discussed in 
	{it:{mansection R marginsplotRemarksandexamplesHorizontalissometimesbetter:Horizontal is sometimes better}} in {bf:[R] marginsplot}.

{phang}
{opt noci} removes plots of the pointwise confidence intervals.  The default 
	is to plot the confidence intervals.

{phang}
{cmd:derivlabels} specifies that variable labels attached to marginal-effects
variables be used in place of the variable names in titles and legends.
Marginal-effects variables are the ones specified in {cmd:margins}'s option
{cmd:dydx()}, {cmd:dyex()}, {cmd:eydx()}, or {cmd:eyex()}.

{phang}
{cmd:name(}{it:name}|{it:stub} [{cmd:, replace}]{cmd:)} specifies the
        name of the graph or graphs.  If the {cmd:graphdimension()} option
        is specified, or if the default action is to produce multiple graphs,
        then the argument of {opt name()} is taken to be {it:stub} and
        graphs named {it:stub}{cmd:1}, {it:stub}{cmd:2}, ... are created.  
	
{pmore}
        The {opt replace} suboption causes existing graphs with the specified
        name or names to be replaced.

{pmore}
        If {cmd:name()} is not specified, default names are used and the graphs
        may be replaced by subsequent {cmd:marginsplot} or other graphing
        commands.

{dlgtab:Labels}
	
{pstd}
With the exception of {opt allxlabels}, all of these options may be specified
either directly as options or as {it:dimopts} within options 
{opt xdimension()}, {opt plotdimension()}, {opt bydimension()}, and 
{opt graphdimension()}.  When specified in one of the dimension options, only the
labels for that dimension are affected.  When specified outside the
dimension options, all labels on all dimensions are affected.  Specifications
within the dimension options take precedence.

{phang}
{opt allxlabels} specifies that tick marks and labels be placed on the x
	axis for each value of the x-dimension variables.  By default, if
	there are more than 25 ticks, default graph axis labeling
	rules are applied.  Labeling may also be specified using the
	standard {cmd:graph twoway} x-axis label
        {help axis label options:rules and options} -- {cmd:xlabel()}.

{phang}
{opt nolabels} specifies that value labels not be used to construct graph
        labels and titles for the group levels in the dimension.  By default,
        if a variable in a dimension has value labels, those labels are used
        to construct labels and titles for axis ticks, plots, subgraphs, and
        graphs.  
	
{pmore} 
	Graphs of contrasts and pairwise comparisons are an exception
        to this rule and are always labeled with values rather than value
        labels.

{phang}
{opt allsimplelabels} and {opt nosimplelabels}
        control whether graphs' labels and titles include just the values of
        the variables or include variable names and equal signs.  The default
	is to use just the value label for variables that have value labels
	and to use variable names and equal signs for variables that do not
	have value labels.  An example of the former is "Female" and the
	latter is "country=2".

{pmore}
	Sometimes, value labels are universally descriptive, and sometimes
	they have meaning only when considered in relation to their variable.
	For example, "Male" and "Female" are typically universal, regardless
	of the variable from which they are taken.  "High" and "Low" may not
	have meaning unless you know they are in relation to a specific
	measure, say, blood-pressure level.  The {opt allsimplelabels} and
	{opt nosimplelabels} options let you override the default labeling.

{phang2}
{opt allsimplelabels}
	specifies that all titles and labels use just the value or value label
	of the variable.

{phang2}
{opt nosimplelabels}
	specifies that all titles and labels include {it:varname}{cmd:=} before
        the value or value label of the variable.

{phang}
{opth separator:(strings:string)} and {opt noseparator} control the separator
       between label sections when more than one variable is used to specify a
       dimension.  The default separator is a comma followed by a space, but
       no separator may be requested with {opt noseparator} or the default
       may be changed to any string with {opt separator()}.

{pmore} 
        For example, if {cmd:plotdimension(a b)} is specified, the plot labels
        in our graph legend might be "a=1, b=1", "a=1, b=2", ... . Specifying
        {cmd:separator(:)} would create labels "a=1:b=1", "a=1:b=2", ... .

{dlgtab:Plot}

{phang}
{cmd:plotopts(}{it:{help marginsplot##plotopts:plot_options}}{cmd:)}
        affects the rendition of all margin plots.  The {it:plot_options} can
        affect the size and color of markers, whether and how the markers are
        labeled, and whether and how the points are connected; 
        see {manhelpi marker_options G-3}, 
        {manhelpi marker_label_options G-3}, and {manhelpi cline_options G-3}.

{pmore} 
        These settings may be overridden for specific plots by using the
        {cmd:plot}{it:#}{cmd:opts()} option.

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:{help marginsplot##plotopts:plot_options}}{cmd:)}
        affects the rendition of the {it:#}th margin plot.  The
        {it:plot_options} can affect the size and color of markers, whether
        and how the markers are labeled, and whether and how the points are
        connected; see {manhelpi marker_options G-3}, 
        {manhelpi marker_label_options G-3}, and {manhelpi cline_options G-3}.

{phang}
{opt recast(plottype)}
	specifies that margins be plotted using {it:plottype}.  
        {it:plottype} may be {cmd:scatter}, {cmd:line}, {cmd:connected},
        {cmd:bar}, {cmd:area}, {cmd:spike}, {cmd:dropline}, or {cmd:dot}; see
	{manhelp graph_twoway G-2:graph twoway}.  When {cmd:recast()} is
	specified, the plot-rendition options appropriate to the specified
        {it:plottype} may be used in lieu of
	{it:{help marginsplot##plotopts:plot_options}}.  For details on those
        options, follow the appropriate link from
        {manhelp graph_twoway G-2:graph twoway}.

{pmore} 
	For an example using {cmd:recast()}, see
	{it:{mansection R marginsplotRemarksandexamplesContinuouscovariates:Continuous covariates}} in {bf:[R] marginsplot}.

{pmore} 
	You may specify {cmd:recast()} within a {cmd:plotopts()} or
        {cmd:plot}{it:#}{cmd:opts()} option.  It is better, however, to
        specify it as documented here, outside those options.  When
        specified outside those options, you have greater access to the
        plot-specific rendition options of your specified {it:plottype}.

{dlgtab:CI plot}

{phang}
{opt ciopts(rcap_options)} 
        affects the rendition of all confidence interval plots; see 
	{manhelpi rcap_options G-3}.

{pmore} 
        These settings may be overridden for specific confidence interval
        plots with the {cmd:ci}{it:#}{cmd:opts()} option.

{phang}
{cmd:ci}{it:#}{cmd:opts(}{it:rcap_options}{cmd:)} 
        affects the rendition of the {it:#}th confidence interval; see
        {manhelpi rcap_options G-3}.

{phang}
{opt recastci(plottype)}
        specifies that confidence intervals be plotted using {it:plottype}.
        {it:plottype} may be {cmd:rarea}, {cmd:rbar}, {cmd:rspike},
        {cmd:rcap}, {cmd:rcapsym}, {cmd:rline}, {cmd:rconnected}, or
        {cmd:rscatter}; see {manhelp graph_twoway G-2:graph twoway}.  When
        {cmd:recastci()} is
        specified, the plot-rendition options appropriate to the specified
        {it:plottype} may be used in lieu of {it:rcap_options}.  For details
        on those options, follow the appropriate link from 
        {manhelp graph_twoway G-2:graph twoway}.

{pmore} 
	For an example using {cmd:recastci()}, see
	{it:{mansection R marginsplotRemarksandexamplesContinuouscovariates:Continuous covariates}} in {bf:[R] marginsplot}.

{pmore} 
	You may specify {cmd:recastci()} within a {cmd:ciopts()} or
        {cmd:ci}{it:#}{cmd:opts()} option.  It is better, however, to
        specify it as documented here, outside those options.  When
        specified outside those options, you have greater access to the
        plot-specific rendition options of your specified {it:plottype}.

{phang}
{opt mcompare(method)}
specifies the method for confidence intervals that account for multiple
comparisons within a factor-variable term.
The default is determined by the {cmd:margins} results stored in {cmd:r()}.
If {cmd:marginsplot} is working from {cmd:margins} results stored in
{cmd:e()}, the default is {cmd:mcompare(noadjust)}.

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is determined by the {cmd:margins} results stored in {cmd:r()}.
If {cmd:marginsplot} is working from {cmd:margins} results stored in
{cmd:e()}, the default is {cmd:level(95)} or as set by {helpb set level}.

{dlgtab:Pairwise}

{pstd}
These options have an effect only when the {opt pwcompare} option was specified
on the preceding {cmd:margins} command.

{phang}
{opt unique}
	specifies that only unique pairwise comparisons be plotted.  The
	default is to plot all pairwise comparisons, including those that are
	mirror images of each other -- "male" versus "female" and "female"
	versus "male".  {cmd:margins} reports only the unique pairwise
	comparisons.  {cmd:unique} also changes the default {cmd:xdimension()}
	for graphs of pairwise comparisons from the reference categories
        ({cmd:_pw0}) to the comparisons of each pairwise category ({cmd:_pw}).

{pmore}
	Unique comparisons are often preferred with horizontal graphs that put
	all pairwise comparisons on the x axis, whereas including the full
	matrix of comparisons is preferred for charts showing the reference
	groups on an axis and the comparison groups as plots; see 
	{it:{mansection R marginsplotRemarksandexamplesPairwisecomparisons:Pairwise comparisons}} and
	{it:{mansection R marginsplotRemarksandexamplesHorizontalissometimesbetter:Horizontal is sometimes better}} in {bf:[R] marginsplot}.

{phang}
{opt csort}
	specifies that comparison categories are sorted first, and then
	reference categories are sorted within comparison category.  The
	default is to sort reference categories first, and then sort comparison
	categories within reference categories.  This option has an observable
	effect only when {cmd:_pw} is also specified in one of the dimension
	options.  It then determines the order of the labeling in the dimension
        where {cmd:_pw} is specified.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} 
        provides a way to add other plots to the generated graph; see
        {manhelpi addplot_option G-3}.  

{pmore} 
	For an example using {cmd:addplot()}, see
	{it:{mansection R marginsplotRemarksandexamplesAddingscatterplotsofthedata:Adding scatterplots of the data}} of {bf:[R] marginsplot}.
	
{pmore}
        If multiple graphs are drawn by a single {cmd:marginsplot} command or
        if {it:plot} specifies plots with multiple y variables, for example,
        {cmd:scatter y1 y2 x}, then the graph's legend will not clearly identify
	all the plots and will require customization using the 
	{opt legend()} option; see {manhelpi legend_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} 
        are any of the options documented in {manhelpi twoway_options G-3}.
        These include options for 
	titling the graph (see {manhelpi title_options G-3}); 
	for saving the graph to disk (see {manhelpi saving_option G-3});
	for controlling the labeling and look of the axes
	(see {manhelpi axis_options G-3});
	for controlling the look, contents, position, 
	and organization of the legend (see {manhelpi legend_options G-3});
	for adding lines (see {manhelpi added_line_options G-3})
	and text (see {manhelpi added_text_options G-3});
	and for controlling other aspects of the graph's appearance
	(see {manhelpi twoway_options G-3}).

{pmore}
        The {cmd:label()} suboption of the {cmd:legend()} option has no
        effect on {cmd:marginsplot}.  Use the {cmd:order()} suboption instead.

{phang}
{opt byopts(byopts)} 
        affects the appearance of the combined graph when {cmd:bydimension()}
        is specified or when the default graph has subgraphs, including the
        overall graph title, the position of the legend, and the organization
        of subgraphs.  See {manhelpi by_option G-3}.


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:marginsplot} and examples with discussion, see
{it:{mansection R marginsplotRemarksandexamples:Remarks and examples}} in
{bf:[R] marginsplot}.

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2}

{pstd}Profile plot of margins{p_end}
{phang2}{cmd:. regress bpsystol agegrp##sex}{p_end}
{phang2}{cmd:. margins agegrp}{p_end}
{phang2}{cmd:. marginsplot}{p_end}

{pstd}Interaction plot{p_end}
{phang2}{cmd:. margins agegrp#sex}{p_end}
{phang2}{cmd:. marginsplot}{p_end}

{pstd}Contrasts of margins -- effects (discrete marginal effects){p_end}
{phang2}{cmd:. margins r.sex@agegrp}{p_end}
{phang2}{cmd:. marginsplot}{p_end}

{pstd}Equivalently, using dydx(){p_end}
{phang2}{cmd:. margins agegrp, dydx(sex)}{p_end}
{phang2}{cmd:. marginsplot}{p_end}

{pstd}Plots at specified values of continuous covariates{p_end}
{phang2}{cmd:. logistic highbp sex##agegrp##c.bmi}{p_end}
{phang2}{cmd:. margins sex, at(bmi=(10(5)65))}{p_end}
{phang2}{cmd:. marginsplot}{p_end}

{pstd}Changing plot types{p_end}
{phang2}{cmd:. marginsplot, recast(line) recastci(rarea)}{p_end}

{pstd}Controlling dimensions{p_end}
{phang2}{cmd:. regress bpsystol agegrp##sex##c.bmi}{p_end}
{phang2}{cmd:. margins agegrp, over(sex) at(bmi=(10(10)60))}{p_end}
{phang2}{cmd:. marginsplot}{p_end}
{phang2}{cmd:. marginsplot, xdimension(agegrp)}{p_end}
{phang2}{cmd:. marginsplot, xdimension(agegrp) bydimension(sex)}{p_end}
{phang2}{cmd:. marginsplot, xdimension(agegrp) bydimension(bmi) xlabel(, angle(45))}{p_end}

{pstd}Marginal effects of continuous covariates{p_end}
{phang2}{cmd:. logistic highbp sex##agegrp##c.bmi}{p_end}
{phang2}{cmd:. margins agegrp, dydx(bmi)}{p_end}
{phang2}{cmd:. marginsplot}{p_end}

{phang2}{cmd:. margins agegrp#sex, dydx(bmi)}{p_end}
{phang2}{cmd:. marginsplot}{p_end}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=7iSa_gboh9I":Profile plots and interaction plots, part 1: A single categorical variable}

{phang}
{browse "http://www.youtube.com/watch?v=O4QbEaHRGT8":Profile plots and interaction plots, part 2: A single continuous variable}

{phang}
{browse "http://www.youtube.com/watch?v=7M3vJrLq1t0":Profile plots and interaction plots, part 3: Interactions between categorical variables}

{phang}
{browse "http://www.youtube.com/watch?v=iHfTJIdhwWs":Profile plots and interaction plots, part 4: Interactions of continuous and categorical variables}

{phang}
{browse "http://www.youtube.com/watch?v=QFROtui_OyM":Profile plots and interaction plots, part 5: Interactions of two continuous variables}


{marker dimlist2}{...}
{title:Addendum: Advanced uses of {it:dimlist}}

{pstd}
{it:dimlist} specifies the dimensions from the immediately preceding
{cmd:margins} command that are to be used for the {cmd:marginsplot}'s
{it:x} axis, plots, subgraphs, and graphs.  
{it:dimlist} may contain:

{synoptset 15}{...}
{synopthdr:dim}
{synoptline}
{synopt:{it:varname}}Any 
	variable referenced in the preceding {cmd:margins} command{p_end}

{synopt:{cmd:_equation}}If 
	the estimation command being analyzed is multivariate and
	{cmd:margins} automatically produced estimates for more than one 
	dependent-variable equation, then {it:dimlist} may 
	contain {cmd:_equation} to enumerate those equations.

{synopt:{cmd:_outcome}}If 
	the estimation command being analyzed is ordinal and {cmd:margins}
        automatically produced estimates for more than one outcome level, 
	then {it:dimlist} may contain {cmd:_outcome} to enumerate 
	those outcomes.

{synopt:{cmd:_predict}}If 
	the preceding {cmd:margins} command included multiple 
	{cmd:predict()} options, then {it:dimlist} may contain {cmd:_predict} 
	to enumerate those {cmd:predict()} options.

{synopt:{cmd:at(}{it:varname}{cmd:)}}If
        a variable is specified in both the {it:marginlist} or the
        {cmd:over()} option and in the {cmd:at()} option of {cmd:margins},
        then the two uses can be distinguished in {cmd:marginsplot} by typing
        the {cmd:at()} variables as {cmd:at(}{it:varname}{cmd:)} in 
        {it:dimlist}.{p_end}

{synopt:{cmd:_deriv}}If 
	the preceding {cmd:margins} command included a {cmd:dydx()},
        {cmd:eyex()}, {cmd:dyex()}, or {cmd:eydx()} option, {it:dimlist} may
        also contain {cmd:_deriv} to specify all the variables over which
        derivatives were taken.{p_end}

{synopt:{cmd:_term}}If 
        the preceding {cmd:margins} command included multiple terms; e.g.,  
        {cmd:margins} {cmd:a} {cmd:b}; then {it:dimlist} may contain
        {cmd:_term} to enumerate those terms.

{synopt:{cmd:_atopt}}If 
	the preceding {cmd:margins} command included multiple {cmd:at()}
	options, then {it:dimlist} may contain {cmd:_atopt} to enumerate those
	{cmd:at()} options.

{pstd}
When the {cmd:pairwise} option is specified on {cmd:margins} you can
	specify dimensions that enumerate the pairwise comparisons.{p_end}

{synopt:{cmd:_pw}}enumerates 
	all the pairwise comparisons{p_end}
{synopt:{cmd:_pw0}}enumerates 
	the reference categories of the comparisons{p_end}
{synopt:{cmd:_pw1}}enumerates 
	the comparison categories of the comparisons{p_end}
{synoptline}
