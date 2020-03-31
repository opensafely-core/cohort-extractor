{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrright(}{it:s}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the last {it:n} Unicode characters 
        of the Unicode string {it:s}{p_end}

{p2col:}An invalid UTF-8 sequence is 
	replaced with a Unicode replacement character {bf:\ufffd}.{p_end}

{p2col:}{cmd:ustrright("Экспериментальные",3)} = {cmd:"ные"}{break}
        {cmd:ustrright("Экспериментальные",5)} = {cmd:"льные"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:n}:}integers{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
