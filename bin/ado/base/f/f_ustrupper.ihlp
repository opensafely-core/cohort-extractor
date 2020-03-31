{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrupper(}{it:s}[{cmd:,}{it:loc}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}uppercase all characters in string {it:s} under the given
	locale {it:loc}{p_end}

{p2col:}If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale} is used.  The
	same {it:s} but a different {it:loc} may produce different results;
	for example, the uppercase letter of "i" is "I" in English, but "I"
	with a dot in Turkish.  The result can be longer or shorter than the
	input string in bytes; for example, the uppercase form of the German
	letter ß (code point {bf:\u00df}) is two capital letters "SS".{p_end}

{p2col:}{cmd:ustrupper("médiane","fr")}  = {cmd:"MÉDIANE"}{break}
        {cmd:ustrupper("Rußland", "de")} = {cmd:"RUSSLAND"}{break} 
        {cmd:ustrupper("istanbul", "tr")} = {cmd:"İSTANBUL"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}locale name{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
