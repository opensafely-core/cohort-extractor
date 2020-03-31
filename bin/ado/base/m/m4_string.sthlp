{smcl}
{* *! version 1.4.0  23jan2019}{...}
{vieweralsosee "[M-4] String" "mansection M-4 String"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_string##contents"}{...}
{viewerjumpto "Description" "m4_string##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_string##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_string##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-4] String} {hline 2}}String manipulation functions
{p_end}
{p2col:}({mansection M-4 String:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 23}Function{col 39}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Parsing }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 7}{bf:{help mf_tokens:tokens()}}{...}
{col 23}{cmd:tokens()}{...}
{col 39}obtain tokens (words) from string

{col 7}{bf:{help mf_invtokens:invtokens()}}{...}
{col 23}{cmd:invtokens()}{...}
{col 39}concatenate string vector into string
{col 41}scalar

{col 7}{bf:{help mf_ustrword:ustrword()}}{...}
{col 23}{cmd:ustrword()}{...}
{col 39}return {it:n}th Unicode word
{col 23}{cmd:ustrwordcount()}{...}
{col 39}return the number of Unicode words

{col 7}{bf:{help mf_strmatch:strmatch()}}{...}
{col 23}{cmd:strmatch()}{...}
{col 39}pattern matching

{col 7}{bf:{help mf_tokenget:tokenget()}}{...}
{col 23}...{...}
{col 39}advanced parsing

{col 7}{bf:{help mf_ustrsplit:ustrsplit()}}{...}
{col 23}{cmd:ustrsplit()}{...}
{col 39}split string into parts based on a 
{col 41}Unicode regular expression

{col 5}   {c TLC}{hline 19}{c TRC}
{col 5}{hline 3}{c RT}{it: Length & position }{c LT}{hline}
{col 5}   {c BLC}{hline 19}{c BRC}

{col 7}{bf:{help mf_strlen:strlen()}}{...}
{col 23}{cmd:strlen()}{...}
{col 39}length of string in bytes

{col 7}{bf:{help mf_ustrlen:ustrlen()}}{...}
{col 23}{cmd:ustrlen()}{...}
{col 39}length of string in Unicode characters

{col 7}{bf:{help mf_udstrlen:udstrlen()}}{...}
{col 23}{cmd:udstrlen()}{...}
{col 39}length of string in display columns

{col 7}{bf:{help mf_fmtwidth:fmtwidth()}}{...}
{col 23}{cmd:fmtwidth()}{...}
{col 39}width of {cmd:%}{it:fmt}

{col 7}{bf:{help mf_strpos:strpos()}}{...}
{col 23}{cmd:strpos()}{...}
{col 39}find substring within string from left
{col 23}{cmd:strrpos()}{...}
{col 39}find substring within string from right

{col 7}{bf:{help mf_ustrpos:ustrpos()}}{...}
{col 23}{cmd:ustrpos()}{...}
{col 39}find Unicode substring within string,
{col 41}first occurrence
{col 23}{cmd:ustrrpos()}{...}
{col 39}find Unicode substring within string,
{col 41}last occurrence

{col 7}{bf:{help mf_indexnot:indexnot()}}{...}
{col 23}{cmd:indexnot()}{...}
{col 39}find character not in list

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Editing }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 7}{bf:{help mf_substr:substr()}}{...}
{col 23}{cmd:substr()}{...}
{col 39}extract substring

{col 7}{bf:{help mf_usubstr:usubstr()}}{...}
{col 23}{cmd:usubstr()}{...}
{col 39}extract Unicode substring

{col 7}{bf:{help mf_udsubstr:udsubstr()}}{...}
{col 23}{cmd:udsubstr()}{...}
{col 39}extract Unicode substring 
{col 41}based on display columns

{col 7}{bf:{help mf_strupper:strupper()}}{...}
{col 23}{cmd:strupper()}{...}
{col 39}convert to uppercase
{col 23}{cmd:strlower()}{...}
{col 39}convert to lowercase
{col 23}{cmd:strproper()}{...}
{col 39}convert to proper case

{col 7}{bf:{help mf_ustrupper:ustrupper()}}{...}
{col 23}{cmd:ustrupper()}{...}
{col 39}convert Unicode characters to uppercase 
{col 23}{cmd:ustrlower()}{...}
{col 39}convert Unicode characters to lowercase 
{col 23}{cmd:ustrtitle()}{...}
{col 39}convert Unicode characters to titlecase

{col 7}{bf:{help mf_strtrim:strtrim()}}{...}
{col 23}{cmd:stritrim()}{...}
{col 39}replace multiple, consecutive internal
{col 41}blanks with one blank
{col 23}{cmd:strltrim()}{...}
{col 39}remove leading blanks
{col 23}{cmd:strrtrim()}{...}
{col 39}remove trailing blanks
{col 23}{cmd:strtrim()}{...}
{col 39}remove leading and trailing blanks

{col 7}{bf:{help mf_ustrtrim:ustrtrim()}}{...}
{col 23}{cmd:ustrtrim()}{...}
{col 39}remove leading and trailing Unicode 
{col 41}whitespace characters and blanks
{col 23}{cmd:ustrltrim()}{...}
{col 39}remove leading Unicode 
{col 41}whitespace characters and blanks
{col 23}{cmd:ustrrtrim()}{...}
{col 39}remove trailing Unicode 
{col 41}whitespace characters and blanks

{col 7}{bf:{help mf_subinstr:subinstr()}}{...}
{col 23}{cmd:subinstr()}{...}
{col 39}substitute text
{col 23}{cmd:subinword()}{...}
{col 39}substitute word

{col 7}{bf:{help mf_usubinstr:usubinstr()}}{...}
{col 23}{cmd:usubinstr()}{...}
{col 39}replace Unicode substring

{col 7}{bf:{help mf__substr:_substr()}}{...}
{col 23}{cmd:_substr()}{...}
{col 39}substitute into string

{col 7}{bf:{help mf__usubstr:_usubstr()}}{...}
{col 23}{cmd:_usubstr()}{...}
{col 39}substitute into Unicode string

{col 7}{bf:{help mf_strdup:strdup()}}{...}
{col 23}{cmd:*}{...}
{col 39}duplicate string

{col 7}{bf:{help mf_strreverse:strreverse()}}{...}
{col 23}{cmd:strreverse()}{...}
{col 39}reverse string in bytes

{col 7}{bf:{help mf_ustrreverse:ustrreverse()}}{...}
{col 23}{cmd:ustrreverse()}{...}
{col 39}reverse string in Unicode characters

{col 7}{bf:{help mf_soundex:soundex()}}{...}
{col 23}{cmd:soundex()}{...}
{col 39}convert to soundex code
{col 23}...{cmd:_nara()}{...}
{col 39}convert to U.S. Census soundex code

{col 5}   {c TLC}{hline 7}{c TRC}
{col 5}{hline 3}{c RT}{it: Stata }{c LT}{hline}
{col 5}   {c BLC}{hline 7}{c BRC}

{col 7}{bf:{help mf_abbrev:abbrev()}}{...}
{col 23}{cmd:abbrev()}{...}
{col 39}abbreviate Unicode strings to display
{col 41}columns

{col 7}{bf:{help mf_strtoname:strtoname()}}{...}
{col 23}{cmd:strtoname()}{...}
{col 39}translate strings to Stata 13 
{col 41}compatible names

{col 7}{bf:{help mf_ustrtoname:ustrtoname()}}{...}
{col 23}{cmd:ustrtoname()}{...}
{col 39}translate Unicode strings to Stata
{col 41}names

{col 5}   {c TLC}{hline 18}{c TRC}
{col 5}{hline 3}{c RT}{it: Text translation }{c LT}{hline}
{col 5}   {c BLC}{hline 18}{c BRC}

{col 7}{bf:{help mf_strofreal:strofreal()}}{...}
{col 23}{cmd:strofreal()}{...}
{col 39}convert real to string

{col 7}{bf:{help mf_strtoreal:strtoreal()}}{...}
{col 23}{cmd:strtoreal()}{...}
{col 39}convert string to real

{col 7}{bf:{help mf_ustrto:ustrto()}}{...}
{col 23}{cmd:ustrto()}{...}
{col 39}convert a Unicode string to a string
{col 41}in another encoding
{col 23}{cmd:ustrfrom()}{...}
{col 39}convert a string in one encoding to
{col 41}a Unicode string

{col 7}{bf:{help mf_ustrunescape:ustrunescape()}}{...}
{col 23}{cmd:ustrunescape()}{...}
{col 39}convert the escaped hex sequences
{col 41}to Unicode 
{col 23}{cmd:ustrtohex()}{...}
{col 39}convert a Unicode sequence to hex
{col 41}sequences

{col 7}{bf:{help mf_urlencode:urlencode()}}{...}
{col 23}{cmd:urlencode()}{...}
{col 39}convert a string to a valid ASCII 
{col 41}format for web transmission
{col 23}{cmd:urldecode()}{...}
{col 39}decode the string obtained from 
{col 41}{cmd:urlencode()}

{col 7}{bf:{help mf_ascii:ascii()}}{...}
{col 23}{cmd:ascii()}{...}
{col 39}obtain ASCII or byte codes
{col 41}of string
{col 23}{cmd:char()}{...}
{col 39}make string from ASCII or byte codes

{col 7}{bf:{help mf_uchar:uchar()}}{...}
{col 23}{cmd:uchar()}{...}
{col 39}make Unicode character from Unicode 
{col 41}code-point value

{col 7}{bf:{help mf_isascii:isascii()}}{...}
{col 23}{cmd:isascii()}{...}
{col 39}whether string scalar contains only
{col 41}ASCII codes

{col 5}   {c TLC}{hline 18}{c TRC}
{col 5}{hline 3}{c RT}{it: Unicode utilities}{c LT}{hline}
{col 5}   {c BLC}{hline 18}{c BRC}

{col 7}{bf:{help mf_ustrcompare:ustrcompare()}}{...}
{col 23}{cmd:ustrcompare()}{...}
{col 39}compare or sort Unicode strings
{col 23}{cmd:ustrsortkey()}{...}
{col 39}obtain sort key of Unicode string

{col 7}{bf:{help mf_ustrfix:ustrfix()}}{...}
{col 23}{cmd:ustrfix()}{...}
{col 39}replace invalid sequences in Unicode
{col 41}string

{col 7}{bf:{help mf_ustrnormalize:ustrnormalize()}}{...}
{col 23}{cmd:ustrnormalize()}{...}
{col 39}normalize Unicode string

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions are for manipulating strings.  Strings in Mata are 
strings of Unicode characters in {help m6_glossary##utf8:UTF-8 encoding},
usually the printable characters, but Mata enforces no such restriction.  In
particular, strings may contain binary 0.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 StringRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
In addition to the above functions, two operators are especially useful 
for dealing with strings.

{p 4 4 2}
The first is {cmd:+}.  Addition is how you concatenate strings:

	: {cmd:"abc" + "def"}
	{res:abcdef}

	: {cmd:"Café " + "de Flore"}
	{res:Café de Flore}

	: {cmd:command = "list"}
	: {cmd:args = "mpg weight"}
	: {cmd:result = command + " " + args}
	: {cmd:result}
	{res:list mpg weight}

{p 4 4 2}
The second is {cmd:*}.  Multiplication is how you duplicate strings:

	: {cmd:5*"a"}
	{res:aaaaa}

	: {cmd:"Allô"*2}
	{res:AllôAllô}

	: {cmd:indent = 20}
	: {cmd:title = indent*" " + "My Title"}
	: {cmd:title}
        {res:                    My Title}
