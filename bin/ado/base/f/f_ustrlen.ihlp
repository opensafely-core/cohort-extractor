{* *! version 1.0.4  17may2019}{...}
    {cmd:ustrlen(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the number of characters in the 
        Unicode string {it:s}{p_end}

{p2col:}An invalid UTF-8 sequence is counted as one Unicode character.  An
	invalid UTF-8 sequence may contain one byte or multiple bytes.  Note
	that any Unicode character beyond the 
	{help u_glossary##plainascii:plain ASCII} range (code point
	greater than 127) takes more than 1 byte in the UTF-8 encoding; for
	example, {cmd:é} takes 2 bytes.{p_end}

{p2col:}{cmd:ustrlen("médiane")} = {cmd:7}{break}
	{cmd:strlen("médiane")} = {cmd:8}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}integers {ul:>} 0{p_end}
{p2colreset}{...}
