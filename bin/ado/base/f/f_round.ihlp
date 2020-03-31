{* *! version 1.1.3  21mar2018}{...}
    {cmd:round(}{it:x}{cmd:,}{it:y}{cmd:)} or {cmd:round(}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:x} rounded in units of {it:y} or {it:x}
        rounded to the nearest integer if the argument {it:y} is omitted;
	{it:x} (not "{cmd:.}") if {it:x} is missing (meaning that
	{cmd:round(.a)} = {cmd:.a} and that
	{cmd:round(.a,}{it:y}{cmd:)} = {cmd:.a} if {it:y} is not missing)
	and if {it:y} is missing, then "{cmd:.}" is returned{p_end}

{p2col:}For {it:y} = 1, or with {it:y} omitted, this amounts to the
	closest integer to {it:x}; {cmd:round(5.2,1)} is 5, as is
	{cmd:round(4.8,1)}; {cmd:round(-5.2,1)} is -5, as is
	{cmd:round(-4.8,1)}.  The rounding definition is generalized for
	{it:y} != 1.  With {it:y} = 0.01, for instance, {it:x} is rounded to
	two decimal places; {cmd:round(sqrt(2),.01)} is 1.41. {it:y} may also
	be larger than 1; {cmd:round(28,5)} is 30, which is 28 rounded to the
	closest multiple of 5.  For {it:y} = 0, the function is defined as
	returning {it:x} unmodified.  Also see
	{help int():{bf:int(}{it:x}{bf:)}},
        {help ceil():{bf:ceil(}{it:x}{bf:)}}, and
	{help floor():{bf:floor(}{it:x}{bf:)}}.{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:y}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}
