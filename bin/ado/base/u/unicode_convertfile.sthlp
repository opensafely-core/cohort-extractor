{smcl}
{* *! version 1.0.3  19oct2017}{...}
{vieweralsosee "[D] unicode convertfile" "mansection D unicodeconvertfile"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "[D] unicode translate" "help unicode translate"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}
{findalias asfrunicodeadvice}
{viewerjumpto "Syntax" "unicode_convertfile##syntax"}{...}
{viewerjumpto "Description" "unicode_convertfile##description"}{...}
{viewerjumpto "Links to PDF documentation" "unicode_convertfile##linkspdf"}{...}
{viewerjumpto "Options" "unicode_convertfile##options"}{...}
{viewerjumpto "Remarks" "unicode_convertfile##remarks"}{...}
{viewerjumpto "Examples" "unicode_convertfile##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[D] unicode convertfile} {hline 2}}Low-level file conversion between encodings{p_end}
{p2col:}({mansection D unicodeconvertfile:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:unicode}
{opt conv:ertfile}
{it:{help filename:srcfilename}}
{it:destfilename}
[{cmd:,} {it:options}]

{phang}
{it:srcfilename} is a text file that is to be converted from a given encoding
and {it:destfilename} is the destination text file that will use a different
encoding.


{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{cmdab:srcenc:oding}{cmd:(}[{it:{help strings:string}}]{cmd:)}}encoding of the source file; 
	UTF-8 if not specified{p_end}
{synopt :{cmdab:dstenc:oding}{cmd:(}[{it:{help strings:string}}]{cmd:)}}encoding of the destination file; 
	UTF-8 if not specified{p_end}
{synopt :{cmdab:srccall:back(}{it:{help unicode_convertfile##method:method}}{cmd:)}}what to do if source file contains 
	invalid byte sequence(s){p_end}
{synopt :{cmdab:dstcall:back(}{it:{help unicode_convertfile##method:method}}{cmd:)}}what to do if destination encoding
	does not support characters in the source file{p_end}
{synopt :{opt rep:lace}}replace the destination file if it exists{p_end}
{synoptline}

{marker method}{...}
{synoptset 20}{...}
{synopthdr:method}
{synoptline}
{synopt :{opt stop}}specify that {cmd:unicode convertfile} stop with an
	error if an invalid character is encountered; the default{p_end}
{synopt :{opt skip}}specify that {cmd:unicode convertfile} skip invalid 
	characters{p_end}
{synopt :{opt sub:stitute}}specify that {cmd:unicode convertfile} 
	substitute invalid characters with the destination
	encoding's substitute character during conversion;
	the substitute character for Unicode encodings is {bf:\ufffd}{p_end}
{synopt :{opt esc:ape}}specify that {cmd:unicode convertfile} 
	replace any Unicode characters not supported in the destination 
	encoding with an escaped string of the hex value of the Unicode 
	code point. The string is in 4-hex-digit form {bf:\uhhhh} for a code
        point less than or equal to {bf:\uffff}. The string is in 8-hex-digit
        form {bf:\Uhhhhhhhh} for code points greater than {bf:\uffff}.
        {cmd:escape} may only be specified when converting from a Unicode
        encoding such as UTF-8.{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:unicode} {cmd:convertfile} converts text files from one encoding to
another encoding.  It is a low-level utility that will feel familiar
to those of you who have used the Unix command {cmd:iconv} or the
similar International Components for Unicode (ICU)-based command
{cmd:uconv}.  If you need to convert Stata datasets ({cmd:.dta}) or text files
commonly used with Stata such as do-files, ado-files, help files, and
CSV (*{cmd:.csv}) files, you should use the {cmd:unicode} {cmd:translate}
command; see {manhelp unicode_translate D:unicode translate}.  If you
wish to convert individual strings or string variables in your dataset,
use the {helpb ustrfrom()} and {helpb ustrto()} functions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D unicodeconvertfileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:srcencoding}{cmd:(}[{it:{help strings:string}}]{cmd:)}
specifies the source file encoding.  See
{help encodings:help encodings} for a list of common encodings
and advice on choosing an encoding.

{phang}
{cmd:dstencoding}{cmd:(}[{it:{help strings:string}}]{cmd:)}
specifies the destination file encoding.  See
{help encodings:help encodings} for a list of common encodings
and advice on choosing an encoding.

{phang}
{cmd:srccallback(}{it:{help unicode_convertfile##method:method}}{cmd:)}
specifies the method for handling characters in the source file that cannot
be converted.

{phang}
{cmd:dstcallback(}{it:{help unicode_convertfile##method:method}}{cmd:)}
specifies the method for handling characters that are not supported in the
destination encoding.

{phang}
{opt replace} permits {cmd:unicode convertfile} to overwrite an existing
destination file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help unicode_convertfile##remarks1:Conversion between encodings}
        {help unicode_convertfile##remarks2:Invalid and unsupported characters}


{marker remarks1}{...}
{title:Conversion between encodings}

{pstd}
{cmd:unicode convertfile} is a utility to convert strings from one
encoding to another.  Encoding is the method by which text is stored in
a computer.  It maps a character to a nonnegative integer, called a code
point, and then maps that integer to a single byte or a sequence of bytes.
Common encodings are ASCII, UTF-8, and UTF-16.  Stata uses UTF-8
encoding for storing text.  Unless otherwise noted, the terms "Unicode
string" and "Unicode character" in Stata refer to a UTF-8 encoded
Unicode string or character.  For more information about encodings, see
{findalias frencodings}.  See
{help encodings:help encodings} for a list of common encodings, and see
{manhelp unicode_encoding D:unicode encoding} for a utility to find all
available encodings.

{pstd}
If you are using {cmd:unicode} {cmd:convertfile} to convert a file to UTF-8
format, the string encoding using by Stata, you only need to specify the
encoding of the source file.  By default, UTF-8 is selected as the
encoding for the destination file.  You can also use {cmd:unicode}
{cmd:convertfile} to convert files from UTF-8 encoding to another
encoding.  Although conversion to or from UTF-8 is the most
common usage, you can use {cmd:unicode} {cmd:convertfile} to convert
files between any pair of encodings.

{pstd}
Be aware that some characters may not be shared across encodings.  The
next section explains options for dealing with unsupported characters.


{marker remarks2}{...}
{title:Invalid and unsupported characters}
 
{pstd}
Unsupported characters generally occur in two ways: the bytes used to encode a
character in the source encoding are not valid in the destination
encoding such as UTF-8 (called an invalid sequence); or the character
from the source encoding does not exist in the destination encoding.

{pstd}
It is common to encounter inconvertible characters when converting from
a Unicode encoding such as UTF-8 to some other encoding.
UTF-8 supports more than 100,000 characters.
Depending on the characters in your file and the destination encoding you
select, it is possible that not all characters will be supported.  For
example, ASCII only supports 128 characters, so all Unicode characters
with code points greater than 127 are unsupported in ASCII encoding.


{marker examples}{...}
{title:Examples}

{pstd}Convert file from Latin1 encoding to UTF-8 encoding{p_end}
{phang2}{cmd:. unicode convertfile data.csv data_utf8.csv, srcencoding(ISO-8859-1)}

{pstd}Convert file from UTF-32 encoding to UTF-16 encoding, skipping any invalid sequences in the source file{p_end}
{phang2}{cmd:. unicode convertfile utf32file.txt utf16file.txt, srcencoding(UTF-32) dstencoding(UTF-16) srccallback(skip)}
{p_end}
