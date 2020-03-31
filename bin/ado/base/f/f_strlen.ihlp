{* *! version 1.1.3  17may2019}{...}
    {cmd:strlen(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the number of characters in ASCII {it:s} or length in bytes{p_end}

{p2col:}{cmd:strlen()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} characters and for use
	by programmers who want to obtain the byte-length of a string.
	Note that any Unicode character beyond ASCII range (code point greater
	than 127) takes more than 1 byte in the UTF-8 encoding; for example,
	{cmd:é} takes 2 bytes.{p_end}

{p2col:}For the number of characters in a
	{help u_glossary##unichar:Unicode string}, see
	{helpb f_ustrlen:ustrlen()}.{p_end}

{p2col:}{cmd:strlen("ab")} = {cmd:2}{break}
        {cmd:strlen("é")} = {cmd:2}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}integers {ul:>} 0{p_end}
{p2colreset}{...}
