{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrreverse(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}reverses the Unicode string {it:s}{p_end}

{p2col:}The function does not take
	Unicode character equivalence into consideration.  Hence, a Unicode
	character in a decomposed form will not be reversed as one unit.  An
	invalid UTF-8 sequence is replaced with a Unicode replacement
	character {bf:\ufffd}.{p_end}

{p2col:}{cmd:ustrreverse("médiane")} = {cmd:"enaidém"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}reversed Unicode strings{p_end}
{p2colreset}{...}
