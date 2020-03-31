{* *! version 1.0.1  02mar2015}{...}
    {cmd:exponential(}{it:b}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative exponential distribution with scale {it:b}{p_end}

{p2col:}The cumulative distribution function of the exponential distribution
is 

                                             1 - exp(-{it:x}/{it:b})

{p2col:}for {it:x} {ul:>} 0 and 0 for {it:x} < 0, where {it:b} is the scale
and {it:x} is the value of an exponential variate.{p_end}
{p2col:}The mean of the exponential distribution is {it:b} and its variance
is {it:b}^2.{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is {it:x} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
