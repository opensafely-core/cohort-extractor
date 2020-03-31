{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spbalance" "mansection SP spbalance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spset" "help spset"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{vieweralsosee "[SP] spxtregress" "help spxtregress"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "spbalance##syntax"}{...}
{viewerjumpto "Menu" "spbalance##menu"}{...}
{viewerjumpto "Description" "spbalance##description"}{...}
{viewerjumpto "Links to PDF documentation" "spbalance##linkspdf"}{...}
{viewerjumpto "Example" "spbalance##example"}{...}
{viewerjumpto "Stored results" "spbalance##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[SP] spbalance} {hline 2}}Make panel data strongly
balanced{p_end}
{p2col:}({mansection SP spbalance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Query whether data are strongly balanced

{p 8 14 2}
{cmd:spbalance}


{phang}
Make data strongly balanced if they are not

{p 8 14 2}
{cmd:spbalance,} {cmd:balance}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spbalance} reports whether panel data are strongly balanced and,
optionally, makes them balanced if they are not.

{pstd}
The data are required to be {helpb xtset}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spbalanceQuickstart:Quick start}

        {mansection SP spbalanceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}
In your browser, search for "County_2010Census_DP1" and save the
Zip file.

{pstd}Setup{p_end}
{phang2}{cmd:. unzipfile County_2010Census_DP1.zip}
{p_end}
{phang2}{cmd:. spshape2dta County_2010Census_DP1}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/cbp05_14co.dta .}
{p_end}
{phang2}{cmd:. use cbp05_14co}
{p_end}
{phang2}{cmd:. merge m:1 GEOID10 using County_2010Census_DP1}
{p_end}
{phang2}{cmd:. keep if _merge == 3}
{p_end}
{phang2}{cmd:. drop _merge}
{p_end}
{phang2}{cmd:. save cbp05_14co_census}
{p_end}
{phang2}{cmd:. xtset _ID year}

{pstd}Check if data are balanced{p_end}
{phang2}{cmd:. spbalance}

{pstd}Balance the data{p_end}
{phang2}{cmd:. spbalance, balance}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spbalance} without the {cmd:balance} option stores the following in
{cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(balanced)}}{cmd:1} if strongly balanced, {cmd:0}
otherwise{p_end}

{pstd}
{cmd:spbalance, balance} stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(balanced)}}{cmd:1}{p_end}
{synopt:{cmd:r(Ndropped)}}number of observations dropped{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(T)}}1 x {cmd:r(Ndropped)} vector of the times dropped
if {cmd:r(Ndropped)} > 0{p_end}
{p2colreset}{...}
