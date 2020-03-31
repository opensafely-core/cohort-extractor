{* *! version 1.1.1  02mar2015}{...}
    {cmd:nbinomialtail(}{it:n}{cmd:,}{it:k}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative probability of the
	negative binomial distribution{p_end}
	
{p2col:}When {it:n} is an integer, {cmd:nbinomialtail()} returns the
	probability of observing {it:k} or more failures before the
	{it:n}th success, when the probability of a success on one trial
	is {it:p}.{p_end}

{p2col:}The reverse negative binomial distribution function is 
	evaluated using {helpb ibetatail()}.{p_end}
{p2col: Domain {it:n}:}1e-10 to 1e+17 (can be nonintegral){p_end}
{p2col: Domain {it:k}:}0 to 2^53-1{p_end}
{p2col: Domain {it:p}:}0 to 1 (left exclusive){p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
