{smcl}
{* *! version 1.3.2  19oct2017}{...}
{vieweralsosee "[G-3] axis_options" "mansection G-3 axis_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{vieweralsosee "[G-3] axis_scale_options" "help axis_scale_options"}{...}
{vieweralsosee "[G-3] axis_title_options" "help axis_title_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_choice_options" "help axis_choice_options"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{viewerjumpto "Description" "axis_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "axis_options##linkspdf"}{...}
{viewerjumpto "Options" "axis_options##options"}{...}
{viewerjumpto "Remarks" "axis_options##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-3]} {it:axis_options} {hline 2}}Options for specifying numeric axes{p_end}
{p2col:}({mansection G-3 axis_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{it:axis_options} allow you to change the title, labels, ticks, and scale of a
numeric axis from the defaults set by the scheme.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 axis_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
{it:axis_options} are grouped into four classes.

{phang2}
{it:axis_title_options} specify the titles to appear next to the axes.
    They also allow you to format the title fonts.
    See {manhelpi axis_title_options G-3}.

{phang2}
{it:axis_label_options} specify how the axes should be labeled and ticked.
    These options allow you to control the placement of major and minor ticks
    and labels.  {it:axis_label_options} also allow you to add or to suppress
    grid lines on your graphs.  See {manhelpi axis_label_options G-3}.

{phang2}
{it:axis_scale_options} specify how the axes should be
    scaled -- either logarithmic scaled or reverse scaled to run from
    maximum to minimum.  These options also allow you to change the
    range of the axes and the look of the lines that are the axes, including
    placement.  See {manhelpi axis_scale_options G-3}.

{phang2}
{it:axis_choice_options} control the specific axis on which a plot
    appears when there are multiple x or y axes. 
    See {manhelpi axis_choice_options G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Numeric axes are allowed with
{helpb graph twoway}
and
{helpb graph matrix}
and are allowed for one of the axes of
{helpb graph bar},
{helpb graph dot},
and
{helpb graph box}.
They are also allowed on the contour key of a legend on a 
{help twoway_contour:contour plot}.
The default appearance of the axes is determined by the
{help schemes intro:scheme} but can be modified using {it:axis_options}.
{p_end}
