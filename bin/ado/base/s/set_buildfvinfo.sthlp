{smcl}
{* *! version 1.0.0  08jul2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{viewerjumpto "Syntax" "set_buildfvinfo##syntax"}{...}
{viewerjumpto "Description" "set_buildfvinfo##description"}{...}
{title:Title}

{p2colset 4 27 29 2}{...}
{p2col:{hi:[P] set buildfvinfo} {hline 2}}Build extra factor-variables
information into parameter estimates
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:buildfvinfo}
{c -(}{cmd:on} | {cmd:off}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:buildfvinfo}
allows you to control whether to build
factor-variables information from the dataset
and store it with the column stripe of {cmd:e(b)}.  This information
identifies empty cells in factors and interactions in the column stripe; it
also helps identify estimable functions in
{helpb contrast},
{helpb margins}, and
{helpb pwcompare}.

{pstd}
{cmd:set} {cmd:buildfvinfo} is a programmer's setting that when set {cmd:off}
can help speed up simulations and replication-based variance estimation.
{p_end}
