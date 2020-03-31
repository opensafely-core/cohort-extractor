{* *! version 1.1.1  02mar2015}{...}
    {cmd:rgamma(}{it:a}{cmd:, }{it:b}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}gamma({it:a},{it:b}) random variates, where {it:a} 
	is the gamma shape parameter and {it:b} is the scale parameter{p_end}

{p2col:}Methods for generating gamma variates are taken from 
	{help rgamma()##AD1974:Ahrens and Dieter (1974)},
        {help rgamma()##B1983:Best (1983)}, and
        {help rgamma()##SL1980:Schmeiser and Lal (1980)}.{p_end}
{p2col: Domain {it:a}:}1e-4 to 1e+8{p_end}
{p2col: Domain {it:b}:}{cmd:c(smallestdouble)} to {cmd:c(maxdouble)}{p_end}
{p2col: Range:}0 to {cmd:c(maxdouble)}{p_end}
{p2colreset}{...}
