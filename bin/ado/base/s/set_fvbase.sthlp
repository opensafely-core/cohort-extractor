{smcl}
{* *! version 1.0.0  08mar2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrfvvarlists}{...}
{viewerjumpto "Syntax" "set_fvbase##syntax"}{...}
{viewerjumpto "Description" "set_fvbase##description"}{...}
{title:Title}

{p2colset 4 22 24 2}{...}
{p2col:{hi:[P] set fvbase} {hline 2}}Set whether to automatically
determine the default base level for factor variables
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:fvbase}
{c -(}{cmd:on} | {cmd:off}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:fvbase}
specifies whether to automatically determine the default base level for
factor variables when one is not specified.  When {cmd:set} {cmd:fvbase}
{cmd:off} is in effect, all factor variables are assumed to have no base
level if one is not specified, even when base levels are {helpb fvset}.

{pstd}
The following commands behave as if {cmd:set} {cmd:fvbase} {cmd:off} is
in effect, regardless of the current setting:

	{helpb list}
	{helpb mean}
	{helpb summarize}
	{helpb total}

