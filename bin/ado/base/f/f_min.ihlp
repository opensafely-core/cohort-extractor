{* *! version 1.1.2  02mar2015}{...}
    {cmd:min(}{it:x1}{cmd:,}{it:x2}{cmd:,}{it:...}{cmd:,}{it:xn}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the minimum value of {it:x1}, {it:x2}, ...,
        {it:xn}{p_end}
	
{p2col:}Unless all arguments are {it:missing},
	missing values are ignored.{break}
	{cmd:min(2,10,.,7)} = {cmd:2}{break}
	{cmd:min(.,.,.)} = {cmd:.}{p_end}
{p2col: Domain {it:x1}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Domain {it:x2}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col:...}{p_end}
{p2col: Domain {it:xn}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Range:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2colreset}{...}
