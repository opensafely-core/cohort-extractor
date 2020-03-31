{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrsortkeyex(}{it:s}{cmd:,}{it:loc}{cmd:,}{it:st}{cmd:,}{it:case}{cmd:,}{it:cslv}{cmd:,}{it:norm}{cmd:,}{it:num}{cmd:,}{it:alt}{cmd:,}{it:fr}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}generates a null-terminated byte array that can be used by
	the {helpb sort} command to produce the same order
	as {cmd:ustrcompare()}{p_end}
	
{p2col:}The function may return an empty array if an error occurs. The result
	is locale dependent.  If {it:loc} is not specified, the
	{mansection U 12.4.2.4LocalesinUnicode:default locale} is used.
	See {findalias frunicodesort} for details and examples.{p_end}

{p2col:}{it:st} controls the strength of the comparison.  Possible values are
	{bf:1} (primary), {bf:2} (secondary), {bf:3} (tertiary), {bf:4}
	(quaternary), or {bf:5} (identical).  {bf:-1} means to use the default
	value for the locale.  Any other numbers are treated as tertiary.  The
	primary difference represents base letter differences; for example,
	letter "a" and letter "b" have primary differences.  The
	secondary difference represents diacritical differences on the same
	base letter; for example, letters "a" and "ä" have
	secondary differences.  The tertiary difference represents case
	differences of the same base letters; for example, letters "a" and
	"A" have tertiary differences.  Quaternary strength is useful to
	distinguish between Katakana and Hiragana for the JIS 4061 collation
	standard.  Identical strength is essentially the code-point order of
	the string and, hence, is rarely useful.{p_end}

{p2col:}{it:case} controls the uppercase and lowercase letter order. Possible
	values are {bf:0} (use order specified in tertiary strength),
	{bf:1} (uppercase first), or {bf:2} (lowercase first).  {bf:-1} means
	to use the default value for the locale.  Any other values are treated
	as {bf:0}.{p_end}

{p2col:}{it:cslv} controls if an extra case level between the secondary level
	and the tertiary level is generated.  Possible values are {bf:0} (off)
	or {bf:1} (on).  {bf:-1} means to use the default value for the locale.
	Any other values are treated as {bf:0}.  Combining this setting to be
	"on" and the strength setting to be primary can achieve the
	effect of ignoring the diacritical differences but preserving the case
	differences.  If the setting is "on", the result is also affected by
	the {it:case} setting.{p_end}

{p2col:}{it:norm} controls whether the normalization check and normalizations 
	are performed.  Possible values are {bf:0} (off) or {bf:1} (on).
	{bf:-1} means to use the default value for the locale.  Any other
	values are treated as {bf:0}.  Most languages do not require normalization for
	comparison.  Normalization is needed in languages that use multiple
	combining characters such as Arabic, ancient Greek, or Hebrew.{p_end}

{p2col:}{it:num} controls how contiguous digit substrings are sorted.
	Possible values are {bf:0} (off) or {bf:1} (on).  {bf:-1} means to use
	the default value for the locale.  Any other values are treated as
	{bf:0}.  If the setting is "on", substrings consisting of digits
	are sorted based on the numeric value.  For example, "100" is after
	"20" instead of before it.  Note that the digit substring is limited
	to 254 digits, and plus/minus signs, decimals, or exponents are
	not supported.{p_end}

{p2col:}{it:alt} controls how spaces and punctuation characters are handled.
	Possible values are {bf:0} (use primary strength) or {bf:1}
	(alternative handling).  Any other values are treated as {bf:0}.  If
	the setting is {bf:1} (alternative handling), "onsite",
	"on-site", and "on site" are considered equals.{p_end}

{p2col:}{it:fr} controls the direction of the secondary strength. Possible 
	values are {bf:0} (off) or {bf:1} (on).  {bf:-1} means to use the
	default value for the locale.  All other values are treated as
	"off".  If the setting is "on", the diacritical letters are
	sorted backward.  Note that the setting is "on" by default only for
	Canadian French (locale {bf:fr_CA}).{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:loc}:}Unicode strings{p_end}
{p2col: Domain {it:st}:}integers{p_end}
{p2col: Domain {it:case}:}integers{p_end}
{p2col: Domain {it:cslv}:}integers{p_end}
{p2col: Domain {it:norm}:}integers{p_end}
{p2col: Domain {it:num}:}integers{p_end}
{p2col: Domain {it:alt}:}integers{p_end}
{p2col: Domain {it:fr}:}integers{p_end}
{p2col: Range:}null-terminated byte array{p_end}
{p2colreset}{...}
