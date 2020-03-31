{smcl}
{* *! version 1.0.9  24jan2019}{...}
{vieweralsosee "[M-5] ustrword()" "mansection M-5 ustrword()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] invtokens()" "help mf_invtokens"}{...}
{vieweralsosee "[M-5] tokenget()" "help mf_tokenget"}{...}
{vieweralsosee "[M-5] tokens()" "help mf_tokens"}{...}
{vieweralsosee "[M-5] ustrsplit()" "help mf_ustrsplit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FN] String functions" "help string functions"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrword##syntax"}{...}
{viewerjumpto "Description" "mf_ustrword##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrword##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrword##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrword##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrword##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrword##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] ustrword()} {hline 2}}Obtain Unicode word from Unicode string
{p_end}
{p2col:}({mansection M-5 ustrword():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 33 2}
{it:string matrix} {cmd:ustrword(}{it:string matrix s}{cmd:,}
{it:real matrix n}{cmd:)}

{p 8 33 2}
{it:string matrix} {cmd:ustrword(}{it:string matrix s}{cmd:,} {it:real matrix n}{cmd:,}{break}
{it:string scalar loc}{cmd:)}

{p 8 33 2}
{it:real matrix} {cmd:ustrwordcount(}{it:string matrix s}{cmd:)}

{p 8 33 2}
{it:real matrix} {cmd:ustrwordcount(}{it:string matrix s}{cmd:,}
{it:string scalar loc}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrword(}{it:s}{cmd:,} {it:n}{cmd:)} returns the {it:n}th Unicode word 
in the Unicode string {it:s}.  Positive numbers count Unicode words from the 
beginning of {it:s}, and negative numbers count Unicode words from the
end of {it:s}.  {cmd:1} is the first word in {it:s}, and {cmd:-1}
is the last Unicode word in {it:s}.  The function uses the
{helpb set locale_functions:locale_functions} setting.

{p 4 4 2}
{cmd:ustrword(}{it:s}{cmd:,} {it:n}{cmd:,} {it:loc}{cmd:)} returns the
{it:n}th Unicode word in the Unicode string {it:s}.  Positive numbers count
Unicode words from the beginning of {it:s}, and negative numbers count Unicode
words from the end of {it:s}.  {cmd:1} is the first word in {it:s}, and
{cmd:-1} is the last Unicode word in {it:s}.  The function uses the locale
specified in {it:loc}.  

{p 4 4 2}
{cmd:ustrwordcount(}{it:s}{cmd:)} returns the number of nonempty Unicode words 
in the Unicode string {it:s}.  An empty Unicode word is a Unicode word 
consisting of only Unicode whitespace characters.  The function uses the 
{helpb set locale_functions:locale_functions} setting.

{p 4 4 2}
{cmd:ustrwordcount(}{it:s}{cmd:,} {it:loc}{cmd:)} returns the number of nonempty 
Unicode words in the Unicode string {it:s}.  An empty Unicode word is a Unicode 
word consisting of only Unicode whitespace characters.  The function uses 
the locale specified in {it:loc}.  

{p 4 4 2}
When {it:s} and {it:n} are not scalar, these functions return element-by-element 
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrword()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
A Unicode word is different from a word produced by the function 
{helpb word()}.  The word in {cmd:word()} is a space-separated token.
A Unicode word is a language unit based on either a set of 
{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules} 
or dictionaries for some language such as Chinese, Japanese, and Thai.

{p 4 4 2}
An invalid UTF-8 sequence is replaced with a Unicode replacement character
{bf:\ufffd}. 

{p 4 4 2}
The null terminator {cmd:char(0)} is a nonempty Unicode word. 


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrword(}{it:s}{cmd:,} {it:n}{cmd:)},
{cmd:ustrword(}{it:s}{cmd:,} {it:n}{cmd:,} {it:loc}{cmd:)}:
{p_end}
		{it:s}:  {it:r x c} 
	        {it:n}:  {it:r x c} or 1 {it:x} 1
	      {it:loc}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:ustrwordcount(}{it:s}{cmd:)},
{cmd:ustrwordcount(}{it:s}{cmd:,} {it:loc}{cmd:)}:
{p_end}
		{it:s}:  {it:r x c} 
	      {it:loc}:  1 {it:x} 1
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrword()} returns an empty string if an error occurs.  
{cmd:ustrwordcount()} returns a negative number if an error occurs.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
