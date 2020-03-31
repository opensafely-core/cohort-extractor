{* *! version 1.1.2  02mar2015}{...}
    {cmd:logit(}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the log of the odds ratio of {it:x},{break}
	{cmd:logit(}{it:x}{cmd:)} = ln{c -(}{it:x}/(1-{it:x}){c )-}{p_end}
{p2col: Domain:}0 to 1 (exclusive){p_end}
{p2col: Range:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2colreset}{...}
