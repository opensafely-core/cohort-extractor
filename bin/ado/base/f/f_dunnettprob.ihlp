{* *! version 1.1.1  02mar2015}{...}
    {cmd:dunnettprob(}{it:k}{cmd:,}{it:df}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative multiple range distribution 
	that is used in Dunnett's multiple-comparison method with {it:k} 
	ranges and {it:df} degrees of freedom; {cmd:0} if {it:x} < 0{p_end}

{p2col:}{cmd:dunnettprob()} is computed using an algorithm
		 described in {help density_functions##M1981:Miller (1981)}.
		 {p_end}
{p2col: Domain {it:k}:}2 to 1e+6{p_end}
{p2col: Domain {it:df}:}2 to 1e+6{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is
	{it:x} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
