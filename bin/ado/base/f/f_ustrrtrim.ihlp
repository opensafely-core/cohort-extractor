{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrrtrim(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}remove trailing Unicode whitespace characters and blanks 
	from the Unicode string {it:s}{p_end}
	
{p2col:}Note that, in addition to {cmd:char(32)},  ASCII characters 
	{bf:char(9)}, {bf:char(10)}, {bf:char(11)}, {bf:char(12)}, and 
	{bf:char(13)} are considered whitespace characters in the 
	Unicode standard.{p_end}

{p2col:}{cmd:ustrrtrim("this ")} = {cmd:"this"}{break}
        {cmd:ustrltrim("this"+char(10))} = {cmd:"this"}{break}		     
	{cmd:ustrrtrim("this "+ustrunescape("\u2000"))} = {cmd:"this"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}

