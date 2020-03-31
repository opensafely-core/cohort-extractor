{* *! version 1.1.1  02mar2015}{...}
    {cmd:inv(}{it:M}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse of the matrix {it:M}{p_end}

{p2col:}If {it:M} is singular, this will result in an error.{p_end}

{p2col:}The function {helpb invsym()} should be used in preference
to {cmd:inv()} because {cmd:invsym()} is more accurate.  The row names of the
result are obtained from the column names of {it:M}, and the column names of
the result are obtained from the row names of {it:M}.{p_end}
{p2col: Domain:}{it:n} x {it:n} nonsingular matrices{p_end}
{p2col: Range:}{it:n} x {it:n} matrices{p_end}
{p2colreset}{...}
