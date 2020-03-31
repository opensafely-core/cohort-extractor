{* *! version 1.0.0  02mar2015}{...}
    {cmd:strltrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s} without leading blanks (ASCII space character
{bf:char(32)}){p_end}

{p2col:}{cmd:strltrim(" this")} = {cmd:"this"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings without leading blanks{p_end}
{p2colreset}{...}
