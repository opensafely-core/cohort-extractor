{* *! version 1.0.5  17may2019}{...}
    {cmd:strrpos(}{it:s1}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the position in {it:s1} at which {it:s2} is
                     last found; otherwise, {cmd:0}{p_end}
		     
{p2col:}{cmd:strrpos()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} characters and for use
	by programmers who want to obtain the last byte-position of {it:s2}.
	Note that any Unicode character beyond ASCII range (code point greater
	than 127) takes more than 1 byte in the UTF-8 encoding; for example,
	{cmd:é} takes 2 bytes.{p_end}

{p2col:}To find the last character position of {it:s2} in a
	{help u_glossary##unichar:Unicode string}, see
	{helpb f_ustrrpos:ustrrpos()}.{p_end}

{p2col:}{cmd:strrpos("this","is")} = {cmd:3}{break}
	{cmd:strrpos("this is","is")} = {cmd:6}{break}
	{cmd:strrpos("this is","it")} = {cmd:0}{p_end}
{p2col: Domain {it:s1}:}strings (to be searched){p_end}
{p2col: Domain {it:s2}:}strings (to search for){p_end}
{p2col: Range:}integers {ul:>} 0{p_end}
{p2colreset}{...}
