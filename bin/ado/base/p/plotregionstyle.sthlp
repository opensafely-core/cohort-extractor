{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-4] plotregionstyle" "mansection G-4 plotregionstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] areastyle" "help areastyle"}{...}
{vieweralsosee "[G-4] marginstyle" "help marginstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{viewerjumpto "Syntax" "plotregionstyle##syntax"}{...}
{viewerjumpto "Description" "plotregionstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "plotregionstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "plotregionstyle##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[G-4]} {it:plotregionstyle} {hline 2}}Choices for overall look of plot regions{p_end}
{p2col:}({mansection G-4 plotregionstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:plotregionstyle}}Description{p_end}
{p2line}
{p2col:{cmd:twoway}}default for {helpb graph twoway}{p_end}
{p2col:{cmd:transparent}}used for overlaid plot regions by 
			    {helpb graph twoway}{p_end}
{p2col:{cmd:bargraph}}default for {helpb graph bar}{p_end}
{p2col:{cmd:hbargraph}}default for {helpb graph hbar}{p_end}
{p2col:{cmd:boxgraph}}default for {helpb graph box}{p_end}
{p2col:{cmd:hboxgraph}}default for {helpb graph hbox}{p_end}
{p2col:{cmd:dotgraph}}default for {helpb graph dot}{p_end}
{p2col:{cmd:piegraph}}default for {helpb graph pie}{p_end}

{p2col:{cmd:matrixgraph}}default for {helpb graph matrix}{p_end}
{p2col:{cmd:matrix}}{helpb graph matrix} interior region{p_end}
{p2col:{cmd:matrix_label}}{helpb graph matrix} diagonal labels{p_end}

{p2col:{cmd:combinegraph}}default for {helpb graph combine}{p_end}
{p2col:{cmd:combineregion}}{helpb graph combine} interior region{p_end}
{p2col:{cmd:bygraph}}default for {help by_option:by graphs}{p_end}

{p2col:{cmd:legend_key_region}}key and label region of legends{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:plotregionstyle} may be available; type

	    {cmd:.} {bf:{stata graph query plotregionstyle}}

{pstd}
to obtain a list of all {it:plotregionstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
A {it:plotregionstyle} controls the overall look of a plot region.

{pstd}
Plot region styles are used only in scheme files (see {help scheme files})
and are not accessible from {helpb graph} commands.  To learn about the
{cmd:graph} options that affect plot styles, see
{manhelpi region_options G-3}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 plotregionstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
The look of plot regions is defined by four sets of attributes:

{phang2}
    1.  {it:marginstyle} -- the internal margin of the plot region;{break}
	see {manhelpi marginstyle G-4}

{phang2}
    2.  overall {it:areastyle} -- the look of the total area of the
    plot region;  see {manhelpi areastyle G-4}

{phang2}
    3.  internal {it:areastyle} -- the look of the area within the 
    	margin; {break}
	see {manhelpi areastyle G-4}

{phang2}
    4.  positioning -- horizontal and vertical positioning of the plot
            region if the space where the region is located is larger than the
            plot region itself

{pstd}
A {it:plotregionstyle} specifies all of these attributes.  
{p_end}
