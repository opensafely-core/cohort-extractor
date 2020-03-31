{* *! version 1.1.2  02mar2015}{...}
    {cmd:recode(}{it:x}{cmd:,}{it:x1}{cmd:,}{it:x2}{cmd:,}{it:...}{cmd:,}{it:xn}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:missing} if {it:x1}, {it:x2}, ..., {it:xn} is 
	not weakly increasing; {it:x} if {it:x} is missing; {it:x1} if
	{it:x} {ul:<} {it:x1}; {it:x2} if 
        {it:x} {ul:<} {it:x2}, ...; otherwise, {it:xn} if
        {it:x} > {it:x1}, {it:x2}, ..., {it:xn-1}.
	{it:xi} {ul:>} {cmd:.} is interpreted as {it:xi} = +inf{p_end}

{p2col:}Also see {helpb autocode()} and {helpb irecode()} for other
	styles of recode functions.{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Domain {it:x1}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:x2}:}{it:x1} to 8e+307{p_end}
{p2col: ...}{p_end}
{p2col: Domain {it:xn}:}{it:xn-1} to 8e+307{p_end}
{p2col: Range:}{it:x1}, {it:x2}, ..., {it:xn} or {it:missing}{p_end}
{p2colreset}{...}
