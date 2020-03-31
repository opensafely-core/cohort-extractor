{smcl}
{* *! version 1.0.9  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway kdensity" "help twoway_kdensity"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{viewerjumpto "Syntax" "twoway__kdensity_gen##syntax"}{...}
{viewerjumpto "Description" "twoway__kdensity_gen##description"}{...}
{viewerjumpto "Options" "twoway__kdensity_gen##options"}{...}
{viewerjumpto "Stored results" "twoway__kdensity_gen##results"}{...}
{title:Title}

{p 4 34 2}
{hi:[G-2] twoway__kdensity_gen} {hline 2} twoway kdensity subroutine


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:twoway__kdensity_gen}
	{it:varname}
	[{it:weight}]
	[{cmd:if} {it:exp}]
	[{cmd:in} {it:in_range}]
	{cmd:,}{break}
	{cmdab:r:ange:(}{it:range}{cmd:)}{break}
	[
	{cmd:n(}{it:#}{cmd:)}
	{cmdab:bw:idth:(}{it:#}{cmd:)}
	{cmd:area(}{it:#}{cmd:)}
	{cmdab:gen:erate:(}{it:yvar} {it:xvar} [, {cmd:replace} ]{cmd:)}
	{cmdab:k:ernel:(}{it:kernel}{cmd:)} {it:kernel_names}
	]

{pstd}
{cmd:fweight}s and {cmd:aweight}s are allowed; see {help weights}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway__kdensity_gen} was written to help in parsing and generating
variables for {cmd:graph twoway kdensity}, see
{manhelp twoway_kdensity G-2:twoway kdensity}.


{marker options}{...}
{title:Options}

{phang}
{cmd:range(}{it:range}{cmd:)} specifies the range of values for {it:xvar}.
Here {it:range} can be a pair of numbers identifying the minimum and maximum,
or {it:range} can be a variable.  If {it:range} is a variable, the range is
determined by the values of {cmd:r(min)} and {cmd:r(max)} after

{pmore}
{cmd}. summarize {it:range} if {it:exp} in {it:in_range}, meanonly{text}

{phang}
{cmd:n(}{it:#}{cmd:)} specifies the number of evaluation points.  The default
is {cmd:n(1)}.

{phang}
{cmd:bwidth(}{it:#}{cmd:)} specifies the smoothing parameter.  This is the
same {cmd:bwidth()} option as for {cmd:kdensity}, see {manhelp kdensity R}.
The old {cmd:width()} option is also available.

{phang}
{cmd:area(}{it:#}{cmd:)} specifies the area adjustment.  The number is multiplied with
the kernel density estimates when {it:yvar} is generated.  The default value
is {cmd:area(1)}.

{phang}
{cmd:generate(}{it:yvar} {it:xvar} [{cmd:,} {cmd:replace}]{cmd:)} specifies
the names of the variables to generate.  The grid of values is placed in
{it:xvar}, and kernel density estimates are placed in {it:yvar}.  The
{cmd:replace} option indicates that these variables may be replaced if they
already exist.

{phang}
{cmd:kernel(}{it:kernel}{cmd:)} specifies kernel weight functions in {it:kernel} where {it:kernel} is defined in {helpb kdensity##kernel}.

{phang}
{it:kernel_names} are the names for kernel weight functions accepted by
{helpb kdensity}.  This old syntax may not be combined with the new syntax
{cmd:kernel()}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:twoway__kdensity_gen} stores the following in {cmd:r()}:

{pstd}
Scalars:

	 {cmd:r(n)}        number of evaluation points
	 {cmd:r(min)}      minimum of {cmd:range()}
	 {cmd:r(max)}      maximum of {cmd:range()}
	 {cmd:r(delta)}    distance between grid points
	 {cmd:r(area)}     area multiplier
	 {cmd:r(width)}    smoothing parameter

{pstd}
Macros:

	 {cmd:r(varname)}  {it:varname}
	 {cmd:r(range)}    {it:range} from {cmd:range(}{it:range}{cmd:)} option
	 {cmd:r(kernel)}   name of kernel used to compute density estimates
