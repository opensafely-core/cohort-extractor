{* *! version 1.1.2  27mar2017}{...}
    {cmd:binomial(}{it:n}{cmd:,}{it:k}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the probability of observing
        {help floor():{bf:floor(}{it:k}{bf:)}} or fewer successes in
	{cmd:floor(}{it:n}{cmd:)} trials when
	the probability of a success on one trial is {it:p};
        {cmd:0} if {it:k} < 0; or {cmd:1} if {it:k} > {it:n}{p_end}
{p2col: Domain {it:n}:}0 to 1e+17{p_end}
{p2col: Domain {it:k}:}-8e+307 to 8e+307; interesting domain is
	0 {ul:<} {it:k} < {it:n}{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
