{* *! version 1.1.4  17may2019}{...}
    {cmd:substr(}{it:s}{cmd:,}{it:n1}{cmd:,}{it:n2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the substring of {it:s}, starting at {it:n1},
	for a length of {it:n2}{p_end}
	
{p2col:}{cmd:substr()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} characters and for use
	by programmers who want to extract a subset of bytes from a string.
	For those with plain ASCII text, {it:n1} is the starting character,
	and {it:n2} is the length of the string in characters.  For
	programmers, {cmd:substr()} is technically a byte-based function.
	For plain ASCII characters, the two are equivalent but you can operate
	on byte values beyond that range.
	Note that any Unicode character beyond ASCII range (code point greater
	than 127) takes more than 1 byte in the UTF-8 encoding; for example,
	{cmd:é} takes 2 bytes.{p_end}

{p2col:}To obtain substrings of
	{help u_glossary##unichar:Unicode strings}, see
	{helpb f_usubstr:usubstr()}.{p_end}

{p2col:}If {it:n1} < 0, {it:n1} is interpreted as the distance
	from the end of the string; if {it:n2} = {cmd:.} ({it:missing}),
	the remaining portion of the string is returned.{p_end}

{p2col:}{cmd:substr("abcdef",2,3)} = {cmd:"bcd"}{break}
        {cmd:substr("abcdef",-3,2)} = {cmd:"de"}{break}
	{cmd:substr("abcdef",2,.)} = {cmd:"bcdef"}{break}
	{cmd:substr("abcdef",-3,.)} = {cmd:"def"}{break}
	{cmd:substr("abcdef",2,0)} = {cmd:""}{break}
	{cmd:substr("abcdef",15,2)} = {cmd:""}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Domain {it:n1}:}integers >= 1 and <= -1{p_end}
{p2col: Domain {it:n2}:}integers >= 1{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
