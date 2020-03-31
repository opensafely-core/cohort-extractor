{* *! version 1.0.1  10mar2015}{...}
    {cmd:usubinstr(}{it:s1}{cmd:,}{it:s2}{cmd:,}{it:s3}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}replaces the first {it:n} occurrences of the Unicode 
        string {it:s2} with the Unicode string {it:s3} in {it:s1}{p_end}
	
{p2col:}If {it:n} is {it:missing}, all occurrences are replaced.  An invalid
	UTF-8 sequence in {it:s1}, {it:s2}, or {it:s3} is replaced with a
	Unicode replacement character {bf:\ufffd} before replacement is
	performed.{p_end}

{p2col 5 22 26 2:}{cmd:usubinstr("de très près","ès","es",1)} = {cmd:"de tres près"}{p_end}
{p2col 5 22 26 2:}{cmd:usubinstr("de très près","ès","X",2)} = {cmd:"de trX prX"}{p_end}
{p2col: Domain {it:s1}:}Unicode strings (to be substituted into){p_end}
{p2col: Domain {it:s2}:}Unicode strings (to be substituted from){p_end}
{p2col: Domain {it:s3}:}Unicode strings (to be substituted with){p_end}
{p2col: Domain {it:n}:}integers {ul:>} 0 or {it:missing}{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
