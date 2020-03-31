{* *! version 1.1.2  02mar2015}{...}
    {cmd:nF(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the cumulative noncentral F distribution with
        {it:df1} numerator and {it:df2} denominator degrees of freedom and
        noncentrality parameter {it:np}; {cmd:0} if {it:f} < 0{p_end}

{p2col:}{cmd:nF(}{it:df1}{cmd:,}{it:df2}{cmd:,0,}{it:f}{cmd:)} =
        {cmd:F(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:f}{cmd:)}{p_end}

{p2col:}{cmd:nF()} is computed using {helpb nibeta()} based on the
	relationship between the noncentral beta and noncentral
	F distributions: {p_end}
{p2col:}{cmd:nF(}{it:df1}{cmd:,}{it:df2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)}
	={break}
	{cmd:nibeta(}{it:df1}/2{cmd:,} {it:df2}/2{cmd:,} {it:np}{cmd:,} {it:df1}*{it:f}/{({it:df1}*{it:f})+{it:df2}}}{cmd:)}.
{p_end}
{* spaces added in nibeta() to help separate groups}
{p2col: Domain {it:df1}:}2e-10 to 1e+8 (may be nonintegral){p_end}
{p2col: Domain {it:df2}:}2e-10 to 1e+8 (may be nonintegral){p_end}
{p2col: Domain {it:np}:}0 to 10,000{p_end}
{p2col: Domain {it:f}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
