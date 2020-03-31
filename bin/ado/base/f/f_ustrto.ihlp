{* *! version 1.0.3  17mar2015}{...}
    {cmd:ustrto(}{it:s}{cmd:,}{it:enc}{cmd:,}{it:mode}{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}converts the Unicode string {it:s} in UTF-8 encoding 
        to a string in encoding {it:enc}{p_end}
	
{p2col:}See {manhelp unicode_encoding D:unicode encoding} for details on
	available encodings.  Any invalid sequence in {it:s} is replaced
	with a Unicode replacement character {bf:\ufffd}.  {it:mode} controls
	how unsupported Unicode characters in the encoding {it:enc} are
	handled.  The possible values are {cmd:1}, which substitutes any
	unsupported characters with the {it:enc}'s substitution strings (the
	substitution character for both {cmd:ascii} and {cmd:latin1} is
	{cmd:char(26)}); {cmd:2}, which skips any unsupported characters;
	{cmd:3}, which stops at the first unsupported character and returns an
	empty string; or {cmd:4}, which replaces any unsupported character
	with an escaped hex digit sequence {bf:\uhhhh} or {bf:\Uhhhhhhhh}.
	The hex digit sequence contains either 4 or 8 hex digits, depending if
	the Unicode character's code-point value is less than or greater than
	{bf:\uffff}.  Any other values are treated as {cmd:1}.{p_end}

{p2col:}{cmd:ustrto("café", "ascii", 1)} = {cmd:"caf"+char(26)}{break}
	{cmd:ustrto("café", "ascii", 2)} = {cmd:"caf"}{break}
	{cmd:ustrto("café", "ascii", 3)} = {cmd:""}{break}
	{cmd:ustrto("café", "ascii", 4)} = {cmd:"caf\u00E9"}{p_end}
	
{p2col:}{cmd:ustrto()} can be used to removed diacritical marks from base
	letters.  First, normalize the Unicode string to {cmd:NFD} form using
	{cmd:ustrnormalize()}, and then call {cmd:ustrto()} with value {cmd:2}
	to skip all non-ASCII characters.{p_end}

{p2col:}Also see {helpb ustrfrom()}.{p_end}

{p2col 5 22 26 2:}{cmd:ustrto(ustrnormalize("café", "nfd"), "ascii", 2)} = {cmd:"cafe"}{p_end}
{p2col: Domain {it:s}:}Unicode strings{p_end}
{p2col: Domain {it:enc}:}Unicode strings{p_end}
{p2col: Domain {it:mode}:}integers{p_end}
{p2col: Range:}strings in encoding {it:enc}{p_end}
{p2colreset}{...}
