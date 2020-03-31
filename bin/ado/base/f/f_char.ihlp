{* *! version 1.1.3  02mar2015}{...}
    {cmd:char(}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the character corresponding
	to ASCII or extended ASCII code {it:n}; {cmd:""} if {it:n} is not in
	the domain{p_end}
	
{p2col:}Note: ASCII codes are from 0 to 127; extended ASCII codes
	are from 128 to 255.  Prior to Stata 14, the display of extended ASCII
	characters was encoding dependent.  For example, {cmd:char(128)} on
	Microsoft Windows using Windows-1252 encoding displayed the Euro
	symbol, but on Linux using ISO-Latin-1 encoding, {cmd:char(128)}
	displayed an invalid character symbol.  Beginning with Stata 14,
	Stata's display encoding is UTF-8 on all platforms.  The
	{cmd:char(128)} function is an invalid UTF-8 sequence and thus will
	display a question mark.  There are two Unicode functions
	corresponding to {cmd:char()}:  {cmd:uchar()} and {cmd:ustrunescape()}.
	You can use {cmd:uchar(8364)} or {cmd:ustrunescape("\u20AC")} to
	display a Euro sign on all platforms.{p_end}
{p2col: Domain {it:n}:}integers 0 to 255{p_end}
{p2col: Range:}ASCII characters{p_end}
{p2colreset}{...}
