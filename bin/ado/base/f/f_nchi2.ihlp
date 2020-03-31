{* *! version 1.1.1  02mar2015}{...}
    {cmd:nchi2(}{it:df}{cmd:,}{it:np}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative noncentral chi-squared distribution;
	{cmd:0} if {it:x} < 0{p_end}

{p2col:}{it:df} denotes the degrees of freedom, {it:np} is the noncentrality
	parameter, and {it:x} is the value of chi-squared.{p_end}

{p2col:}{cmd:nchi2(}{it:df}{cmd:,0,}{it:x}{cmd:)} = 
         {cmd:chi2(}{it:df}{cmd:,}{it:x}{cmd:)}, but {cmd:chi2()} is the
	 preferred function to use for the central chi-squared distribution.
{p_end}
{p2col: Domain {it:df}:}2e-10 to 1e+6 (may be nonintegral){p_end}
{p2col: Domain {it:np}:}0 to 10,000{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is
	{it:x} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
