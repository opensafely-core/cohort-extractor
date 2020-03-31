{smcl}
{* *! version 1.0.2  19oct2017}{...}
{vieweralsosee "[D] unicode" "mansection D unicode"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode collator" "help unicode collator"}{...}
{vieweralsosee "[D] unicode convertfile" "help unicode convertfile"}{...}
{vieweralsosee "[D] unicode encoding" "help unicode encoding"}{...}
{vieweralsosee "[D] unicode locale" "help unicode locale"}{...}
{vieweralsosee "[D] unicode translate" "help unicode translate"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}
{vieweralsosee "help encodings" "help encodings"}{...}
{viewerjumpto "Description" "unicode##description"}{...}
{viewerjumpto "Links to PDF documentation" "unicode##linkspdf"}{...}
{viewerjumpto "Remarks" "unicode##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] unicode} {hline 2}}Unicode utilities{p_end}
{p2col:}({mansection D unicode:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{p 8 9 9}
{it:[Suggestion:  Read} {findalias frunicode} {it:first.]}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:unicode} command provides utilities to help you work with Unicode
strings in your data.  If you have only plain ASCII characters in your
data (a-z, A-Z, 0-9, and typical punctuation characters), you can stop
reading now.  Otherwise, continue with {help unicode##remarks:Remarks} below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D unicodeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
We recommend that you start with some overview documentation.  First, you
should read {findalias frunicode},
which will explain the difference between ASCII and Unicode and provide
detailed advice on working with Unicode strings in Stata.  In that section,
you will learn about locales, encodings, sorting, and Unicode-specific string
functions.  For a general overview of Unicode-specific advice, see
{help unicode_advice:help unicode advice}.

{pstd}
Second, if you have datasets, do-files, ado-files, or other
files that you used with Stata 13 or earlier and those files contain
characters other than plain ASCII such as accented characters, Chinese,
Japanese, or Korean (CJK) characters, Cyrillic characters, and the like,
you should read {manhelp unicode_translate D:unicode translate}.

{pstd}
{cmd:unicode} provides the following utilities:

{p2colset 8 35 37 2}{...}
{p2col :{manhelp unicode_translate D:unicode translate}}Translate files to Unicode{p_end}
{p2col :{manhelp unicode_encoding D:unicode encoding}}Unicode encoding utilities{p_end}
{p2col :{manhelp unicode_locale D:unicode locale}}Unicode locale utilities{p_end}
{p2col :{manhelp unicode_collator D:unicode collator}}Language-specific Unicode collators{p_end}
{p2col :{manhelp unicode_convertfile D:unicode convertfile}}Low-level file conversion between encodings{p_end}
{p2colreset}{...}

{pstd}
You may also find {help encodings:help encodings} useful if you
need to choose an encoding when converting a string from extended ASCII
to Unicode.
{p_end}
