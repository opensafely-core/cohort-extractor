{* *! version 1.0.2  12mar2015}{...}
    {cmd:ustrnormalize(}{it:s}{cmd:,}{it:norm}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col:Description:}normalizes Unicode string {it:s} to one of the five 
	normalization forms specified by {it:norm}{p_end}

{p2col:}The normalization forms are {bf:nfc}, {bf:nfd}, {bf:nfkc}, {bf:nfkd},
	or {bf:nfkcc}.  The function returns an empty string for any other
	value of {it:norm}.  Unicode normalization removes the Unicode string
	differences caused by Unicode character equivalence.  {bf:nfc}
	specifies {bf:Normalization Form C}, which normalizes decomposed
	Unicode code points to a composited form.  {bf:nfd} specifies
	{bf:Normalization Form D}, which normalizes composited Unicode code
	points to a decomposed form.  {bf:nfc} and {bf:nfd} produce canonical
	equivalent form.  {bf:nfkc} and {bf:nfkd} are similar to {bf:nfc} and
	{bf:nfd} but produce compatibility equivalent forms.  
	{bf:nfkcc} specifies {bf:nfkc}
	with casefolding.  This normalization and casefolding implement the
	{browse "http://www.unicode.org/reports/tr44/":Unicode Character Database}.{p_end}

{p2col:}In the Unicode standard, both "i" ({bf:\u0069} followed by a diaeresis
	{bf:\u0308}) and the composite character {bf:\u00ef} represent "i"
	with 2 dots as in "naïve".  Hence, the code-point sequence
	{bf:\u0069\u0308} and the code point {bf:\u00ef} are considered
	Unicode equivalent.  According to the Unicode standard, they should be
	treated as the same single character in Unicode string operations,
	such as in display, comparison, and selection.  However, Stata does
	not support multiple code-point characters; each code point is
	considered a separate Unicode character.  Hence, {bf:\u0069\u0308} is
	displayed as two characters in the Results window.
	{cmd:ustrnormalize()} can be used with {bf:"nfc"} to normalize
	{bf:\u0069\u0308} to the canonical equivalent composited code point
	{bf:\u00ef}.{p_end}

{p2col 5 22 26 2:}{cmd:ustrnormalize(ustrunescape("\u0069\u0308"), "nfc")} = {cmd:"ï"}{p_end}

{p2col:}The decomposed form {bf:nfd} can be used to removed diacritical 
	marks from base letters.  First, normalize the Unicode string to 
	canonical decomposed form, and then call {helpb f_ustrto:ustrto()} 
	with mode {bf:skip} to skip all non-ASCII characters.{p_end}

{p2col:}Also see {helpb f_ustrfrom:ustrfrom()}.

{p2col 5 22 26 2:}{cmd:ustrto(ustrnormalize("café", "nfd"), "ascii", 2)} = {cmd:"cafe"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:norm}:}Unicode strings{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
