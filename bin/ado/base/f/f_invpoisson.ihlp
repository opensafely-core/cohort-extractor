{* *! version 1.1.1  02mar2015}{...}
    {cmd:invpoisson(}{it:k}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Poisson mean such that the 
	cumulative Poisson distribution evaluated at {it:k} is {it:p}: if
	{cmd:poisson(}{it:m}{cmd:,}k{cmd:)} = {it:p}, then
	{cmd:invpoisson(}{it:k}{cmd:,}{it:p}{cmd:)} = {it:m}{p_end}

{p2col:}The inverse Poisson distribution function is evaluated using 
	{helpb invgammaptail()}.{p_end}
{p2col: Domain {it:k}:}0 to 2^53-1{p_end}
{p2col: Domain {it:p}:}0 to 1 (exclusive){p_end}
{p2col: Range:}1.110e-16 to 2^53{p_end}
{p2colreset}{...}
