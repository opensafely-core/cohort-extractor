{smcl}
{* *! version 1.0.1  04may2015}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_unab##syntax"}{...}
{viewerjumpto "Description" "_unab##description"}{...}
{viewerjumpto "Options" "_unab##options"}{...}
{viewerjumpto "Examples" "_unab##examples"}{...}
{viewerjumpto "Stored results" "_unab##results"}{...}
{title:Title}

{p2colset 4 14 17 2}{...}
{p2col:{hi:[P] _unab}}{hline 2}
Unabbreviate variable list from matrix stripe elements
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_unab} {varlist}
	[{cmd:,}
		{opt matrix(name)}
		{opt row}
		{opt needbase}]

{pstd}
{it:varlist} may contain factor variables; see {help fvvarlist}.
{p_end}
{pstd}
{it:varlist} may contain time-series operators; see {help tsvarlist}.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_unab} expands and unabbreviates {it:varlist} using the variable
names in the column stripe of a matrix instead of the current dataset.

{pstd}
{cmd:_unab} expands factor variables to the levels present in the matrix
stripe.  Level values not present in the matrix stripe will cause an
error.


{marker options}{...}
{title:Options}

{phang}
{opt matrix(name)} specifies that variable names present on the column stripe
of matrix {it:name} be used.  The default is {cmd:matrix(e(b))}.  If
{cmd:e(b)} does not exist, then {cmd:_unab} uses the variable names in the
current dataset.

{phang}
{opt row} specifies that the variable names come from the row stripe.
The default is the column stripe.

{phang}
{opt needbase} specifies that the {cmd:bn.} factor-variables operator is
not allowed.


{marker examples}{...}
{title:Examples}

   {cmd:. sysuse auto}
   {cmd:. regress mpg for#rep}

   {cmd:. _unab *}
   {cmd:. di r(varlist)}
   {cmd:foreign rep78}

   {cmd:. _unab i.for}
   {cmd:. di r(varlist)}
   {cmd:0b.foreign 1.foreign}

   {cmd:. _unab 1.rep#for}
   {cmd:. di r(varlist)}
   {cmd:1b.rep78#0b.foreign 1.brep78#1.foreign}

   {cmd:. _unab 2.for}
   {err:level 2 of factor foreign not found in list of covariates}
   {search r(111)};


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_unab} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{p2col: {cmd:r(varlist)}}the expanded, specific variable list{p_end}
