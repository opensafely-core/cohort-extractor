{smcl}
{* *! version 1.1.6  19oct2017}{...}
{viewerdialog xtsum "dialog xtsum"}{...}
{vieweralsosee "[XT] xtsum" "mansection XT xtsum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdescribe" "help xtdescribe"}{...}
{vieweralsosee "[XT] xttab" "help xttab"}{...}
{viewerjumpto "Syntax" "xtsum##syntax"}{...}
{viewerjumpto "Menu" "xtsum##menu"}{...}
{viewerjumpto "Description" "xtsum##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtsum##linkspdf"}{...}
{viewerjumpto "Examples" "xtsum##examples"}{...}
{viewerjumpto "Stored results" "xtsum##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xtsum} {hline 2}}Summarize xt data{p_end}
{p2col:}({mansection XT xtsum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:xtsum} [{varlist}] [{it:{help if}}]

{phang}
A panel variable must be specified; use {helpb xtset}.{p_end}
{phang}
{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{phang}
{cmd:by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
        {bf:Summarize xt data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtsum}, a generalization of {helpb summarize}, reports means and
standard deviations for panel data; it differs from
{cmd:summarize} in that it decomposes the standard deviation into between and
within components.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtsumQuickstart:Quick start}

        {mansection XT xtsumRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse nlswork}{p_end}
{phang}{cmd:. xtsum hours}{p_end}
{phang}{cmd:. xtsum birth_yr}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtsum} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(n)}}number of panels{p_end}
{synopt:{cmd:r(Tbar)}}average number of years under observation{p_end}
{synopt:{cmd:r(mean)}}mean{p_end}
{synopt:{cmd:r(sd)}}overall standard deviation{p_end}
{synopt:{cmd:r(min)}}overall minimum{p_end}
{synopt:{cmd:r(max)}}overall maximum{p_end}
{synopt:{cmd:r(sd_b)}}between standard deviation{p_end}
{synopt:{cmd:r(min_b)}}between minimum{p_end}
{synopt:{cmd:r(max_b)}}between maximum{p_end}
{synopt:{cmd:r(sd_w)}}within standard deviation{p_end}
{synopt:{cmd:r(min_w)}}within minimum{p_end}
{synopt:{cmd:r(max_w)}}within maximum{p_end}
{p2colreset}{...}
