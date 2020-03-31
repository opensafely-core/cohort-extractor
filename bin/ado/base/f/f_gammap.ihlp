{* *! version 1.1.1  02mar2015}{...}
    {cmd:gammap(}{it:a}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative gamma distribution with shape
           parameter {it:a}; {cmd:0} if {it:x} < 0{p_end}

{p2col:}The cumulative Poisson (the probability of observing {it:k}
	or fewer events if the expected is {it:x}) can be evaluated as 
	{cmd:1-gammap(}{it:k}{cmd:+1,}{it:x}{cmd:)}. The reverse cumulative
	(the probability of observing {it:k} or more events) can be evaluated
	as {cmd:gammap(}{it:k}{cmd:,}{it:x}{cmd:)}. 

{p2col:}{cmd:gammap()} is also known as the incomplete gamma
	function (ratio).{p_end}
     
{p2col:}Probabilities for the three-parameter gamma distribution (see
	{helpb gammaden()}) can be calculated by shifting and scaling {it:x};
	that is, {cmd:gammap(}{it:a}{cmd:,}({it:x} - {it:g})/{it:b}{cmd:)}.
{p_end}
{p2col: Domain {it:a}:}1e-10 to 1e+17{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is
	{it:x} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
