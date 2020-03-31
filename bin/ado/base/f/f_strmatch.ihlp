{* *! version 1.1.6  17may2019}{...}
    {cmd:strmatch(}{it:s1}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:1} if {it:s1} matches the pattern {it:s2};
                     otherwise, {cmd:0}{p_end}

{p2col:}{cmd:strmatch("17.4","1??4")} returns {cmd:1}.  In {it:s2}, {cmd:"?"}
	means that one character goes here, and {cmd:"*"} means that
	zero or more bytes go here.  Note that a
	{help u_glossary##unichar:Unicode character}
	may contain multiple bytes; thus, using {cmd:"*"} with Unicode
	characters can infrequently result in matches that do not occur at a
	character boundary.

{p2col:}Also see {helpb regexm()}, {cmd:regexr()},
	and {cmd:regexs()}.{p_end}

{p2col:}{cmd:strmatch("café", "caf?")} = {cmd:1}{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings{p_end}
{p2col: Range:}integers 0 or 1{p_end}
{p2colreset}{...}
