{* *! version 1.1.1  02mar2015}{...}
    {cmd:chop(}{it:x}{cmd:,}{it:tol}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:round(}{it:x}{cmd:)} if
        {cmd:abs(}{it:x}{cmd:-round(}{it:x}{cmd:))} < {it:tol}; otherwise,
        {it:x}; or {it:x} if {it:x} is missing{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:tol}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}
