{* *! version 1.1.1  02mar2015}{...}
    {cmd:rhypergeometric(}{it:N}{cmd:,}{it: K}{cmd:,}{it: n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}hypergeometric random variates{p_end}

{p2col:}The distribution parameters are integer valued, where 
	{it:N} is the population size, {it:K} is the 
	number of elements in the population that have the attribute of
	interest, and {it:n} is the sample size.  

{p2col:}Besides using the standard methodology for generating random 
	variates from a given distribution, {cmd:rhypergeometric()} uses 
	the specialized algorithms of 
        {help rhypergeometric()##K1982:Kachitvichyanukul (1982)} and 
	{help rhypergeometric()##KS1985:Kachitvichyanukul and Schmeiser (1985)}.
	{p_end}
{p2col: Domain {it:N}:}2 to 1e+6{p_end}
{p2col: Domain {it:K}:}1 to {it:N-1}{p_end}
{p2col: Domain {it:n}:}1 to {it:N-1}{p_end}
{p2col: Range:}{cmd:max(}0{cmd:,}{it:n-N+K}{cmd:)} to 
	{cmd:min(}{it:K,n}{cmd:)}{p_end}
{p2colreset}{...}
