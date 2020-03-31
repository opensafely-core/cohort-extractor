{smcl}
{* *! version 1.0.15  25sep2018}{...}
{vieweralsosee "[R] set cformat" "mansection R setcformat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Estimation options" "help estimation options"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_cformat##syntax"}{...}
{viewerjumpto "Description" "set_cformat##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_cformat##linkspdf"}{...}
{viewerjumpto "Option" "set_cformat##option"}{...}
{viewerjumpto "Remarks" "set_cformat##remarks"}{...}
{viewerjumpto "Example" "set_cformat##example"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[R] set cformat} {hline 2}}Format settings for coefficient tables{p_end}
{p2col:}({mansection R setcformat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:cformat}
[{it:fmt}]
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:pformat}
[{it:fmt}]
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:sformat}
[{it:fmt}]
[{cmd:,} {cmdab:perm:anently}]

{pstd}
where {it:fmt} is a {help format:numerical format}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:cformat} specifies the output format of
coefficients, standard errors, and confidence limits in coefficient tables.

{pstd}
{cmd:set} {cmd:pformat} specifies the output format of
p-values in coefficient tables.

{pstd}
{cmd:set} {cmd:sformat} specifies the output format of
test statistics in coefficient tables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setcformatRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
The maximum format widths for {cmd:set cformat}, {cmd:set pformat}, and 
{cmd:set sformat} in coefficient tables are 9, 5, and 8, respectively.


{marker example}{...}
{title:Example}

{pstd}
Use a {cmd:%9.2f} format for coefficients, standard errors, and confidence
limits

{phang2}
{cmd:. set cformat %9.2f}

{pstd}
Reset the format to the command-specific default

{phang2}
{cmd:. set cformat}
{p_end}
