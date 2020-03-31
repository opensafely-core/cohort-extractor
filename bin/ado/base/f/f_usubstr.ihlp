{* *! version 1.0.2  12mar2015}{...}
    {cmd:usubstr(}{it:s}{cmd:,}{it:n1}{cmd:,}{it:n2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Unicode substring of {it:s}, starting at 
	{it:n1}, for a length of {it:n2}{p_end}
	
{p2col:}If {it:n1} < 0, {it:n1} is interpreted as the distance
	from the last character of the {it:s};
	if {it:n2} = {cmd:.} ({it:missing}),
	the remaining portion of the Unicode string is returned.{p_end}
	
{p2col:}{cmd:usubstr("médiane",2,3)} = {cmd:"édi"}{break}
        {cmd:usubstr("médiane",-3,2)} = {cmd:"an"}{break}
	{cmd:usubstr("médiane",2,.)} = {cmd:"édiane"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:n1}:}integers {ul:>} 1 and {ul:<} -1{p_end}
{p2col: Domain {it:n2}:}integers {ul:>} 1{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
