{* *! version 1.2.0  02mar2015}{...}
    {cmd:strrtrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s} without trailing blanks (ASCII space character
        {bf:char(32)}){p_end}

{p2col:}{cmd:strrtrim("this ")} = {cmd:"this"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings without trailing blanks{p_end}
{p2colreset}{...}
