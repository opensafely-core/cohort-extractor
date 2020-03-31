{* *! version 1.0.2  12mar2015}{...}
    {cmd:udstrlen(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the number of display columns needed to display 
	the Unicode string {it:s} in the Stata Results window{p_end}
	
{p2col:}A Unicode character in the CJK (Chinese, Japanese, and Korean)
	encoding usually requires two
	{mansection U 12.4.2.2DisplayingUnicodecharacters:display columns};
	a Latin character usually requires one column.  Any invalid UTF-8
	sequence requires one column.{p_end}

{p2col:}{cmd:udstrlen("中值")} = {cmd:4}{break}
	{cmd:ustrlen("中值")} = {cmd:2}{break}
	{cmd:strlen("中值")} = {cmd:6}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}integers {ul:>} 0{p_end}
{p2colreset}{...}
