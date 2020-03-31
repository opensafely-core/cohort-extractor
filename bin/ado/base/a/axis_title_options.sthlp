{smcl}
{* *! version 1.1.11  19oct2017}{...}
{vieweralsosee "[G-3] axis_title_options" "mansection G-3 axis_title_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_options" "help axis_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{vieweralsosee "[G-3] axis_scale_options" "help axis_scale_options"}{...}
{vieweralsosee "[G-4] text" "help text"}{...}
{viewerjumpto "Syntax" "axis_title_options##syntax"}{...}
{viewerjumpto "Description" "axis_title_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "axis_title_options##linkspdf"}{...}
{viewerjumpto "Options" "axis_title_options##options"}{...}
{viewerjumpto "Suboptions" "axis_title_options##suboptions"}{...}
{viewerjumpto "Remarks" "axis_title_options##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-3]} {it:axis_title_options} {hline 2}}Options for specifying axis titles{p_end}
{p2col:}({mansection G-3 axis_title_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
{it:axis_title_options} are a subset of {it:axis_options}; see
{manhelpi axis_options G-3}.
{it:axis_title_options} control the titling of an axis.

{synoptset 25}{...}
{p2col:{it:axis_title_options}}Description{p_end}
{p2line}
{p2col:{cmdab:yti:tle:(}{it:axis_title}{cmd:)}}specify {it:y} axis title{p_end}
{p2col:{cmdab:xti:tle:(}{it:axis_title}{cmd:)}}specify {it:x} axis title{p_end}
{p2col:{cmdab:tti:tle:(}{it:axis_title}{cmd:)}}specify {it:t} (time) axis title
{p_end}
{p2col:{cmdab:zti:tle:(}{it:axis_title}{cmd:)}}specify contour legend axis title
{p_end}
{p2line}
{p 4 6 2}
The above options are {it:merged-explicit}; see {help repeated options}.

{pstd}
where {it:axis_title} is

{p 8 16 2}
{cmd:"}{it:string}{cmd:"} [{cmd:"}{it:string}{cmd:"} [...]]
[{cmd:,} {it:suboptions}]

{pmore}
{it:string} may contain Unicode characters and SMCL tags to render mathematical
symbols, italics, etc.; see {manhelpi graph_text G-4:text}.

{p2col:{it:suboptions}}Description{p_end}
{p2line}
{p2col:{cmd:axis(}{it:#}{cmd:)}}which axis, {cmd:1} {ul:<} {it:#}
           {ul:<} {cmd:9}{p_end}
{p2col:{cmd:prefix}}combine options{p_end}
{p2col:{cmd:suffix}}combine options{p_end}
{p2col:{it:textbox_options}}control details of text appearance; see
        {manhelpi textbox_options G-3}{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{it:axis_title_options} specify the titles to appear on axes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 axis_title_optionsQuickstart:Quick start}

        {mansection G-3 axis_title_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt ytitle(axis_title)}, {opt xtitle(axis_title)}, and
 {opt ttitle(axis_title)} specify the titles to appear on the {it:y}, {it:x},
 and {it:t} axes.  {cmd:ttitle()} is a synonym for {cmd:xtitle()}.

{phang}
{cmd:ztitle(}{it:axis_title{cmd:)}}; see
    {it:{help axis_title_options##remarks7:Contour axes -- ztitle()}}
    below.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:axis(}{it:#}{cmd:)}
    specifies to which axis  this title belongs and is specified when dealing
    with multiple {it:y} or multiple {it:x} axes; see 
    {manhelpi axis_choice_options G-3}.

{phang}
{cmd:prefix} and {cmd:suffix}
    specify
    that what is specified in this option is to be added to any previous
    {cmd:xtitle()} or {cmd:ytitle()} options previously specified.
    See {it:{help axis_title_options##remarks5:Interpretation of repeated options}} below.

{phang}
{it:textbox_options}
    specifies the look of the text.  See {manhelpi textbox_options G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:axis_title_options} are a subset of {it:axis_options};
see {manhelpi axis_options G-3} for an overview.
The other appearance options are

	{it:axis_scale_options}{right:(see {manhelpi axis_scale_options G-3})  }

	{it:axis_label_options}{right:(see {manhelpi axis_label_options G-3})  }

{pstd}
Remarks are presented under the following headings:

	{help axis_title_options##remarks1:Default axis titles}
	{help axis_title_options##remarks2:Overriding default titles}
	{help axis_title_options##remarks3:Specifying multiline titles}
	{help axis_title_options##remarks4:Suppressing axis titles}
	{help axis_title_options##remarks5:Interpretation of repeated options}
	{help axis_title_options##remarks6:Titles with multiple y axes or multiple x axes}
	{help axis_title_options##remarks7:Contour axes -- ztitle()}


{marker remarks1}{...}
{title:Default axis titles}

{pstd}
Even if you do not specify the
{cmd:ytitle()} or {cmd:xtitle()}
options, axes will usually be titled.  In those cases,
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:title()}
changes the title.
If an axis is not titled, specifying
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:title()}
adds a title.

{pstd}
Default titles are obtained using the corresponding variable's variable label
or, if it does not have a label, using its name.  For instance, in

	{cmd:. twoway scatter yvar xvar}

{pstd}
the default title for the {it:y} axis will be obtained from variable yvar, and
the default title for the {it:x} axis will be obtained from xvar. Sometimes 
the plottype substitutes a different title; for instance,

	{cmd:. twoway lfit yvar xvar}

{pstd}
labels the {it:y} axis "Fitted values" regardless of the name or variable
label associated with variable yvar.

{pstd}
If multiple variables are associated with the same axis, the axis titles
are dispensed with and instead a legend is shown to label each plot.
For instance, in

{phang2}
	{cmd:. twoway scatter y1var xvar || line y2var xvar || lfit y1var xvar}

{pstd}
a legend with a separate key and label is shown for
{it:y1var_title}, {it:y2var_title}, and Fitted values.


{marker remarks2}{...}
{title:Overriding default titles}

{pstd}
You may specify the title to appear on the {it:y} axis using {cmd:ytitle()}
and the title to appear on the {it:x} axis using {cmd:xtitle()}.  You
specify the text -- surrounded by double quotes -- inside the option:

	{cmd:ytitle("My y title")}

	{cmd:xtitle("My x title")}

{pstd}
For {cmd:scatter}, the command might read

{phang2}
	{cmd:. scatter yvar xvar, ytitle("Price") xtitle("Quantity")}


{marker remarks3}{...}
{title:Specifying multiline titles}

{pstd}
Titles may include more than one line.  Lines are specified one after the
other, each enclosed in double quotes:

	{cmd:ytitle("First line" "Second line")}

	{cmd:xtitle("First line" "Second line" "Third line")}


{marker remarks4}{...}
{title:Suppressing axis titles}

{pstd}
To eliminate an axis title, specify
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:title("")}.

{pstd}
To eliminate the title on a second, third, ..., axis, specify
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:title("", axis(}{it:#}{cmd:))}.
See {hi:Titles with multiple y axes or multiple x axes} below.


{marker remarks5}{...}
{title:Interpretation of repeated options}

{pstd}
{cmd:xtitle()} and {cmd:ytitle()} may be specified more than once in
the same command.  When you do that, the rightmost one takes effect.

{pstd}
See {it:{help axis_label_options##appendix5:Interpretation of repeated options}} in {manhelpi axis_label_options G-3}.  Multiple {cmd:ytitle()} and
{cmd:xtitle()} options work the same way.  The twist for the title options is
that you specify whether the extra information is to be prefixed or suffixed
onto what came before.

{pstd}
For instance, pretend that {cmd:sts graph} produced the {it:x} axis title
"analysis time".  If you typed

	{cmd:. sts graph, xtitle("My new title")}

{pstd}
the title you specified would replace that.  If you typed

	{cmd:.sts graph, xtitle("in days", suffix)}

{pstd}
the {it:x} axis title would be (first line) "analysis time" (second line)
"in days".  If you typed

{phang2}
	{cmd:.sts graph, xtitle("Time to failure", prefix)}

{pstd}
the {it:x} axis title would be (first line) "Time to failure" (second line)
"analysis time".


{marker remarks6}{...}
{title:Titles with multiple y axes or multiple x axes}

{pstd}
When you have more than one {it:y} or {it:x} axis (see 
{manhelpi axis_choice_options G-3}), remember to specify the
{cmd:axis(}{it:#}{cmd:)} suboption to indicate to which axis you are
referring.


{marker remarks7}{...}
{title:Contour axes -- ztitle()}

{pstd}
The {cmd:ztitle()} option is unusual in that it applies not to axes on the
plot region, but to the axis that shows the scale of a 
{help clegend_option:contour legend}.  It has effect only when the graph
includes a {cmd:twoway contour} plot; 
see {helpb twoway_contour:[G-2] graph twoway contour}.  In
all other respects, it acts like {cmd:xtitle()}, {cmd:ytitle()}, and
{cmd:ttitle()}.
{p_end}
