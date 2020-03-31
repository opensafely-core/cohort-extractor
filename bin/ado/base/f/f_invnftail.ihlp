{* *! version 1.1.2  23mar2018}{...}
    {cmd:invnFtail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse reverse cumulative
        (upper tail or survivor) noncentral F distribution: if
	{cmd:nFtail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)} =
	{it:p}, then
	{cmd:invnFtail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)}
	= {it:f}{p_end}
{p2col: Domain {it:df1}:}1e-323 to 8e+307 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}1e-323 to 8e+307 (may be nonintegral){p_end}
{p2col: Domain {it:np}:}0 to 1,000{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
