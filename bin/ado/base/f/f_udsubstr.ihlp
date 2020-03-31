{* *! version 1.0.2  12mar2015}{...}
    {cmd:udsubstr(}{it:s}{cmd:,}{it:n1}{cmd:,}{it:n2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Unicode substring of {it:s}, starting at 
	character {it:n1}, for {it:n2} display columns{p_end}

{p2col:}If {it:n2} = {cmd:.} ({it:missing}), the remaining portion of the
	Unicode string is returned.  If {it:n2}
	{mansection U 12.4.2.2DisplayingUnicodecharacters:display columns}
	from {it:n1} is in the middle of a Unicode character, the substring
	stops at the previous Unicode character.{p_end}

{p2col:}{cmd:udsubstr("médiane",2,3)} = {cmd:"édi"}{break}
        {cmd:udsubstr("中值",1,1)} = {cmd:""}{break}
	{cmd:udsubstr("中值",1,2)} = {cmd:"中"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:n1}:}integers {ul:>} 1{p_end}
{p2col: Domain {it:n2}:}integers {ul:>} 1{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
