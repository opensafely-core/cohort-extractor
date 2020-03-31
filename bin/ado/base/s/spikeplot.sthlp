{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog spikeplot "dialog spikeplot"}{...}
{vieweralsosee "[R] spikeplot" "mansection R spikeplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{viewerjumpto "Syntax" "spikeplot##syntax"}{...}
{viewerjumpto "Menu" "spikeplot##menu"}{...}
{viewerjumpto "Description" "spikeplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "spikeplot##linkspdf"}{...}
{viewerjumpto "Options" "spikeplot##options"}{...}
{viewerjumpto "Examples" "spikeplot##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] spikeplot} {hline 2}}Spike plots and rootograms{p_end}
{p2col:}({mansection R spikeplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:spikeplot}
{varname}
{ifin}
[{it:{help spikeplot##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt r:ound(#)}}round {varname} to nearest multiple of {it:#} (bin
width){p_end}
{synopt:{opt frac:tion}}make vertical scale the proportion of total values;
default is frequencies{p_end}
{synopt:{opt root}}make vertical scale show square roots of frequencies{p_end}

{syntab:Plot}
{synopt:{it:{help twoway_spike:spike_options}}}affect rendition of plotted
spikes{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall, By}
{synopt:{it:twoway_options}}any options documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, and {opt iweight}s are allowed; see
{help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Distributional graphs > Spike plot and rootogram}


{marker description}{...}
{title:Description}

{pstd}
{opt spikeplot} produces a frequency plot for a variable in which the
frequencies are depicted as vertical lines from zero.  The frequency may be
a count, a fraction, or the square root of the count (Tukey's rootogram,
circa 1965).  The vertical lines may also originate from a baseline other than
zero at the user's option.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R spikeplotQuickstart:Quick start}

        {mansection R spikeplotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt round(#)} rounds the values of {varname} to the
  nearest multiple of {it:#}.  This action effectively specifies the bin width.

{phang}
{opt fraction} specifies that the vertical scale be the proportion
  of total values (percentage) rather than the count.

{phang}
{opt root} specifies that the vertical scale show square roots.
  This option may not be specified if {opt fraction} is specified.

{dlgtab:Plot}

{phang}
{it:spike_options} affect the rendition of the plotted spikes; see
{manhelp twoway_spike G-2:graph twoway spike}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}.  These include options for titling the graph
(see {manhelpi title_options G-3}), options for saving the graph to disk
(see {manhelpi saving_option G-3}), and the {opt by()} option
(see {manhelpi by_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ghanaage}{p_end}

{pstd}Spike plot{p_end}
{phang2}{cmd:. spikeplot age [fw=pop], ytitle("Population in 1000s")}
                {cmd:xlab(0(10)90) xmtick(5(10)85)}
		
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse splotxmpl}{p_end}

{pstd}Rootogram{p_end}
{phang2}{cmd:. spikeplot normal, round(.10) xlab(-4(1)4) root}{p_end}
    {hline}
