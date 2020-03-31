{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-3] advanced_options" "mansection G-3 advanced_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{viewerjumpto "Syntax" "advanced_options##syntax"}{...}
{viewerjumpto "Description" "advanced_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "advanced_options##linkspdf"}{...}
{viewerjumpto "Options" "advanced_options##options"}{...}
{viewerjumpto "Remarks" "advanced_options##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-3]} {it:advanced_options} {hline 2}}Rarely specified options for use with graph twoway{p_end}
{p2col:}({mansection G-3 advanced_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col : {it:title_options}}Description{p_end}
{p2line}
{p2col : {cmdab:pcyc:le:(}{it:#}{cmd:)}}plots before {help pstyle:pstyles}
     recycle{p_end}

{p2col : {cmdab:yvarl:abel:(}{it:quoted_strings}{cmd:)}}respecify
     {it:y}-variable labels{p_end}
{p2col : {cmdab:xvarl:abel:(}{it:quoted_string}{cmd:)}}respecify
     {it:x}-variable label{p_end}

{p2col : {cmdab:yvarf:ormat:(}{help format:{bf:%}{it:fmt}} [...]{cmd:)}}respecify {it:y}-variable formats{p_end}
{p2col : {cmdab:xvarf:ormat:(}{help format:{bf:%}{it:fmt}}{cmd:)}}respecify
     {it:x}-variable format{p_end}

{p2col : {opt yoverhang:s}}adjust margins for {it:y}-axis labels{p_end}
{p2col : {opt xoverhang:s}}adjust margins for {it:x}-axis labels{p_end}

{p2col : {cmd:recast(}{it:newplottype}{cmd:)}}treat plot as {it:newplottype}
       {p_end}
{p2line}
{p 4 6 2}
The above options are {it:rightmost}; see {help repeated options}.

{pstd}
where {it:quoted_string} is one quoted string and {it:quoted_strings} are
one or more quoted strings, such as

	{cmd:"}{it:plot 1 label}{cmd:"}

	{cmd:"}{it:plot 1 label}{cmd:"} {cmd:"}{it:plot 2 label}{cmd:"}

{p2col : {it:newplottype}}
	Description{p_end}
{p2line}
{p2col : {cmdab:sc:atter}}
	treat as {helpb graph twoway scatter}{p_end}
{p2col : {cmdab:li:ne}}
	treat as {helpb graph twoway line}{p_end}
{p2col : {cmdab:con:nected}}
	treat as {helpb graph twoway connected}{p_end}
{p2col : {cmd:bar}}
	treat as {helpb graph twoway bar}{p_end}
{p2col : {cmd:area}}
	treat as {helpb graph twoway area}{p_end}
{p2col : {cmd:spike}}
	treat as {helpb graph twoway spike}{p_end}
{p2col : {cmd:dropline}}
	treat as {helpb graph twoway dropline}{p_end}
{p2col : {cmd:dot}}
	treat as {helpb graph twoway dot}{p_end}

{p2col : {cmd:rarea}}
	treat as {helpb graph twoway rarea}{p_end}
{p2col : {cmd:rbar}}
	treat as {helpb graph twoway rbar}{p_end}
{p2col : {cmd:rspike}}
	treat as {helpb graph twoway rspike}{p_end}
{p2col : {cmd:rcap}}
	treat as {helpb graph twoway rcap}{p_end}
{p2col : {cmd:rcapsym}}
	treat as {helpb graph twoway rcapsym}{p_end}
{p2col : {cmd:rline}}
	treat as {helpb graph twoway rline}{p_end}
{p2col : {cmd:rconnected}}
	treat as {helpb graph twoway rconnected}{p_end}
{p2col : {cmd:rscatter}}
	treat as {helpb graph twoway rscatter}{p_end}

{p2col:{cmd:pcspike}}
	treat as {helpb graph twoway pcspike}{p_end}
{p2col:{cmd:pccapsym}}
	treat as {helpb graph twoway pccapsym}{p_end}
{p2col:{cmd:pcarrow}}
	treat as {helpb graph twoway pcarrow}{p_end}
{p2col:{cmd:pcbarrow}}
	treat as {helpb graph twoway pcbarrow}{p_end}
{p2col:{cmd:pcscatter}}
	treat as {helpb graph twoway pcscatter}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
{it:newplottypes} in each grouping ({cmd:scatter} through
{cmd:dot}, {cmd:rarea} though {cmd:rscatter}, and {cmd:pcspike} through
{cmd:pcscatter}) should be recast only among themselves.


{marker description}{...}
{title:Description}

{pstd}
The {it:advanced_options} are not so much advanced as they are difficult to
explain and are rarely used.  They are also invaluable when you need them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 advanced_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:pcycle(}{it:#}{cmd:)}
    specifies how many plots are drawn before the {help pstyle} of the next plot
    begins again at {cmd:p1}, with the plot after the next plot using
    {cmd:p2}, and so on.  The default {it:#} for most {help schemes} is
    {cmd:pcycle(15)}.

{phang}
{cmd:yvarlabel(}{it:quoted_strings}{cmd:)}
and
{cmd:xvarlabel(}{it:quoted_string}{cmd:)}
     specify strings that are to be treated as if they were the variable
     labels of the first, second, ..., {it:y} variables and of the {it:x}
     variable.

{phang}
{cmd:yvarformat(}{help format:{bf:%}{it:fmt}}{cmd:)}
and
{cmd:xvarformat(%}{it:fmt}{cmd:)}
     specify display formats that are to be treated as if they were the
     display formats of the first, second, ..., {it:y} variables and of the
     {it:x} variable.

{phang}
{opt yoverhangs} and {opt xoverhangs} attempt to adjust the graph region
margins to prevent long labels on the {it:y} or {it:x} axis from extending off
the edges of the graph.  Only the labels for the smallest and largest tick
values on the axes are considered when making the adjustment. 
{opt yoverhangs} and {opt xoverhangs} are ignored if {helpb by_option:by()} is
specified.

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
     specifies the new plottype to which the original
     {cmd:graph} {cmd:twoway} {it:plottype} command is to be recast;
     see {manhelp graph_twoway G-2:graph twoway} to see the available
     {it:plottype}s.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help advanced_options##remarks1:Use of yvarlabel() and xvarlabel()}
	{help advanced_options##remarks2:Use of yvarformat() and xvarformat()}
	{help advanced_options##remarks3:Use of recast()}


{marker remarks1}{...}
{title:Use of yvarlabel() and xvarlabel()}

{pstd}
When you type, for instance,

	{cmd:. scatter mpg weight}

{pstd}
the axes are titled using the variable labels of {cmd:mpg} and {cmd:weight}
or, if the variables have no variable labels, using the names of the variables
themselves.  Options {cmd:yvarlabel()} and {cmd:xvarlabel()} allow you to
specify strings that will be used in preference to both the variable label and
the name.

{phang2}
	{cmd:. scatter mpg weight, yvarl("Miles per gallon")}

{pstd}
would label the {it:y} axis "Miles per gallon" (omitting the quotes),
regardless of how variable {cmd:mpg} was labeled.  Similarly,

{phang2}
	{cmd:. scatter mpg weight, xvarl("Weight in pounds")}

{pstd}
would label the {it:x} axis "Weight in pounds", regardless of how
variable {cmd:weight} was labeled.

{pstd}
Obviously, you could specify both options.

{pstd}
In neither case will the actual variable label be changed.  Options
{cmd:yvarlabel()} and {cmd:xvarlabel()} treat the specified strings as if
they were the variable labels.  {cmd:yvarlabel()} and {cmd:xvarlabel()} are
literal in this treatment.  If you specified {cmd:xvarlabel("")},
for instance, the variable label would be treated as if it were nonexistent,
and thus the variable name would be used to title the {it:x} axis.

{pstd}
What makes these two options "advanced" is not only that they affect the way
axes are titled but also that they substitute the specified strings for the
variable labels wherever the variable label might be used.  Variable labels
are also used, for instance, in the construction of legends (see 
{manhelpi legend_options G-3}).


{marker remarks2}{...}
{title:Use of yvarformat() and xvarformat()}

{pstd}
Options {cmd:yvarformat()} and {cmd:xvarformat()} work much like
{cmd:yvarlabel()} and {cmd:xvarlabel()}, except that, rather than overriding
the variable labels, they override the variable formats.
If you type

{phang2}
	{cmd:. scatter mpg weight, yvarformat(%9.2f)}

{pstd}
the values on the {it:y} axis will be labeled 10.00, 20.00, 30.00, and 40.00
rather than 10, 20, 30, and 40.


{marker remarks3}{...}
{title:Use of recast()}

{pstd}
{cmd:scatter}, {cmd:line}, {cmd:histogram}, ... -- the word that appears
directly after {cmd:graph} {cmd:twoway} -- is called a {it:plottype}.
Plottypes come in two forms:  {it:base} {it:plottypes} and
{it:derived} {it:plottypes}.

{pstd}
Base plottypes plot the data as given according to some style.
{cmd:scatter} and {cmd:line} are examples of base plottypes.

{pstd}
Derived plottypes do not plot the data as given but instead derive something
from the data and then plot that according to one of the base plottypes.
{cmd:histogram} is an example of a derived plottype.  It derives from the data
the values for the frequencies at certain {it:x} ranges, and then it plots
that derived data using the base plottype {cmd:graph} {cmd:twoway} {cmd:bar}.
{cmd:lfit} is another example of a derived plottype.  It takes the data, fits
a linear regression, and then passes that result along to {cmd:graph}
{cmd:twoway} {cmd:line}.

{pstd}
{cmd:recast()} is useful when using derived plottypes.  It specifies that the
data are to be derived just as they would be ordinarily, but rather than
passing the derived data to the default base plottype for plotting, they are
passed to the specified base plottype.

{pstd}
For instance, if we typed

{phang2}
	{cmd:. twoway lfit mpg weight, pred(resid)}

{pstd}
we would obtain a graph of the residuals as a line plot because the
{cmd:lfit} plottype produces line plots.  If we typed

{phang2}
	{cmd:. twoway lfit mpg weight, pred(resid) recast(scatter)}

{pstd}
we would obtain a scatterplot of the residuals.  {cmd:graph} {cmd:twoway}
{cmd:lfit} would use {cmd:graph} {cmd:twoway} {cmd:scatter} rather than
{cmd:graph} {cmd:twoway} {cmd:line} to plot the data it derives.

{pstd}
{cmd:recast(}{it:newplottype}{cmd:)} may be used with both derived and base
plottypes, although it is most useful when combined with derived plots.

{pin}
{it:Technical note:}{break}
The syntax diagram shown for {cmd:scatter} in
{manhelp scatter G-2:graph twoway scatter}, although
extensive, is incomplete, and so are all the other plottype
syntax diagrams shown in this manual.

{pin}
Consider what would happen if you specified

	    {cmd:. scatter} ...{cmd:,} ... {cmd:recast(bar)}

{pin}
You would be specifying that {cmd:scatter} be treated as a {cmd:bar}.
Results would be the same as if you typed

	    {cmd:. twoway bar} ...{cmd:,} ...

{pin}
but let's ignore that and pretend that you typed the {cmd:recast()} version.
What if you wanted to specify the look of the bars?  You could type

{pin2}
	    {cmd:. scatter} ...{cmd:,} ... {it:bar_options} {cmd:recast(bar)}

{pin}
That is, {cmd:scatter} allows {cmd:graph} {cmd:twoway} {cmd:bar}'s options,
even though they do not appear in {cmd:scatter}'s syntax diagram.  Similarly,
{cmd:graph} {cmd:twoway} {cmd:bar} allows all of {cmd:scatter}'s options;
you might type

{pin2}
	    {cmd:. twoway bar} ...{cmd:,} ... {it:scatter_options} {cmd:recast(scatter)}

{pin}
The same is true for all other pairs of base plottypes, with the result
that all base plottypes allow all base plottype options.  The emphasis
here is on base:  the derived plottypes do not allow this sharing.

{pin}
If you use a base plottype without {cmd:recast()} and if you specify
irrelevant options from other base types, that is not an error, but
the irrelevant options
are
ignored.  In the syntax diagrams for the base plottypes, we have listed only
the options that matter under the assumption that you do not specify
{cmd:recast}.
{p_end}
