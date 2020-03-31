{smcl}
{* *! version 1.1.11  15may2018}{...}
{vieweralsosee "[G-3] connect_options" "mansection G-3 connect_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] connectstyle" "help connectstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{viewerjumpto "Syntax" "connect_options##syntax"}{...}
{viewerjumpto "Description" "connect_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "connect_options##linkspdf"}{...}
{viewerjumpto "Options" "connect_options##options"}{...}
{viewerjumpto "Remarks" "connect_options##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[G-3]} {it:connect_options} {hline 2}}Options for connecting data points with lines{p_end}
{p2col:}({mansection G-3 connect_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 27}{...}
{p2col:{it:connect_options}}Description{p_end}
{p2line}
{p2col:{cmdab:c:onnect:(}{it:{help connectstyle}}{cmd:)}}how to connect points
      {p_end}
{p2col:{cmd:sort}[{cmd:(}{varlist}{cmd:)}]}how to sort before connecting{p_end}
{p2col:{cmdab:cmis:sing:(}{c -(}{cmd:y}|{cmd:n}{c )-} ...{cmd:)}}missing
       values are ignored{p_end}

{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}line pattern
      (solid, dashed, etc.){p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of line
      {p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of line{p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}line
	alignment (inside, outside, center){p_end}
{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of line
      {p_end}

{p2col:{cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style,
      including linestyle{p_end}

{p2col:{help advanced_options:{bf:recast(}{it:newplottype}{bf:)}}}advanced;
      treat plot as {it:newplottype}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.
If both {cmd:sort} and {cmd:sort(}{it:varlist}{cmd:)} are specified,
{cmd:sort} is ignored and
{cmd:sort(}{it:varlist}{cmd:)} is honored.


{marker description}{...}
{title:Description}

{pstd}
The {it:connect_options} specify how points on a graph are
to be connected.

{pstd}
In certain contexts (for example, {cmd:scatter}; see
{manhelp scatter G-2:graph twoway scatter}),
the {cmd:lstyle()}, {cmd:lpattern()}, {cmd:lwidth()}, {cmd:lcolor()}, and
{cmd:lalign()} options may be specified with a list of elements, with the
first element applying to the first variable, the second element to the
second variable, and so on.  For information about specifying lists, see 
{manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 connect_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt connect(connectstyle)} specifies whether points are to be connected and,
if so, how the line connecting them is to be shaped; see
{manhelpi connectstyle G-4}.  The line between each
pair of points can connect them directly or in stairstep fashion.

{phang}
{cmd:sort} and {cmd:sort(}{varlist}{cmd:)}
    specify how the data be sorted before the points are connected.

{pmore}
    {cmd:sort} specifies that the data should be sorted by the {it:x}
    variable.

{pmore}
    {cmd:sort(}{it:varlist}{cmd:)} specifies that the data be
    sorted by the specified variables.

{pmore}
    {cmd:sort} is the option usually specified.
    Unless you are after a special
    effect or your data are already sorted, do not forget to specify this
    option.  If you are after a special effect, and if the data are not
    already sorted, you can specify {cmd:sort(}{it:varlist}{cmd:)} to specify
    exactly how the data should be sorted.

{pmore}
    Specifying {cmd:sort} or {cmd:sort(}{it:varlist}{cmd:)} when it is not
    necessary will slow {cmd:graph} down a little.  It is usually necessary to
    specify {cmd:sort} if you specify the {cmd:twoway} option {cmd:by()}, and
    especially if you include the suboption {cmd:total}.

{pmore}
    Options {cmd:sort} and {cmd:sort(}{it:varlist}{cmd:)} may not be repeated
    within the same plot.

{phang}
{cmd:cmissing(}{c -(}{cmd:y}|{cmd:n}{c )-} ...{cmd:)}
    specifies whether missing values are to be ignored.  The default is
    {cmd:cmissing(y} {cmd:...)}, meaning that they are ignored.
    Consider the following data:

	    {txt}
		 {c TLC}{hline 8}{c -}{hline 3}{c TRC}
		 {c |} {res}  rval   x {txt}{c |}
		 {c LT}{hline 8}{c -}{hline 3}{c RT}
	      1. {c |} {res}  .923   1 {txt}{c |}
	      2. {c |} {res} 3.046   2 {txt}{c |}
	      3. {c |} {res} 5.169   3 {txt}{c |}
	      4. {c |} {res}     .   . {txt}{c |}
	      5. {c |} {res} 9.415   5 {txt}{c |}
		 {c LT}{hline 8}{c -}{hline 3}{c RT}
	      6. {c |} {res}11.538   6 {txt}{c |}
		 {c BLC}{hline 8}{c -}{hline 3}{c BRC}{txt}

{pmore}
Say that you graph these data by using "{cmd:line} {cmd:rval} {cmd:x}" or
equivalently "{cmd:scatter} {cmd:rval} {cmd:x,} {cmd:c(l)}".
Do you want a break in the line between 3 and 5?  If so, you code

	    {cmd:. line rval x, cmissing(n)}

{pmore}
or equivalently

	    {cmd:. scatter rval x, c(l) cmissing(n)}

{pmore}
If you omit the option (or code {cmd:cmissing(y)}), the data are treated
as if they contained

		 {c TLC}{hline 8}{c -}{hline 3}{c TRC}
		 {c |} {res}  rval   x {txt}{c |}
		 {c LT}{hline 8}{c -}{hline 3}{c RT}
	      1. {c |} {res}  .923   1 {txt}{c |}
	      2. {c |} {res} 3.046   2 {txt}{c |}
	      3. {c |} {res} 5.169   3 {txt}{c |}
	      4. {c |} {res} 9.415   5 {txt}{c |}
	      5. {c |} {res}11.538   6 {txt}{c |}
		 {c BLC}{hline 8}{c -}{hline 3}{c BRC}{txt}

{pmore}
meaning that a line will be drawn between {bind:(3, 5.169)} and
{bind:(5, 9.415)}.

{pmore}
If you are plotting more than one variable, you may specify a sequence of
{cmd:y}/{cmd:n} answers.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)},
{cmd:lwidth(}{it:linewidthstyle}{cmd:)},
{cmd:lcolor(}{it:colorstyle}{cmd:)},
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
and
{cmd:lstyle(}{it:linestyle}{cmd:)}
    determine the look of the line used to connect the points; see 
    {help lines}.  Note the {cmd:lpattern()} option, which
    allows you to specify whether the line is solid, dashed, etc.;
    see {manhelpi linepatternstyle G-4} for a list of line-pattern choices.

{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot, including not only the
    {it:{help linestyle}}, but also all other settings for the look of the plot.
    Only the {it:linestyle} affects the look of line plots.  See
    {manhelpi pstyle G-4} for a list of available plot styles.

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
        is an advanced option allowing the plot to be recast from one type to
        another, for example, from a {help twoway line:line plot} to a
        {help twoway scatter:scatterplot}; see
        {manhelpi advanced_options G-3}.  Most, but not all, plots allow
        {cmd:recast()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
An important option among all the above is {cmd:connect()}, which  determines
whether and how the points are connected.  The points need not be connected at
all ({cmd:connect(i)}), which is {cmd:scatter}'s default.  Or the points might
be connected by straight lines ({cmd:connect(l)}), which is {cmd:line}'s
default (and is available in {cmd:scatter}).  {cmd:connect(i)} and
{cmd:connect(l)} are commonly specified, but there are other possibilities
such as {cmd:connect(J)}, which connects in stairstep fashion and is
appropriate for empirical distributions.  See {manhelpi connectstyle G-4}
for a full list of your choices.

{pstd}
Equally as important as {cmd:connect()} is {cmd:sort}.  If you do not
specify this, the points will be connected in the order in which they
are encountered.  That can be useful when you are creating special effects,
but, in general, you want the points sorted into ascending order of their
{it:x} variable.  That is what {cmd:sort} does.

{pstd}
The remaining connect options specify how the line is to look:  Is it solid or
dashed?  Is it red or green?  How thick is it?  Option
{cmd:lpattern()} can be of great importance, especially when printing to a
monochrome printer.  For a general discussion of lines (which occur in
many contexts other than connecting points), see {help lines}.
{p_end}
