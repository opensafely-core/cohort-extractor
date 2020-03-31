{* *! version 1.2.2  17may2019}{...}
    {cmd:strupper(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}uppercase ASCII characters in string {it:s}{p_end}

{p2col:}Unicode characters beyond the 
	{help u_glossary##plainascii:plain ASCII} range are ignored.{p_end}

{p2col:}{cmd:strupper("this")} = {cmd:"THIS"}{break}
	{cmd:strupper("café")} = {cmd:"CAFé"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings with uppercased characters{p_end}
{p2colreset}{...}
