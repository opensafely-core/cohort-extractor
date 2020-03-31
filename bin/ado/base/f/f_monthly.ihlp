{* *! version 1.1.2  02mar2015}{...}
    {cmd:monthly(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:Y}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_m} monthly date (months since
           1960m1) corresponding to {it:s1} based on {it:s2} and {it:Y};
           {it:Y} specifies {it:topyear}; see {helpb date()}{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings {cmd:"MY"} and {cmd:"YM"}; {cmd:Y} may be
           prefixed with {it:##}{p_end}
{p2col: Domain {it:Y}:}integers 1000 to 9998 (but probably 2001 to 2099){p_end}
{p2col: Range:}{cmd:%tm} dates 0100m1 to 9999m12 (integers -22,320 to 96,479)
           or {it:missing}{p_end}
{p2colreset}{...}
