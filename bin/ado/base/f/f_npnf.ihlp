{* *! version 1.1.1  02mar2015}{...}
    {cmd:npnF(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the noncentrality parameter, {it:np}, for the noncentral F:
	if {cmd:nF(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)} =
	{it:p}, then
	{cmd:npnF(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:,}{it:p}{cmd:)}
	= {it:np}{p_end}
{p2col: Domain {it:df1}:}2e-10 to 1e+6 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}2e-10 to 1e+6 (may be nonintegral){p_end}
{p2col: Domain {it:f}:}0 to 8e+307{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}0 to 10,000{p_end}
{p2colreset}{...}
