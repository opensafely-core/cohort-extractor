{smcl}
{* *! version 1.0.19  25sep2018}{...}
{vieweralsosee "[R] set showbaselevels" "mansection R setshowbaselevels"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_showbaselevels##syntax"}{...}
{viewerjumpto "Description" "set_showbaselevels##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_showbaselevels##linkspdf"}{...}
{viewerjumpto "Option" "set_showbaselevels##option"}{...}
{viewerjumpto "Examples" "set_showbaselevels##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[R] set showbaselevels} {hline 2}}Display settings for
   coefficient tables{p_end}
{p2col:}({mansection R setshowbaselevels:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:showbaselevels}
{c -(}{opt on}|{opt off}|{opt all}{c )-}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:showemptycells}
{c -(}{opt on}|{opt off}{c )-}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:showomitted}
{c -(}{opt on}|{opt off}{c )-}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:fvlabel}
{c -(}{opt on}|{opt off}{c )-}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:fvwrap}
{it:#}
[{cmd:,} {cmdab:perm:anently}]

{p 8 16 2}
{cmd:set}
{cmd:fvwrapon}
{c -(}{opt word}|{opt width}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:showbaselevels} specifies whether to display base levels of
factor variables and their interactions in coefficient tables.  {cmd:set}
{cmd:showbaselevels} {cmd:on} specifies that base levels be reported for
factor variables and for interactions whose bases cannot be inferred from
their component factor variables.  {cmd:set} {cmd:showbaselevels} {cmd:all}
specifies that all base levels of factor variables and interactions be
reported.

{pstd}
{cmd:set} {cmd:showemptycells} specifies whether to display empty cells
in coefficient tables.

{pstd}
{cmd:set} {cmd:showomitted} specifies whether to display omitted
coefficients in coefficient tables.

{pstd}
{cmd:set} {cmd:fvlabel} specifies whether to display factor-variable value
labels in coefficient tables.  {cmd:set} {cmd:fvlabel} {cmd:on}, the
default, specifies that the labels be displayed.  {cmd:set} {cmd:fvlabel}
{cmd:off} specifies that the levels of factor variables rather than the labels
be displayed.

{pstd}
{cmd:set} {cmd:fvwrap} {it:#} specifies that long value labels wrap {it:#} lines
in the coefficient table.  The default is {cmd:set} {cmd:fvwrap} {cmd:1}, which
means that long value labels will be abbreviated to fit on one line.

{pstd}
{cmd:set} {cmd:fvwrapon} specifies whether value labels that wrap will break at
word boundaries or break based on available space.  {cmd:set} {cmd:fvwrapon}
{cmd:word}, the default, specifies that value labels break at word boundaries.
{cmd:set} {cmd:fvwrapon} {cmd:width} specifies that value labels break based on
available space.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setshowbaselevelsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker examples}{...}
{title:Examples}

{pstd}
Show all base levels for factor variables
and interactions but suppress empty cells and omitted predictors

{pmore2}
{cmd:. set showbaselevels all}{break}
{cmd:. set showemptycells off}{break}
{cmd:. set showomitted off}

{pstd}
Reset the display of baselevels, empty cells, and omitted predictors to the
command-specific default behavior

{pmore2}
{cmd:. set showbaselevels}{break}
{cmd:. set showemptycells}{break}
{cmd:. set showomitted}{p_end}

{pstd}
Allow value labels to wrap 2 lines in coefficient tables; illustrate with
{cmd:mvreg} model.

{pmore2}
{cmd:. set fvwrap 2}{break}

{pmore2}
{cmd:. webuse jaw}{break}
{cmd:. mvreg y1 y2 y3 = i.fracture}

{pstd}
Same as above, but break based on available space rather than word boundaries.

{pmore2}
{cmd:. set fvwrapon width}

{pmore2}
{cmd:. mvreg y1 y2 y3 = i.fracture}{p_end}
