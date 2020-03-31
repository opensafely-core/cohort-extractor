{* *! version 1.1.4  17may2019}{...}
    {cmd:subinstr(}{it:s1}{cmd:,}{it:s2}{cmd:,}{it:s3}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s1}, where the first {it:n} occurrences
        in {it:s1} of {it:s2} have been replaced with {it:s3}{p_end}
	
{p2col:}{cmd:subinstr()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} characters and for use
	by programmers who want to perform byte-based substitution.
	Note that any Unicode character beyond ASCII range (code point greater
	than 127) takes more than 1 byte in the UTF-8 encoding; for example,
	{cmd:é} takes 2 bytes.{p_end}

{p2col:}To perform character-based replacement in
	{help u_glossary##unichar:Unicode strings}, see
	{helpb f_usubinstr:usubinstr()}.{p_end}

{p2col:}If {it:n} is {it:missing}, all occurrences are replaced.

{p2col:}Also see {helpb regexm()}, {cmd:regexr()}, and {cmd:regexs()}.{p_end}

{p2col 5 22 26 2:}{cmd:subinstr("this is the day","is","X",1)} = 
	          {cmd:"thX is the day"}{p_end}
{p2col 5 22 26 2:}{cmd:subinstr("this is the hour","is","X",2)} =
	          {cmd:"thX X the hour"}{p_end}
{p2col 5 22 26 2:}{cmd:subinstr("this is this","is","X",.)} = 
	          {cmd:"thX X thX"}{p_end}
{p2col: Domain {it:s1}:}strings (to be substituted into){p_end}
{p2col: Domain {it:s2}:}strings (to be substituted from){p_end}
{p2col: Domain {it:s3}:}strings (to be substituted with){p_end}
{p2col: Domain {it:n}:}integers {ul:>} 0 or {it:missing}{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
