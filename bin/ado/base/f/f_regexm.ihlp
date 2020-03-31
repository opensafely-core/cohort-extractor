{* *! version 1.1.5  17may2019}{...}
    {cmd:regexm(}{it:s}{cmd:,}{it:re}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}performs a match of a regular expression and evaluates to
	{cmd:1} if regular expression {it:re} is satisfied by the ASCII string
	{it:s}; otherwise, {cmd:0}{p_end}

{p2col:}Regular expression syntax is based on Henry Spencer's NFA algorithm,
	and this is nearly identical to the POSIX.2 standard.  {it:s} and
	{it:re} may not contain binary 0 ({bf:\0}).{p_end}

{p2col:}{cmd:regexm()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} characters.  For
	Unicode characters beyond the plain ASCII range, the match
	is based on {help u_glossary##disambig:bytes}.  For a
	character-based match, see {helpb f_ustrregexm:ustrregexm()}.{p_end}
{p2col: Domain {it:s}:}ASCII strings{p_end}
{p2col: Domain {it:re}:}regular expression{p_end}
{p2col: Range:}ASCII strings{p_end}
{p2colreset}{...}

    {cmd:regexr(}{it:s1}{cmd:,}{it:re}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}replaces the first substring within ASCII string {it:s1}
	that matches {it:re} with ASCII string {it:s2} and returns the
	resulting string{p_end}

{p2col:}If {it:s1} contains no substring that matches {it:re}, the unaltered
	{it:s1} is returned.  {it:s1} and the result of {cmd:regexr()} may be
	at most 1,100,000 characters long.  {it:s1}, {it:re}, and {it:s2} may not
	contain binary 0 ({bf:\0}).{p_end}

{p2col:}{cmd:regexr()} is intended for use with only
	{help u_glossary##plainascii:plain ASCII} characters.  For
	Unicode characters beyond the plain ASCII range, the match
	is based on {help u_glossary##disambig:bytes} and the result
	is restricted to 1,100,000 bytes.  For a
	character-based match, see {helpb f_ustrregexrf:ustrregexrf()}
	or {helpb f_ustrregexra:ustrregexra()}.{p_end}
{p2col: Domain {it:s1}:}ASCII strings{p_end}
{p2col: Domain {it:re}:}regular expression{p_end}
{p2col: Domain {it:s2}:}ASCII strings{p_end}
{p2col: Range:}ASCII strings{p_end}
{p2colreset}{...}

    {cmd:regexs(}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}subexpression {it:n} from a previous {cmd:regexm()}
        match, where {bind:0 {ul:<} {it:n} < 10}{p_end}

{p2col:}Subexpression 0 is reserved for the entire string that satisfied the
	regular expression.  The returned subexpression may be at most
	1,100,000 characters (bytes) long.{p_end}
{p2col: Domain {it:n}:}0 to 9{p_end}
{p2col: Range:}ASCII strings{p_end}
{p2colreset}{...}
