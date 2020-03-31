{* *! version 1.1.4  17may2019}{...}
    {cmd:soundex_nara(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the U.S. Census soundex code for a string, {it:s}{p_end}

{p2col:}The soundex code consists of a letter followed by three numbers:
	the letter is the first ASCII letter of the name and the numbers encode
	the remaining consonants.  Similar sounding consonants are encoded
	by the same number.  Unicode characters beyond the
	{help u_glossary##plainascii:plain ASCII} range are
	ignored.{p_end}

{p2col:}{cmd:soundex_nara("Ashcraft")} = {cmd:"A261"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
