{* *! version 1.1.1  02mar2015}{...}
    {cmd:rbinomial(}{it:n}{cmd:,}{it: p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}binomial({it:n},{it:p}) random variates, where
	{it:n} is the number of trials and {it:p} is the success
	probability{p_end}

{p2col:}Besides using the standard methodology for generating random 
	variates from a given distribution, {cmd:rbinomial()} uses the 
	specialized algorithms of 
        {help rbinomial()##K1982:Kachitvichyanukul (1982)},
	{help rbinomial()##KS1988:Kachitvichyanukul and Schmeiser (1988)},
        and {help rbinomial()##K1986:Kemp (1986)}.{p_end}
{p2col: Domain {it:n}:}1 to 1e+11{p_end}
{p2col: Domain {it:p}:}1e-8 to 1-1e-8{p_end}
{p2col: Range:}0 to {it:n}{p_end}
{p2colreset}{...}
