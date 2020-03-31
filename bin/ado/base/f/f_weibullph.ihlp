{* *! version 1.0.1  02mar2015}{...}
    {cmd:weibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative Weibull (proportional hazards) distribution with shape {it:a} and
scale {it:b}{p_end}

{p2col:}{cmd:weibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} =
{cmd:weibullph(}{it:a}{cmd:,}{it:b}{cmd:,0,}{it:x}{cmd:)},
where {it:a} is the shape, {it:b} is the scale, and {it:x} is the value of the
Weibull random variable.{p_end}
{p2col: Domain {it:a}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:x}:}1e-323 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}

    {cmd:weibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative Weibull (proportional hazards) distribution with shape {it:a},
scale {it:b}, and location {it:g}{p_end}
{p2col: Domain {it:a}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:g}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is {it:x} {ul:>} {it:g}{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
