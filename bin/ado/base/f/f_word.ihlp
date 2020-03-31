{* *! version 1.1.2  02mar2015}{...}
    {cmd:word(}{it:s}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:n}th word in {it:s}; {it:missing} ({cmd:""}) if
        {it:n} is missing{p_end}

{p2col:}Positive numbers count words from the beginning of {it:s}, and
	negative numbers count words from the end of {it:s}.  ({cmd:1} is the
	first word in {it:s}, and {cmd:-1} is the last word in {it:s}.)
	A word is a set
	of characters that start and terminate with spaces.  This is different
	from a Unicode word, which is a language unit based on either a set of
	{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules} 
	or dictionaries for several languages (Chinese, Japanese, and Thai).{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Domain {it:n}:}integers{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
