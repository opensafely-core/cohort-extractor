{smcl}
{* *! version 1.0.4  13apr2010}{...}
{cmd:help gr7axes}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:{cmd:graph7} command common options -- title and axes options}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}] [{cmd:,} {it:graph_type} {it:specific_options}
{it:common_options}]


{p 4 4 2}
The title and axes {it:common_options} are

{p 8 8 2}
{cmdab:noax:is}
[{cmdab:no:}]{cmdab:bor:der}
{cmdab:g:ap:(}{it:#}{cmd:)}{break}
{cmdab:lo:g}
{cmdab:ylo:g}
{cmdab:xlo:g}
{cmdab:rlo:g}

{p 8 8 2}
{cmdab:ti:tle:("}{it:text}{cmd:")}
{cmdab:t1:title:("}{it:text}{cmd:")}
{cmdab:t2:title:("}{it:text}{cmd:")}
{cmdab:b1:title:("}{it:text}{cmd:")}
{cmdab:b2:title:("}{it:text}{cmd:")}
{cmdab:l1:title:("}{it:text}{cmd:")}
{cmdab:l2:title:("}{it:text}{cmd:")}
{cmdab:r1:title:("}{it:text}{cmd:")}
{cmdab:r2:title:("}{it:text}{cmd:")}

{p 8 8 2}
{cmd:key1(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)}{break}
{cmd:key2(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)}{break}
{cmd:key3(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)}{break}
{cmd:key4(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)}

{p 8 8 2}
{cmdab:xla:bel}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:yla:bel}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:rla:bel}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:tla:bel}[{cmd:(}{it:numlist}{cmd:)}]

{p 8 8 2}
{cmdab:xt:ick}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:yt:ick}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:rt:ick}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:tt:ick}[{cmd:(}{it:numlist}{cmd:)}]

{p 8 8 2}
{cmdab:xs:cale:(}{it:#}[{cmd:,}]{it:#}{cmd:)}
{cmdab:ys:cale:(}{it:#}[{cmd:,}]{it:#}{cmd:)}
{cmdab:rs:cale:(}{it:#}[{cmd:,}]{it:#}{cmd:)}


{p 4 4 2}
Information on the {cmd:graph7} command and the different {it:graph_types}
is found in {helpb graph7}.  This entry details the title and axes
{it:common_options}.  Help for the other {it:common_options} is also
available.  See {help gr7sym} for symbols and lines; help {help gr7color}
for color and shading; {help gr7other} for saving, printing, and multiple
images.


{title:Options}

{p 4 8 2}{cmd:noaxis} requests that no axis be drawn.

{p 4 8 2}[{cmd:no}]{cmd:border} requests or suppresses a border-style axis.
{cmd:border} requests the border style.  On occasion, {cmd:graph7} may decide
by itself that a border would look better.  On those occasions, {cmd:noborder}
requests that only an axis be drawn.  "{cmd:graph7 y x, border}" graph7 y
versus x with a border-style axis.

{p 8 8 2}{cmd:border} is also used with {cmd:matrix} (see {help gr7matrix})
to indicate that the diagonal entries are to be bordered.

{p 8 8 2}Borders, like axes, are always drawn using pen 1.

{p 4 8 2}{cmd:gap(}{it:#}{cmd:)} sets the amount of space between the left title
and the values along the axis on any style that includes an axis.  The default
is 8 although it "should be" 9.  If it were 9, the value labels could never
run into the left title.  In most cases, however, 8 is sufficient and 9
results in too much space to be aesthetically pleasing.  You can close or
widen the gap.

{p 4 8 2}{cmd:log}, {cmd:ylog}, {cmd:xlog}, and {cmd:rlog} specify log scales.
{cmd:log} is used for {cmd:histogram} (see {help gr7hist}) and the
remaining options are used for {cmd:twoway} (see {help gr7twoway}).
{cmd:rlog} refers to the right scale and is allowed only in {cmd:twoway}s with
two vertical scales.  The values of all labels, ticks, lines, etc., are
specified in natural (unlogged) units.

	Examples:
{p 16 20 2}{cmd:. graph7 y, log}{p_end}
{p 16 20 2}{cmd:. graph7 y x, ylog xlog}{p_end}
{p 16 20 2}{cmd:. graph7 y x, ylog}{p_end}
{p 16 20 2}{cmd:. graph7 y x, xlog}{p_end}
{p 16 20 2}{cmd:. graph7 y1 y2 x, rescale rlog}

{p 4 8 2}{cmd:title("}{it:text}{cmd:")} adds a title in large letters at the
bottom of the graph.  Usually, the quotes can be omitted if text contains no
special characters.  If the text itself contains quotes then compound double
quotes ({cmd:`"} and {cmd:"'}) must be used.

	Examples:
{p 16 20 2}{cmd:. graph7 y x, title(Figure 1.  Raw data)}{p_end}
{p 16 20 2}{cmd:. graph7 y x, title("Figure 1.  Raw data")}{p_end}
{p 16 20 2}{cmd:. graph7 y x, title(`"Figure 1.  "Raw" data"')}

{p 4 8 2}{cmd:t1title("}{it:text}{cmd:")}, {cmd:t2title("}{it:text}{cmd:")},
{cmd:b1title("}{it:text}{cmd:")}, {cmd:b2title("}{it:text}{cmd:")},
{cmd:l1title("}{it:text}{cmd:")}, {cmd:l2title("}{it:text}{cmd:")},
{cmd:r1title("}{it:text}{cmd:")}, and {cmd:r2title("}{it:text}{cmd:")} are
more titling options.  There are two titles on every side of the figure.  The
sides are referred to as {cmdab:t:op}, {cmdab:b:ottom}, {cmdab:l:eft}, and
{cmdab:r:ight}.  {cmd:b1title()} is also known as simply the {cmd:title()}.
These title options can be abbreviated by their first two characters.
{cmd:b2()} is the same as {cmd:b2title()}.  The first (#1) title on a side is
always farther from the figure.

{p 4 8 2}
{cmd:key1(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)},
{cmd:key2(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)},
{cmd:key3(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)}, and
{cmd:key4(}[{it:symbol}] [{it:connect}] [{it:pen}] [{cmd:"}{it:text}{cmd:"}]{cmd:)}
specify a key to appear at the top of the graph in the area of {cmd:t1title()}
and {cmd:t2title()}.  Specify {it:symbol} as {cmd:symbol(}{it:s}{cmd:)} and
specify {it:connect} as {cmd:connect(}{it:c}[{cmd:[}{it:p}{cmd:]}]{cmd:)},
see {help gr7sym}.  Specify {it:pen} as {cmd:p(}{it:#}{cmd:)}, see
{help gr7color}.

{p 8 8 2}There are four total keys that can be specified.  If no titles are
specified, Stata produces default key definitions.  These definitions can be
specified by the user by using {cmd:key1()}, {cmd:key2()}, {cmd:key3()}, and
{cmd:key4()}.  If you have multiple keys and specify one of them, you must
specify as many as you have if you wish to display all your keys.  No default
keys are generated once a {cmd:key}{it:#}{cmd:()} is specified.

{p 4 8 2}{cmd:xlabel}[{cmd:(}{it:numlist}{cmd:)}],
{cmd:ylabel}[{cmd:(}{it:numlist}{cmd:)}],
{cmd:rlabel}[{cmd:(}{it:numlist}{cmd:)}], and
{cmd:tlabel}[{cmd:(}{it:numlist}{cmd:)}] specify axes labels.  {cmd:graph7}
usually labels just the minimums and maximums of the data.  On any style that
has a numeric {it:x} axis, such as {cmd:histogram} (see {help gr7hist}) or
{cmd:twoway} (see {help gr7twoway}), you can specify {cmd:xlabel}.  Without
arguments, {cmd:graph7} will choose "round" values for you; with arguments, the
values you specify will be labeled.  {cmd:ylabel}, {cmd:rlabel}, and
{cmd:tlabel} work similarly.  {cmd:ylabel} refers to the {it:y} axis;
{cmd:rlabel} to the right axis (if there is one), and {cmd:tlabel} to the top
axis (if there is one).

{p 8 8 2}"{cmd:graph7 y x, ylabel xlabel}" plots y versus x with round labeling
of the axes.

{p 8 8 2}"{cmd:graph7 y x, ylabel xlabel(0 10 to 40)}" does the same except the
values 0, 10, ..., 40 are labeled on the {it:x} axis.

{p 8 8 2}These options are not allowed with {cmd:matrix} (see
{help gr7matrix}).  Instead, the {cmd:label} option, which allows no arguments,
provides round labels.

{p 4 8 2}{cmd:xtick}[{cmd:(}{it:numlist}{cmd:)}],
{cmd:ytick}[{cmd:(}{it:numlist}{cmd:)}],
{cmd:rtick}[{cmd:(}{it:numlist}{cmd:)}], and
{cmd:ttick}[{cmd:(}{it:numlist}{cmd:)}] place tick marks on axes.  By default,
{cmd:graph7} places tick marks wherever axes are labeled, so these options allow
specifying additional ticking.  {cmd:xtick}, ... options work like the
{cmd:xlabel}, ... options described above.

{p 4 8 2}{cmd:xscale(}{it:#}[{cmd:,}]{it:#}{cmd:)},
{cmd:yscale(}{it:#}[{cmd:,}]{it:#}{cmd:)}, and
{cmd:rscale(}{it:#}[{cmd:,}]{it:#}{cmd:)} can widen, but never narrow, the
scale of the axes.  By default, {cmd:graph7} chooses to scale each axis
according to the minimum and maximum of all things that go on the axis.  This
includes the data and any labeling or ticking you specify.  These options add
two more numbers to this calculation.  Either can be specified as "{cmd:.}" to
indicate that it is unchanged from what {cmd:graph7} otherwise would have
chosen.

{p 8 8 2}Suppose x range from 1 to 9.  "{cmd:graph7 y x, xscale(.,5)}" will have
no effect on the scale:  It will not graph solely the data for which x is
between 1 and 5.  "{cmd:graph7 y x if x<=5}" will have the desired effect.

{p 8 8 2}"{cmd:graph7 y x, xscale(0,.)}" would make the x-scale 0 to 9.{p_end}
{p 8 8 2}"{cmd:graph7 y x, xscale(.,10)}" would make the x-scale 1 to 10.{p_end}
{p 8 8 2}"{cmd:graph7 y x, xscale(0,10)}" would make the x-scale 0 to 10.


{title:Also see}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7bar}, {help gr7box},
{help gr7color}, {help gr7hist}, {help gr7matrix}, {help gr7oneway},
{help gr7other}, {help gr7pie}, {help gr7star}, {help gr7sym},
{help gr7twoway}
{p_end}
