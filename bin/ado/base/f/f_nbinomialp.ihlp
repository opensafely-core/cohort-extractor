{* *! version 1.1.1  02mar2015}{...}
    {cmd:nbinomialp(}{it:n}{cmd:,}{it:k}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the negative binomial probability{p_end}

{p2col:}When {it:n} is an integer, {cmd:nbinomialp()} returns the probability 
	of observing exactly {help floor():{bf:floor(}{it:k}{bf:)}} failures
	before the {it:n}th success when the probability of a success on one
	trial is {it:p}.{p_end}
{p2col: Domain {it:n}:}1e-10 to 1e+6 (can be nonintegral){p_end}
{p2col: Domain {it:k}:}0 to 1e+10{p_end}
{p2col: Domain {it:p}:}0 to 1 (left exclusive){p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
