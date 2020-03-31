{smcl}
{* *! version 1.4.3  05nov2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_extract_varlist##syntax"}{...}
{viewerjumpto "Description" "_ms_extract_varlist##description"}{...}
{viewerjumpto "Options" "_ms_extract_varlist##options"}{...}
{viewerjumpto "Remarks" "_ms_extract_varlist##remarks"}{...}
{viewerjumpto "Stored results" "_ms_extract_varlist##results"}{...}
{title:Title}

{pstd}
{hi:[P] _ms_extract_varlist} {hline 2} Match variables from e(b)


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_extract_varlist} [{varlist}]
[{cmd:,}	{opt mat:rix(name)}
		{opt row}
		{opt eq:uation(eqid)}
		{opt noomit:ted}
		{opt nofatal}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_extract_varlist} returns the expanded, specific varlist from
{cmd:e(b)} that matches {it:varlist}.


{marker options}{...}
{title:Options}

{phang}
{opt matrix(name)} specifies that {cmd:_ms_extract_varlist} use
information from the column stripe associated with the named matrix.  The
default matrix is {cmd:e(b)}.

{phang}
{opt row} specifies that the information come from the row stripe.  By
default, the information comes from the column stripe.

{phang}
{opt equation(eqid)} specifies that {it:varlist} is in equation {it:eqid}.
The default is the first equation.

{phang}
{opt noomitted} specifies that omitted {it:varlist} is ignored.  The default
is to match omitted variables.  Omitted variables include variables dropped
because of collinearity, as well as base levels of factor variables and
interactions.

{phang}
{opt nofatal} specifies that {cmd:_ms_extract_varlist} ignore variables in
{it:varlist} that are not found in the column stripe for {cmd:e(b)}.  The
default is to exit with an error message.


{marker remarks}{...}
{title:Remarks}

{pstd}
Let's fit a linear regression of {cmd:mpg} on {cmd:i.foreign} and
{cmd:i.rep78}:

	{cmd:. sysuse auto}
	{cmd:. regress mpg i.foreign i.rep78}

{pstd}
The corresponding specific, expanded varlist is
{cmd:i0b.foreign i1.foreign i1b.rep78 i2.rep78 i3.rep78 i4.rep78 i5.rep78}.
It can be found on the column stripe of {cmd:e(b)},

	{cmd:. matrix list e(b)}

{pstd}
If you now coded {cmd:_ms_extract_varlist i.foreign}, returned in
{cmd:r(varlist)} would be {cmd:0.foreign 1.foreign}.  This would be useful,
for instance, if you were programming ancillary statistics after estimation
and, in the command you are writing, the user specified the variables of
interest.  Thus your program might read

	{cmd:program mycmd}
		{cmd:version {ccl stata_version}}
		{cmd:syntax varlist(fv)} ...
		...
		{cmd:_ms_extract_varlist `varlist'}
		{cmd:local vars_to_use `r(varlist)'}
		...
		{cmd:foreach el of local vars_to_use} {
			...
		}
		...
	{cmd:end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_extract_varlist} stores the following in {cmd:r()}:

{pstd}Macros{p_end}
{p2colset 9 24 28 2}{...}
{p2col: {cmd:r(varlist)}}the matched expanded, specific varlist{p_end}
