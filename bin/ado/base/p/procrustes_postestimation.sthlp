{smcl}
{* *! version 1.2.7  05sep2018}{...}
{viewerdialog predict "dialog procrustes_p"}{...}
{viewerdialog estat "dialog procrustes_estat"}{...}
{viewerdialog procoverlay "dialog procoverlay"}{...}
{vieweralsosee "[MV] procrustes postestimation" "mansection MV procrustespostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] procrustes" "help procrustes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{viewerjumpto "Postestimation commands" "procrustes postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "procrustes_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "procrustes postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "procrustes postestimation##syntax_estat"}{...}
{viewerjumpto "procoverlay" "procrustes postestimation##syntax_procoverlay"}{...}
{viewerjumpto "Examples" "procrustes postestimation##examples"}{...}
{viewerjumpto "Stored results" "procrustes postestimation##results"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[MV] procrustes postestimation} {hline 2}}Postestimation tools for
{cmd:procrustes}
{p_end}
{p2col:}({mansection MV procrustespostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:procrustes}:

{synoptset 19}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb procrustes postestimation##estat:estat compare}}fit statistics
	for orthogonal, oblique, and unrestricted transformations{p_end}
{synopt:{helpb procrustes postestimation##estat:estat mvreg}}display
	multivariate regression resembling unrestricted transformation{p_end}
{synopt:{helpb procrustes postestimation##estat:estat summarize}}display
	summary statistics over the estimation sample{p_end}
{synopt:{helpb procrustes postestimation##procoverlay:procoverlay}}produce a
	Procrustes overlay graph{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 19 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}catalog estimation results{p_end}
{synopt:{helpb procrustes postestimation##predict:predict}}compute fitted values
	and residuals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {helpb estimates} subcommands except {cmd:table} and {cmd:stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV procrustespostestimationRemarksandexamples:Remarks and examples}

        {mansection MV procrustespostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar:list}} {ifin} [{cmd:,}
	{it:statistic}]

{synoptset 13 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt fit:ted}}fitted  values {bf:1} {bf:c}' + rho {bf:X} {bf:A};
the default (specify {it:#}y vars){p_end}
{synopt:{opt res:iduals}}unstandardized residuals (specify {it:#}y vars){p_end}
{synopt:{opt q}}residual sum of squares over the target
	variables (specify one var){p_end}
{synoptline}
INCLUDE help esample


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates new variables containing predictions such as
fitted values, unstandardized residuals, and residual sum of squares.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt fitted}, the default,
computes fitted values, that is, the least-squares approximations of the target
({it:{help varlist:varlist_y}}) variables.  You must specify the same number of
new variables as there are target variables.

{phang}{opt residuals}
computes the raw (unstandardized) residuals for each target
({it:{help varlist:varlist_y}}) variable.  You must specify the same number of
new variables as there are target variables.

{phang}{opt q}
computes the residual sum of squares over all variables, that is, the squared
Euclidean distance between the target and transformed source points.  Specify
one new variable.


{marker syntax_estat}{...}
{marker estat}{...}
{title:Syntax for estat}

{pstd}
Table of fit statistics

{p 8 14 2}
{cmd:estat} {cmdab:co:mpare} [{cmd:,} {opt det:ail}]


{pstd}
Comparison of {cmd:mvreg} and {cmd:procrustes} output

{p 8 14 2}
{cmd:estat} {cmdab:mv:reg} [{cmd:,} 
      {help mvreg:{it: mvreg_options}}]


{pstd}
Display summary statistics

{p 8 14 2}
{cmd:estat} {cmdab:su:mmarize}
	[{cmd:,}
		{opt lab:els}
		{opt nohea:der}
		{opt nowei:ghts}]


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat} {cmd:compare}
displays a table with fit statistics of the three transformations provided
by {cmd:procrustes}: {cmd:orthogonal}, {cmd:oblique}, and {cmd:unrestricted}.
The two additional procrustes analyses are performed on the same sample as
the original procrustes analysis and with the same options. 
F tests comparing the models are provided.

{pstd}
{cmd:estat} {cmd:mvreg}
produces the {helpb mvreg} output related to the unrestricted
Procrustes analysis (the {cmd:transform(unrestricted)} option of
{cmd:procrustes}).

{pstd}
{cmd:estat} {cmd:summarize}
displays summary statistics over the estimation sample of the target and
source variables ({it:{help varlist:varlist_y}} and {it:varlist_x}).


{marker options_estat}{...}
{title:Options for estat}

{phang}
{opt detail}, an option with {cmd:estat compare}, displays the standard
{cmd:procrustes} output for the two additional transformations.

{phang}
{it:mvreg_options}, allowed with {cmd:estat mvreg}, are any of the options
allowed by {cmd:mvreg}; see {manhelp mvreg MV}.  The constant is already
suppressed if the Procrustes analysis suppressed it.

{phang}
{opt labels}, {opt noheader}, and {opt noweights} are the same as for the
generic {cmd:estat} {cmd:summarize} command; see
{helpb estat summarize:[R] estat summarize}.


{marker syntax_procoverlay}{...}
{marker procoverlay}{...}
{title:Syntax for procoverlay}

{p 8 20 2}
{cmd:procoverlay} {ifin} [{cmd:,} {it:procoverlay_options}]

{synoptset 27 tabbed}{...}
{synopthdr:procoverlay_options}
{synoptline}
{syntab:Main}
{synopt:{opt auto:aspect}}adjust aspect ratio on the basis of the data; default
	aspect ratio is 1{p_end}
{synopt:{opth target:opts(procrustes_postestimation##targetopts:target_opts)}}affect the rendition of the target{p_end}
{synopt:{opth source:opts(procrustes_postestimation##sourceopts:source_opts)}}affect the rendition of the source{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented
	in {manhelpi twoway_options G-3}{p_end}

{syntab:By}
{synopt:{opth byo:pts(by_option)}}affect the
	rendition of combined graphs{p_end}
{synoptline}

{marker targetopts}{...}
{synopthdr:target_opts}
{synoptline}
{syntab:Main}
{synopt:{opt nolab:el}}removes the default observation label from the
	target{p_end}
{synopt:{it:{help marker_options}}}change look of markers 
	(color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}change 
	look or position of marker labels{p_end}
{synoptline}

{marker sourceopts}{...}
{synopthdr:source_opts}
{synoptline}
{syntab:Main}
{synopt:{opt nolab:el}}removes the default observation label from the
	source{p_end}
{synopt:{it:{help marker_options}}}change look of markers 
	(color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}change 
	look or position of marker labels{p_end}
{synoptline}
{p2colreset}{...}


{marker menu_procoverlay}{...}
{title:Menu for procoverlay}

{phang}
{bf:Statistics > Multivariate analysis > Procrustes overlay graph}


{marker desc_procoverlay}{...}
{title:Description for procoverlay}

{pstd}
{cmd:procoverlay}
displays a plot of the target variables overlaid with the fitted values
derived from the source variables.  If there are more than two target
variables, multiple plots are shown in one graph.


{marker options_procoverlay}{...}
{title:Options for procoverlay}

{dlgtab:Main}

{marker autoaspect}{...}
{phang}{opt autoaspect}
specifies that the aspect ratio be automatically adjusted based on the
range of the data to be plotted.  This option can make some {cmd:procoverlay}
plots more readable.  By default, {cmd:procoverlay} uses an aspect ratio of
one, producing a square plot.

{pmore}
As an alternative to {opt autoaspect}, the {it:twoway_option}
{helpb aspect_option:aspectratio()} can be used to override the default
aspect ratio.  {cmd:procoverlay}
accepts the {cmd:aspectratio()} option as a suggestion only and will override
it when necessary to produce plots with balanced axes, that is, where distance
on the {it:x} axis equals distance on the {it:y} axis.

{pmore}
{it:{help twoway_options}}, such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()}, should be used with
caution.  These {it:{help axis_options}} are accepted but may have unintended
side effects on the aspect ratio.

{phang}{opt targetopts(target_opts)}
affects the rendition of the target plot.  The following {it:target_opts}
are allowed:

{phang2}
{opt nolabel}
removes the default target observation label from the graph.

{phang2}
{it:marker_options}
affect the rendition of markers drawn at the plotted points, including
their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{phang2}
{it:marker_label_options}
specify if and how the markers are to be labeled; see
{manhelpi marker_label_options G-3}.

{phang}{opt sourceopts(source_opts)}
affects the rendition of the source plot.  The following {it:source_opts}
are allowed:

{phang2}
{opt nolabel}
removes the default source observation label from the graph.

{phang2}
{it:marker_options}
affect the rendition of markers drawn at the plotted points, including
their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{phang2}
{it:marker_label_options}
specify if and how the markers are to be labeled; see
{manhelpi marker_label_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).
See {helpb procrustes postestimation##autoaspect:autoaspect} above for a
warning against using options such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()}.

{dlgtab:By}

{phang}
{marker byopts}
{opt byopts(by_option)}
is documented in {manhelpi by_option G-3}.  This option affects the appearance
of the combined graph and is ignored, unless there are more than two target
variables specified in {cmd:procrustes}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse speed_survey}{p_end}
{phang2}{cmd:. procrustes (survey_x survey_y) (speed_x speed_y)}

{pstd}Compare transformations{p_end}
{phang2}{cmd:. estat compare}

{pstd}Produce Procrustes overlay graph{p_end}
{phang2}{cmd:. procoverlay}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat compare} after {cmd:procrustes} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(cstat)}}Procrustes statistics, degrees of freedom, and
RMSEs{p_end}
{synopt:{cmd:r(fstat)}}F statistics, degrees of freedom, and p-values{p_end}

{pstd}
{cmd:estat mvreg} does not return results.

{pstd}
{cmd:estat summarize} after {cmd:procrustes} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(stats)}}means, standard deviations, minimums, and
maximums{p_end}
{p2colreset}{...}
