{* *! version 1.1.1  02mar2015}{...}
    {cmd:Ftail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative (upper tail or survivor)
	F distribution with {it:df1} numerator and {it:df2} denominator
	degrees of freedom; {cmd:1} if {it:f} < 0{p_end}

{p2col:}{cmd:Ftail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:)} =
	1 - {cmd:F(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:)}{p_end}
{p2col: Domain {it:df1}:}2e-10 to 2e+17 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}2e-10 to 2e+17 (may be nonintegral){p_end}
{p2col: Domain {it:f}:}-8e+307 to 8e+307; interesting domain is
	{it:f} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
