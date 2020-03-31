{* *! version 1.0.2  10may2017}{...}
    {cmd:cauchytail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative (upper tail or survivor) Cauchy
distribution with location parameter {it:a} and scale parameter {it:b}{p_end}

{p2col:}{cmd:cauchytail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} = 1 - 
{cmd:cauchy(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)}{p_end}
{p2col: Domain {it:a}:}-1e+300 to 1e+300{p_end}
{p2col: Domain {it:b}:}1e-100 to 1e+300{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
