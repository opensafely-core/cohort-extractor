{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] intensitystyle" "mansection G-4 intensitystyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] shadestyle" "help shadestyle"}{...}
{viewerjumpto "Syntax" "intensitystyle##syntax"}{...}
{viewerjumpto "Description" "intensitystyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "intensitystyle##linkspdf"}{...}
{viewerjumpto "Remarks" "intensitystyle##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-4]} {it:intensitystyle} {hline 2}}Choices for the intensity of a color{p_end}
{p2col:}({mansection G-4 intensitystyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:intensitystyle}}Description{p_end}
{p2line}
{p2col:{cmd:inten0}}0% intensity, no color at all{p_end}
{p2col:{cmd:inten10}}{p_end}

{p2col:{cmd:inten20}}{p_end}

{p2col:{cmd:...}}{p_end}

{p2col:{cmd:inten90}}{p_end}

{p2col:{cmd:inten100}}100% intensity, full color{p_end}

{p2col:{it:#}}{it:#}% intensity, 0 to 100{p_end}
{p2line}
{p2colreset}{...}

{p 4 4 2}
Other {it:intensitystyles} may be available; type

	    {cmd:.} {bf:{stata graph query intensitystyle}}

{p 4 4 2}
to obtain the complete list of {it:intensitystyles} installed on your computer.
If other {it:intensitystyles} do exist, they are merely words attached to
numeric values.


{marker description}{...}
{title:Description}

{pstd}
{it:intensitystyles} specify the intensity of colors as a percentage from 0 to
100 and are used in {it:shadestyles}; see {manhelpi shadestyle G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 intensitystyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:intensitystyle} is used primarily in {help scheme files} and is rarely
specified interactively, though some options, such as the {cmd:intensity()}
option, may accept the style names in addition to numeric values.
{p_end}
