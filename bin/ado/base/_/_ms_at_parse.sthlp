{smcl}
{* *! version 1.2.1  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_at_parse##syntax"}{...}
{viewerjumpto "Description" "_ms_at_parse##description"}{...}
{viewerjumpto "Option" "_ms_at_parse##option"}{...}
{viewerjumpto "Stored results" "_ms_at_parse##results"}{...}
{title:Title}

{p2colset 4 21 24 2}{...}
{p2col:{hi:[P] _ms_at_parse}}{hline 2}
Parse {opt at()} specifications for postestimation commands
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_at_parse} [{it:at_list}]
[{cmd:,} {opt asobs:erved}]


	{it:at_list}:
	        {it:at_spec} {it:at_list}
	        {it:at_spec}
	        ''

	{it:at_spec}:
	        {cmd:(} {it:at_stat} {cmd:)}
	        {it:at_var}

	{it:at_stat}:
	        {cmd:mean}	or	{cmd:omean}
	        {cmd:median}	or	{cmd:omedian}
	        {cmd:min}	or	{cmd:omin}
	        {cmd:max}	or	{cmd:omax}
	        {cmd:p1}	or	{cmd:op1}
		...
		{cmd:p99}	or	{cmd:op99}
		{cmd:zero}
		{opt asbal:anced}
		{opt asobs:erved}
		{opt base}

	{it:at_var}:
	        {it:indepvar}
	        {it:indepvar} {cmd:=} {it:value}
	        {it:indepvar} {cmd:=} {cmd:(} {it:{help numlist}} {cmd:)}
	        {it:indepvar} {cmd:=} {opth gen:erate(exp)}
		{opt _c:ontinuous}
		{opt _f:actor}
		{opt _all}
		{cmd:*}

{pstd}
where {it:value} is a numeric (nonmissing) value,
{it:exp} is a numeric expression allowed by the {helpb generate}
command, and
{it:indepvar} is any valid single variable specification that identifies
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

{pstd}
Although an {it:indepvar} can be specified multiple times, only the rightmost
{it:at_stat} has any affect, and only if the {it:indepvar} is not
associated with {it:value} or {it:numlist}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_at_parse} parses the contents of the standard {opt at()} option for
some of Stata's postestimation commands.


{marker option}{...}
{title:Option}

{phang}
{opt asobserved} indicates that any unspecified independent variable is to be
left as observed.  The default is to associate {cmd:(mean)} with each of the
unspecified independent variables.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_at_parse} stores the following in {cmd:r()}:

{p2colset 9 24 28 2}{...}
{pstd}Macros{p_end}
{p2col: {cmd:r(statlist)}}list
	of expressions or
	keywords associated with each of the {it:p} independent variables
	participating in the column names of {cmd:e(b)}; a keyword is either
	{cmd:asobserved} or one of the {it:at_stat}s{p_end}
{p2col: {cmd:r(atvars)}}list
	of variable names explicitly specified in {it:at_list}; this list
	preserved the order in which the variables were specified{p_end}

{pstd}Matrices{p_end}
{p2col: {cmd:r(at)}}a
	{it:k} x {it:p} matrix with {it:k} patterns of values associated with
	the full set of {it:p} independent variables
        participating in the column names of {cmd:e(b)}{p_end}
