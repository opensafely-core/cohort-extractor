{* *! version 1.1.2  27mar2017}{...}
    {cmd:invsym(}{it:M}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse of {it:M} if {it:M} is positive definite
{p_end}

{p2col:}If {it:M} is not positive definite, rows will be inverted until the
	diagonal terms are zero or negative; the rows and columns corresponding
	to these terms will be set to 0, producing a g2 inverse.  The row names
	of the result are obtained from the column names of {it:M}, and the
	column names of the result are obtained from the row names of {it:M}.
	{p_end}
{p2col: Domain:}{it:n} x {it:n} symmetric matrices{p_end}
{p2col: Range:}{it:n} x {it:n} symmetric matrices{p_end}
{p2colreset}{...}
