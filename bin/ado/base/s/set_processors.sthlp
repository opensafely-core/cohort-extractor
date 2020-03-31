{smcl}
{* *! version 1.1.1  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "set_processors##syntax"}{...}
{viewerjumpto "Description" "set_processors##description"}{...}
{title:Title}

{phang}Set the number of processors for Stata/MP to use


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set} {cmdab:processors} {it:#}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set processors} sets the number of processors or cores that
{help statamp:Stata/MP} will use.  The default is the number of processors
available on the computer, or the number of processors allowed by Stata/MP's
license, whichever is less.

{pstd}
Most users will never want to change this setting.  Use it only
when you do not want to use all available processors
on a computer.  For example, if two users are trying to use an 8-processor
system at the same time, they each might wish to type {cmd:set processors 4}
so that they are not competing with each other for processor time on all
8 processors.
{p_end}
