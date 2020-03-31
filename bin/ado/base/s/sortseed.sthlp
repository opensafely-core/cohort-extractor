{smcl}
{* *! version 1.0.6  24may2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "sortseed##syntax"}{...}
{viewerjumpto "Description" "sortseed##description"}{...}
{viewerjumpto "Remarks" "sortseed##remarks"}{...}
{viewerjumpto "Example" "sortseed##example"}{...}
{title:Title}

{p 4 26 2}
{hi:[P] set sortseed} {hline 2} Set the default seed for randomly breaking
ties in sorts


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:set} {opt sortseed} {it:#} 


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:sortseed} specifies the seed used for the random-number
generator that breaks any ties in the key values when data are sorted.  This
affects the commands {helpb sort} and {helpb gsort}, as well as any commands
that use sorting as part of their computation.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:set sortseed} should be used rarely.  Access to the sorting seed is
provided solely for those doing replication studies, where occasionally it is
necessary to set the sort seed to produce numerically identical results for
computations whose results may change slightly when the computations
are run repeatedly.  These
changes are typically in the digits beyond those displayed by the command, but
these might be compared nevertheless in a replication study.

{pstd}
The current value of {cmd:sortseed} can be obtained by accessing stored result
{cmd:r(sortseed)} after issuing the command {cmd:query} {cmd:sortseed}.

{pstd}
Using {cmd:set sortseed} outside of such comparisons is strongly
discouraged.  Many data manipulations depend on sorts being specified fully
and correctly, and setting the sorting seed can disguise logic problems in data
management.  For a discussion, see
{stata "view browse http://www.stata.com/statalist/archive/2005-09/msg00582.html":a posting on Statalist about this topic}.
{p_end}


{marker example}{...}
{title:Example}

{pstd}Obtain the sorting seed, perform some operations which change the
sort order of the data (and thus change the sorting seed), and then
reset the sorting seed.{p_end}
{phang2}{cmd:. query sortseed}{p_end}
{phang2}{cmd:. local origseed = r(sortseed)}{p_end}
{phang2}...any command(s) which change the sort order of the data...{p_end}
{phang2}{cmd:. set sortseed `origseed'}{p_end}
