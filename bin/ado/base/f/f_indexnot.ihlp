{* *! version 1.1.4  17may2019}{...}
    {cmd:indexnot(}{it:s1}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the position in ASCII string {it:s1} of
	the first character of {it:s1} not found in ASCII string {it:s2}, or
	{cmd:0} if all characters of {it:s1} are found in {it:s2}{p_end}

{p2col:}{cmd:indexnot()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} strings.  For
	Unicode characters beyond the plain ASCII range, the position
	and character are given in {help u_glossary##disambig:bytes},
	not characters.{p_end}
{p2col: Domain {it:s1}:}ASCII strings (to be searched){p_end}
{p2col: Domain {it:s2}:}ASCII strings (to search for){p_end}
{p2col: Range:}integers {ul:>} 0{p_end}
{p2colreset}{...}
