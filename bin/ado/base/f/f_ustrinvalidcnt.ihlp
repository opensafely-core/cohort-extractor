{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrinvalidcnt(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the number of invalid UTF-8 sequences in {it:s}{p_end}

{p2col:}An invalid UTF-8 sequence may contain one byte or multiple bytes.{break}

{p2col:}{cmd:ustrinvalidcnt("médiane")} = {cmd:0}{break}
	{cmd:ustrinvalidcnt("médiane"+char(229))} = {cmd:1}{break}
	{cmd:ustrinvalidcnt("médiane"+char(229)+char(174))} = {cmd:1}{break}
	{cmd:ustrinvalidcnt("médiane"+char(174)+char(158))} = {cmd:2}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
