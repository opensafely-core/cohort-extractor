{smcl}
{* *! version 1.0.5  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[P] _tsnatscale" "help _tsnatscale"}{...}
{viewerjumpto "Syntax" "_natscale##syntax"}{...}
{viewerjumpto "Description" "_natscale##description"}{...}
{viewerjumpto "Stored results" "_natscale##results"}{...}
{title:Title}

{p 4 19 2}
{hi:[G-2] _natscale} {hline 2} Obtain nice label or tick values


{marker syntax}{...}
{title:Syntax}

	{cmd:_natscale} {it:#_min} {it:#_max} {it:#_n}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_natscale} returns in {cmd:r()} "nice" values for labeling or ticking of
the range {it:#_min} to {it:#_max} in approximately {it:#_n} steps.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_natscale} returns in {cmd:r()}

	scalar {cmd:r(n)}            number of values chosen
	scalar {cmd:r(min)}          first value to label or tick
	scalar {cmd:r(max)}          last  value to label or tick
	scalar {cmd:r(delta)}        ({cmd:r(max)}-{cmd:r(min)})/{cmd:r(n)}

{pstd}
The values to tick are
{cmd:r(min)},
{cmd:r(min)}+{cmd:r(delta)},
{cmd:r(min)}+2*{cmd:r(delta)},
...,
{cmd:r(min)}+({cmd:r(n)}-1)*{cmd:r(delta)}.
{p_end}
