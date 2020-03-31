{smcl}
{* *! version 1.1.1  12may2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{viewerjumpto "Syntax" "version_missing##syntax"}{...}
{viewerjumpto "Description" "version_missing##description"}{...}
{title:Title}

{p2colset 5 29 31 2}{...}
{p2col :{hi:[P] version, missing} {hline 2}}Set version to use modern
treatment of missing values{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	    {cmdab:vers:ion} {it:#}{cmd:,} {cmdab:mis:sing}

	    {cmdab:vers:ion} {it:#}{cmd:,} {cmdab:mis:sing}{cmd::}  {it:command}


{marker description}{...}
{title:Description}

{pstd}
{cmd:version} {it:#}{cmd:,} {cmd:missing} requests the modern treatment of
missing values.  {cmd:missing} is allowed only when {it:#} is less than 8
(because otherwise, modern treatment of missing values is implied).

{pstd}
Before version 8, there was only one missing value ({cmd:.}).  To keep old
programs working, when {cmd:version} is less than 8, Stata acts as if {cmd:.}
= {cmd:.a} = {cmd:.b} = ... = {cmd:.z}.  Thus old lines, such as
"...{cmd:if x!=.}", continue to exclude all missing observations.

{pstd}
Specifying {cmd:missing} will cause old programs to break.  The only reason
to specify {cmd:missing} is that you want to update the old program to 
distinguish between missing-value codes and you do want to update it to
be modern in other ways.  Few, if any, programs need this.
{p_end}
