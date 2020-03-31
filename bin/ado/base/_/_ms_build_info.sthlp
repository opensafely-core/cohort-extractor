{smcl}
{* *! version 1.1.1  15nov2014}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{vieweralsosee "[P] _matrix_table" "help _matrix_table"}{...}
{viewerjumpto "Syntax" "_ms_build_info##syntax"}{...}
{viewerjumpto "Description" "_ms_build_info##description"}{...}
{viewerjumpto "Option" "_ms_build_info##option"}{...}
{viewerjumpto "Stored results" "_ms_build_info##results"}{...}
{title:Title}

{p2colset 4 26 28 2}{...}
{p2col:{hi:[P] _ms_build_info} {hline 2}}Building extra factor-variables information into column stripes
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_build_info} {it:matrix_name} {ifin} {weight} [{cmd:,}
{opt row} {opt elabels}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_build_info} builds some factor-variables information from the dataset
and stores it with the column stripe for {it:matrix_name}.  This information
identifies empty cells in factors and interactions in the column stripe.


{marker option}{...}
{title:Option}

{phang}
{opt row} specifies that the information come from the row stripe.  The
default is the column stripe.

{phang}
{opt elabels} specifies that value labels attached to factor variables
in the column stripe of {it:matrix_name} be copied into the current
estimation results.

{pmore}
This option, when combined with {opt row}, makes the value labels
available for better labeled output when {it:matrix_name} is used with
{cmd:_matrix_table}; see {helpb _matrix_table}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_build_info} stores its results directly in the stripe information
associated with {it:matrix_name}.
{p_end}

{pstd}
With option {opt elabels}, {cmd:_ms_build_info} also invisibly adds
value-label information to the current estimation results.
{p_end}
