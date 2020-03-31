{* *! version 1.1.1  02mar2015}{...}
    {cmd:inrange(}{it:z}{cmd:,}{it:a}{cmd:,}{it:b}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:1} if it is known that
        {it:a} {ul:<} {it:z} {ul:<} {it:b}; otherwise, {cmd:0}{p_end}
	
{p2col:}The following ordered rules apply:{break}
	{it:z} {ul:>} {cmd:.} returns {cmd:0}.{break}
	{it:a} {ul:>} {cmd:.} and {it:b} = {cmd:.} returns {cmd:1}.{break}
	{it:a} {ul:>} {cmd:.} returns {cmd:1} if {it:z} {ul:<} {it:b};
	     otherwise, it returns {cmd:0}.{break}
	{it:b} {ul:>} {cmd:.} returns {cmd:1} if {it:a} {ul:<} {it:z};
	     otherwise, it returns {cmd:0}.{break}
        Otherwise, {cmd:1} is returned if {it:a} {ul:<} {it:z} {ul:<} {it:b}.
	      {break}
        If the arguments are strings, "{cmd:.}" is interpreted as
	{cmd:""}.{p_end}
{p2col: Domain:}all reals or all strings{p_end}
{p2col: Range:}0 or 1{p_end}
{p2colreset}{...}
