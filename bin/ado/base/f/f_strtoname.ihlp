{* *! version 1.1.4  12mar2015}{...}
    {cmd:strtoname(}{it:s}[{cmd:,}{it:p}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s} translated into a Stata 13 compatible name{p_end}

{p2col:}{cmd:strtoname()} results in a name that is truncated to
	{ccl namelenchar} bytes.  Each character in {it:s} that is not allowed
	in a Stata name is converted to an underscore character, {cmd:_}.  If
	the first character in {it:s} is a numeric character and {it:p} is not
	0, then the result is prefixed with an underscore.
	Stata 14 names may be 32 characters; see {findalias frnames}.{p_end}

{p2col:}{cmd:strtoname("name")} = {cmd:"name"}{break}
        {cmd:strtoname("a name")} = {cmd:"a_name"}{break}
	{cmd:strtoname("5",1)} = {cmd:"_5"}{break}
	{cmd:strtoname("5:30",1)} = {cmd:"_5_30"}{break}
	{cmd:strtoname("5",0)} = {cmd:"5"}{break}
	{cmd:strtoname("5:30",0)} = {cmd:"5_30"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Domain {it:p}:}integers 0 or 1{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
