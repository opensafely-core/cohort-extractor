{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrtohex(}{it:s}[{cmd:,}{it:n}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}escaped hex digit string of {it:s} up to 200 
	Unicode characters{p_end}
	
{p2col:}The escaped hex digit string is in the form of
	{bf:\uhhhh} for code points less than {bf:\uffff} or
	{bf:\Uhhhhhhhh} for code points greater than {bf:\uffff}.  The
	function starts at the {it:n}th Unicode character of {it:s}
	if {it:n} is specified and larger than 0.  Any invalid UTF-8 sequence
	is replaced with a Unicode replacement character {bf:\ufffd}.  Note that
	the null terminator {cmd:char(0)} is a valid Unicode character.
	Function {helpb f_ustrunescape:ustrunescape()} can be applied on the
	result to get back the original Unicode string {it:s} if {it:s}
	does not contain any invalid UTF-8 sequences.{p_end}

{p2col:}Also see {helpb ustrunescape()}.{p_end}

{p2col:}{cmd:ustrtohex("нулю")} = {cmd:"\u043d\u0443\u043b\u044e"}{break}
	{cmd:ustrtohex("нулю", 2)} = {cmd:"\u0443\u043b\u044e"}{break}
	{cmd:ustrtohex("i"+char(200)+char(0)+"s")} = {cmd:"\u0069\ufffd\u0000\u0073"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:n}:}integers >= 1{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
