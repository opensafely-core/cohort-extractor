{smcl}
{* *! version 1.1.8  04may2019}{...}
{vieweralsosee "[R] set_defaults" "mansection R set_defaults"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata set" "help mata_set"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_defaults##syntax"}{...}
{viewerjumpto "Description" "set_defaults##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_defaults##linkspdf"}{...}
{viewerjumpto "Option" "set_defaults##option"}{...}
{viewerjumpto "Examples" "set_defaults##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[R] set_defaults} {hline 2}}Reset system parameters to original Stata
defaults{p_end}
{p2col:}({mansection R set_defaults:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:set_defaults}
{c -(}{it:category} | {cmd:_all}{c )-}
[{cmd:,} {opt perm:anently}]

    where {it:category} is one of

{pmore}
{opt mem:ory} | {opt out:put} | {opt inter:face} | {opt graph:ics} |
{opt eff:iciency} | {opt net:work} | {opt up:date} |
{opt trace} | {opt mata} | {opt unicode} | {opt oth:er}


{marker description}{...}
{title:Description}

{pstd}
{opt set_defaults} resets settings made by {helpb set} to the original default
settings that were shipped with Stata.

{pstd}
{cmd:set_defaults} may not be used with {cmd:java} or {cmd:python}
system-parameter categories.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R set_defaultsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
   the settings be remembered and become the default settings when you invoke
   Stata.


{marker examples}{...}
{title:Examples}

    {cmd:. set_defaults network}
    {cmd:. set_defaults output}

    {cmd:. set_defaults _all}
