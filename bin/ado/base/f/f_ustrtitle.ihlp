{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrtitle(}{it:s}[{cmd:,}{it:loc}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}a string with the first characters of 
        Unicode words titlecased and other characters
	lowercased{p_end}

{p2col:}If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale}
	is used. Note that a Unicode word is different from a Stata word
	produced by function {helpb word()}.  The Stata word is a
	space-separated token.  A Unicode word is a language unit based on
	either a set of
	{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules}
	or dictionaries for some languages (Chinese, Japanese, and Thai).
	The titlecase is also locale dependent and context sensitive; for
	example, lowercase "ij" is considered a digraph in Dutch. Its
	titlecase is "IJ".{p_end}

{p2col:}{cmd:ustrtitle("vous êtes", "fr")} = {cmd:"Vous Êtes"}{break}
	{cmd:ustrtitle("mR. joHn a. sMitH")} = {cmd:"Mr. John A. Smith"}{break}
	{cmd:ustrtitle("ijmuiden", "en")} = {cmd:"Ijmuiden"}{break}
	{cmd:ustrtitle("ijmuiden", "nl")} = {cmd:"IJmuiden"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}Unicode strings{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
