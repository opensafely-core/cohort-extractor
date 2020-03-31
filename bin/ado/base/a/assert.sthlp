{smcl}
{* *! version 1.2.4  15jun2019}{...}
{vieweralsosee "[D] assert" "mansection D assert"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assertnested" "help assertnested"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[P] confirm" "help confirm"}{...}
{viewerjumpto "Syntax" "assert##syntax"}{...}
{viewerjumpto "Description" "assert##description"}{...}
{viewerjumpto "Links to PDF documentation" "assert##linkspdf"}{...}
{viewerjumpto "Options" "assert##options"}{...}
{viewerjumpto "Examples" "assert##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] assert} {hline 2}}Verify truth of claim{p_end}
{p2col:}({mansection D assert:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt as:sert} {it:{help exp}} {ifin} [{cmd:,} {opt r:c0} {opt n:ull} {opt f:ast}]

{phang}
{cmd:by} is allowed; see {manhelp by D}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:assert} verifies that {it:{help exp}} is true.  If it is true, the command
produces no output.  If it is not true, {cmd:assert} informs you that the
"assertion is false" and issues a return code of 9; see 
{findalias frrc}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D assertQuickstart:Quick start}

        {mansection D assertRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt rc0} forces a return code of 0, even if the assertion is false.

{phang}
{opt null} forces a return code of 8 on null assertions.   A null
assertion occurs when an {cmd:if} condition excludes all observations
from being checked by {cmd:assert}. By default, the return code is 0
for null assertions.

{phang}
{opt fast} forces the command to exit at the first occurrence 
that {it:{help exp}} evaluates to false.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse bplong}{p_end}
{phang2}{cmd:. describe}{p_end}

{pstd}Verify that {cmd:sex} variable is coded as 0 or 1{p_end}
{phang2}{cmd:. assert sex == 0 | sex == 1}

    Setup
{phang2}{cmd:. replace sex = 3 in 1}

{pstd}Verify that {cmd:sex} variable is coded as 0 or 1{p_end}
{phang2}{cmd:. assert sex == 0 | sex == 1}{p_end}

{pstd}List observation for which assertion is false{p_end}
{phang2}{cmd:. list if sex != 0 & sex != 1}

{pstd}Verify that {cmd:bp} is in [100,200]{p_end}
{phang2}{cmd:. assert bp >= 100 & bp <= 200}

    {hline}
    Setup
{phang2}{cmd:. webuse autotech, clear}{p_end}
{phang2}{cmd:. merge 1:1 make using https://www.stata-press.com/data/r16/autocost}

{pstd}Confirm {cmd:_merge} is always 3{p_end}
{phang2}{cmd:. assert _merge == 3}{p_end}

    {hline}
