{* *! version 1.1.1  02mar2015}{...}
    {cmd:invFtail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse reverse cumulative (upper tail or survivor)
	F distribution: if
	{cmd:Ftail(}{it:df1}{cmd:,}{it:df2}{cmd:,}f{cmd:)} = {it:p}, then
	{cmd:invFtail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:p}{cmd:)} = f{p_end}
{p2col: Domain {it:df1}:}2e-10 to 2e+17 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}2e-10 to 2e+17 (may be nonintegral){p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
