{* *! version 1.0.3  17may2019}{...}
    {cmd:strproper(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}a string with the first ASCII letter and any other
	letters immediately following characters that are not letters
	capitalized; all other ASCII letters converted to lowercase{p_end}

{p2col:}{cmd:strproper()} implements a form of
	{help u_glossary##titlecase:titlecasing} and is 
	intended for use with only
	{help u_glossary##plainascii:plain ASCII} strings.
	Unicode characters beyond ASCII are treated
        as characters that are not letters.  To titlecase strings with
	Unicode characters beyond the plain ASCII range or to implement 
	language-sensitive rules for titlecasing, see
	{helpb f_ustrtitle:ustrtitle()}.{p_end}

{p2col:}{cmd:strproper("mR. joHn a. sMitH")} = {cmd:"Mr. John A. Smith"}{break}
	{cmd:strproper("jack o'reilly")} = {cmd:"Jack O'Reilly"}{break}
	{cmd:strproper("2-cent's worth")} = {cmd:"2-Cent'S Worth"}{break}
	{cmd:strproper("vous êtes")} = {cmd:"Vous êTes"}{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
