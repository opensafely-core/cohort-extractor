{* *! version 1.2.1  02mar2015}{...}
    {cmd:lnnormalden(}{it:z}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the natural logarithm of the standard normal density{p_end}
{p2col: Domain:}-1e+154 to 1e+154{p_end}
{p2col: Range:}-5e+307 to -0.91893853 = {cmd:lnnormalden(0)}{p_end}
{p2colreset}{...}

    {cmd:lnnormalden(}{it:x}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the natural logarithm
	of the normal density with mean 0 and standard deviation
	{it:s}{p_end}

{p2col:}{cmd:lnnormalden(}{it:x}{cmd:,1)} =
        {cmd:lnnormalden(}{it:x}{cmd:)} and{break}
	{cmd:lnnormalden(}{it:x}{cmd:,}{it:s}{cmd:)} =
        {cmd:lnnormalden(}{it:x/s}{cmd:)} - ln({it:s}){p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:s}:}1e-323 to 8e+307{p_end}
{p2col: Range:}-5e+307 to 742.82799{p_end}
{p2colreset}{...}

    {cmd:lnnormalden(}{it:x}{cmd:,}{it:m}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the natural logarithm of the normal density with mean
	{it:m} and standard deviation {it:s}{p_end}

{p2col:}{cmd:lnnormalden(}{it:x}{cmd:,0,}{it:s}{cmd:)} =
	{cmd:lnnormalden(}{it:x}{cmd:,}{it:s}{cmd:)}
     and {cmd:lnnormalden(}{it:x}{cmd:,}{it:m}{cmd:,}{it:s}{cmd:)} =
	{cmd:lnnormalden(}({it:x}-{it:m})/{it:s}{cmd:) -}
	ln({it:s}){p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:m}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:s}:}1e-323 to 8e+307{p_end}
{p2col: Range:}1e-323 to 8e+307{p_end}
{p2colreset}{...}
