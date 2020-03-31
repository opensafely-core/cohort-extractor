{* *! version 1.1.3  12mar2015}{...}
    {cmd:tukeyprob(}{it:k}{cmd:,}{it:df}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative Tukey's Studentized range
	distribution with {it:k} ranges and {it:df} degrees of freedom;
	{cmd:0} if {it:x} < 0{p_end}
	
{p2col:}If {it:df} is a missing value, then the normal distribution is used
	instead of Student's t.{p_end}

{p2col:}{cmd:tukeyprob()} is computed using an algorithm
	 described in {help density_functions##M1981:Miller (1981)}.{p_end}
{p2col: Domain {it:k}:}2 to 1e+6{p_end}
{p2col: Domain {it:df}:}2 to 1e+6{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
