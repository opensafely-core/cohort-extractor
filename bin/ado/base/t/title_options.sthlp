{smcl}
{* *! version 1.1.11  16apr2019}{...}
{vieweralsosee "[G-3] title_options" "mansection G-3 title_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] legend_options" "help legend_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{vieweralsosee "[G-4] text" "help text"}{...}
{viewerjumpto "Syntax" "title_options##syntax"}{...}
{viewerjumpto "Description" "title_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "title_options##linkspdf"}{...}
{viewerjumpto "Options" "title_options##options"}{...}
{viewerjumpto "Suboptions" "title_options##suboptions"}{...}
{viewerjumpto "Remarks" "title_options##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:title_options} {hline 2}}Options for specifying titles{p_end}
{p2col:}({mansection G-3 title_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 35}{...}
{p2col:{it:title_options}}Description{p_end}
{p2line}
{p2col:{cmdab:ti:tle:(}{it:tinfo}{cmd:)}}overall title{p_end}
{p2col:{cmdab:sub:title:(}{it:tinfo}{cmd:)}}subtitle of title{p_end}
{p2col:{cmd:note(}{it:tinfo}{cmd:)}}note about graph{p_end}
{p2col:{cmdab:cap:tion:(}{it:tinfo}{cmd:)}}explanation of graph{p_end}

{p2col:{cmdab:t1:title:(}{it:tinfo}{cmd:)}{space 2}{cmdab:t2:title:(}{it:tinfo}{cmd:)}}rarely used{p_end}
{p2col:{cmdab:b1:title:(}{it:tinfo}{cmd:)}{space 2}{cmdab:b2:title:(}{it:tinfo}{cmd:)}}rarely used{p_end}
{p2col:{cmdab:l1:title:(}{it:tinfo}{cmd:)}{space 2}{cmdab:l2:title:(}{it:tinfo}{cmd:)}}vertical text{p_end}
{p2col:{cmdab:r1:title:(}{it:tinfo}{cmd:)}{space 2}{cmdab:r2:title:(}{it:tinfo}{cmd:)}}vertical text{p_end}
{p2line}
{p 4 6 2}
The above options are {it:merged-explicit}; see {help repeated options}.
{break}
{c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{c -(}{cmd:1}|{cmd:2}{c )-}{cmd:title()} are allowed with {cmd:graph} {cmd:twoway} only.

{marker tinfo}{...}
{pstd}
where {it:tinfo} is

{p 8 16 2}
{cmd:"}{it:string}{cmd:"}
[{cmd:"}{it:string}{cmd:"} [...]]
[{cmd:,}
{it:suboptions}]

{pmore}
{it:string} may contain Unicode characters and SMCL tags to render mathematical
symbols, italics, etc.; see {manhelpi graph_text G-4:text}.

{p2col:{it:suboptions}}Description{p_end}
{p2line}
{p2col:{cmd:prefix} and {cmd:suffix}}add to title text{p_end}
{p2col:{cmdab:pos:ition:(}{it:{help clockposstyle}}{cmd:)}}position of title
        -- side{p_end}
{p2col:{cmd:ring(}{it:{help ringposstyle}}{cmd:)}}position of title -- distance
      {p_end}
{p2col:{cmd:span}}"centering" of title{p_end}
{p2col:{it:{help textbox_options}}}rendition of title{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
Option {cmd:position()} is not allowed with {c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{c -(}{cmd:1}|{cmd:2}{c )-}{cmd:title()}.

{pstd}
Examples include

	{cmd:title("My graph")}
	{cmd:note(`"includes both "high" and "low" priced items"')}

	{cmd:title("First line" "Second line")}
	{cmd:title("Third line", suffix)}
	{cmd:title("Fourth line" "Fifth line", suffix)}

{pstd}
The definition of {it:ringposstyle} and
the default positioning of titles is

	  l2  l1                          r1  r2     {c |}
	   1  2  0 0 0 0 0 0 0 0 0 0 0 0   1  2      {c |}  {it:ringposstyle}
	{hline 45}{c +}{hline 20}
	{c TLC}{hline 39}{c TRC}    {c |}
	{c |}                title                  {c |}    {c |}    7     title
	{c |}               subtitle                {c |}    {c |}    6     subtitle
	{c |}               t2title                 {c |}    {c |}    2     t2
	{c |}               t1title                 {c |}    {c |}    1     t1
	{c |}       {c TLC}{hline 23}{c TRC}       {c |}    {c |}
	{c |}  l  l {c |}                       {c |} r  r  {c |}    {c |}    0
	{c |}  2  1 {c |}                       {c |} 1  2  {c |}    {c |}    0
	{c |}  t  t {c |}                       {c |} t  t  {c |}    {c |}    0
	{c |}  i  i {c |}      {it:plot region}      {c |} i  i  {c |}    {c |}    0
	{c |}  t  t {c |}                       {c |} t  t  {c |}    {c |}    0
	{c |}  l  l {c |}                       {c |} l  l  {c |}    {c |}    0
	{c |}  e  e {c |}                       {c |} e  e  {c |}    {c |}    0
	{c |}       {c BLC}{hline 23}{c BRC}       {c |}    {c |}
	{c |}               b1title                 {c |}    {c |}    1     b1
	{c |}               b2title                 {c |}    {c |}    2     b2
	{c |}               legend                  {c |}    {c |}    3     legend
	{c |}       note                            {c |}    {c |}    4     note
	{c |}       caption                         {c |}    {c |}    5     caption
	{c BLC}{hline 39}{c BRC}
	   where titles are located is
	   controlled by the {help schemes:scheme}


{marker description}{...}
{title:Description}

{pstd}
Titles are the adornment around a graph that explains the graph's purpose.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 title_optionsQuickstart:Quick start}

        {mansection G-3 title_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:title(}{it:{help title_options##tinfo:tinfo}}{cmd:)}
    specifies the overall title of the graph.
    The title usually appears centered at the top of the graph.
    It is sometimes desirable to specify the {cmd:span} suboption
    when specifying the title, as in

{phang2}
	{cmd:. graph} ...{cmd:,} ...{cmd:title("Life expectancy", span)}

{pmore}
    See {it:{help title_options##remarks5:Spanning}} under {it:Remarks} below.

{phang}
{cmd:subtitle(}{it:{help title_options##tinfo:tinfo}}{cmd:)}
    specifies the subtitle of the graph.  The subtitle appears near the title
    (usually directly under it) and is presented in a slightly smaller font.
    {cmd:subtitle()} is used in conjunction with {cmd:title()}, and
    {cmd:subtitle()} is used by itself when the {cmd:title()} seems too big.
    For instance, you might type

{phang2}
	    {cmd:. graph} ...{cmd:,} ... {cmd:title("Life expectancy") subtitle("1900-1999")}
{p_end}
	or
{phang2}
	    {cmd:. graph} ...{cmd:,} ... {cmd:subtitle("Life expectancy" "1900-1999")}

{pmore}
    If {cmd:subtitle()} is used in conjunction with {cmd:title()} and
    you specify suboption {cmd:span} with {cmd:title()}, remember also to
    specify {cmd:span} with {cmd:subtitle()}.

{phang}
{cmd:note(}{it:{help title_options##tinfo:tinfo}}{cmd:)}
    specifies notes to be displayed with the graph.  Notes are usually
    displayed in a small font placed at the bottom-left corner of the graph.
    By default, the left edge of the note will align with the left edge of the
    plot region.  Specify suboption {cmd:span} if you wish the note moved all
    the way left; see {it:{help title_options##remarks5:Spanning}} under
    {it:Remarks} below.

{phang}
{cmd:caption(}{it:{help title_options##tinfo:tinfo}}{cmd:)}
    specifies an explanation to accompany the graph.  Captions are usually
    displayed at the bottom of the graph, below the {cmd:note()}, in
    a font slightly larger than used for the {cmd:note()}.
    By default, the left edge of the caption will align with the left edge of
    the plot region.  Specify suboption {cmd:span} if you wish the note moved
    all the way left; see {it:{help title_options##remarks5:Spanning}} under
    {it:Remarks} below.

{phang}
{c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{c -(}{cmd:1}|{cmd:2}{c )-}{cmd:title()}
     are rarely specified.  It is generally better to specify the
     {it:axis_title_options} {cmd:ytitle()} or {cmd:xtitle()};
     see {manhelpi axis_title_options G-3}.
     The
{c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{c -(}{cmd:1}|{cmd:2}{c )-}{cmd:title()}
     options are included for backward compatibility with previous versions
     of Stata.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:prefix} and {cmd:suffix} specify that the specified text be added
    as separate lines either before or after any existing title of the
    specified type.  See
    {it:{help title_options##remarks2:Interpretation of repeated options}}
    below.

{phang}
{cmd:position(}{it:clockposstyle}{cmd:)}
and
{cmd:ring(}{it:ringposstyle}{cmd:)}
    override the default location of the title; see
    {manhelpi clockposstyle G-4} and {manhelpi ringposstyle G-4}.
    {cmd:position()} specifies a
    direction {it:[sic]} according to the hours on the dial of a 12-hour clock,
    and {cmd:ring()} specifies how far from the plot region the title is to
    appear.

{pmore}
    {cmd:ring(0)} is defined as inside the plot region and is for the
    special case when you are placing a title directly on top of the plot.
    {cmd:ring(}{it:k}{cmd:)}, {it:k}>0, specifies positions outside the plot
    region; the larger the {cmd:ring()} value, the farther away from the plot
    region.  {cmd:ring()} values may be integer or noninteger and
    are treated ordinally.

{pmore}
    {cmd:position(12)} puts the title directly above the plot region
    (assuming {cmd:ring()}>0), {cmd:position(3)} puts the title directly to
    the right of the plot region, and so on.

{phang}
{cmd:span} specifies that the title be placed in an area spanning the
    entire width (or height) of the graph rather than an area spanning the
    plot region.
    See {it:{help title_options##remarks5:Spanning}} under {it:Remarks} below.

{phang}
{it:textbox_options} are any of the options allowed with a textbox.
    Important options include

{pmore}
    {cmd:justification(}{cmd:left}|{cmd:center}|{cmd:right)}:
    determines how the text is to be centered;

{pmore}
    {cmd:orientation(horizontal}|{cmd:vertical)}:  determines whether
    the text in the box reads from left to right or from bottom to top (there
    are other alternatives as well);

{pmore}
    {cmd:color()}:  determines the color and opacity of the text;

{pmore}
    {cmd:box}:  determines whether a box is drawn around the text;

{pmore}
{cmd:width(}{it:size}{cmd:)}:
    overrides the calculated width of the text box and is used in
    cases when text flows outside the box or when there is too much space
    between the text and the right border of the box; see
    {it:{help textbox_options##remarks6:Width and height}} under
    {manhelpi textbox_options G-3}.

{pmore}
    See {manhelpi textbox_options G-3} for a description of each of the
    above options.


{marker remarks}{...}
{title:Remarks}

{pstd}
Titles is the generic term we will use for titles, subtitles, keys, etc.,
and title options is the generic term we will use for
{cmd:title()}, {cmd:subtitle()}, {cmd:note()}, {cmd:caption()},
and
{c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{c -(}{cmd:1}|{cmd:2}{c )-}{cmd:title()}.
Titles and title options all work the same way.
In our examples, we will most often use
the {cmd:title()} option, but we could equally well use any of
the title options.

{pstd}
Remarks are presented under the following headings:

	{help title_options##remarks1:Multiple-line titles}
	{help title_options##remarks2:Interpretation of repeated options}
	{help title_options##remarks3:Positioning of titles}
	{help title_options##remarks4:Alignment of titles}
	{help title_options##remarks5:Spanning}
	{help title_options##remarks6:Using the textbox options box and bexpand}


{marker remarks1}{...}
{title:Multiple-line titles}

{pstd}
Titles can have multiple lines:

	{cmd:. graph} ...{cmd:, title("My title")} ...

{pstd}
specifies a one line title,

{phang2}
	{cmd:. graph} ...{cmd:, title("My title" "Second line")} ...

{pstd}
specifies a two-line title, and

{phang2}
	{cmd:. graph} ...{cmd:, title("My title" "Second line" "Third line")} ...

{pstd}
specifies a three-line title.  You may have as many lines in your titles
as you wish.


{marker remarks2}{...}
{title:Interpretation of repeated options}

{pstd}
Each of the title options can be specified more than once in the same command.
For instance,

{phang2}
	{cmd:. graph} ...{cmd:, title("One")} ... {cmd:title("Two")} ...

{pstd}
This does not produce a two-line title.  Rather, when you specify multiple
title options, the rightmost option is operative and the earlier
options are ignored.  The title in the above command will be "Two".

{pstd}
That is, the earlier options will be ignored unless you specify {cmd:prefix} or
{cmd:suffix}.  In

{phang2}
	. {cmd:graph} ...{cmd:, title("One")} ... {cmd:title("Two", suffix)} ...

{pstd}
the title will consist of two lines, the first line being "One" and the
second, "Two".  In

{phang2}
	. {cmd:graph} ...{cmd:, title("One")} ... {cmd:title("Two", prefix)} ...

{pstd}
the first line will be "Two" and the second line, "One".

{pstd}
Repeatedly specifying title options may seem silly, but it is easier to do
than you might expect.  Consider the command

{phang2}
{cmd}. twoway
(sc y1 x1, title("x1 vs. y1"))
(sc y2 x2, title("x2 vs. y2")){txt}

{pstd}
{cmd:title()} is an option of {cmd:twoway}, not {cmd:scatter}, and
graphs have only one {cmd:title()} (although it might consist of multiple
lines).  Thus the above is probably not what the user intended.  Had the user
typed

{phang2}
{cmd}. twoway
(sc y1 x1)
(sc y2 x2),
title("x1 vs. y1") title("x2 vs. y2"){txt}

{pstd}
he would have seen his mistake.  It is, however, okay to put {cmd:title()}
options inside the {cmd:scatter}s; {cmd:twoway} knows to pull them out.
Nevertheless, only the rightmost one will be honored (because neither
{cmd:prefix} nor {cmd:suffix} was specified), and thus the title of this
graph will be "x2 vs. y2".

{pstd}
Multiple title options arise usefully when you are using a command that
draws graphs that itself is written in terms of {cmd:graph}.  For instance,
the command {cmd:sts} {cmd:graph} (see {manhelp sts ST}) will graph
the Kaplan-Meier survivor function.  When you type

	{cmd:. sts graph}

{pstd}
with the appropriate data in memory, a graph will appear, and that graph will
have a {cmd:title()}.  Yet, if you type

{phang2}
	{cmd:. sts graph, title("Survivor function for treatment 1")}

{pstd}
your title will override {cmd:sts} {cmd:graph}'s default.  Inside the code
of {cmd:sts} {cmd:graph}, both {cmd:title()} options appear on the {cmd:graph}
command.  First appears the default and second appears the one that you
specified.  This programming detail is worth understanding because, as an
implication, if you type

{phang2}
	{cmd:. sts graph, title("for treatment 1", suffix)}

{pstd}
your title will be suffixed to the default.  Most commands work this way,
so if you use some command and it produces a title you do not like,
specify {cmd:title()} (or {cmd:subtitle()}, ...) to override it, or
specify {cmd:title(}...{cmd:,} {cmd:suffix)} (or
{cmd:subtitle(}...{cmd:,} {cmd:suffix)}, ...) to add to it.

	{hline}
{pmore}
{it:Technical note:}
Title options before the rightmost one are not completely ignored.  Their
options are merged and honored, so if a title is moved or the color changed
early on, the title will continue to be moved or the color changed.  You can
always specify the options to change it back.
{p_end}
	{hline}


{marker remarks3}{...}
{title:Positioning of titles}

{pstd}
Where titles appear is determined by the scheme that you choose; see 
{manhelp schemes G-4:Schemes intro}.  Options
{cmd:position(}{it:clockposstyle}{cmd:)} and {cmd:ring(}{it:ringposstyle}{cmd:)}
override that location and let you place the title where you want it.

{pstd}
{cmd:position()} specifies a direction {it:(sic)} according to the hours of a
12-hour clock and {cmd:ring()} specifies how far from the plot region the
title is to appear.

		Interpretation of clock {cmd:position()}
		    {cmd:ring(}{it:k}{cmd:)}, {it:k}>0, and {cmd:ring(0)}
	    {c TLC}{hline 39}{c TRC}
	    {c |}        11         12        1         {c |}
	    {c |}                                       {c |}
	    {c |}       {c TLC}{hline 23}{c TRC}       {c |}
	    {c |}10     {c |}10 or 11   12   1 or 2 {c |}     2 {c |}
	    {c |}       {c |}                       {c |}       {c |}
	    {c |}       {c |}                       {c |}       {c |}
	    {c |} 9     {c |} 9          0        3 {c |}     3 {c |}
	    {c |}       {c |}                       {c |}       {c |}
	    {c |}       {c |}                       {c |}       {c |}
	    {c |} 8     {c |} 7 or 8     6   4 or 5 {c |}     4 {c |}
	    {c |}       {c BLC}{hline 23}{c BRC}       {c |}
	    {c |}                                       {c |}
	    {c |}         7         6         5         {c |}
	    {c BLC}{hline 39}{c BRC}

	    Interpretation of {cmd:ring()}
	    {hline 25}{c TT}{hline 25}
	    plot region        0     {c |} {cmd:ring(0)} = plot region
	    {c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{cmd:1title()}  1     {c |}
	    {c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{cmd:2title()}  2     {c |} {cmd:ring(}{it:k}{cmd:)}, {it:k}>0, is outside
	    {cmd:legend()}           3     {c |} the plot region
	    {cmd:note()}             4     {c |}
	    {cmd:caption()}          5     {c |} the larger the {cmd:ring()}
	    {cmd:subtitle()}         6     {c |} value, the farther
	    {cmd:title()}            7     {c |} away
	    {hline 25}{c BT}{hline 25}

{pstd}
    {cmd:position()} has two interpretations, one for {cmd:ring(0)} and
    another for {cmd:ring(}{it:k}{cmd:)}, {it:k}>0.  {cmd:ring(0)} is for the
    special case when you are placing a title directly on top of the plot.
    Put that case aside; titles usually appear outside the plot region.

{pstd}
    A title directly above the plot region is at {cmd:position(12)},
    a title to the right at {cmd:position(3)}, and so on.  If you put
    your title at {cmd:position(1)}, it will end up above and to the
    right of the plot region.

{pstd}
    Now consider two titles -- say {cmd:title()} and
    {cmd:subtitle()} -- both
    located at {cmd:position(12)}.  Which is to appear first?  That is
    determined by their respective {cmd:ring()} values.  {cmd:ring()}
    specifies ordinally how far a title is from the plot region.
    The title with the larger {cmd:ring()} value is placed
    farther out.  {cmd:ring()} values may be integer or noninteger.

{pstd}
    For instance, {cmd:legend()} (see {manhelpi legend_options G-3})
    is closer to the plot region than
    {cmd:caption()} because, by default, {cmd:legend()} has a {cmd:ring()}
    value of 4 and {cmd:caption()} a {cmd:ring()} value of 5.  Because both
    appear at {cmd:position(7)}, both appear below the plot region and
    because 4<5, the {cmd:legend()} appears above the {cmd:caption()}.
    These defaults assume that you are using the default scheme.

{pstd}
    If you wanted to put your legend below the caption, you could specify

{phang3}
	    {cmd:. graph} ...{cmd:, legend(}... {cmd:ring(5.5)) caption("My caption")}

{pstd}
or

{phang3}
	    {cmd:. graph} ...{cmd:, legend(}...{cmd:) caption("My caption", ring(3.5))}

{pstd}
    The plot region itself is defined as {cmd:ring(0)}, and if you specified
    that, the title would appear inside the plot region, right on top of what
    is plotted!  You can specify where inside the plot region you want the
    title with {cmd:position()}, and the title will put itself on the
    corresponding edge of the plot region.  In {cmd:ring(0)}, the clock
    positions 1 and 2, 4 and 5, 7 and 8, and 10 and 11 are treated as being
    the same.  Also, {cmd:position(0)} designates the center of the
    plot region.

{pstd}
    Within the plot region -- within {cmd:ring(0)} -- given a
    {cmd:position()}, you can further shift the title up or down or left or
    right by specifying the title's {cmd:margin()} {it:textbox_option}.  For
    instance, you might specify

{phang2}
	{cmd:. graph} ...{cmd:, caption(}...{cmd:, ring(0) pos(7))} ...

{pstd}
    and then discover that the caption needed to be moved up and right
    a little and so change the {cmd:caption()} option to read

{phang2}
	{cmd:. graph} ...{cmd:, caption(}...{cmd:, ring(0) pos(7) margin(medium))} ...

{pstd}
    See {manhelpi textbox_options G-3} and
    {manhelpi marginstyle G-4} for more information on the {cmd:margin()}
    option.


{marker remarks4}{...}
{title:Alignment of titles}

{pstd}
How should the text be placed in the textbox:  left-justified, centered, or
right-justified?  The defaults that have been set vary according to
title type:

	title type              default justification
	{hline 45}
	{cmd:title()}                 centered
	{cmd:subtitle()}              centered
	{c -(}{cmd:t}|{cmd:b}|{cmd:l}|{cmd:r}{c )-}{c -(}{cmd:1}|{cmd:2}{c )-}{cmd:title()}   centered
	{cmd:note()}                  left-justified
	{cmd:caption()}               left-justified
	{hline 45}

{pstd}
Actually, how a title is justified is, by default, determined by the scheme,
and in the above, we assume that you are using a default scheme.

{pstd}
You can change that justification using the
{it:textbox_option}
{cmd:justification(}{cmd:left}|{cmd:center}|{cmd:right)}.
For instance,

{phang2}
	{cmd:. graph} ...{cmd:, title("My title", justification(left))} ...

{pstd}
See {manhelpi textbox_options G-3}.


{marker remarks5}{...}
{title:Spanning}

{pstd}
Option {cmd:span} specifies that the title is to be placed in an area spanning
the entire width (or height) of the graph rather than an area spanning the
plot region.  That is,

	    {c TLC}{hline 39}{c TRC}             {c -}
	    {c |}                                       {c |}             {c |}
	    {c |}<--------------- span ---------------->{c |}             {c |}
	    {c |}                                       {c |}             {c |}
	    {c |}       |<------ default ------>|       {c |}             {c |}
	    {c |}       {c TLC}{hline 23}{c TRC}       {c |}    {c -}        {c |}
	    {c |}       {c |}                       {c |}       {c |}    {c |}        {c |}
	    {c |}       {c |}                       {c |}       {c |}    {c |}      span
	    {c |}       {c |}      {it:plot}             {c |}       {c |} default     {c |}
	    {c |}       {c |}          {it:region}       {c |}       {c |}    {c |}        {c |}
	    {c |}       {c |}                       {c |}       {c |}    {c |}        {c |}
	    {c |}       {c |}                       {c |}       {c |}    {c |}        {c |}
	    {c |}       {c BLC}{hline 23}{c BRC}       {c |}    {c -}        {c |}
	    {c |}                                       {c |}             {c |}
	    {c BLC}{hline 39}{c BRC}             {c -}

{pstd}
For instance, the {cmd:title()} is usually centered at the top of the graph.
Is it to be centered above the plot region (the default) or between the
borders of the entire available area ({cmd:title(}...{cmd:,} {cmd:span)}
specified)?  The {cmd:note()} is usually presented left-justified below
the plot region.  Is it left-justified to align with the border
of the plot region (the default), or left-justified to the entire
available area ({cmd:note(}...{cmd:,} {cmd:span)} specified)?

{pstd}
Do not confuse {cmd:span} with the {it:textbox} option
{cmd:justification(}{cmd:left}|{cmd:center}|{cmd:right)} which places the text
left-justified, centered, or right-justified in whatever area is being
spanned; see {hi:Alignment of titles} above.


{marker remarks6}{...}
{title:Using the textbox options box and bexpand}

{pstd}
The {it:textbox_options} {cmd:box} and {cmd:bexpand} -- see
{manhelpi textbox_options G-3} -- can be put to effective use with titles.
Look at three graphs:

{phang2}
	{cmd:. scatter mpg weight, title("Mileage and weight")}
{p_end}
	  {it:({stata `"gr_example auto: scatter mpg weight, title("Mileage and weight")"':click to run})}
{* graph ttlops1}{...}

{phang2}
	{cmd:. scatter mpg weight, title("Mileage and weight", box)}
{p_end}
	  {it:({stata `"gr_example auto: scatter mpg weight, title("Mileage and weight", box)"':click to run})}
{* graph ttlops2}{...}

{phang2}
	{cmd:. scatter mpg weight, title("Mileage and weight", box bexpand)}
{p_end}
	  {it:({stata `"gr_example auto: scatter mpg weight, title("Mileage and weight", box bexpand)"':click to run})}
{* graph ttlops3}{...}

{pstd}
We want to direct your attention to the treatment of the title, which will
be

			Mileage and weight

		      {c TLC}{hline 20}{c TRC}
		      {c |} Mileage and weight {c |}
		      {c BLC}{hline 20}{c BRC}

	{c TLC}{hline 48}{c TRC}
	{c |}               Mileage and weight               {c |}
	{c BLC}{hline 48}{c BRC}

{pstd}
Without options, the title appeared as is.

{pstd}
The textbox option {cmd:box} drew a box around the title.

{pstd}
The textbox options {cmd:bexpand} expanded the box to line up with the
plot region and drew a box around the expanded title.

{pstd}
In both the second and third examples, in the graphs you will also note
that the background of the textbox was shaded.  That is because most schemes
set the textbox option {cmd:bfcolor()}, but {cmd:bfcolor()} becomes
effective only when the textbox is {cmd:box}ed.
{p_end}
