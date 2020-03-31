{* *! version 1.1.1  02mar2015}{...}
    {cmd:rnbinomial(}{it:n}{cmd:,}{it: p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}negative binomial random variates{p_end}

{p2col:}If {it:n} is integer valued, {cmd:rnbinomial()} returns the number 
	of failures before the {it:n}th success, 
	where the probability of success on a single trial is {it:p}. 
	{it:n} can also be nonintegral.{p_end}
{p2col: Domain {it:n}:}1e-4 to 1e+5{p_end}
{p2col: Domain {it:p}:}1e-4 to 1-1e-4{p_end}
{p2col: Range:}0 to 2^53-1{p_end}
{p2colreset}{...}
