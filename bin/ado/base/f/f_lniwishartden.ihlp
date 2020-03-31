{* *! version 1.1.2  11mar2015}{...}
    {cmd:lniwishartden(}{it:df}{cmd:,}{it:V}{cmd:,}{it:X}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the natural logarithm of the density of the inverse
	Wishart distribution; missing if {it:df} <= {it:n}-1{p_end}

{p2col:}{it:df} denotes the degrees of freedom, {it:V} is the scale matrix,
	and {it:X} is the inverse Wishart random matrix.{p_end}
{p2col: Domain {it:df}:}1 to 1e+100 (may be nonintegral){p_end}
{p2col: Domain {it:V}:}{it:n} x {it:n}, positive-definite, symmetric matrices{p_end}
{p2col: Domain {it:X}:}{it:n} x {it:n}, positive-definite, symmetric matrices{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}
