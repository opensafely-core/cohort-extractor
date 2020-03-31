{* *! version 1.0.3  08mar2015}{...}
    {cmd:ustrfix(}{it:s}[{cmd:,}{it:rep}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}replaces each invalid UTF-8 sequence with 
	a Unicode character{p_end}
	
{p2col:}In the one-argument case, the Unicode replacement character
	{bf:\ufffd} is used.  In the two-argument case, the first Unicode
	character of {it:rep} is used.  If {it:rep} starts with an invalid
	UTF-8 sequence, then Unicode replacement character {bf:\ufffd} is
	used.  Note that an invalid UTF-8 sequence can contain one byte or
	multiple bytes.{p_end}

{p2col 5 22 26 2:}{cmd:ustrfix(char(200))} = {cmd:ustrunescape("\ufffd")}{p_end}
{p2col 5 22 26 2:}{cmd:ustrfix("ab"+char(200)+"cdé", "")} = {cmd:"abcdé"}{p_end}
{p2col 5 22 26 2:}{cmd:ustrfix("ab"+char(229)+char(174)+"cdé", "é")} = {cmd:"abécdé"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:rep}:}Unicode character{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
