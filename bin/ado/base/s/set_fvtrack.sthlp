{smcl}
{* *! version 1.0.0  08mar2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrfvvarlists}{...}
{viewerjumpto "Syntax" "set_fvtrack##syntax"}{...}
{viewerjumpto "Description" "set_fvtrack##description"}{...}
{viewerjumpto "Option" "set_fvtrack##option"}{...}
{viewerjumpto "Remarks" "set_fvtrack##remarks"}{...}
{title:Title}

{p2colset 4 23 25 2}{...}
{p2col:{hi:[P] set fvtrack} {hline 2}}Keep track of levels for factor variables
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:fvtrack}
{c -(}{cmd:term} | {cmd:factor}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:fvtrack}
allows you to control how Stata keeps track of factor levels when you
use factor-variables notation.

{pstd}
{helpb contrast} behaves as if {cmd:set fvtrack factor} is in effect,
regardless of the current setting.

{pstd}
{helpb menl} behaves as if {cmd:set fvtrack term} is in effect,
regardless of the current setting.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
Assume that we have the following factor variables:

{pmore2}
Factor {cmd:ind} has 2 levels, taking on the values 0 and 1.

{pmore2}
Factor {cmd:grp} has 3 levels, taking on the values 1, 2, and 3.

{pstd}
The expansion of {cmd:i.ind} is

{phang2}
{cmd:0b.ind}
{cmd:1.ind}

{pstd}
The expansion of {cmd:i.grp} is

{phang2}
{cmd:1b.grp}
{cmd:2.grp}
{cmd:3.grp}

{pstd}
The expansion of their interaction {cmd:i.ind#i.grp} is

{phang2}
{cmd:0b.ind#1b.grp}
{cmd:0b.ind#2.grp}
{cmd:0b.ind#3.grp}
{cmd:1.ind#1b.grp}
{cmd:1.ind#2.grp}
{cmd:1.ind#3.grp}

{pstd}
When {cmd:set fvtrack factor} is in effect, or when it is implied by
setting {helpb version##userversion:version, user} to a version less
than 15, Stata keeps track of factor levels with the factor variable.
This means that specifying a level for {cmd:grp} in one term will
affect all other terms that contain {cmd:grp}.
For example, the expansion of

{phang2}
{cmd:i3.grp i.ind#i.grp}

{pstd}
is

{phang2}
{cmd:3.grp}
{cmd:0b.ind#3.grp}
{cmd:1.ind#3.grp}

{pstd}
and the expansion of

{phang2}
{cmd:i.grp i.ind#i3.grp}

{pstd}
is

{phang2}
{cmd:3.grp}
{cmd:0b.ind#3.grp}
{cmd:1.ind#3.grp}

{pstd}
When {cmd:set fvtrack term} is in effect, Stata keeps track of
factor levels with the term in which they are specified.
This means that specifying a level for {cmd:grp} in one term does
not affect any other term that contains {cmd:grp}.
Using the above examples, we see that the expansion of

{phang2}
{cmd:i3.grp i.ind#i.grp}

{pstd}
is

{phang2}
{cmd:3.grp}
{cmd:0b.ind#1b.grp}
{cmd:0b.ind#2.grp}
{cmd:0b.ind#3.grp}
{cmd:1.ind#1b.grp}
{cmd:1.ind#2.grp}
{cmd:1.ind#3.grp}

{pstd}
and the expansion of

{phang2}
{cmd:i.grp i.ind#i3.grp}

{pstd}
is

{phang2}
{cmd:1b.grp}
{cmd:2.grp}
{cmd:3.grp}
{cmd:0b.ind#3.grp}
{cmd:1.ind#3.grp}
{p_end}
