{* *! version 1.2.0  02mar2015}{...}
    {cmd:strtrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s} without leading and trailing blanks (ASCII space character
        {bf:char(32)}); equivalent to {cmd:strltrim(strrtrim(}{it:s}{cmd:))}{p_end}

{p2col:}{cmd:strtrim(" this ")} = {cmd:"this"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings without leading or trailing blanks{p_end}
{p2colreset}{...}
