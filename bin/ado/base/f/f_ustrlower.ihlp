{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrlower(}{it:s}[{cmd:,}{it:loc}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}lowercase all characters of Unicode string {it:s}
 	under the given locale {it:loc}{p_end}
	
{p2col:}If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale} is used.
	The same {it:s} but different {it:loc} may produce different
	results; for example, the lowercase letter of "I" is "i" in English
	but a dotless "i" in Turkish.  The same Unicode character can be
	mapped to different Unicode characters based on its surrounding
	characters; for example, Greek capital letter sigma Σ has two
	lowercases: ς, if it is the final character of a word, or σ.
	The result can be longer or shorter than the input Unicode string in
	bytes.{p_end}

{p2col:}{cmd:ustrlower("MÉDIANE","fr")} = {cmd:"médiane"}{break}
	{cmd:ustrlower("ISTANBUL","tr")} = {cmd:"ıstanbul"}{break}
	{cmd:ustrlower("ὈΔΥΣΣΕΎΣ")} = {cmd:"ὀδυσσεύς"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}locale name{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
