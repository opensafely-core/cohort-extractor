{* *! version 1.1.1  02mar2015}{...}
    {cmd:twithin(}{it:d1}{cmd:,} {it:d2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:true} if {it:d1} < {it:t} < {it:d2}, where {it:t} is
	the time variable previously {cmd:tsset}{p_end}

{p2col:}See the {helpb tin()} function; {cmd:twithin()} is similar, except
	the range is exclusive.{p_end}
{p2col: Domain {it:d1}:}date or time literals or strings recorded in units of
             {it:t} previously {cmd:tsset} or blank to indicate no minimum date
	     {p_end}
{p2col: Domain {it:d2}:}date or time literals or strings recorded in units of
             {it:t} previously {cmd:tsset} or blank to indicate no maximum date
	     {p_end}
{p2col: Range:}0 and 1, 1 means {it:true}{p_end}
{p2colreset}{...}
