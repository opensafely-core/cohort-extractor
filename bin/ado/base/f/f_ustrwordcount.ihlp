{* *! version 1.0.0  25mar2015}{...}
    {cmd:ustrwordcount(}{it:s}[{cmd:,}{it:loc}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the number of nonempty Unicode words in the 
	Unicode string {it:s}{p_end}
	
{p2col:}An empty Unicode word is a Unicode word
	consisting of only Unicode whitespace characters.  If
	{it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale}
	is used.  A Unicode word is different from a Stata word produced by the 
	{helpb f_word:word()} function.  A Stata word is a space-separated token.
	A Unicode word is a language unit based on either a set of 
	{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules} 
	or dictionaries for some languages (Chinese, Japanese, and Thai).  The 
	function may return a negative number if an error occurs.{p_end}

{p2col:}{cmd:ustrwordcount("Parlez-vous français", "fr")} = {cmd:4}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}Unicode strings{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
