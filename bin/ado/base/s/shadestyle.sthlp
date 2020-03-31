{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[G-4] shadestyle" "mansection G-4 shadestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] intensitystyle" "help intensitystyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{viewerjumpto "Syntax" "shadestyle##syntax"}{...}
{viewerjumpto "Description" "shadestyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "shadestyle##linkspdf"}{...}
{viewerjumpto "Remarks" "shadestyle##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[G-4]} {it:shadestyle} {hline 2}}Choices for overall look of filled areas{p_end}
{p2col:}({mansection G-4 shadestyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:shadestyle}}Description{p_end}
{p2line}
{p2col:{cmd:foreground}}areas in the default foreground color{p_end}
{p2col:{cmd:plotregion}}plot region area{p_end}
{p2col:{cmd:legend}}legend area{p_end}
{p2col:{cmd:none}}nonexistent area{p_end}

{p2col:{cmd:ci}}areas representing confidence intervals{p_end}
{p2col:{cmd:histogram}}histogram bars{p_end}
{p2col:{cmd:sunflowerlb}}light sunflowers{p_end}
{p2col:{cmd:sunflowerdb}}dark sunflowers{p_end}

{p2col:{cmd:p1bar}{hline 1}{cmd:p15bar}}used by first to fifteenth "bar" plot
      {p_end}
{p2col:{cmd:p1box} - {cmd:p15box}}used by first to fifteenth "box" plot{p_end}
{p2col:{cmd:p1area} - {cmd:p15area}}used by first to fifteenth "area" plot
      {p_end}
{p2col:{cmd:p1pie} - {cmd:p15pie}}used for first to fifteenth pie slices{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:shadestyle} may be available; type

	    {cmd:.} {bf:{stata graph query shadestyle}}

{pstd}
to obtain the complete list of {it:shadestyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:shadestyle} sets the {help colorstyle:color} and 
{help intensitystyle:intensity} of the color for a filled area.

{pstd}
Shadestyles are used only in scheme files (see {help scheme files}) and are not accessible from {helpb graph} commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 shadestyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help shadestyle##remarks1:What is a shadestyle?}
	{help shadestyle##remarks2:What are numbered styles?}


{marker remarks1}{...}
{title:What is a shadestyle?}

{pstd}
Shaded areas are defined by two attributes:

{phang2}
    1.  {it:colorstyle} -- the color of the shaded area;{break}
	see {manhelpi colorstyle G-4}

{phang2}
    2.  {it:intensitystyle} -- the intensity of the color; {break}
	see {manhelpi intensitystyle G-4}

{pstd}
The {it:shadestyle} specifies both of these attributes.  

{pstd}
The intensity attribute is not truly necessary because any intensity
could be reached by changing the RGB values of a color; see 
{manhelpi colorstyle G-4}.  An intensity, however, can be used to affect the
intensity of many different colors in some scheme files.


{marker remarks2}{...}
{title:What are numbered styles?}

{phang}
     {cmd:p1bar}{hline 1}{cmd:p15bar} are the default styles used for filling
     the bars on bar charts, including {helpb twoway bar} charts and
     {help graph bar:bar charts}.  {cmd:p1bar} is used for the first set of
     bars, {cmd:p2bar} for the second, and so on.

{phang}
     {cmd:p1box}{hline 1}{cmd:p15box} are the default styles used for filling
     the boxes on {help graph box:box charts}.  {cmd:p1box} is used for the
     first set of boxes, {cmd:p2box} for the second, and so on.

{phang}
     {cmd:p1area}{hline 1}{cmd:p15area} are the default styles used for
     filling the areas on area charts, including {helpb twoway area} charts
     and {helpb twoway rarea}.  {cmd:p1area} is used for the first filled
     area, {cmd:p2area} for the second, and so on.

{phang}
     {cmd:p1pie}{hline 1}{cmd:p15pie} are the default styles used for filling
        pie slices, including {help graph_pie:pie charts}.
        {cmd:p1pie} is used by the first slice, {cmd:p2pie} for the
        second, and so on.

{pstd}
        The look defined by a numbered style, such as {cmd:p1bar},
        {cmd:p1box}, or {cmd:p1area}, is determined by the 
        {help schemes:scheme} selected. By "look", we mean 
        {it:{help colorstyle}} and {it:{help intensitystyle}}.
{p_end}
