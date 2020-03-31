{smcl}
{* *! version 1.0.3  14may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _coef_table" "help _coef_table"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation command (estimation)" "help estcom"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (postestimation)" "help postest"}{...}
{viewerjumpto "Syntax" "_matrix_table##syntax"}{...}
{viewerjumpto "Description" "_matrix_table##description"}{...}
{viewerjumpto "Options" "_matrix_table##options"}{...}
{viewerjumpto "Stored results" "_matrix_table##results"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] _matrix_table} {hline 2} Displaying matrix as a table


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_matrix_table} {it:matname} [{cmd:,} {it:options}]

{synoptset 27}{...}
{synopthdr}
{synoptline}
{synopt :{cmd:formats(}{help format:{bf:%}{it:fmt}} [{cmd:%}{it:fmt} ...]{cmd:)}}format for table cells{p_end}
{synopt :{opt notitles}}do not display the table column titles{p_end}
{synopt :{it:{help _matrix_table##display_options:display_options}}}control
row spacing, line width, and display of omitted variables{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_matrix_table} is an alternative to {helpb matrix list} that
looks more like the output from {helpb _coef_table}.
The column titles are taken from the column names of {it:matname}.
The row titles are taken from the row names of {it:matname} and are
formatted to look like the coefficients.


{marker options}{...}
{title:Options}

{phang}
{opth format(%fmt)} specifies the numeric format for the table cells.

{phang}
{opt notitles} prevents the display of the table column titles.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_matrix_table} stores the following in {cmd:s()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:s(width_col1)}}width of the first column{p_end}
{synopt:{cmd:s(width)}}width of table{p_end}
{p2colreset}{...}
