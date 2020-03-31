{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrleft(}{it:s}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the first {it:n} Unicode characters 
        of the Unicode string {it:s}{p_end}
	
{p2col:}An invalid UTF-8 sequence is 
	replaced with a Unicode replacement character {bf:\ufffd}.{p_end}

{p2col:}{cmd:ustrleft("Экспериментальные",3)} = {cmd:"Экс"}{break}
        {cmd:ustrleft("Экспериментальные",5)} = {cmd:"Экспе"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:n}:}integers{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}
