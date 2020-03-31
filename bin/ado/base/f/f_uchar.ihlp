{* *! version 1.0.3  17may2019}{...}
    {cmd:uchar(}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Unicode character corresponding to Unicode code point
	{it:n} or an empty string if {it:n} is beyond the Unicode code-point
	range{p_end}

{p2col:}Note that {cmd:uchar()} takes the decimal value of the Unicode
	{help u_glossary##codep:code point}.  {cmd:ustrunescape()}
	takes an escaped hex digit string of the
	Unicode code point.  For example, both {cmd:uchar(8364)} and
	{cmd:ustrunescape("\u20ac")} produce the Euro sign.{p_end}
{p2col: Domain {it:n}:}integers {ul:>} 0{p_end}
{p2col: Range:}Unicode characters{p_end}
{p2colreset}{...}
