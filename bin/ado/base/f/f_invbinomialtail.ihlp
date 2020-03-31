{* *! version 1.1.2  02mar2015}{...}
    {cmd:invbinomialtail(}{it:n}{cmd:,}{it:k}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse of the right cumulative binomial;
        that is, the probability of success on one trial such that the
	probability of observing {help floor():{bf:floor(}{it:k}{bf:)}} or
	more successes in {cmd:floor(}{it:n}{cmd:)} trials is {it:p}{p_end}
{p2col: Domain {it:n}:}1 to 1e+17{p_end}
{p2col: Domain {it:k}:}1 to {it:n}{p_end}
{p2col: Domain {it:p}:}0 to 1 (exclusive){p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
