{* *! version 1.1.1  02mar2015}{...}
    {cmd:cholesky(}{it:M}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Cholesky decomposition of the matrix:{break}
             if {it:R} = {cmd:cholesky(}{it:S}{cmd:)}, then 
	     {it:RR}^T = {it:S}{p_end}

{p2col:}{it:R}^T indicates the transpose of {it:R}.{break}
	     Row and column names are obtained from {it:M}.{p_end}
{p2col: Domain:}{it:n} x {it:n}, positive-definite, symmetric matrices{p_end}
{p2col: Range:}{it:n} x {it:n} lower-triangular matrices{p_end}
{p2colreset}{...}
