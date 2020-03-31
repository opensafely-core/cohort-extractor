{* *! version 1.1.2  02mar2015}{...}
    {cmd:wordcount(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the number of words in {it:s}{p_end}

{p2col:}A word is a set of characters that starts and terminates with spaces,
	starts with the beginning of the string, or terminates with the end
	of the string.  This is different from a Unicode word, which is a
	language unit based on either a set of
	{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules} 
	or dictionaries for several languages (Chinese, Japanese, and Thai).
	{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}nonnegative integers 0, 1, 2, ...{p_end}
{p2colreset}{...}
