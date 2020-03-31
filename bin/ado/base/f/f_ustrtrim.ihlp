{* *! version 1.0.1  12mar2015}{...}
    {cmd:ustrtrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}removes leading and trailing Unicode whitespace 
	characters and blanks from the Unicode string {it:s}{p_end}

{p2col:}Note that, in addition to {cmd:char(32)}, ASCII characters
	{cmd:char(9)}, {cmd:char(10)}, {cmd:char(11)}, {cmd:char(12)}, and
	{cmd:char(13)} are considered whitespace characters in the Unicode
	standard.{p_end}

{p2col:}{cmd:ustrtrim(" this ")} = {cmd:"this"}{break}
        {cmd:ustrtrim(char(11)+" this ")+char(13)} = {cmd:"this"}{break}
	{cmd:ustrtrim(" this "+ustrunescape("\u2000"))} = {cmd:"this"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
