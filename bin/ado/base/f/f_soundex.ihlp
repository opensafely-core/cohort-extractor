{* *! version 1.1.4  17may2019}{...}
    {cmd:soundex(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the soundex code for a string, {it:s}{p_end}

{p2col:}The soundex code consists of a letter followed by three numbers:
	the letter is the first ASCII letter of the name and the numbers encode
	the remaining consonants.  Similar sounding consonants are encoded
	by the same number.  Unicode characters beyond the
	{help u_glossary##plainascii:plain ASCII} range are
	ignored.{p_end}

{p2col:}{cmd:soundex("Ashcraft")} = {cmd:"A226"}{break}
        {cmd:soundex("Robert")} = {cmd:"R163"}{break}
        {cmd:soundex("Rupert")} = {cmd:"R163"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
