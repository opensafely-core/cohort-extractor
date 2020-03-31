{* *! version 1.1.2  02mar2015}{...}
    {cmd:week(}{it:e_d}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the numeric week of the year corresponding to date
           {it:e_d}, the {cmd:%td} encoded date (days since 01jan1960){p_end}

{p2col:}Note: The first week of a year is the first 7-day period
           of the year.{p_end}
{p2col: Domain {it:e_d}:}{cmd:%td} dates 01jan0100 to 31dec9999
           (integers -679,350 to 2,936,549){p_end}
{p2col: Range:}integers 1 to 52 or {it:missing}{p_end}
{p2colreset}{...}
