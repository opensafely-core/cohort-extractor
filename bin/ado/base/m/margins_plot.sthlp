{smcl}
{* *! version 1.0.1  18feb2015}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{viewerjumpto "Syntax" "margins_plot##syntax"}{...}
{viewerjumpto "Description" "margins_plot##description"}{...}
{viewerjumpto "Options" "margins_plot##options"}{...}
{title:Title}

{p2colset 4 24 26 2}{...}
{p2col:{hi:[R] margins, plot()}}{hline 2} Margins and marginsplot in one step
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin} {weight}
[{cmd:,} 
{help marginsplot##syntax:{bf:plot}}
{it:{help margins##response_options:response_options}}
{it:{help margins##options:options}}] 

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin} {weight}
[{cmd:,} 
{help marginsplot##syntax:{bf:plot(}{it:options}{bf:)}}
{it:{help margins##response_options:response_options}}
{it:{help margins##options:options}}] 


{marker description}{...}
{title:Description}

{pstd}
{cmd:margins} with the {cmd:plot} or {cmd:plot()} option specifies a
call to the {helpb marginsplot} command using the statistics reported
in the {cmd:margins} output.


{marker options}{...}
{title:Options}

{phang}
{opt plot} specifies a call to {helpb marginsplot} using
the statistics reported in the output.
{p_end}

{phang}
{opt plot(options)} specifies a call to {helpb marginsplot} using the
statistics reported in the output and allows the specification of
{cmd:marginsplot}'s options.
{p_end}
