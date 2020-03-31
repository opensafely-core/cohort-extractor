{* *! version 1.0.3  20mar2015}{...}
    {cmd:ustrcompare(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:loc}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}compares two Unicode strings{p_end}

{p2col:}The function returns {cmd:-1}, {cmd:1}, or {cmd:0} if {it:s1} is less
	than, greater than, or equal to {it:s2}.  The function may return a
	negative number other than -1 if an error happens.  The comparison is
	locale dependent.  For example, z < ö in Swedish but ö < z in German.
	If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale}
	is used.  The comparison is
	diacritic and case sensitive.  If you need different behavior, for
	example, case-insensitive comparison, you should use the extended
	comparison function {cmd:ustrcompareex()}.
	{mansection U 12.4.2.4LocalesinUnicode:Unicode string comparison}
	compares Unicode strings in a language-sensitive manner.  On the other
	hand, the {helpb sort} command compares strings in code-point (binary)
	order.  For example, uppercase "Z" (code-point value 90) comes before
	lowercase "a" (code-point value 97) in code-point order but comes
	after "a" in any English dictionary.{p_end}

{p2col:}{cmd:ustrcompare("z", "ö", "sv")} = {cmd:-1}{break}
	{cmd:ustrcompare("z", "ö", "de")} = {cmd: 1}{p_end}
{p2col: Domain {it:s1}:}Unicode strings{p_end}
{p2col: Domain {it:s2}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}Unicode strings{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
