{* *! version 1.0.1  02mar2015}{...}
    {cmd:runiformint(}{it:a}{cmd:,}{it:b}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}uniformly distributed random integer variates on the
                     interval [{it:a},{it:b}]{p_end}

{p2col:}If {it:a} or {it:b} is nonintegral,
           {cmd:runiformint(}{it:a}{cmd:,}{it:b}{cmd:)} returns
	   {cmd:runiformint(floor(}{it:a}{cmd:), floor(}{it:b}{cmd:))}.{p_end}
{p2col: Domain {it:a}:}-2^53 to 2^53 (may be nonintegral){p_end}
{p2col: Domain {it:b}:}-2^53 to 2^53 (may be nonintegral){p_end}
{p2col: Range:}-2^53 to 2^53{p_end}
{p2colreset}{...}
