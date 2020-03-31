{* *! version 1.1.2  02mar2015}{...}
    {cmd:sum(}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the running sum of {it:x}, treating missing values as zero
	{p_end}
	
{p2col:}For example, following the command {cmd:generate y=sum(x)},
	the {it:j}th observation on {cmd:y} contains the sum of the first
	through {it:j}th observations on {cmd:x}.  See {manhelp egen D}
	for an alternative sum function, {helpb egen##total():total()}, that
	produces a constant equal to the overall sum.{p_end}
{p2col: Domain:}all real numbers or {it:missing}{p_end}
{p2col: Range:}-8e+307 to 8e+307 (excluding {it:missing}){p_end}
{p2colreset}{...}
