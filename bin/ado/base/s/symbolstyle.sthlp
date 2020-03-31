{smcl}
{* *! version 1.2.3  19oct2017}{...}
{vieweralsosee "[G-4] symbolstyle" "mansection G-4 symbolstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_options" "help marker_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] markersizestyle" "help markersizestyle"}{...}
{vieweralsosee "[G-4] markerstyle" "help markerstyle"}{...}
{viewerjumpto "Syntax" "symbolstyle##syntax"}{...}
{viewerjumpto "Description" "symbolstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "symbolstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "symbolstyle##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-4]} {it:symbolstyle} {hline 2}}Choices for the shape of markers{p_end}
{p2col:}({mansection G-4 symbolstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

			Synonym
	{it:symbolstyle}     (if any)     Description
	{hline 55}
	{cmd:circle}             {cmd:O}         solid
	{cmd:diamond}            {cmd:D}         solid
	{cmd:triangle}           {cmd:T}         solid
	{cmd:square}             {cmd:S}         solid
	{cmd:plus}               {cmd:+}
	{cmd:X}                  {cmd:X}
	{cmd:arrowf}             {cmd:A}         filled arrow head
	{cmd:arrow}              {cmd:a}
	{cmd:pipe}               {cmd:|}
	{cmd:V}                  {cmd:V}

	{cmd:smcircle}           {cmd:o}         solid
	{cmd:smdiamond}          {cmd:d}         solid
	{cmd:smsquare}           {cmd:s}         solid
	{cmd:smtriangle}         {cmd:t}         solid
	{cmd:smplus}
        {cmd:smx}                {cmd:x}
	{cmd:smv}                {cmd:v}

	{cmd:circle_hollow}      {cmd:Oh}        hollow
	{cmd:diamond_hollow}     {cmd:Dh}        hollow
	{cmd:triangle_hollow}    {cmd:Th}        hollow
	{cmd:square_hollow}      {cmd:Sh}        hollow

	{cmd:smcircle_hollow}    {cmd:oh}        hollow
	{cmd:smdiamond_hollow}   {cmd:dh}        hollow
	{cmd:smtriangle_hollow}  {cmd:th}        hollow
	{cmd:smsquare_hollow}    {cmd:sh}        hollow

	{cmd:point}              {cmd:p}         a small dot
	{cmd:none}               {cmd:i}         a symbol that is invisible
	{hline 55}

{pin}
For a symbol palette displaying each of the above symbols, type

{phang3}
	    {cmd:.} {bf:{stata palette symbolpalette}}
			[{cmd:,} {cmdab:sch:eme:(}{it:schemename}{cmd:)}]

{pmore}
	Other {it:symbolstyles} may be available; type

	    {cmd:.} {bf:{stata graph query symbolstyle}}

{pmore}
to obtain the complete list of {it:symbolstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Markers are the ink used to mark where points are on a plot;
see {manhelpi marker_options G-3}.
{it:symbolstyle} specifies the shape of the marker.

{pstd}
You specify the {it:symbolstyle} inside the
{cmd:msymbol()} option allowed with many of the {cmd:graph}
commands:

{phang2}
	{cmd:. graph twoway} ...{cmd:, msymbol(}{it:symbolstyle}{cmd:)} ...

{pstd}
Sometimes you will see that a {it:symbolstylelist} is allowed:

{phang2}
	{cmd:. scatter} ...{cmd:, msymbol(}{it:symbolstylelist}{cmd:)} ...

{pstd}
A {it:symbolstylelist} is a sequence of {it:symbolstyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 symbolstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help symbolstyle##remarks1:Typical use}
	{help symbolstyle##remarks2:Filled and hollow symbols}
	{help symbolstyle##remarks3:Size of symbols}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:msymbol(}{it:symbolstyle}{cmd:)} is one of the more commonly specified
options.  For instance, you may not be satisfied with the default rendition
of{cmd}

	. scatter mpg weight if foreign ||
	  scatter mpg weight if !foreign

{pstd}
{txt}and prefer{cmd}

	. scatter mpg weight if foreign, msymbol(oh) ||
	  scatter mpg weight if !foreign, msymbol(x)

{pstd}
{txt}When you are graphing multiple {it:y} variables in the same plot, you
can specify a list of {it:symbolstyles} inside the {cmd:msymbol()} option:

	{cmd:. scatter mpg1 mpg2 weight, msymbol(oh x)}

{pstd}
The result is the same as typing{cmd}

	. scatter mpg1 weight, msymbol(oh) ||
	  scatter mpg2 weight, msymbol(x){txt}

{pstd}
Also, in the above, we specified the symbol-style synonyms.
Whether you type

	{cmd}. scatter mpg1 weight, msymbol(oh) ||
	  scatter mpg2 weight, msymbol(x){txt}

{pstd}
or

	{cmd}. scatter mpg1 weight, msymbol(smcircle_hollow) ||
	  scatter mpg2 weight, msymbol(smx){txt}

{pstd}
makes no difference.


{marker remarks2}{...}
{title:Filled and hollow symbols}

{pstd}
The {it:symbolstyle} specifies the {it:shape} of the symbol, and in that
sense, one of the styles {cmd:circle} and {cmd:hcircle} -- and
{cmd:diamond} and {cmd:hdiamond}, etc. -- is unnecessary in that each is
a different rendition of the same shape.  The option
{cmd:mfcolor(}{it:colorstyle}{cmd:)} (see {manhelpi marker_options G-3})
specifies how the inside of the symbol is to be filled.  {cmd:hcircle()},
{cmd:hdiamond}, etc., are included for convenience and are equivalent to
specifying

	{cmd:msymbol(Oh)}:  {cmd:msymbol(O) mfcolor(none)}

	{cmd:msymbol(dh)}:  {cmd:msymbol(d) mfcolor(none)}

	etc.

{pstd}
Using {cmd:mfcolor()} to fill the inside of a symbol with different colors
sometimes creates what are effectively new symbols.
For instance, if you take {cmd:msymbol(O)} and fill its interior with a lighter
shade of the same color used to outline the shape, you obtain a pleasing
result.  For instance, you might try

	{cmd:msymbol(O) mlcolor(yellow) mfcolor(.5*yellow)}

{pstd}
or

	{cmd:msymbol(O) mlcolor(gs5) mfcolor(gs12)}

{pstd}
as in

{phang2}
	{cmd:. scatter mpg weight, msymbol(O) mlcolor(gs5) mfcolor(gs14)}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight, msymbol(O) mlcolor(gs5) mfcolor(gs14)":click to run})}
{* graph symstyle1}{...}


{marker remarks3}{...}
{title:Size of symbols}

{pstd}
Just as {cmd:msymbol(O)} and {cmd:msymbol(Oh)} differ only in
{cmd:mfcolor()}, {cmd:msymbol(O)} and
{cmd:msymbol(o)} -- symbols {cmd:circle} and
{cmd:smcircle} -- differ only in {cmd:msize()}.  In particular,

	{cmd:msymbol(O)}:  {cmd:msymbol(O) msize(medium)}

	{cmd:msymbol(o)}:  {cmd:msymbol(O) msize(small)}

{pstd}
and the same is true for all the other large and small symbol pairs.

{pstd}
{cmd:msize()} is interpreted as being relative to the size of the
graph region (see {manhelpi region_options G-3}), so the same
symbol size will in fact be a little different in

	{cmd:. scatter mpg weight}

{pstd}
and

	{cmd:. scatter mpg weight, by(foreign total)}
