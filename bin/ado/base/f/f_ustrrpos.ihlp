{* *! version 1.0.0  24mar2015}{...}
    {cmd:ustrrpos(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:n}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the position in {it:s1} at which {it:s2} is
        last found; otherwise, {cmd:0}{p_end}
	
{p2col:}If {it:n} is specified and is greater than 0, only the part between
	the first Unicode character and the {it:n}th Unicode character of
	{it:s1} is searched.  An invalid UTF-8 sequence in either {it:s1} or
	{it:s2} is replaced with a Unicode replacement character {bf:\ufffd}
	before the search is performed.{p_end}

{p2col:}{cmd:ustrrpos("enchanté", "n")} = {cmd:6}{break}
	{cmd:ustrrpos("enchanté", "n", 5)} = {cmd:2}{break}
	{cmd:ustrrpos("enchanté", "n", 6)} = {cmd:6}{break}
        {cmd:ustrrpos("enchanté", "ne")} = {cmd:0}{p_end}
{p2col: Domain {it:s1}:}Unicode strings (to be searched){p_end}
{p2col: Domain {it:s2}:}Unicode strings (to search for){p_end}
{p2col: Domain {it:n}:}integers{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
