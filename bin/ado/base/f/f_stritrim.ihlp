{* *! version 1.0.0  02mar2015}{...}
    {cmd:stritrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s} with multiple, consecutive internal
	blanks (ASCII space character {cmd:char(32)}) collapsed to one
	blank{p_end}

{p2col:}{cmd:stritrim("hello}{space 5}{cmd:there")} = {cmd:"hello there"}
{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings with no multiple, consecutive internal blanks{p_end}
{p2colreset}{...}
