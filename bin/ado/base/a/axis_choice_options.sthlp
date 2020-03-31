{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-3] axis_choice_options" "mansection G-3 axis_choice_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_options" "help axis_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{vieweralsosee "[G-3] axis_scale_options" "help axis_scale_options"}{...}
{vieweralsosee "[G-3] axis_title_options" "help axis_title_options"}{...}
{viewerjumpto "Syntax" "axis_choice_options##syntax"}{...}
{viewerjumpto "Description" "axis_choice_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "axis_choice_options##linkspdf"}{...}
{viewerjumpto "Options" "axis_choice_options##options"}{...}
{viewerjumpto "Remarks" "axis_choice_options##remarks"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[G-3]} {it:axis_choice_options} {hline 2}}Options for specifying the axes on which a plot appears{p_end}
{p2col:}({mansection G-3 axis_choice_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col : {it:axis_choice_options}}Description{p_end}
{p2line}
{p2col : {cmdab:yax:is:(}{it:#} [{it:#} ...]{cmd:)}}which {it:y} axis to use,
      {cmd:1} {ul:<} {it:#} {ul:<} {cmd:9}{p_end}
{p2col : {cmdab:xax:is:(}{it:#} [{it:#} ...]{cmd:)}}which {it:x} axis to use,
      {cmd:1} {ul:<} {it:#} {ul:<} {cmd:9}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
{cmd:yaxis()}
and
{cmd:xaxis()}
are {it:unique}; see 
{help repeated options}.

{pstd}
These options are allowed with any of the {it:plottypes} ({cmd:scatter},
{cmd:line}, etc.) allowed by {helpb graph twoway}.


{marker description}{...}
{title:Description}

{pstd}
The {it:axis_choice_options} determine the {it:y} and {it:x} axis (or
axes) on which the plot is to appear.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 axis_choice_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:yaxis(}{it:#} [{it:#} ...]{cmd:)} and
{cmd:xaxis(}{it:#} [{it:#} ...]{cmd:)}
    specify the {it:y} or {it:x} axis to be used.  The default is
    {cmd:yaxis(1)} and {cmd:xaxis(1)}.

{pmore}
    Typically, {cmd:yaxis()} and {cmd:xaxis()} are treated as if their
    syntax is {cmd:yaxis(}{it:#}{cmd:)} and {cmd:xaxis(}{it:#}{cmd:)} -- 
    that is, just one number is specified.  In fact, however, more than
    one number may be specified, and specifying a second is sometimes
    useful with {cmd:yaxis()}.  The first {it:y} axis appears on the left,
    and the second (if there is a second) appears on the right.  Specifying
    {cmd:yaxis(1} {cmd:2)} allows you to force there to be two identical
    {it:y} axes.  You could use the one on the left in the usual way and the
    one on the right to label special values.


{marker remarks}{...}
{title:Remarks}

{pstd}
Options {cmd:yaxis()} and {cmd:xaxis()} are used when
you wish to create one graph with multiple axes.  These options are
specified with {cmd:twoway}'s {cmd:scatter}, {cmd:line}, etc., to specify
which axis is to be used for each individual plot.

{pstd}
Remarks are presented under the following headings:

	{help axis_choice_options##remarks1:Usual case:  one set of axes}
	{help axis_choice_options##remarks2:Special case:  multiple axes due to multiple scales}
	{help axis_choice_options##remarks3:yaxis(1) and xaxis(1) are the defaults}
	{help axis_choice_options##remarks4:Notation style is irrelevant}
	{help axis_choice_options##remarks5:yaxis() and xaxis() are plot options}
	{help axis_choice_options##remarks6:Specifying the other axes options with multiple axes}
	{help axis_choice_options##remarks7:Each plot may have at most one x scale and one y scale}
	{help axis_choice_options##remarks8:Special case:  multiple axes with a shared scale}


{marker remarks1}{...}
{title:Usual case:  one set of axes}

{pstd}
Normally, when you construct a {cmd:twoway} graph with more than one plot, as
in

{p 8 16 2}
{cmd:. scatter y1 y2 x}

{pstd}
or equivalently,

{p 8 16 2}
{cmd:. twoway (scatter y1 x) (scatter y2 x)}

{pstd}
the two plots share common axes for {it:y} and for {it:x}.


{marker remarks2}{...}
{title:Special case:  multiple axes due to multiple scales}

{pstd}
Sometimes you want the two {it:y} plots graphed on separate scales.
Then you type

{p 8 17 2}
{cmd:. twoway (scatter gnp year, c(l) yaxis(1))}{break}
{cmd:(scatter r{space 3}year, c(l) yaxis(2))}

{pstd}
{cmd:yaxis(1)} specified on the first {cmd:scatter} says, "This
scatter is to appear on the first {it:y} axis."
{cmd:yaxis(2)} specified on the second {cmd:scatter} says, "This
scatter is to appear on the second {it:y} axis."

{pstd}
The result is that two {it:y} axes will be constructed.  The one on the left
will correspond to {cmd:gnp} and the one on the right to {cmd:r}.
If we had two {it:x} axes instead, one would appear on the bottom and
one on the top:

{p 8 17 2}
{cmd:. twoway (scatter year gnp, c(l) xaxis(1))}{break}
{cmd:(scatter year r,{space 3}c(l) xaxis(2))}

{pstd}
You are not limited to having just two {it:y} axes or two {it:x} axes.
You could have two of each:

{p 8 17 2}
{cmd:. twoway (scatter y1var x1var, c(l) yaxis(1) xaxis(1))}{break}
{cmd:(scatter y2var x2var, c(l) yaxis(2) xaxis(2))}

{pstd}
You may have up to nine {it:y} axes and nine {it:x} axes, although
graphs become pretty well unreadable by that point.  When there are three or
more {it:y} axes (or {it:x} axes), the axes are stacked up on the left (on
the bottom).  In any case, you specify {cmd:yaxis(}{it:#}{cmd:)} and
{cmd:xaxis(}{it:#}{cmd:)} to specify which axis applies to which plot.

{pstd}
Also, you may reuse axes:

{p 8 17 2}
{cmd:. twoway (scatter gnp year, c(l) yaxis(1))}{break}
{cmd:(scatter nnp year, c(l) yaxis(1))}{break}
{cmd:(scatter r{space 3}year, c(l) yaxis(2))}{break}
{cmd:(scatter r2{space 2}year, c(l) yaxis(2))}

{pstd}
The above graph has two {it:y} axes, one on the left and one on the right.
The left axis is used for {cmd:gnp} and {cmd:nnp}; the right axis is
used for {cmd:r} and {cmd:r2}.

{pstd}
The order in which we type the plots is not significant; the following
would result in the same graph,

{p 8 17 2}
{cmd:. twoway (scatter gnp year, c(l) yaxis(1))}{break}
{cmd:(scatter r{space 3}year, c(l) yaxis(2))}{break}
{cmd:(scatter nnp year, c(l) yaxis(1))}{break}
{cmd:(scatter r2{space 2}year, c(l) yaxis(2))}

{pstd}
except that the symbols, colors, and {it:{help linestyle:linestyles}}
associated with each plot would change.


{marker remarks3}{...}
{title:yaxis(1) and xaxis(1) are the defaults}

{pstd}
In the first multiple-axis example,

{p 8 17 2}
{cmd:. twoway (scatter gnp year, c(l) yaxis(1))}{break}
{cmd:(scatter r{space 3}year, c(l) yaxis(2))}

{pstd}
{cmd:xaxis(1)} is assumed because we did not specify otherwise.  The command
is interpreted as if we had typed

{p 8 17 2}
{cmd:. twoway (scatter gnp year, c(l) yaxis(1) xaxis(1))}{break}
{cmd:(scatter r{space 3}year, c(l) yaxis(2) xaxis(1))}

{pstd}
Because {cmd:yaxis(1)} is the default, you need not bother to
type it.  Similarly, because {cmd:xaxis(1)} is the default, you could
omit typing it, too:

{p 8 17 2}
{cmd:. twoway (scatter gnp year, c(l))}{break}
{cmd:(scatter r{space 3}year, c(l) yaxis(2))}


{marker remarks4}{...}
{title:Notation style is irrelevant}

{pstd}
Whether you use the {cmd:()}-binding notation or the {cmd:||}-separator
notation never matters.
You could just as well type

{p 8 21 2}
{cmd:. scatter gnp year, c(l) || scatter r year, c(l) yaxis(2)}


{marker remarks5}{...}
{title:yaxis() and xaxis() are plot options}

{pstd}
Unlike all the other axis options, {cmd:yaxis()} and {cmd:xaxis()} are options
of the individual plots and not of {cmd:twoway} itself.  You may not type

{phang2}
{cmd:. scatter gnp year, c(l) || scatter r year, c(l) ||, yaxis(2)}

{pstd}
because {cmd:twoway} would have no way of knowing whether you wanted
{cmd:yaxis(2)} to apply to the first or to the second {cmd:scatter}.  Although
it is true that how the axes appear is a property of {cmd:twoway} -- see
{manhelpi axis_options G-3} -- which axes are used for which plots is a property
of the plots themselves.

{pstd}
For instance, options {cmd:ylabel()} and {cmd:xlabel()} are options that
specify the major ticking and labeling of an axis (see
{manhelpi axis_label_options G-3}).  If you want the {it:x} axis to have
10 ticks with labels, you can type

{p 8 10 2}
{cmd:. scatter gnp year, c(l) ||}{break}
{cmd:scatter r{space 3}year, c(l) yaxis(2) ||, xlabel(#10)}

{pstd}
and indeed you are "supposed" to type it that way to illustrate your deep
understanding that {cmd:xlabel()} is a {cmd:twoway} option.  Nonetheless, you
may type

{p 8 10 2}
{cmd:. scatter gnp year, c(l) ||}{break}
{cmd:scatter r{space 3}year, c(l) yaxis(2) xlabel(#10)}

{pstd}
or

{p 8 10 2}
{cmd:. scatter gnp year, c(l) xlabel(#10) ||}{break}
{cmd:scatter r{space 3} year, c(l) yaxis(2)}

{pstd}
because {cmd:twoway} can reach inside the individual plots and pull out
options intended for it.  What {cmd:twoway} cannot do is redistribute options
specified explicitly as {cmd:twoway} back to the individual plots.


{marker remarks6}{...}
{title:Specifying the other axes options with multiple axes}

{pstd}
Continuing with our example,

{p 8 10 2}
{cmd:. scatter gnp year, c(l) ||}{break}
{cmd:scatter r{space 3}year, c(l) yaxis(2) ||}{break}
{cmd:, xlabel(#10)}

{pstd}
say that you also wanted 10 ticks with labels on the first {it:y} axis and
8 ticks with labels on the second {it:y} axis.  You type

{p 8 10 2}
{cmd:. scatter gnp year, c(l) ||}{break}
{cmd:scatter r{space 3}year, c(l) yaxis(2) ||}{break}
{cmd:, xlabel(#10){space 2}ylabel(#10, axis(1)){space 2}ylabel(#8, axis(2))}

{pstd}
Each of the other axis options (see 
{manhelpi axis_options G-3}) has an
{cmd:axis(}{it:#}{cmd:)} suboption that specifies to which axis the option
applies.  When you do not specify the suboption, {cmd:axis(1)}
is assumed.

{pstd}
As always, even though the other axis options are options of {cmd:twoway},
you can let them run together with the options of individual plots:

	{cmd}. scatter gnp year, c(l) ||
	  scatter r   year, c(l) yaxis(2) xlabel(#10) ylabel(#10, axis(1))
			    ylabel(#8, axis(2)){txt}


{marker remarks7}{...}
{title:Each plot may have at most one x scale and one y scale}

{pstd}
Each {cmd:scatter}, {cmd:line}, {cmd:connected}, etc. -- that is, each
plot -- may have only one {it:y} scale and one {it:x} scale, so
you may not type the shorthand

{phang2}
{cmd:. scatter gnp r year, c(l l) yaxis(1 2)}

{pstd}
to put {cmd:gnp} on one axis and {cmd:r} on another.
In fact, {cmd:yaxis(1 2)} is not an error -- we will get to that in the
next section -- but it will not put {cmd:gnp} on one axis and {cmd:r} on
another.  To do that, you must type

	{cmd:. twoway (scatter gnp year, c(l) yaxis(1))}
	{cmd:         (scatter r   year, c(l) yaxis(2))}

{pstd}
which, of course, you may type as

{phang2}
{cmd:. scatter gnp year, c(l) yaxis(1) || scatter r year, c(l) yaxis(2)}

{pstd}
The overall graph may have multiple scales, but the individual plots that
appear in it may not.


{marker remarks8}{...}
{title:Special case:  Multiple axes with a shared scale}

{pstd}
It is sometimes useful to have multiple axes just so that you have extra
places to label special values.  Consider graphing blood pressure versus
concentration of some drug:

	{cmd:. scatter bp concentration}

{pstd}
Perhaps you would like to add a line at bp=120 and label that value
specially.  One thing you might do is

	{cmd:. scatter bp concentration, yaxis(1 2) ylabel(120, axis(2))}

{pstd}
The {cmd:ylabel(120, axis(2))} part is explained in 
{manhelpi axis_label_options G-3};
it caused the second axis to have the value 120 labeled.  The option
{cmd:yaxis(1 2)} caused there to be a second axis, which you could label.
When you specify {cmd:yaxis()} (or {cmd:xaxis()}) with more than one number,
you are specifying that the axes be created sharing the same scale.

{pstd}
To better understand what {cmd:yaxis(1 2)} does, compare the results of

	{cmd:. scatter bp concentration}

{pstd}
with

	{cmd:. scatter bp concentration, yaxis(1 2)}

{pstd}
In the first graph, there is one {it:y} axis on the left.  In
the second graph, there are two {it:y} axes, one on the left and one
on the right, and they are labeled identically.

{pstd}
Now compare

	{cmd:. scatter bp concentration}

{pstd}
with

	{cmd:. scatter bp concentration, xaxis(1 2)}

{pstd}
In the first graph, there is one {it:x} axis on the bottom.  In the
second graph, there are two {it:x} axes, one on the bottom and one on the
top, and they are labeled identically.

{pstd}
Finally, try

	{cmd:. scatter bp concentration, yaxis(1 2) xaxis(1 2)}

{pstd}
In this graph, there are two {it:y} axes and two {it:x} axes:  left and right,
and top and bottom.
{p_end}
