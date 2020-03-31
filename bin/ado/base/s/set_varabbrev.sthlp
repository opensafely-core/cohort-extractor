{smcl}
{* *! version 1.1.7  23oct2017}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] varabbrev" "help novarabbrev"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "set_varabbrev##syntax"}{...}
{viewerjumpto "Description" "set_varabbrev##description"}{...}
{viewerjumpto "Remarks" "set_varabbrev##remarks"}{...}
{title:Title}

{phang}
Set whether variable abbreviations are supported{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:varabbrev}
{c -(}{cmd:on} | {cmd:off}{c )-}
{cmd:,} {cmdab:perm:anently}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:varabbrev} allows you to control whether variable abbreviations
are allowed.  The default is to allow variable abbreviations.

{pstd}
For the {helpb novarabbrev:varabbrev} and {helpb novarabbrev} commands, see
{manlink P varabbrev}.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you type

	{cmd:. sysuse auto}
	{cmd:. summarize mp}

{pstd}
you will see a summary of the variable {cmd:mpg} because {cmd:mp} is
an abbreviation of {cmd:mpg} and no other variable in the dataset
can be abbreviated to {cmd:mp}.

{pstd}
If you turn off variable abbreviations with

	{cmd:. set varabbrev off}

{pstd}
Stata will not find the variable {cmd:mpg} when you type {cmd:mp} in
a variable list.
{p_end}
