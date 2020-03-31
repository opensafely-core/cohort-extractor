{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrtoname(}{it:s}[{cmd:,}{it:p}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}string {it:s} translated into a Stata name{p_end}

{p2col:}{cmd:ustrtoname()} results in a name that is truncated to
	{ccl namelenchar} characters.  Each character in {it:s} that
	is not allowed in a Stata name is converted to an underscore
	character, {cmd:_}.  If the first character in {it:s} is a numeric
	character and {it:p} is not 0, then the result is prefixed with an
	underscore.

{p2col:}{cmd:ustrtoname("name",1)} = {cmd:"name"}{break}
		  {cmd:ustrtoname("the médiane")} = {cmd:"the_médiane"}{break}
		  {cmd:ustrtoname("0médiane")} = {cmd:"_0médiane"}{break}
		  {cmd:ustrtoname("0médiane", 1)} = {cmd:"_0médiane"}{break}
		  {cmd:ustrtoname("0médiane", 0)} = {cmd:"0médiane"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:p}:}integers 0 or 1{p_end}
{p2col: Range:}Unicode strings{p_end}
