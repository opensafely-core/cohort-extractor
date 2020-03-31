{* *! version 1.1.2  02mar2015}{...}
    {cmd:strdup(}{it:s1}{cmd:,}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}there is no {cmd:strdup()} function; instead the
        multiplication operator is used to create multiple copies
        of strings{p_end}

{p2col:}{cmd:"hello" * 3} = {cmd:"hellohellohello"}{break}
	{cmd:3 * "hello"} = {cmd:"hellohellohello"}{break}
	{cmd:0 * "hello"} = {cmd:""}{break}
	{cmd:"hello" * 1} = {cmd:"hello"}{break}
	{cmd:"Здравствуйте " * 2} = {cmd:"Здравствуйте Здравствуйте "}{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:n}:}nonnegative integers 0, 1, 2, ...{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
