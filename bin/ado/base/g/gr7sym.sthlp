{smcl}
{* *! version 1.0.5  13apr2010}{...}
{cmd:help gr7sym}{right:(out-of-date command)}
{hline}

{title:Warning}

{pstd}
This help file documents the {hi:old} version of Stata's {cmd:graph} command.
See {helpb graph} for the modern version.

{pstd}
Stata runs the old version of {cmd:graph} whenever {cmd:graph} is invoked
under version control (see {helpb version}) or when you use the
{cmd:graph7} or {cmd:gr7} command.


{title:{cmd:graph7} command common options -- symbol and line options}

{p 8 23 2}
{c -(}{cmd:graph7} | {cmd:gr7}{c )-}
[{it:varlist}] [{it:weight}] [{cmd:if} {it:exp}]
[{cmd:in} {it:range}] [{cmd:,} {it:graph_type}
{it:specific_options} {it:common_options}]


{p 4 4 2}The line and symbol {it:common_options} are

{p 8 8 2}
{cmdab:xli:ne}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:yli:ne}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:rli:ne}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:tli:ne}[{cmd:(}{it:numlist}{cmd:)}]
{cmdab:c:onnect:(}{it:c}[{cmd:[}{it:p}{cmd:]}] {it:...} {it:c}[{cmd:[}{it:p}{cmd:]}]{cmd:)}
{cmdab:ba:nds:(}{it:#}{cmd:)}
{cmdab:d:ensity:(}{it:#}{cmd:)}
{cmdab:s:ymbol:(}{it:s...s}{cmd:)}
{cmdab:tr:im:(}{it:#}{cmd:)}
{cmdab:ps:ize:(}{it:#}{cmd:)}

{p 8 8 2}The available {it:c} ({cmd:connect()} symbols) are{p_end}
{p 16 21 2}{cmd:.}{space 4}do not connect (default){p_end}
{p 16 21 2}{cmd:l}{space 4}draw straight lines between points{p_end}
{p 16 21 2}{cmd:L}{space 4}draw straight lines between ascending x points{p_end}
{p 16 21 2}{cmd:m}{space 4}connect median bands using straight lines{p_end}
{p 16 21 2}{cmd:s}{space 4}connect median bands using cubic splines{p_end}
{p 16 21 2}{cmd:J}{space 4}connect rectilinearly, making steps{p_end}
{p 16 21 2}{cmd:||}{space 3}connect two variables vertically{p_end}
{p 16 21 2}{cmd:II}{space 3}same as {cmd:||}, but cap bottom and top of line

{p 8 8 2}The available {it:p} ({cmd:connect()} line patterns) are any
combination of{p_end}
{p 16 21 2}{cmd:l}{space 4}solid line (default){p_end}
{p 16 21 2}{cmd:_}{space 4}(underscore) a long dash{p_end}
{p 16 21 2}{cmd:-}{space 4}(hyphen) a medium dash{p_end}
{p 16 21 2}{cmd:.}{space 4}a short dash (almost a dot){p_end}
{p 16 21 2}{cmd:#}{space 4}a space

{p 8 8 2}The available {it:s} ({cmd:symbol()} identifiers) are{p_end}
{p 16 26 2}{cmd:O} {space 7} large circle{p_end}
{p 16 26 2}{cmd:S} {space 7} large square{p_end}
{p 16 26 2}{cmd:T} {space 7} large triangle{p_end}
{p 16 26 2}{cmd:o} {space 7} small circle{p_end}
{p 16 26 2}{cmd:d} {space 7} small diamond{p_end}
{p 16 26 2}{cmd:p} {space 7} small plus{p_end}
{p 16 26 2}{cmd:x} {space 7} x{p_end}
{p 16 26 2}{cmd:.} {space 7} dot{p_end}
{p 16 26 2}{cmd:i} {space 7} invisible{p_end}
{p 16 26 2}{cmd:[}{it:varname}{cmd:]} contents of variable to be used as text
symbol{p_end}
{p 16 26 2}{cmd:[_n]} {space 4} use observation numbers as symbol


{p 4 4 2}
Information on the {cmd:graph7} command and the different {it:graph_types}
is found in {helpb graph7}.  This entry details the symbol and line
{it:common_options}.  Help for the other {it:common_options} is also
available.  See {help gr7axes} for title and axes; {help gr7color} for
color and shading; {help gr7other} for saving, printing, and multiple
images.


{title:Options}

{p 4 8 2}{cmd:xline}[{cmd:(}{it:numlist}{cmd:)}],
{cmd:yline}[{cmd:(}{it:numlist}{cmd:)}],
{cmd:rline}[{cmd:(}{it:numlist}{cmd:)}], and
{cmd:tline}[{cmd:(}{it:numlist}{cmd:)}] draw lines (using pen 1) across the
graph.  {cmd:yline} and {cmd:rline} draw horizontal lines, {cmd:xline} and
{cmd:tline} draw vertical lines.  If the values at which the lines are to be
drawn are not specified, "round" values are chosen for you.

{p 4 8 2}{cmd:connect(}{it:c...c}{cmd:)} specifies if points are to be connected
in {cmd:twoway} (see {help gr7twoway}) and {cmd:matrix} (see
{help gr7matrix}) plots.  {cmd:connect()} may be abbreviated {cmd:c()}.
Specify the connect symbol(s) c as

{p 12 17 2}{cmd:.} {space 2} do not connect (default){p_end}
{p 12 17 2}{cmd:l} {space 2} draw straight lines between points{p_end}
{p 12 17 2}{cmd:L} {space 2} draw straight lines between ascending x points{p_end}
{p 12 17 2}{cmd:m} {space 2} connect median bands using straight lines{p_end}
{p 12 17 2}{cmd:s} {space 2} connect median bands using cubic splines{p_end}
{p 12 17 2}{cmd:J} {space 2} connect rectilinearly, making steps{p_end}
{p 12 17 2}{cmd:||} {space 1} connect two variables vertically{p_end}
{p 12 17 2}{cmd:II} {space 1} same as {cmd:||}, but cap bottom and top of line

{p 8 8 2}{cmd:l}, {cmd:L}, and {cmd:J} connect points in the
order of the data.  To connect in the order of the {it:x} axis, also specify
the {cmd:sort} option. "{cmd:graph7 a b c , c(.l) sort}" plots a versus c, not
connecting the points, and b versus c, connecting points with straight lines.

{p 8 8 2}Within each line type you can specify the pattern of the line.  This
can be done by adding a {cmd:[}{it:pattern}{cmd:]} after the line type, where
{it:pattern} is any combination of the following:

{p 12 17 2}{cmd:l}{space 4}solid line (default){p_end}
{p 12 17 2}{cmd:_}{space 4}(underscore) a long dash{p_end}
{p 12 17 2}{cmd:-}{space 4}(hyphen) a medium dash{p_end}
{p 12 17 2}{cmd:.}{space 4}a short dash (almost a dot){p_end}
{p 12 17 2}{cmd:#}{space 4}a space

{p 8 8 2}Typing "{cmd:graph7 a b c, c(.l[_.]) sort}" plots a versus c not
connecting the points and b versus c connecting points with a
long-short-long-short dashed line.

{p 8 8 2}Note, {cmd:symbol(i)} (see below) and {cmd:connect()} can be usefully
combined:{p_end}
{p 12 16 2}{cmd:. regress y x}{p_end}
{p 12 16 2}{cmd:. predict hat}{p_end}
{p 12 16 2}{cmd:. graph7 y hat x, c(.l) s(Oi) sort}

{p 8 8 2}To graph high-low charts:
"{cmd:graph7 close high low time, s(oii) c(.||)}"

{p 4 8 2}{cmd:bands(}{it:#}{cmd:)} is used with {cmd:connect(m)} and
{cmd:connect(s)}; it specifies the number of bands along the {it:x} axis in
which data are to be grouped and medians of x and y calculated.  The default
is {cmd:bands(200)}.  Reducing the number results in substantial smoothing:
"{cmd:graph7 y x, s(o) c(s) bands(12)}".

{p 4 8 2}{cmd:density(}{it:#}{cmd:)} is used only with {cmd:connect(s)}; it
specifies the number of points to be calculated on the cubic spline.  The
default is {cmd:density(5)}.  Increasing the density results in a smoother
appearing image:  "{cmd:graph7 y x, s(o) c(s) bands(12) density(100)}".

{p 4 8 2}{cmd:symbol(}{it:s...s}{cmd:)} specifies the symbols used to draw points
in {cmd:twoway} (see {help gr7twoway}) and {cmd:matrix} (see
{help gr7matrix}) graph7 styles.  {cmd:symbol()} may be abbreviated {cmd:s()}.
Specify the symbol identifier(s) s as

{p 12 21 2}{cmd:O} {space 7} large circle (default for {cmd:twoway}){p_end}
{p 12 21 2}{cmd:S} {space 7} large square{p_end}
{p 12 21 2}{cmd:T} {space 7} large triangle{p_end}
{p 12 21 2}{cmd:o} {space 7} small circle (default for {cmd:twoway} with
		{cmd:by}, or {cmd:matrix}){p_end}
{p 12 21 2}{cmd:d} {space 7} small diamond{p_end}
{p 12 21 2}{cmd:p} {space 7} small plus{p_end}
{p 12 21 2}{cmd:x} {space 7} x{p_end}
{p 12 21 2}{cmd:.} {space 7} dot{p_end}
{p 12 21 2}{cmd:i} {space 7} invisible{p_end}
{p 12 21 2}{cmd:[}{it:varname}{cmd:]} contents of variable to be used as text
		symbol{p_end}
{p 12 21 2}{cmd:[_n]} {space 4} use observation numbers as symbol

{p 8 8 2}In the case of {cmd:[}{it:varname}{cmd:]}, {it:varname} may be either a
string or numeric variable.  For instance, {it:varname} might be a string
variable containing "Ca", "Wa", and "Or" for its first three observations.
Then the text {hi:Ca} would be used to mark the location of the first
observation, {hi:Wa} for the second, and {hi:Or} for the third.

	Examples:
{p 16 20 2}{cmd:. graph7 y x, symbol(o)}{p_end}
{p 16 20 2}{cmd:. graph7 y x, s(.)}{p_end}
{p 16 20 2}{cmd:. graph7 y1 y2 x, s(OS)}{p_end}
{p 16 20 2}{cmd:. graph7 y1 y2 x, s(oo)}{p_end}
{p 16 20 2}{cmd:. graph7 y x, s([state])}{p_end}
{p 16 20 2}{cmd:. graph7 y x, s([_n])}{p_end}
{p 16 20 2}{cmd:. graph7 y1 y2 x, s([state]o)}{p_end}
{p 16 20 2}{cmd:. graph7 y1 y2 x, s([state][_n])}{p_end}
{p 16 20 2}{cmd:. graph7 y1 y2 x, s([state]o)}{p_end}
{p 16 20 2}{cmd:. graph7 a b c d, matrix s(.)}

{p 4 8 2}{cmd:trim(}{it:#}{cmd:)} is used only when one or more of the plotting
symbols is {cmd:[}{it:varname}{cmd:]}.  {it:#} specifies the maximum number of
characters from {it:varname} to be used to make each coordinate and defaults
to 8.  It may be set smaller or larger than 8.  For instance, if state were a
string variable containing "California", "Washington", and "Oregon" in its
first three observations, "{cmd:graph7 y x, s([state]) trim(2)}" would use
{hi:Ca} as the plotting symbol for the first observation, {hi:Wa} for the
second, and {hi:Or} for the third.

{p 4 8 2}{cmd:psize(}{it:#}{cmd:)} specifies the size of
{cmd:[}{it:varname}{cmd:]} and {cmd:[_n]} plotting symbols.  The default is
100, meaning 100% of normal size.  {cmd:psize(150)} uses larger and
{cmd:psize(75)} uses smaller symbols.


{title:Also see}

{psee}
{space 2}Help:  {manhelp graph7 G-2}, {help gr7axes}, {help gr7bar},
{help gr7box}, {help gr7color}, {help gr7hist},
{help gr7matrix}, {help gr7oneway},
{help gr7other}, {help gr7pie}, {help gr7star}, {help gr7twoway}
{p_end}
