{* *! version 1.1.3  05mar2015}{...}
    {cmd:plural(}{it:n}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the plural of {it:s} if {bind:{it:n} != +/-1}{p_end}

{p2col:}The plural is formed by adding "s" to {it:s}.{p_end}

{p2col:}{cmd:plural(1, "horse")} = {cmd:"horse"}{break}
	{cmd:plural(2, "horse")} = {cmd:"horses"}{p_end}
{p2col: Domain {it:n}:}real numbers{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}

    {cmd:plural(}{it:n}{cmd:,}{it:s1}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the plural of {it:s1}, as modified by or replaced with
	{it:s2}, if {bind:{it:n} != +/-1}

{p2col:}If {it:s2} begins with the character "{cmd:+}", the plural is formed
	by adding the remainder of {it:s2} to {it:s1}.  If {it:s2} begins with
	the character "{cmd:-}", the plural is formed by subtracting the
	remainder of {it:s2} from {it:s1}.  If {it:s2} begins with neither
	"{cmd:+}" nor "{cmd:-}", then the plural is formed by returning
	{it:s2}.{p_end}

{p2col:}{cmd:plural(2, "glass", "+es")} = {cmd:"glasses"}{break}
        {cmd:plural(1, "mouse", "mice")} = {cmd:"mouse"}{break}
        {cmd:plural(2, "mouse", "mice")} = {cmd:"mice"}{break}
	{cmd:plural(2, "abcdefg", "-efg")} = {cmd:"abcd"}{p_end}
{p2col: Domain {it:n}:}real numbers{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
