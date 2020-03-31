{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] by" "help by"}{...}
{vieweralsosee "[P] byable" "help byprog"}{...}
{vieweralsosee "[P] quietly" "help quietly"}{...}
{viewerjumpto "Syntax" "qby##syntax"}{...}
{viewerjumpto "Description" "qby##description"}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{hi:[R] qby} {hline 2}}Quietly repeat Stata command on subsets of the
data{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 34 2}{cmd:qby} {it:varlist}{cmd::}  {it:command}

{p 8 34 2}{cmd:qby} {it:varlist1} [{cmd:(}{it:varlist2}{cmd:)}]
	[{cmd:,} {cmdab:s:ort} {cmd:rc0}]{cmd::}  {it:command}


{p 8 34 2}{cmd:qbys} {it:varlist}{cmd::}  {it:command}

{p 8 34 2}{cmd:qbys} {it:varlist1} [{cmd:(}{it:varlist2}{cmd:)}]
	[{cmd:,} {cmd:rc0}]{cmd::}  {it:command}


{marker description}{...}
{title:Description}

{pstd}
{cmd:qby} and {cmd:qbys} are convenience commands and are equivalent to

	    {cmd:quietly by} {it:...}
    and
	    {cmd:quietly bysort} {it:...}

{pstd}
See {helpb by} and {helpb quietly}.
{p_end}
