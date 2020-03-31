{* *! version 1.0.1  02mar2015}{...}
    {cmd:invweibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse cumulative Weibull (proportional hazards) distribution with shape
{it:a} and scale {it:b}: if {cmd:weibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:x}{cmd:)} = {it:p}, then
{cmd:invweibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:p}{cmd:)} = {it:x}{p_end}
{p2col: Domain {it:a}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}1e-323 to 8e+307{p_end}
{p2colreset}{...}

    {cmd:invweibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse cumulative Weibull (proportional hazards) distribution with
shape {it:a}, scale {it:b}, and location {it:g}: if
{cmd:weibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:x}{cmd:)} = {it:p}, then
{cmd:invweibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:p}{cmd:)} = {it:x}{p_end}
{p2col: Domain {it:a}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:g}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}{it:g}+{cmd:c(epsdouble)} to 8e+307{p_end}
{p2colreset}{...}
