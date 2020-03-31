{smcl}
{* *! version 1.3.4  24jan2019}{...}
{vieweralsosee "[P] tokenize" "mansection P tokenize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] invtokens()" "help mf_invtokens"}{...}
{vieweralsosee "[M-5] tokenget()" "help mf_tokenget"}{...}
{vieweralsosee "[M-5] tokens()" "help mf_tokens"}{...}
{vieweralsosee "[M-5] ustrsplit()" "help mf_ustrsplit"}{...}
{viewerjumpto "Syntax" "tokenize##syntax"}{...}
{viewerjumpto "Description" "tokenize##description"}{...}
{viewerjumpto "Links to PDF documentation" "tokenize##linkspdf"}{...}
{viewerjumpto "Option" "tokenize##option"}{...}
{viewerjumpto "Remarks" "tokenize##remarks"}{...}
{viewerjumpto "Examples" "tokenize##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] tokenize} {hline 2}}Divide strings into tokens{p_end}
{p2col:}({mansection P tokenize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmdab:token:ize} [[{cmd:`}]{cmd:"}][{it:string}][{cmd:"}[{cmd:'}]]
	[{cmd:,} {cmdab:p:arse:("}{it:pchars}{cmd:")} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:tokenize} divides {it:string} into tokens, storing the result
in {hi:`1'}, {hi:`2'}, ... (the positional local macros).  Tokens are
determined based on the parsing characters {it:pchars}, which default to a
space if not specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P tokenizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}{cmd:parse("}{it:pchars}{cmd:")} specifies the parsing characters.  If
{cmd:parse()} is not specified, {cmd:parse(" ")} is assumed, and 
{it:string} is split into words.  Note that {it:pchars} is treated as a
sequence of bytes.  Any Unicode character in multibyte UTF-8 encoding, which
applies to all Unicode characters except ASCII characters, is treated as a
sequence of bytes rather than as a single character.  For example,
{cmd:parse()} will not work as expected when trying to break a string into
tokens based on a Unicode whitespace character {bf:\u2000}. 


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:tokenize} may be used as an alternative or supplement to the {helpb syntax}
command for parsing command-line arguments.  Generally, it is used to further
process the local macros created by {cmd:syntax}, as shown below.

    {cmd:program myprog}
            {cmd:version {ccl stata_version}}
	    {cmd:syntax [varlist] [if] [in]}
	    {cmd:marksample touse }

	    {cmd:tokenize `varlist'}
	    {cmd:local first `1'}
	    {cmd:macro shift}
	    {cmd:local rest `*'}
	    {it:...}
    {cmd:end}


{marker examples}{...}
{title:Examples}

    {cmd:. tokenize some words}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|"}

    {cmd:. tokenize "some more words"}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|, 4=|`4'|"}

    {cmd:. tokenize `""Marcello Pagano""Rino Bellocco""'}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|"}

    {cmd:. local str "A strange++string"}
    {cmd:. tokenize `str'}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|"}

    {cmd:. tokenize `str', parse(" +")}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|, 4=|`4'|, 5=|`5'|, 6=|`6'|"}

    {cmd:. tokenize `str', parse("+")}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|, 4=|`4'|, 5=|`5'|, 6=|`6'|"}

    {cmd:. tokenize}
    {cmd:. di "1=|`1'|, 2=|`2'|, 3=|`3'|"}
