{* *! version 1.1.1  02mar2015}{...}
    {cmd:lnfactorial(}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the natural log of {it:n} factorial = ln({it:n}!){p_end}

{p2col:}To calculate {it:n}!, use
	{bind:{cmd:round(exp(lnfactorial(}{it:n}{cmd:)),1)}} to ensure that
	the result is an integer.  Logs of factorials are generally more
	useful than the factorials themselves because of overflow problems.
	{p_end}
{p2col: Domain:}integers 0 to 1e+305{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
