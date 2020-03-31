{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrfrom(}{it:s}{cmd:,}{it:enc}{cmd:,}{it:mode}{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}converts the string {it:s} in encoding {it:enc} to a
	UTF-8 encoded Unicode string{p_end}
	
{p2col:}{it:mode} controls how invalid byte sequences in {it:s} are handled.
	The possible values are {cmd:1}, which substitutes an invalid byte
	sequence with a Unicode replacement character {bf:\ufffd}; {cmd:2},
	which skips any invalid byte sequences; {cmd:3}, which stops at the
	first invalid byte sequence and returns an empty string; or {cmd:4},
	which replaces any byte in an invalid sequence with an escaped hex
	digit sequence {bf:%Xhh}.  Any other values are treated as {cmd:1}. A
	good use of value {bf:4} is to check what invalid bytes a Unicode
	string {it:ust} contains by examining the result of
	{cmd:ustrfrom(ust, "utf-8", 4)}.{p_end}

{p2col:}Also see {helpb ustrto()}.{p_end}

{p2col 5 22 26 2:}{cmd:ustrfrom("caf"+char(233), "latin1", 1)} = {cmd:"café"}{p_end}
{p2col 5 22 26 2:}{cmd:ustrfrom("caf"+char(233), "utf-8", 1)} = {cmd:"caf"+ustrunescape("\ufffd")}{p_end}
{p2col 5 22 26 2:}{cmd:ustrfrom("caf"+char(233), "utf-8", 2)} = {cmd:"caf"}{p_end}
{p2col 5 22 26 2:}{cmd:ustrfrom("caf"+char(233), "utf-8", 3)} = {cmd:""}{p_end}
{p2col 5 22 26 2:}{cmd:ustrfrom("caf"+char(233), "utf-8", 4)} = {cmd:"caf%XE9"}{p_end}
{p2col: Domain {it:s}:}strings in encoding {it:enc}{p_end}
{p2col: Domain {it:enc}:}Unicode strings{p_end}
{p2col: Domain {it:mode}:}integers{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
