{smcl}
{* *! version 1.0.1  11feb2011}{...}
{title:Out-of-date commands}

{pstd}
{cmd:bstrap},
{cmd:simul},
{cmd:spikeplt},
{cmd:stcurv},
{cmd:svyintrg},
{cmd:svymlog},
{cmd:svyolog},
{cmd:svyoprob},
{cmd:svypois},
{cmd:svyprobt},
{cmd:svyreg},
{cmd:xtclog}, and
{cmd:xtpois}
have been renamed to take advantage of the longer names
allowed in Stata version 7 (and later).  The old command names continue to
work.

	Old Name        New Name
	{hline 8}        {hline 12}
	{cmd:bstrap}          {helpb bootstrap}
	{cmd:simul}           {helpb simulate}
	{cmd:spikeplt}        {helpb spikeplot}
	{cmd:stcurv}          {helpb stcurve}
	{cmd:svyintrg}        {cmd:svy:} {helpb intreg}
	{cmd:svymlog}         {cmd:svy:} {helpb mlogit}
	{cmd:svyolog}         {cmd:svy:} {helpb ologit}
	{cmd:svyoprob}        {cmd:svy:} {helpb oprobit}
	{cmd:svypois}         {cmd:svy:} {helpb poisson}
	{cmd:svyprobt}        {cmd:svy:} {helpb probit}
	{cmd:svyreg}          {cmd:svy:} {helpb regress}
	{cmd:xtclog}          {helpb xtcloglog}
	{cmd:xtpois}          {helpb xtpoisson}

{pstd}
See the help for the new commands listed above.
{p_end}
