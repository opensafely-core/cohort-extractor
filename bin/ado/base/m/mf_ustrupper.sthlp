{smcl}
{* *! version 1.0.9  17may2019}{...}
{vieweralsosee "[M-5] ustrupper()" "mansection M-5 ustrupper()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strupper()" "help mf_strupper"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrupper##syntax"}{...}
{viewerjumpto "Description" "mf_ustrupper##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ustrupper##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ustrupper##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrupper##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrupper##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrupper##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] ustrupper()} {hline 2}}Convert Unicode string to uppercase, lowercase, or titlecase
{p_end}
{p2col:}({mansection M-5 ustrupper():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:ustrupper(}{it:string matrix s} [{cmd:,}{it:string scalar loc}]{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:ustrlower(}{it:string matrix s} [{cmd:,}{it:string scalar loc}]{cmd:)}

{p 8 12 2}
{it:string matrix} {cmd:ustrtitle(}{it:string matrix s} [{cmd:,}{it:string scalar loc}]{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrupper(}{it:s} [{cmd:,}{it:loc}]{cmd:)} converts the characters
in Unicode string {it:s} to uppercase under the given locale {it:loc}.
If {it:loc} is not specified, the
{helpb set locale_functions:locale_functions} setting is used.
The result can be longer or shorter than the input string; for example,
the uppercase form of the German letter ß (code point {bf:\u00df}) is two
capital letters "SS".  The same {it:s} but different {it:loc} can produce
different results; for example, the uppercase letter "i" is "I" in English,
but it is "İ" with a dot in Turkish.

{p 4 4 2}
{cmd:ustrlower(}{it:s} [{cmd:,}{it:loc}]{cmd:)} converts the characters
in Unicode string {it:s} to lowercase under the given locale {it:loc}.
If {it:loc} is not specified, the
{helpb set locale_functions:locale_functions} setting is used.
The result can be longer or shorter than the input Unicode string in
bytes.  The same {it:s} but different {it:loc} can produce different results;
for example, the lowercase letter of "I" is "i" in English, but it is "i"
without a dot in Turkish.  The same Unicode character can be mapped to
different Unicode characters based on its surrounding characters; for example,
Greek capital letter sigma, Σ, has two lowercase alternatives: σ or, if it is
the final character of a word, ς.

{p 4 4 2}
{cmd:ustrtitle(}{it:s} [{cmd:,}{it:loc}]{cmd:)} converts the Unicode words in
string {it:s} to
{help p_glossary##titlecase:titlecase}. Note that a Unicode word is
titlecase.  Note that the Unicode word is different from the
space-delimited words produced by function
{helpb word()}.  A Unicode word is a language unit based on either a set of
{browse "http://www.unicode.org/reports/tr29/#Word_Boundaries":word-boundary rules}
or dictionaries for some languages (Chinese, Japanese, and Thai).  The
titlecase is also locale dependent and context sensitive; for example,
lowercase "ij" in titlecase form is "IJ" in Dutch, but it is "Ij" in English.
If {it:loc} is not specified, the
{helpb set locale_functions:locale_functions} setting is used.

{p 4 4 2}
When {it:s} is not a scalar, these functions return element-by-element
results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ustrupper()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Use functions {helpb mf_strupper:strupper()} and
{helpb mf_strupper:strlower()} to convert only ASCII letters to uppercase and
lowercase.
 

{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrupper(}{it:s}[{cmd:,}{it:loc}]{cmd:)},
{cmd:ustrlower(}{it:s}[{cmd:,}{it:loc}]{cmd:)},
{cmd:ustrtitle(}{it:s}[{cmd:,}{it:loc}]{cmd:)}:
{p_end}
	    {it:s}:  {it:r x c}
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrupper(}{it:s}[{cmd:,}{it:loc}]{cmd:)},
{cmd:ustrlower(}{it:s}[{cmd:,}{it:loc}]{cmd:)}, and
{cmd:ustrtitle(}{it:s}[{cmd:,}{it:loc}]{cmd:)}
return an empty string if an error occurs.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
