{* *! version 1.1.5  17may2019}{...}
    {cmd:abbrev(}{it:s},{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}name {it:s}, abbreviated to a length of {it:n}{p_end}

{p2col:}Length is measured in the number of
	{help u_glossary##disambig:display columns}, not in the number of
	characters.  For most users, the number of display columns equals the
	number of characters.  For a detailed discussion of display columns,
	see {findalias frdiunicode}.{p_end}

{p2col:}If any of the characters of {it:s} are a
	period, "{cmd:.}", and {it:n} < 8, then the value {it:n} defaults to a
	value of 8.  Otherwise, if {it:n} < 5, then {it:n} defaults to a value
	of 5.  If {it:n} is {it:missing}, {cmd:abbrev()} will return the
	entire string {it:s}.  {cmd:abbrev()} is typically used with variable
	names and variable names with factor-variable or time-series operators
	(the period case).{p_end}
	
{p2col:}{cmd:abbrev("displacement",8)} is {cmd:displa~t}.{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Domain {it:n}:}integers 5 to 32{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
