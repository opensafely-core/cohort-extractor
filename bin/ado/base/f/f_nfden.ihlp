{* *! version 1.1.2  27mar2017}{...}
    {cmd:nFden(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the probability density function of the
        noncentral F density with {it:df1} numerator and
	{it:df2} denominator degrees of freedom and noncentrality
	parameter {it:np}; {cmd:0} if {it:f} < 0{p_end}

{p2col:}{cmd:nFden(}{it:df1}{cmd:,}{it:df2}{cmd:,0,}{it:f}{cmd:)} =
         {cmd:Fden(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:)}, but 
	 {helpb Fden()} is the preferred function to use for the central F
	 distribution.{p_end}

{p2col:}Also, if {it:F} follows the noncentral {it:F} distribution
      with {it:df1} and {it:df2} degrees of freedom and noncentrality
      parameter {it:np}, then

                                 {it:df1 F}
		               {hline 11}
		               {it:df2} + {it:df1 F}

{p2col:}follows a noncentral beta distribution with shape parameters
            {it:a}={it:df1}/2, {it:b}={it:df2}/2, and noncentrality parameter
	    {it:np}, as given in {cmd:nbetaden()}.  {cmd:nFden()} is computed
	    based on this relationship.{p_end}
{p2col: Domain {it:df1}:}1e-323 to 8e+307 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}1e-323 to 8e+307 (may be nonintegral){p_end}
{p2col: Domain {it:np}:}0 to 1,000{p_end}
{p2col: Domain {it:f}:}-8e+307 to 8e+307; interesting domain is
	{it:f} {ul:>} 0{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
