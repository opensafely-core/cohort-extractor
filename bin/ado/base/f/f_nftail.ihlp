{* *! version 1.1.1  02mar2015}{...}
    {cmd:nFtail(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative (upper tail or survivor)
        noncentral F distribution with {it:df1} numerator and {it:df2}
	denominator degrees of freedom and noncentrality parameter {it:np};
	{cmd:1} if {it:f} < 0{p_end}

{p2col:}{cmd:nFtail()} is computed using {cmd:nibeta()} based on the
	relationship between the noncentral beta and F distributions.  See
	{help density functions##JKB1995:Johnson, Kotz, and Balakrishnan (1995)}
	for more details.{p_end}
{p2col: Domain {it:df1}:}1e-323 to 8e+307 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}1e-323 to 8e+307 (may be nonintegral){p_end}
{p2col: Domain {it:np}:}0 to 1,000{p_end}
{p2col: Domain {it:f}:}-8e+307 to 8e+307; interesting domain is
	{it:f} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
