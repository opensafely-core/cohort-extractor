{smcl}
{* *! version 1.1.4  23oct2017}{...}
{viewerdialog mcaplot "dialog mcaplot"}{...}
{viewerdialog mcaprojection "dialog mcaprojection"}{...}
{vieweralsosee "[MV] mca postestimation plots" "mansection MV mcapostestimationplots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mca" "help mca"}{...}
{vieweralsosee "[MV] mca postestimation" "help mca postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] ca postestimation" "help ca_postestimation"}{...}
{viewerjumpto "Postestimation commands" "mca postestimation plots##description"}{...}
{viewerjumpto "Links to PDF documentation" "mca_postestimation_plots##linkspdf"}{...}
{viewerjumpto "mcaplot" "mca postestimation plots##syntax_mcaplot"}{...}
{viewerjumpto "mcaprojection" "mca postestimation plots##syntax_mcaprojection"}{...}
{viewerjumpto "Examples" "mca postestimation plots##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[MV] mca postestimation plots} {hline 2}}Postestimation plots for
{cmd:mca}
{p_end}
{p2col:}({mansection MV mcapostestimationplots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:mca}:

{synoptset 21}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb mca postestimation plots##mcaplot:mcaplot}}plot of category coordinates{p_end}
{synopt:{helpb mca postestimation plots##mcaprojection:mcaprojection}}MCA dimension projection plot{p_end}
{synoptline}
{p 4 6 2}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mcapostestimationplotsRemarksandexamples:Remarks and examples}

        {mansection MV mcapostestimationplotsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_mcaplot}{...}
{marker mcaplot}{...}
{title:Syntax for mcaplot}

{p 8 17 2}
{cmd:mcaplot} [{it:speclist}]  [{cmd:,} 
    {help mca postestimation plots##options:{it:options}}]

    where

{p 8 17 2}
{it:speclist} = {it:spec} [{it:spec} ...]

{p 8 17 2}
{it:spec} = {varlist} | {cmd:(}{varname} [{cmd:,} 
   {help mca postestimation plots##plot_options:{it:plot_options}}]{cmd:)}

{p 4 4 2}
and variables in {it:varlist} or {it:varname} must be from the preceding
{cmd:mca} and may refer to either a regular categorical variable or 
a crossed variable.  The variables may also be supplementary.

{marker options}{...}
{synoptset 26 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt:{it:{help graph_combine:combine_options}}}affect the rendition of
	the combined graphs{p_end}
{synopt:{opt over:lay}}overlay the plots of the variables; default is to produce separate plots{p_end}
{synopt:{opt dim:ensions(#_1 #_2)}}display dimensions {it:#_1} and {it:#_2}; {bind:default is {cmd:dimension(2 1)}}{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:s:tandard)}}display standard coordinates{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:p:rincipal)}}display principal coordinates{p_end}
{synopt:{opt max:length(#)}}use {it:#} as maximum number of characters for labels; default is {cmd:maxlength(12)}{p_end}
{synopt:{opt xneg:ate}}negate the coordinates relative to the {it:x} axis{p_end}
{synopt:{opt yneg:ate}}negate the coordinates relative to the {it:y} axis{p_end}
{synopt:{opt or:igin}}mark the origin and draw origin axes{p_end}
{synopt:{opth or:iginlopts(line_options)}}affect the rendition of the origin axes{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in 
   {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker plot_options}{...}
{synoptset 26}{...}
{synopthdr:plot_options}
{synoptline}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}add marker labels; change look or position{p_end}
{synopt:{it:{help twoway_options}}}titles, legends, axes, added lines and
     text, regions, etc.{p_end}
{synoptline}


{marker menu_mcaplot}{...}
{title:Menu for mcaplot}

{phang}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
     {bf:Postestimation after MCA or JCA > Plot of category coordinates}


{marker description_mcaplot}{...}
{title:Description for mcaplot}

{pstd}
{cmd:mcaplot} produces a scatterplot of category points of the MCA variables
in two dimensions.


{marker options_mcaplot}{...}
{title:Options for mcaplot}

{dlgtab:Plots}

{phang}
{it:plot_options} affect the rendition of markers, including their shape,
size, color, and outline (see {manhelpi marker_options G-3}) and specify
if and how the markers are to be labeled
(see {manhelpi marker_label_options G-3}).  These
options may be specified for each variable.  If the {cmd:overlay} option
is not specified, then for each variable you may also specify many of the
{it:twoway_options} excluding {cmd:by()}, {cmd:name()}, and
{cmd:aspectratio()}; see {manhelpi twoway_options G-3}.  See 
{it:{help mca postestimation plots##twoway_options:twoway_options}} below for a
warning against using options such as {cmd:xlabel()}, {cmd:xscale()},
{cmd:ylabel()}, and {cmd:yscale()}.

{dlgtab:Options}

{phang}{it:combine_options}
affect the rendition of the combined plot; see
{manhelp graph_combine G-2:graph combine}.  {it:combine_options} may not be
specified with {cmd:overlay}.

{phang}{cmd:overlay}
overlays the biplot graphs for the variables.  The default is to produce
a combined graph of the biplot graphs.

{phang}{opt dimension(#_1 #_2)}
identifies the dimensions to be displayed.  For instance,
{bind:{cmd:dimension(3 2)}} plots the third dimension (vertically) versus the
second dimension (horizontally).  The dimension number cannot exceed the
number of extracted dimensions.  The default is {cmd:dimension(2 1)}.

{phang}{opt normalize(norm)}
specifies the normalization of the coordinates.  {cmd:normalize(standard)}
returns coordinates in standard normalization.  {cmd:normalize(principal)}
returns principal coordinates.  The default is the normalization method
specified with {cmd:mca} during estimation, or {cmd:normalize(standard)}
if no method was specified.

{phang}{opt maxlength(#)}
specifies the maximum number of characters for row and column labels;
the default is {cmd:maxlength(12)}.

{phang}{opt xnegate}
specifies that the {it:x}-axis coordinates be negated
(multiplied by -1).

{phang}{opt ynegate}
specifies that the {it:y}-axis coordinates be negated
(multiplied by -1).

{phang}{cmd:origin}
marks the origin and draws the origin axes.

{phang}{opt originlopts(line_options)}
affect the rendition of the origin axes.  See {manhelpi line_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{marker twoway_options}{...}
{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3} excluding
{cmd:by()}.

{pmore}
{cmd:mcaplot} automatically adjusts the aspect ratio on the basis of the range
of the data and ensures that the axes are balanced.  As an alternative, the
{it:twoway_option} {helpb aspect_option:aspectratio()} can be used to override
the default aspect ratio.  {cmd:mcaplot} accepts the {cmd:aspectratio()}
option as a suggestion only and will override it when necessary to produce
plots with balanced axes; that is, distance on the {it:x} axis equals distance
on the {it:y} axis.

{pmore}
{it:{help twoway_options}} such as {cmd:xlabel()},
{cmd:xscale()}, {cmd:ylabel()}, and {cmd:yscale()} should be used with
caution.  These {it:{help axis_options}} are accepted but may have unintended
side effects on the aspect ratio.


{marker syntax_mcaprojection}{...}
{marker mcaprojection}{...}
{title:Syntax for mcaprojection}

{p 8 19 2}
{cmd:mcaprojection} [{it:speclist}]  [{cmd:,} 
      {help mca postestimation plots##mcaproj_options:{it:options}}]

    where

{p 8 19 2}
{it:speclist} = {it:spec} [{it:spec} ...]

    and

{p 8 19 2}
{it:spec} = {varlist} | {cmd:(}{varname} [{cmd:,} 
    {help mca postestimation plots##mcaproj_plot_options:{it:plot_options}}]{cmd:)}

{p 4 4 2}
and variables in {it:varlist} or {it:varname} must be from the preceding
{cmd:mca} and may refer to either a regular categorical variable or 
a crossed variable.  The variables may also be supplementary.

{marker mcaproj_options}{...}
{synoptset 24 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt:{opth dim:ensions(numlist)}}display {it:numlist} dimensions; default is all{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:p:rincipal)}}scores (coordinates) should be in principal normalization{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:s:tandard)}}scores (coordinates) should be in standard normalization{p_end}
{synopt:{opt alt:ernate}}alternate labels{p_end}
{synopt:{opt max:length(#)}}use {it:#} as maximum number of characters for
        labels; default is {cmd:maxlength(12)}{p_end}
{synopt:{it:{help graph_combine:combine_options}}}affect the rendition of
	the combined graphs{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
	documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker mcaproj_plot_options}{...}
{synoptset 24}{...}
{synopthdr:plot_options}
{synoptline}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}add marker labels; change look or position{p_end}
{synopt:{it:{help twoway_options}}}titles, legends, axes, added lines and 
     text, regions, etc.{p_end}
{synoptline}


{marker menu_mcaprojection}{...}
{title:Menu for mcaprojection}

{phang}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
    {bf:Postestimation after MCA or JCA > Dimension projection plot}


{marker description_mcaprojection}{...}
{title:Description for mcaprojection}

{pstd}
{cmd:mcaprojection} produces a projection plot of the coordinates of the
categories of the MCA variables.


{marker options_mcaprojection}{...}
{title:Options for mcaprojection}

{dlgtab:Plots}

{phang}
{it:plot_options} affect the rendition of markers, including their shape,
size, color, and outline (see {manhelpi marker_options G-3}) and specify
if and how the markers are to be labeled
(see {manhelpi marker_label_options G-3}).  These
options may be specified for each variable.  If the {cmd:overlay} option
is not specified then for each variable you may also specify
{it:twoway_options} excluding {cmd:by()} and {cmd:name()}; see
{manhelpi twoway_options G-3}.

{dlgtab:Options}

{phang}{opth dimensions(numlist)}
identifies the dimensions to be displayed.  By default, all dimensions are
displayed.

{phang}{opt normalize(norm)}
specifies the normalization of the coordinates.  {cmd:normalize(standard)}
returns coordinates in standard normalization.  {cmd:normalize(principal)}
returns principal coordinates.  The default is the normalization method
specified with {cmd:mca} during estimation, or {cmd:normalize(standard)}
if no method was specified.

{phang}{opt alternate}
causes adjacent labels to alternate sides.

{phang}{opt maxlength(#)}
specifies the maximum number of characters for row and column labels;
the default is {cmd:maxlength(12)}.

{phang}{it:combine_options}
affect the rendition of the combined plot; see
{manhelp graph_combine G-2:graph combine}.
These options may not be used if only one variable is specified.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3}, excluding
{cmd:by()}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse issp93}{p_end}
{phang2}{cmd:. mca A B C D, dimensions(2) suppl(age edu) method(joint)}{p_end}

{pstd}Biplots{p_end}
{phang2}{cmd:. mcaplot}{p_end}
{phang2}{cmd:. mcaplot A B C, ynegate}{p_end}
{phang2}{cmd:. mcaplot (A, mcolor(red) mlabcolor(red)) (B, mcolor(blue)), overlay}{p_end}

{pstd}Dimension projection plots{p_end}
{phang2}{cmd:. mcaprojection}{p_end}
{phang2}{cmd:. mcaprojection A B C, alternate}{p_end}
