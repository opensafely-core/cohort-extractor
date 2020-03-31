{* *! version 1.1.1  02mar2015}{...}
    {cmd:byteorder()}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:1} if
	your computer stores numbers by using a hilo byte order and evaluates
	to {cmd:2} if your computer stores numbers by using a lohi byte order
	{p_end}

{p2col:}Consider the number 1 written as a 2-byte integer.  On some computers
	(called hilo), it is written as {bind:"00 01"}, and on other computers
	(called lohi), it is written as {bind:"01 00"} (with the least
	significant byte written first).  There are similar issues for 4-byte
	integers, 4-byte floats, and 8-byte floats.  Stata automatically
	handles byte-order differences for Stata-created files.  Users need
	not be concerned about this issue.  Programmers producing custom
	binary files can use {cmd:byteorder()} to determine the native byte
	ordering; see {manhelp file P}.{p_end}
{p2col: Range:}1 and 2{p_end}
{p2colreset}{...}
