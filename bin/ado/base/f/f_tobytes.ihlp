{* *! version 1.0.1  10mar2015}{...}
    {cmd:tobytes(}{it:s}[{cmd:,}{it:n}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}escaped decimal or hex digit strings of up to 200 
	bytes of {it:s}{p_end}
	
{p2col:}The escaped decimal digit string is in the form of {bf:\dDDD}. The
	escaped hex digit string is in the form of {bf:\xhh}.  If {it:n} is
	not specified or is 0, the decimal form is produced.  Otherwise, the
	hex form is produced.{p_end}

{p2col:}{cmd:tobytes("abc")} = {cmd:"\d097\d098\d099"}{break}
	{cmd:tobytes("abc", 1)} = {cmd:"\x61\x62\x63"}{break}
	{cmd:tobytes("café")} = {cmd:"\d099\d097\d102\d195\d169"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:n}:}integers{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
