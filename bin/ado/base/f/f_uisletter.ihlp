{* *! version 1.0.1  10mar2015}{...}
    {cmd:uisletter(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:1} if the first Unicode character in {it:s} is a
	Unicode letter; otherwise, {cmd:0}{p_end}

{p2col:}A Unicode letter is a Unicode character with the character property
	{bf:L} according to the Unicode standard.  The function returns
	{cmd:-1} if the string starts with an invalid UTF-8 sequence.{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
