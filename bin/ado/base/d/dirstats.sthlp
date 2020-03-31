{smcl}
{* *! version 1.0.5  29nov2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{viewerjumpto "Syntax" "dirstats##syntax"}{...}
{viewerjumpto "Description" "dirstats##description"}{...}
{viewerjumpto "Options" "dirstats##options"}{...}
{viewerjumpto "Examples" "dirstats##examples"}{...}
{viewerjumpto "Stored results" "dirstats##results"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] dirstats} {hline 2} Directory statistics


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:dirstats}
[{cmd:,}
{c -(}{cmd:base}|{cmd:updates}|{cmd:plus}{c )-}
    {cmd:leave}
]


{marker description}{...}
{title:Description}

{pstd}
{cmd:dirstats} presents a report on the number of files in the lettered
subdirectories of {helpb sysdir} BASE or PLUS.


{marker options}{...}
{title:Options}

{phang}
{cmd:base}, {cmd:updates}, and {cmd:plus} specify the directory for which
    results are to be reported.  The default is {cmd:base}.

{phang}
{cmd:leave} specifies that a dataset is to be left behind containing
    variables {cmd:ltr} and {cmd:n}.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. sysdir}

{phang}
{cmd:. sysdir, updates}

{phang}
{cmd:. sysdir, updates leave}


{marker results}{...}
{title:Stored results}

{pstd}
Lots.  Type {cmd:return list} after issuing {cmd:sysdir}.
{p_end}
