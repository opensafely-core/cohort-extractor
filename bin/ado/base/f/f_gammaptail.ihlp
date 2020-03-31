{* *! version 1.1.2  27mar2017}{...}
    {cmd:gammaptail(}{it:a}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative (upper tail or survivor)
	gamma distribution with shape parameter {it:a};
	{cmd:1} if {it:x} < 0{p_end}

{p2col:}{cmd:gammaptail()} is also known as the complement to the
	incomplete gamma function (ratio).{p_end}
{p2col: Domain {it:a}:}1e-10 to 1e+17{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is
	{it:x} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
