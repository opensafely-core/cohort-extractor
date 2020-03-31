{smcl}
{* *! version 1.0.3  19oct2017}{...}
{vieweralsosee "[D] unicode encoding" "mansection D unicodeencoding"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "help encodings" "help encodings"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "[D] unicode translate" "help unicode translate"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}
{findalias asfrencodings}
{viewerjumpto "Syntax" "unicode_encoding##syntax"}{...}
{viewerjumpto "Description" "unicode_encoding##description"}{...}
{viewerjumpto "Links to PDF documentation" "unicode_encoding##linkspdf"}{...}
{viewerjumpto "Remarks" "unicode_encoding##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[D] unicode encoding} {hline 2}}Unicode encoding utilities{p_end}
{p2col:}({mansection D unicodeencoding:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
List encodings

{p 8 16 2}
{cmd:unicode}
{opt enc:oding}
{cmd:list}
[{it:pattern}]


{phang}
List all aliases of an encoding

{p 8 16 2}
{cmd:unicode}
{opt enc:oding}
{cmd:alias}
{it:name}


{phang}
Set an encoding for use with {cmd:unicode translate}

{p 8 16 2}
{cmd:unicode}
{opt enc:oding}
{cmd:set}
{it:name}


{phang}
{it:pattern} is one of the following: {cmd:*}, {cmd:_all},
{cmd:*}{it:name}{cmd:*}, {cmd:*}{it:name}, or {it:name}{cmd:*}. Specifying
nothing, {cmd:_all}, or {cmd:*} lists all results.  Specifying
{cmd:*}{it:name}{cmd:*} lists all results containing {it:name}. Specifying
{cmd:*}{it:name} lists all results ending with {it:name}. Specifying
{it:name}{cmd:*} lists all results starting with {it:name}.     


{marker description}{...}
{title:Description}

{pstd}
{cmd:unicode} {cmd:encoding} {cmd:list} and {cmd:unicode} {cmd:encoding}
{cmd:alias} list encodings that are available in Stata.  See
{help encodings:help encodings} for advice on choosing an encoding and a list
of the most common encodings.  {cmd:unicode} {cmd:encoding} {cmd:list}
provides a list of all encodings and their aliases or those that meet
specified criteria.  {cmd:unicode} {cmd:encoding} {cmd:alias} provides a
list of alternative names that may be used to refer to a specific
encoding.

{pstd}
{cmd:unicode encoding set} sets an encoding to be used with the
{cmd:unicode translate} command; see
{manhelp unicode_translate D:unicode translate} for documentation
for {cmd:unicode encoding set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D unicodeencodingRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Encoding is the method by which text is stored in a computer. It maps a
character to a nonnegative integer, called a code point, then maps that integer
to a single byte or a sequence of bytes.  Common encodings are ASCII
(for which there are many variants), UTF-8, and UTF-16.  Stata uses
UTF-8 encoding for storing text and UTF-16 to encode the GUI on
Microsoft Windows and macOS.  For more information about encodings,
see {findalias frencodings}.

{pstd}
The most common reason you will need to specify an encoding is when
converting a dataset, do-file, ado-file, or some other file used
with Stata 13 or earlier (which was not Unicode aware) for use
with Stata {ccl stata_version}.  See
{manhelp unicode_translate D:unicode translate}
for help with this, and see {help encodings:help encodings} for
advice on choosing an encoding and a list of common encodings.

{pstd}
Some commands and functions require that you specify one or more
encodings.  Often you will need to use only common encodings.  However,
you may not know how to specify these to Stata.  For example, suppose
that we are using {cmd:unicode translate} to convert a do-file
from Stata 13 that contains extended ASCII characters
for use in Stata {ccl stata_version}.  If we are working on a Windows machine,
the most likely encoding is Windows-1252.  If we want to check that this is
how it should be specified as we use {cmd:unicode translate}, we can type

{phang2}
{cmd:. unicode encoding list Windows-1252}

{pstd}
Stata returns all encodings for which the encoding name or an alias
exactly matches {cmd:Windows-1252}.  Capitalization does not matter.

{pstd}
If we wanted to search for all encodings and aliases that have {cmd:windows}
anywhere in their name, we could type

{phang2}
{cmd:. unicode encoding list *windows*}

{pstd}
and see a long list of matches.

{pstd}
If we are told that a text file is encoded with {cmd:ibm-913_P100-2000}
and we want to see by what other names that encoding is known (perhaps
because we just do not want to type out such a long string when using
Stata's functions that need an encoding), we can use

{phang2}
{cmd:. unicode encoding alias ibm-913_P100-2000}

{pstd}
and we find that there are many synonyms, including some that are much
easier to type.

{pstd}
You may not know the exact encoding that you need and wish to browse the
full list of available encodings. To do this, you can just type
{cmd:unicode encoding list} without specifying a pattern.
{p_end}
