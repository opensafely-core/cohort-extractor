{smcl}
{* *! version 1.0.2  11feb2011}{...}
{title:Out-of-date commands}

{pstd}
A Stata version 8.2 update to the time-series commands in July of 2004 made
several commands obsolete.  The old commands continue to work, but are now
undocumented.

{pstd}
The table below associates the old commands with their replacements.

{col 9}{hi:obsolete command}{col 35}{hi:replacement}
{col 9}{hline 39}
{col 9}{cmd:varfcast}{col 35}{helpb fcast}
{col 9}{cmd:varfcast compute}{col 35}{helpb fcast compute}
{col 9}{cmd:varfcast graph}{col 35}{helpb fcast graph}
{col 9}{cmd:varirf}{col 35}{helpb irf}
{col 9}{cmd:varirf create}{col 35}{helpb irf create}
{col 9}{cmd:varirf graph}{col 35}{helpb irf graph}
{col 9}{cmd:varirf cgraph}{col 35}{helpb irf cgraph}
{col 9}{cmd:varirf ograph}{col 35}{helpb irf ograph}
{col 9}{cmd:varirf ctable}{col 35}{helpb irf ctable}
{col 9}{cmd:varirf add}{col 35}{helpb irf add}
{col 9}{cmd:varirf describe}{col 35}{helpb irf describe}
{col 9}{cmd:varirf drop}{col 35}{helpb irf drop}
{col 9}{cmd:varirf rename}{col 35}{helpb irf rename}
{col 9}{cmd:varirf set}{col 35}{helpb irf set}
{col 9}{cmd:varirf table}{col 35}{helpb irf table}

{pstd}
The commands {cmd:varfcast clear}, {cmd:varirf dir}, and {cmd:varirf erase}
are obsolete and have no replacements.  The structure of {cmd:fcast} does
not require an equivalent to {cmd:varfcast clear}.  Use {helpb dir} or 
{helpb erase} instead of {cmd:varirf dir} or {cmd:varirf erase}.
{p_end}
