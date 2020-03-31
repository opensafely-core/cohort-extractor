{* *! version 1.1.2  02mar2015}{...}
    {cmd:reldif(}{it:x}{cmd:,}{it:y}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the "relative"
    	                difference  |{it:x}-{it:y}|/(|{it:y}|+1);
		{cmd:0} if both arguments are the same type of extended 
                        missing value;
		{it:missing} if only one argument is missing
                        or if the two arguments are two different types of
			{it:missing}{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Domain {it:y}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Range:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2colreset}{...}
