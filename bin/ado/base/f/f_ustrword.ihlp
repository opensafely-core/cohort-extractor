{* *! version 1.0.2  25mar2015}{...}
    {cmd:ustrword(}{it:s}{cmd:,}{it:n}[{cmd:,}{it:loc}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:n}th Unicode word in the Unicode string
	{it:s}{p_end}
	
{p2col:}Positive {it:n} counts Unicode words from the beginning of
	{it:s}, and negative {it:n} counts Unicode words from the
	end of {it:s}.  For examples, {it:n} equal to 1 returns the first word
	in {it:s}, and {it:n} equal to -1 returns the last word in {it:s}.
	If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale} is used.
	A Unicode word is
	different from a Stata word produced by the {helpb f_word:word()}
	function.  A Stata word is a space-separated token.  A Unicode word
	is a language unit based on either a set of
	{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules}
	or dictionaries for some languages (Chinese, Japanese, and Thai). The
	function returns {it:missing} ({cmd:""}) if {it:n} is  greater than
	{it:cnt} or less than {it:-cnt}, where {it:cnt} is the number of words
	{it:s} contains.  {it:cnt} can be obtained from {cmd:ustrwordcount()}.
	The function also returns {it:missing} ({cmd:""}) if an error
	occurs.{p_end}

{p2col 5 22 26 2:}{cmd:ustrword("Parlez-vous français", 1, "fr")} = {cmd:"Parlez"}{p_end}
{p2col 5 22 26 2:}{cmd:ustrword("Parlez-vous français", 2, "fr")} = {cmd:"-"}{p_end}
{p2col 5 22 26 2:}{cmd:ustrword("Parlez-vous français",-1, "fr")} = {cmd:"français"}{p_end}
{p2col 5 22 26 2:}{cmd:ustrword("Parlez-vous français",-2, "fr")} = {cmd:"vous"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}Unicode strings{p_end}
{p2col: Domain {it:n}:}integers{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
