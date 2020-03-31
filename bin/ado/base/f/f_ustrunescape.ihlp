{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrunescape(}{it:s}{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}the Unicode string corresponding to the escaped 
	sequences of {it:s}{p_end}
	
{p2col:}The following escape sequences are recognized: 4 hex digit form
	{bf:\uhhhh}; 8 hex digit form {bf:\Uhhhhhhhh}; 1-2 hex digit form
	{bf:\xhh}; and 1-3 octal digit form {bf:\ooo}, where {bf:h} is
	{bf:[0-9A-Fa-f]} and {bf:o} is {bf:[0-7]}.  The standard ANSI C
	escapes {bf:\a}, {bf:\b}, {bf:\t}, {bf:\n}, {bf:\v}, {bf:\f}, {bf:\r},
	{bf:\e}, {bf:\"}, {bf:\'}, {bf:\?}, {bf:\\} are recognized as well.
	The function returns an empty string if an escape sequence is badly
	formed.  Note that the 8 hex digit form {bf:\Uhhhhhhhh} begins with a
	capital letter "U".{p_end}

{p2col:}Also see {helpb ustrtohex()}.{p_end}

{p2col 5 22 26 2:}{cmd:ustrunescape("\u043d\u0443\u043b\u044e")} = {cmd:"нулю"}{p_end}
{p2col: Domain {it:s}:}strings of escaped hex values{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
