{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] stylelists" "mansection G-4 stylelists"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{viewerjumpto "Syntax" "stylelists##syntax"}{...}
{viewerjumpto "Description" "stylelists##description"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[G-4]} {it:stylelists} {hline 2}}Lists of style elements and shorthands{p_end}
{p2col:}({mansection G-4 stylelists:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
A {it:stylelist} is a generic list of style elements and shorthands; specific
examples of {it:stylelists} include {it:symbolstylelist}, {it:colorstylelist},
etc.

{pstd}
A {it:stylelist} is

	{it:el} [{it:el} [...]]

{pstd}
where each {it:el} may be

{synoptset 25}{...}
{p2col:{it:el}}Description{p_end}
{p2line}
{p2col:{it:as_defined_by_style}}what {it:symbolstyle}, {it:colorstyle}, ... allows{p_end}
{p2col:{cmd:"}{it:as defined by style}{cmd:"}}must quote {it:el}s containing spaces{p_end}
{p2col:`"{it:as "defined" by style}"'}compound quote {it:el}s containing quotes{p_end}
{p2col:{cmd:.}}specifies the "default"{p_end}
{p2col:{cmd:=}}repeat previous {it:el}{p_end}
{p2col:{cmd:..}}repeat previous {it:el} until end{p_end}
{p2col:{cmd:...}}same as {cmd:..}{p_end}
{p2line}
{p2colreset}{...}

{p 4 6 2}
If the list ends prematurely, it is as if the list were padded out with {cmd:.}
(meaning the default for the remaining elements).

{p 4 6 2}
If the list has more elements than required, extra elements are ignored.

{p 4 6 2}
{cmd:=} in the first element is taken to mean {cmd:.} (period).

{p 4 6 2}
If the list allows numbers including missing values, if missing value is not the
default, and if you want to specify missing value for an element, you must
enclose the period in quotes:  {cmd:"."}.


    Examples:

	. ..., ... {cmd:msymbol(O d p o)} ...
	. ..., ... {cmd:msymbol(O . p)} ...
	. ..., ... {cmd:mcolor(blue . green green)} ...
	. ..., ... {cmd:mcolor(blue . green =)} ...
	. ..., ... {cmd:mcolor(blue blue blue blue)} ...
	. ..., ... {cmd:mcolor(blue = = =)} ...
	. ..., ... {cmd:mcolor(blue ...)} ...


{marker description}{...}
{title:Description}

{pstd}
Sometimes an option takes not a {it:colorstyle} but a {it:colorstylelist},
or not a {it:symbolstyle} but a {it:symbolstylelist}.
{it:colorstyle} and {it:symbolstyle} are just two examples; there are many
styles.   Whether an option allows a list is documented in its syntax diagram.
For instance, you might see

{phang2}
	{cmd:graph matrix} ... [{cmd:,} ... {cmd:mcolor(}{it:colorstyle}{cmd:)} ... ]

{pstd}
in one place and

{phang2}
	{cmd:graph twoway scatter} ... [{cmd:,} ... {cmd:mcolor(}{it:colorstylelist}{cmd:)} ... ]

{pstd}
in another.  In either case, to learn about {it:colorstyles}, you would see
{manhelpi colorstyle G-4}.  Here we have discussed how you would generalize a
{it:colorstyle} into a {it:colorstylelist} or a {it:symbolstyle} into a
{it:symbolstylelist}, etc.
{p_end}
