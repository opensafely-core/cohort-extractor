{* *! version 1.0.0  23jan2019}{...}
{phang}
{opt nodots} and {opt dots(#)} specify whether to display replication
dots.  By default, one dot character is displayed for each successful
replication.  A red `x' is displayed if {it:command} returns an error or
if any value in {it:exp_list} is missing.  You can also control whether dots
are displayed using {helpb set dots}.

{phang2}
{opt nodots} suppresses display of the replication dots.

{phang2}
{opt dots(#)} displays dots every {it:#} replications.
{cmd:dots(0)} is a synonym for {cmd:nodots}.
{p_end}
