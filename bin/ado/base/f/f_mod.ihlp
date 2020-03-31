{* *! version 1.1.1  02mar2015}{...}
    {cmd:mod(}{it:x}{cmd:,}{it:y}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the modulus of {it:x} with respect to {it:y}{break}
        {bind:{cmd:mod(}{it:x}{cmd:,}{it:y}{cmd:)} = {it:x} - {it:y}*{cmd:floor(}{it:x}/{it:y}{cmd:)}}{break}
	{cmd:mod(}{it:x}{cmd:,0)} = {cmd:.}{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:y}:}0 to 8e+307{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
