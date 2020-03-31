{* *! version 1.1.1  02mar2015}{...}
    {cmd:rnormal()}
{p2colset 8 22 22 2}{...}
{p2col: Description:}standard normal (Gaussian) random variates,
	that is, variates from a normal distribution with a mean of 0 and a 
	standard deviation of 1{p_end}
{p2col: Range:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}

    {cmd:rnormal(}{it:m}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}normal({it:m},1) (Gaussian) random variates,
	where {it:m} is the mean and the standard deviation is 1{p_end}
{p2col: Domain {it:m}:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}
{p2col: Range:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}
{p2colreset}{...}

    {cmd:rnormal(}{it:m}{cmd:,}{it: s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}normal({it:m},{it:s}) (Gaussian) random variates,
	where {it:m} is the mean and {it:s} is the standard deviation{p_end}

{p2col:}The methods for generating normal (Gaussian) random variates
	are taken from {help rnormal()##K1998:Knuth (1998, 122-128)};
	{help rnormal()##MMB1964:Marsaglia, MacLaren, and Bray (1964)};
	and
	{help rnormal()##W1977:Walker (1977)}.{p_end}
{p2col: Domain {it:m}:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}
{p2col: Domain {it:s}:}0 to {cmd:c(maxdouble)}{p_end}
{p2col: Range:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}
{p2colreset}{...}
