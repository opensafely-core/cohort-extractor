{* *! version 1.0.1  10mar2015}{...}
    {cmd:ustrregexm(}{it:s}{cmd:,}{it:re}[{cmd:,}{it:noc}]{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}performs a match of a regular expression and evaluates to
{cmd:1} if regular expression {it:re} is satisfied by the Unicode string
{it:s}; otherwise, {cmd:0}{p_end}

{p2col:}If {it:noc} is specified and not 0, a case-insensitive match is
	performed.  The function may return a negative integer if an error
	occurs.{p_end}

{p2col:}{cmd:ustrregexm("12345", "([0-9]){5}")} = {cmd:1}{break}
        {cmd:ustrregexm("de TRÈS près", "rès")} = {cmd:1}{break}
        {cmd:ustrregexm("de TRÈS près", "Rès")} = {cmd:0}{break}
        {cmd:ustrregexm("de TRÈS près", "Rès", 1)} = {cmd:1}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:re}:}Unicode regular expressions{p_end}
{p2col: Domain {it:noc}:}integers{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}

    {cmd:ustrregexrf(}{it:s1}{cmd:,}{it:re}{cmd:,}{it:s2}[{cmd:,}{it:noc}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}replaces the first substring within the Unicode string
        {it:s1} that matches {it:re} with {it:s2} and returns the resulting
	string{p_end}
	
{p2col:}If {it:noc} is specified and not 0, a case-insensitive match is
        performed. The function may return an empty string if an error
	occurs.{p_end}

{p2col:}{cmd:ustrregexrf("très près", "rès", "X")} = {cmd:"tX près"}{break}
        {cmd:ustrregexrf("TRÈS près", "Rès", "X")} = {cmd:"TRÈS près"}{break}
        {cmd:ustrregexrf("TRÈS près", "Rès", "X", 1)} = {cmd:"TX près"}{p_end}
{p2col: Domain {it:s1}:}Unicode strings{p_end}
{p2col: Domain {it:re}:}Unicode regular expressions{p_end}
{p2col: Domain {it:s2}:}Unicode strings{p_end}
{p2col: Domain {it:noc}:}integers{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}

    {cmd:ustrregexra(}{it:s1}{cmd:,}{it:re}{cmd:,}{it:s2}[{cmd:,}{it:noc}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}replaces all substrings within the Unicode string {it:s1} 
        that match {it:re} with {it:s2} and returns the resulting
	string{p_end}
	
{p2col:}If {it:noc} is specified and not 0, a case-insensitive match is 
	performed.  The function may return an empty string if an error
	occurs.{p_end}

{p2col:}{cmd:ustrregexra("très près", "rès", "X")} = {cmd:"tX pX"}{break}
        {cmd:ustrregexra("TRÈS près", "Rès", "X")} = {cmd:"TRÈS près"}{break}
        {cmd:ustrregexra("TRÈS près", "Rès", "X", 1)} = {cmd:"TX pX"}{p_end}
{p2col: Domain {it:s1}:}Unicode strings{p_end}
{p2col: Domain {it:re}:}Unicode regular expressions{p_end}
{p2col: Domain {it:s2}:}Unicode strings{p_end}
{p2col: Domain {it:noc}:}integers{p_end}
{p2col: Range:}Unicode strings{p_end}
{p2colreset}{...}

    {cmd:ustrregexs(}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}subexpression {it:n} from a previous 
	{cmd:ustrregexm()} match{p_end}
	
{p2col:}Subexpression 0 is reserved for the entire string that satisfied the
	regular expression. The function may return an empty string if {it:n}
	is larger than the maximum count of subexpressions from the previous
	match or if an error occurs.{p_end}
{p2col: Domain {it:n}:}integers {ul:>} 0{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
