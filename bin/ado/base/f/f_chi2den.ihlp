{* *! version 1.1.1  02mar2015}{...}
    {cmd:chi2den(}{it:df}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the probability density of the
	chi-squared distribution with {it:df} degrees of freedom;
	{cmd:0} if {it:x} < 0{break}
	{cmd:chi2den(}{it:df}{cmd:,}{it:x}{cmd:)} =
        {help gammaden():{bf:gammaden(}{it:df}/2{bf:,}2{bf:,}0{bf:,}{it:x}{bf:)}}{p_end}
{p2col: Domain {it:df}:}2e-10 to 2e+17 (may be nonintegral){p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
