{smcl}
{* *! version 1.0.5  15may2018}{...}
{vieweralsosee "undocumented" "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{viewerjumpto "Syntax" "bitowt##syntax"}{...}
{viewerjumpto "Description" "bitowt##description"}{...}
{viewerjumpto "Options" "bitowt##options"}{...}
{viewerjumpto "Examples" "bitowt##examples"}{...}
{title:Title}

{p 4 20 2}
{hi:[D] bitowt} {hline 2} Convert binary frequency records to
frequency-weighted data


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmd:bitowt} {it:case#_var} {it:pop_var} [{cmd:if} {it:exp}] [{cmd:in}
{it:range}] [{cmd:,} {cmdab:c:ase:(}{it:newvarname}{cmd:)}
{cmdab:w:eight:(}{it:newvarname}{cmd:)} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:bitowt} converts binary frequency records to frequency weighted data.
{it:case#_var} specifies the variable containing the number of cases
represented by each observation and {it:pop_var} specifies the number of
subjects (cases plus controls) represented by each observation. This command
will change the data in memory.


{marker options}{...}
{title:Options}

{phang}
{cmd:case(}{it:newvarname}{cmd:)} specifies the name of a new binary
variable containing 1 for cases and 0 for controls.  If {cmd:case()} is not
specified, {cmd:case(_case)} is assumed.

{phang}
{cmd:weight(}{it:newvarname}{cmd:)} specifies the name of a variable
that will contain frequency weights.  If {cmd:weight()} is not specified,
{cmd:weight(_weight)} is assumed.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. bitowt deaths N}{p_end}
{phang}{cmd:. bitowt deaths N, case(cases) weight(wt)}{p_end}
