{* *! version 1.1.2  02mar2015}{...}
    {cmd:quarterly(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:Y}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_q} quarterly date (quarters since
           1960q1) corresponding to {it:s1} based on {it:s2} and {it:Y};
           {it:Y} specifies {it:topyear}; see {helpb date()}{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings {cmd:"QY"} and {cmd:"YQ"}; {cmd:Y} may be
           prefixed with {it:##}{p_end}
{p2col: Domain {it:Y}:}integers 1000 to 9998 (but probably 2001 to 2099){p_end}
{p2col: Range:}{cmd:%tq} dates 0100q1 to 9999q4 (integers -7,440 to 32,159)
           or {it:missing}{p_end}
{p2colreset}{...}
