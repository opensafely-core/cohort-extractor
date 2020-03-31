{* *! version 1.1.2  05mar2015}{...}
    {cmd:irecode(}{it:x}{cmd:,}{it:x1}{cmd:,}{it:x2}{cmd:,}{it:...}{cmd:,}{it:xn}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:missing} if {it:x} is missing or
	{it:x1},...,{it:xn} is not weakly increasing;
	{cmd:0} if {it:x} {ul:<} {it:x1};
	{cmd:1} if {it:x1} < {it:x} {ul:<} {it:x2};
	{cmd:2} if {it:x2} < {it:x} {ul:<} {it:x3}; ...;
	{it:n} if {it:x} > {it:xn}{p_end}

{p2col:}Also see {helpb autocode()} and {helpb recode()} for
	other styles of recode functions.{p_end}

{p2col:}{cmd:irecode(3, -10, -5, -3, -3, 0, 15, .)} = {cmd:5}{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:xi}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}nonnegative integers{p_end}
{p2colreset}{...}
