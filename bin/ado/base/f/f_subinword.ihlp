{* *! version 1.1.3  12mar2015}{...}
    {cmd:subinword(}{it:s1}{cmd:,}{it:s2}{cmd:,}{it:s3}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s1}, where the first {it:n} occurrences
        in {it:s1} of {it:s2} as a word have been replaced with {it:s3}{p_end}

{p2col:}A word is defined as a space-separated token.  A token at the beginning
	or end of {it:s1} is considered space-separated.  This is different
	from Unicode word, which is a language unit based on either a
	set of {browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules}
	or dictionaries for several languages (Chinese, Japanese, and Thai).
	If {it:n} is {it:missing}, all occurrences are replaced.{p_end}
	
{p2col:}Also see {helpb regexm()}, {cmd:regexr()}, and {cmd:regexs()}.{p_end}

{p2col 5 22 26 2:}{cmd:subinword("this is the day","is","X",1)} = 
                          {cmd:"this X the day"}{p_end}
{p2col 5 22 26 2:}{cmd:subinword("this is the hour","is","X",.)} =
		          {cmd:"this X the hour"}{p_end}
{p2col 5 22 26 2:}{cmd:subinword("this is this","th","X",.)} =
		          {cmd:"this is this"}{p_end}
{p2col: Domain {it:s1}:}strings (to be substituted for){p_end}
{p2col: Domain {it:s2}:}strings (to be substituted from){p_end}
{p2col: Domain {it:s3}:}strings (to be substituted with){p_end}
{p2col: Domain {it:n}:}integers {ul:>} 0 or {it:missing}{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
