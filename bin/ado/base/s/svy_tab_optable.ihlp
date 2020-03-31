{* *! version 1.0.8  01mar2017}{...}
{marker svy_options}{...}
{synopthdr:svy_options}
{synoptline}
{syntab:if/in}
{synopt :{opt sub:pop}{cmd:(}[{varname}] [{it:{help if}}]{cmd:)}}identify a subpopulation{p_end}

{syntab:SE}
{synopt :{it:{help bootstrap_options}}}more
	options allowed with bootstrap variance estimation{p_end}
{synopt :{it:{help brr_options}}}more
	options allowed with BRR variance estimation{p_end}
{synopt :{it:{help jackknife_options}}}more
	options allowed with jackknife variance estimation{p_end}
{synopt :{it:{help sdr_options}}}more
	options allowed with SDR variance estimation{p_end}
{synoptline}
{p 4 6 2}
{cmd:svy} requires that the survey design variables be identified using
{cmd:svyset}; see {manhelp svyset SVY}.
{p_end}
{p 4 6 2}
See {manhelp svy_postestimation SVY:svy postestimation} for features available
after estimation. {p_end}
{p 4 6 2}
Warning:  Using {cmd:if} or {cmd:in} restrictions will often not produce correct
variance estimates for subpopulations.  To compute estimates
for subpopulations, use the {cmd:subpop()} option.
{p_end}
