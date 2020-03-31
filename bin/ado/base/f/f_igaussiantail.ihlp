{* *! version 1.0.0  16may2016}{...}
    {cmd:igaussiantail(}{it:m}{cmd:,}{it:a}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative (upper tail or survivor) inverse
Gaussian distribution with mean {it:m} and shape parameter {it:a}; {cmd:1} if
x {ul:<} 0{p_end}

{p2col:}{cmd:igaussiantail(}{it:m}{cmd:,}{it:a}{cmd:,}{it:x}{cmd:)} = 1 - 
{cmd:igaussian(}{it:m}{cmd:,}{it:a}{cmd:,}{it:x}{cmd:)}{p_end}
{p2col: Domain {it:m}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:a}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
