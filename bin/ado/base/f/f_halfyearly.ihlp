{* *! version 1.1.2  02mar2015}{...}
    {cmd:halfyearly(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:Y}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_h} half-yearly date (half-years since
           1960h1) corresponding to {it:s1} based on {it:s2} and {it:Y};
           {it:Y} specifies {it:topyear}; see {helpb date()}{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings {cmd:"HY"} and {cmd:"YH"}; {cmd:Y} may be
           prefixed with {it:##}{p_end}
{p2col: Domain {it:Y}:}integers 1000 to 9998 (but probably 2001 to 2099){p_end}
{p2col: Range:}{cmd:%th} dates 0100h1 to 9999h2 (integers -3,720 to 16,079)
           or {it:missing}{p_end}
{p2colreset}{...}
