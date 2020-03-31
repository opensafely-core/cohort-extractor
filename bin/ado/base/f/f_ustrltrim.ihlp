{* *! version 1.0.2  13mar2015}{...}
    {cmd:ustrltrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}removes the leading Unicode whitespace characters and 
	blanks from the Unicode string {it:s}{p_end}
	
{p2col:}Note that, in addition to {cmd:char(32)}, ASCII characters
	{cmd:char(9)}, {cmd:char(10)}, {cmd:char(11)}, {cmd:char(12)}, and
	{cmd:char(13)} are whitespace characters in Unicode standard.{p_end}

{p2col:}{cmd:ustrltrim(" this")} = {cmd:"this"}{break}
        {cmd:ustrltrim(char(9)+"this")} = {cmd:"this"}{break}
	{cmd:ustrltrim(ustrunescape("\u1680")+" this")} = {cmd:"this"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
