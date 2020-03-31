{* *! version 1.0.2  13mar2015}{...}
    {cmd:ustrsortkey(}{it:s}[{cmd:,}{it:loc}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}generates a null-terminated byte array that can be used
	by the {helpb sort} command to produce the same order as
	{cmd:ustrcompare()}{p_end}

{p2col:}The function may return an empty array if an error occurs.  The result
	is locale dependent.  If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale} is used.
	The result is also
	diacritic and case sensitive.  If you need different behavior, for
	example, case-insensitive results, you should use the extended
	function {cmd:ustrsortkeyex()}. See
	{findalias frunicodesort} for details and examples.{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}Unicode strings{p_end}
{p2col: Range:}null-terminated byte array{p_end}
{p2colreset}{...}
