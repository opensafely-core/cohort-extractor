{* *! version 1.1.3  17may2019}{...}
    {cmd:strlower(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}lowercase ASCII characters in string {it:s}{p_end}

{p2col:}Unicode characters beyond the
	{help u_glossary##plainascii:plain ASCII} 
	range are ignored.{p_end}

{p2col:}{cmd:strlower("THIS")} = {cmd:"this"}{break}
 	{cmd:strlower("CAFÉ")} = {cmd:"cafÉ"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings with lowercased characters{p_end}
{p2colreset}{...}
