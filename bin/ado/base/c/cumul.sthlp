{smcl}
{* *! version 1.1.10  14may2018}{...}
{viewerdialog cumul "dialog cumul"}{...}
{vieweralsosee "[R] cumul" "mansection R cumul"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Diagnostic plots" "help diagnostic_plots"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[D] stack" "help stack"}{...}
{viewerjumpto "Syntax" "cumul##syntax"}{...}
{viewerjumpto "Menu" "cumul##menu"}{...}
{viewerjumpto "Description" "cumul##description"}{...}
{viewerjumpto "Links to PDF documentation" "cumul##linkspdf"}{...}
{viewerjumpto "Options" "cumul##options"}{...}
{viewerjumpto "Examples" "cumul##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] cumul} {hline 2}}Cumulative distribution{p_end}
{p2col:}({mansection R cumul:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:cumul}
{varname}
{ifin}
[{it:{help cumul##weight:weight}}]
{cmd:,}
{opth g:enerate(newvar)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent :* {opth g:enerate(newvar)}}create variable {it:newvar}{p_end}
{synopt :{opt f:req}}use frequency units for cumulative{p_end}
{synopt :{opt eq:ual}}generate equal cumulatives for tied values{p_end}
{synoptline}
{p 4 6 2}
* {opt generate(newvar)} is required.{p_end}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s and {opt aweight}s are allowed; see {help weight}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests > Distributional plots and tests}
      {bf:> Generate cumulative distribution}


{marker description}{...}
{title:Description}

{pstd}
{opt cumul} creates {newvar}, defined as the empirical cumulative
distribution function of {varname}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R cumulQuickstart:Quick start}

        {mansection R cumulRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth generate(newvar)} is required.  It specifies
the name of the new variable to be created.

{phang}
{opt freq} specifies that the cumulative be in frequency units; otherwise, it
is normalized so that {newvar} is 1 for the largest value of {varname}.

{phang}
{opt equal} requests that observations with equal values in
{varname} get the same cumulative value in {newvar}.


{marker examples}{...}
{title:Examples}

{pstd}
To graph cumulative distribution:{p_end}

{phang2}{cmd:. webuse hsng}{p_end}
{phang2}{cmd:. cumul faminc, gen(cum)}{p_end}
{phang2}{cmd:. line cum faminc, sort}

{pstd}
To graph two cumulative distributions on the same graph:{p_end}

{phang2}{cmd:. sysuse citytemp, clear}{p_end}
{phang2}{cmd:. cumul tempjan, gen(cjan)}{p_end}
{phang2}{cmd:. cumul tempjuly, gen(cjuly)}{p_end}
{phang2}{cmd:. stack cjan tempjan  cjuly tempjuly, into(c temp) wide clear}{p_end}
{phang2}{cmd:. line cjan cjuly temp, sort}{p_end}
