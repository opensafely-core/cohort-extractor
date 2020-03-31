{smcl}
{* *! version 1.0.5  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_dydx_parse##syntax"}{...}
{viewerjumpto "Description" "_ms_dydx_parse##description"}{...}
{viewerjumpto "Options" "_ms_dydx_parse##options"}{...}
{viewerjumpto "Stored results" "_ms_dydx_parse##results"}{...}
{title:Title}

{p2colset 4 23 26 2}{...}
{p2col:{hi:[P] _ms_dydx_parse}}{hline 2}
Parse dydx() specifications for postestimation commands
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_dydx_parse} [{it:dydx_varlist}]
[{cmd:,} {opt ey} {opt ex}]


	{it:dydx_varlist}:
		{it:dydx_var} {it:dydx_varlist}
		{it:dydx_var}

	{it:dydx_var}:
	        {it:indepvar}
		{opt _cont:inuous}
		{opt _fac:tor}
		{opt _all}
		{cmd:*}

{pstd}
where {it:indepvar} is any valid single variable specification that identifies
an independent variable participating in the column stripe for {cmd:e(b)},
for example, standard variables with or without time-series operators, and
factor-level variables (but not interactions of variables).

{pstd}
{opt _continuous} is a shortcut notation that means all the continuous
{it:indepvar}s.

{pstd}
{opt _factor} is a shortcut notation that means all the factor-variable
{it:indepvar}s.

{pstd}
{opt _all} and {cmd:*} are synonyms for {opt _continuous} {opt _factor}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_dydx_parse} parses the contents of the standard {opt dydx()} options
for some of Stata's postestimation commands.


{marker options}{...}
{title:Options}

{phang}
{opt ey} and {opt ex} are used only for error messages.  The default error
message mentions "invalid dydx() option".  With {opt ey}, the message becomes
"invalid eydx() option"; with {opt ex}, the message becomes
"invalid dyex() option"; with both, the message becomes "invalid eyex()
option".


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_dydx_parse} stores the following in {cmd:r()}:

{p2colset 9 24 28 2}{...}
{pstd}Macros{p_end}
{p2col: {cmd:r(varlist)}}list
	of variables from {it:dydx_varlist}{p_end}
