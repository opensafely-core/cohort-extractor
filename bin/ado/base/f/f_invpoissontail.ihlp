{* *! version 1.1.1  02mar2015}{...}
    {cmd:invpoissontail(}{it:k}{cmd:,}{it:q}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Poisson mean such that the 
	reverse cumulative Poisson distribution evaluated at {it:k} is 
	{it:q}: if {cmd:poissontail(}{it:m}{cmd:,}k{cmd:)} = {it:q}, then
	{cmd:invpoissontail(}{it:k}{cmd:,}{it:q}{cmd:)} = {it:m}{p_end}

{p2col:}The inverse of the reverse cumulative Poisson distribution 
	function is evaluated using {helpb invgammap()}.{p_end}
{p2col: Domain {it:k}:}0 to 2^53-1{p_end}
{p2col: Domain {it:q}:}0 to 1 (exclusive){p_end}
{p2col: Range:}0 to 2^53 (left exclusive){p_end}
{p2colreset}{...}
