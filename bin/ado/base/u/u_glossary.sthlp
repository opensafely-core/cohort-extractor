{smcl}
{* *! version 1.0.0  03may2019}{...}
{* Apply text changes to p_glossary and d_glossary, too.}{...}
{vieweralsosee "[U] Glossary" "mansection U Glossary"}{...}
{viewerjumpto "Description" "u_glossary##description"}{...}
{viewerjumpto "Glossary" "u_glossary##glossary"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[U] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection U Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{marker ascii}{...}
{phang}
{bf:ASCII}.  ASCII stands for American Standard Code for Information
Interchange.  It is a way of representing text and the characters that form
text in computers.  It can be divided into two sections: plain, or
{help u_glossary##plainascii:lower, ASCII},
which includes numbers, punctuation, plain letters without diacritical marks,
whitespace characters such as space and tab, and some control characters such
as carriage return; and
{help u_glossary##extascii:extended ASCII},
which includes letters with diacritical marks as well as other special
characters.

{pmore}
Before Stata 14, datasets, do-files, ado-files, and other Stata files were
{help u_glossary##encode:encoded} using ASCII.

{marker bin0}{...}
{phang}
{bf:binary 0}.  Binary 0, also known as the null character, is traditionally
used to indicate the end of a string, such as an ASCII or
UTF-8 string.

{pmore}
Binary 0 is obtained by using {cmd:char(0)} and is sometimes displayed as
{cmd:\0}.  See {findalias frstrlbin} for more information.

{phang}
{bf:binary string}.
A binary string is, technically speaking, any string that does not contain
text.  In Stata, however, a string is only marked as binary if it contains
{help u_glossary##bin0:binary 0}, or if it contains the contents of a
file read in using the {helpb fileread()} function, or if it is the result of
a string expression containing a string that has already been marked as
binary.

{pmore}
In Stata, {cmd:strL} variables, string scalars, and Mata strings can store
binary strings.

{pmore}
See {findalias frstrlbin} for more information.

{phang}
{bf:BLOB}.
BLOB is database jargon for binary large object.  In Stata, BLOBs can be
stored in {cmd:strL}s.  Thus {cmd:strL}s can contain BLOBs such as Word
documents, JPEG images, or anything else.  See
{help u_glossary##strL:{it:strL}}.

{marker byte}{...}
{phang}
{bf:byte}.
Formally, a byte is eight binary digits (bits), the units used to record
computer data.  Each byte can also be considered as representing a value from
0 through 255.  Do not confuse this with Stata's
{helpb data_types:byte} variable storage
type, which allows values from -127 to 100 to be stored.  With regard
to strings, all strings are composed of individual characters that are
{help u_glossary##encode:encoded} using either one byte or
several bytes to represent each character.

{pmore}
For example, in {help u_glossary##utf:UTF-8}, the
encoding system used by Stata, byte value 97 encodes "a".  Byte values 195
and 161 in sequence encode "á".

{marker characteristics}{...}
{phang}
{bf:characteristics}.
Characteristics are one form of metadata about a Stata dataset and each of the
variables within the dataset.  They are typically used in programming
situations.  For example, the xt commands need to know the name of the panel
variable and possibly the time variable.  These variable names are stored in
characteristics within the dataset.  See {findalias frchars} for an overview
and {manhelp char P} for a technical description.
 
{marker code_pages}{...}
{phang}
{bf:code pages}.
A code page maps extended ASCII values to a set of characters, typically for a
specific language or set of languages.  For example, the most commonly used
code page is Windows-1252, which maps extended ASCII values to characters used
in Western European languages.  Code pages are essentially encodings for
{help u_glossary##extascii:extended ASCII} characters.

{marker codep}{...}
{phang}
{bf:code point}.
A code point is the numerical value or position that represents a single
character in a text system such as ASCII or Unicode.  The original
{help u_glossary##ascii:ASCII} encoding system
contains only 128 code points and thus can represent only 128 characters.
Historically, the 128 additional bytes of
{help u_glossary##extascii:extended ASCII} have been
encoded in many different and inconsistent ways to provide additional sets of
128 code points.  The formal Unicode specification has 1,114,112 possible code
points, of which roughly 250,000 have been assigned to actual characters.
Stata uses {help u_glossary##utf:UTF-8} encoding for
Unicode.  Note that the UTF-8-encoded version of a code point does
not have the same numeric value as the code point itself.

{marker disambig}{...}
{phang}
{bf:disambiguation: characters, and bytes, and display columns}.
A character is simply the letter or symbol that you want to represent -- the
letter "a", the punctuation mark ".", or a Chinese logogram.  A byte or
sequence of bytes is how that character is stored in the computer.  And, a
display column is the space required to display one typical character in the
fixed-width display used by Stata's Results window and Viewer.  Some
characters are too wide for one display column.  Each character is displayed
in one or two display columns.

{pmore}
For {help u_glossary##plainascii:plain ASCII} characters, the number of
characters always equals the number of bytes and equals the number of display
columns.

{pmore}
For {help u_glossary##utf:UTF-8}  characters that are not plain ASCII, there
are usually two bytes per character but there are sometimes three or even four
bytes per character, such as for Chinese, Japanese, and Korean (CJK)
characters.  Characters that are too wide to fit in one display column (such
as CJK characters) are displayed in two display columns.

{pmore}
In general, for {help u_glossary##unichar:Unicode characters}, the
relationship between the number of characters and the number of bytes and the
relationship between the number of characters and the number of display
columns is more ambiguous.  All characters can be stored in four or fewer
bytes and are displayed in Stata using two or fewer display columns.

{pmore}
See {findalias frunicodefuncs} and {findalias frdiunicode} to learn how to
deal with the distinction between characters, bytes, and display columns in
your code.

{marker dispcol}{...}
{phang}
{bf:display column}.
A display column is the space required to display one typical character in the
fixed-width display used by Stata's Results window and Viewer.  Some
characters are too wide for one display column.  Each character is displayed
in one or two display columns.

{pmore}
All {help u_glossary##plainascii:plain ASCII}
characters (for example, "M" and "9") and many
{help u_glossary##utf:UTF-8} characters that are not
plain ASCII (for example, "é") require the same space when using a
fixed-width font.  That is to say, they all require a single display column.

{pmore}
Characters from non-Latin alphabets, such as Chinese, Cyrillic, Japanese, and
Korean, may require two display columns.

{pmore}
See {findalias frdiunicode} for more information.

{marker displayfmt}{...}
{phang}
{bf:display format}.
The display format for a variable specifies how the variable will be displayed
by Stata.  For numeric variables, the display format would indicate to Stata
how many digits to display, how many decimal places to display, whether to
include commas, and whether to display in exponential format.  Numeric
variables can also be formatted as dates.  For strings, the display format
indicates whether the variable should be left-aligned or right-aligned in
displays and how many characters to display.  Display formats may be specified
by the {helpb format} command.  Display formats may
also be used with individual numeric or string values to control how they are
displayed.  Distinguish display formats from
{help u_glossary##storagetypes:storage types}.

{marker encode}{...}
{phang}
{bf:encodings}.
An encoding is a way of representing a character as a byte or
series of bytes.  Examples of encoding systems are
{help u_glossary##ascii:ASCII} and
{help u_glossary##utf:UTF-8}.  Stata uses UTF-8
encoding.

{pmore}
For more information, see {findalias frencodings}.

{marker extascii}{...}
{phang}
{bf:extended ASCII}.
Extended ASCII, also known as higher ASCII, 
is the byte values 128 to 255, which were not defined as part of the original
{help u_glossary##ascii:ASCII} specification.  Various
{help u_glossary##code_pages:code pages} have been defined over
the years to map the extended ASCII byte values to many characters not
supported in the original ASCII specification, such as Latin letters
with diacritical marks, such as "á" and "Á"; non-Latin alphabets, such
as Chinese, Cyrillic, Japanese, and Korean; punctuation marks used in
non-English languages, such as "<", complex mathematical symbols such as
"±", and more.

{pmore}
Although extended ASCII characters are stored in a single byte in
ASCII {help u_glossary##encode:encoding},
UTF-8 stores the same characters in two to four bytes.  Because each
code page maps the extended ASCII values differently, another
distinguishing feature of extended ASCII characters is that their
meaning can change across fonts and operating systems.

INCLUDE help glossary_frames

{phang}
{bf:higher ASCII}.
See {help u_glossary##extascii:{it:extended ASCII}}.

{marker immedcmd}{...}
{phang}
{bf:immediate command}.
An immediate command is a command that obtains data not from the data stored
in memory but from numbers typed as arguments.  Immediate commands never
disturb the data in memory.  See {findalias frimmediate} for an overview.

{marker locale}{...}
{phang}
{bf:locale}.
A locale is a code that identifies a community with a certain set of rules for
how their language should be written.  A locale can refer to something as
general as an entire language (for example, "en" for English) or something as
specific as a language in a particular country (for example, "en_HK" for
English in Hong Kong).

{pmore}
A locale specifies a set of rules that govern how the language should be
written.  Stata uses locales to determine how certain language-specific
operations are carried out.  For more information, see {findalias frlocales}.

{phang}
{bf:lower ASCII}.
See {help u_glossary##plainascii:{it:plain ASCII}}.

{phang}
{bf:null-terminator}.
See {help u_glossary##bin0:{it:binary 0}}.

{marker numlist}{...}
{phang}
{bf:numlist}.
A numlist is a list of numbers.  That list can be one or more arbitrary
numbers or can use certain shorthands to indicate ranges, such as {cmd:5/9} to
indicate integers 5, 6, 7, 8, and 9.  Ranges can be ascending or descending
and can include an optional increment or decrement amount, such as
{cmd:10.5(-2)4.5} to indicate 10.5, 8.5, 6.5, and 4.5.
See {findalias frnumlist} for a list of shorthands to indicate ranges.

{marker option}{...}
{phang}
{bf:option}.  A Stata option is a modifier to a Stata command that indicates
additional specifications for the command.  For example, the {cmd:detail}
option of {helpb summarize} asks Stata to specify additional statistics.  An
option is always specified following a comma after the Stata command.  See
{findalias frsyntaxop}.

{marker plainascii}{...}
{phang}
{bf:plain ASCII}.
We use plain ASCII as a nontechnical term to refer to what computer
programmers call lower ASCII. These are the plain Latin letters "a"
to "z" and "A" to "Z"; numbers "0" through "9"; many punctuation
marks, such as "!"; simple mathematical symbols, such as "+"; and whitespace
and control characters such as space (" "), tab, and carriage return.

{pmore}
Each plain ASCII characters is stored as a single byte with a value
between 0 and 127.  Another distinguishing feature is that the byte values used
to {help u_glossary##encode:encode} plain ASCII characters are the same across
different operating systems and are common between ASCII and
{help u_glossary##utf:UTF-8}.

{pmore}
Also see {help u_glossary##ascii:{it:ASCII}} and
{help u_glossary##encode:{it:encodings}}.

{marker prefixcmd}{...}
{phang}
{bf:prefix command}.  A prefix command is a command in Stata that prefixes
other Stata commands.  For example, {cmd:by} {it:varlist}{cmd::}.
The command {cmd:by} {cmd:region:} {cmd:summarize} {cmd:marriage_rate}
{cmd:divorce_rate} would summarize {cmd:marriage_rate} and {cmd:divorce_rate}
for each region separately.  See {findalias frprefix}.

{marker storagetypes}{...}
{phang}
{bf:storage types}.  A storage type is how Stata stores a variable.
The numeric storage types in Stata are {cmd:byte}, {cmd:int}, {cmd:long},
{cmd:float}, and {cmd:double}.  There is also a {cmd:string} storage type.
The storage type is specified before the variable name when a variable is
created.  See {findalias frnumtypes}, {findalias frstr}, and
{helpb data types:[D] Data types}.  Distinguish storage types from 
{help u_glossary##displayfmt:display formats}.

{phang}
{bf:str1}, {bf:str2}, ..., {bf:str2045}.
     See {help u_glossary##strL:{it:strL}}.

{marker strL}{...}
{phang}
{bf:strL}.
    {cmd:strL} is a storage type for string variables.
    The full list of string storage types is {cmd:str1}, {cmd:str2},
    ..., {cmd:str2045}, and {cmd:strL}.

{pmore}
    {cmd:str1}, {cmd:str2}, ..., {cmd:str2045} are fixed-length
    storage types.  If variable {cmd:mystr} is {cmd:str8}, then
    8 bytes are allocated in each observation to store {cmd:mystr}'s
    value.  If you have 2,000 observations, then 16,000 bytes in total
    are allocated.

{pmore}
    Distinguish between storage length and string length.  If {cmd:myvar} is
    {cmd:str8}, that does not mean the strings are 8 characters long in
    every observation.  The maximum length of strings is 8 characters.
    Individual observations may have strings of length 0, 1, ..., 8.
    Even so, every string requires 8 bytes of storage.

{pmore}
    You need not concern yourself with the storage length because
    string variables are automatically promoted.  If {cmd:myvar} is
    {cmd:str8}, and you changed the contents of {cmd:myvar} in the
    third observation to "Longer than 8", then {cmd:myvar} would
    automatically become {cmd:str13}.

{pmore}
    If you changed the contents of {cmd:myvar} in the third observation
    to a string longer than 2,045 characters, {cmd:myvar} would become
    {cmd:strL}.

{pmore}
    {cmd:strL} variables are not necessarily longer than 2,045 characters;
    they can be longer or shorter than 2,045 characters.  The real difference
    is that {cmd:strL} variables are stored as varying length.
    Pretend that {cmd:myothervar} is a {cmd:strL} and its third observation
    contains "this".  The total memory consumed by the observation would be
    64 + 4 + 1 = 69 bytes.  There would be 64 bytes of tracking information,
    4 bytes for the contents (there are 4 characters), and 1 more byte to
    terminate the string.  If the fifth observation contained a
    2,000,000-character string, then 64 + 2,000,000 + 1 = 2,000,069 bytes
    would be used to store it.

{pmore}
    Another difference between {cmd:str1}, {cmd:str2}, ..., {cmd:str2045}, and
    {cmd:strL}s is that the {cmd:str}{it:#} storage types can store only ASCII
    strings.  {cmd:strL} can store ASCII or binary strings.  Thus a {cmd:strL}
    variable could contain, for instance, the contents of a Word document or a
    JPEG image or anything else.

{pmore}
    {cmd:strL} is pronounce sturl.

{marker titlecase}{...}
{phang}
{bf:titlecase}, {bf:title-cased string}, and {bf:Unicode title-cased string}.
In grammar, titlecase refers to the capitalization of the key words in a
phrase.  In Stata, titlecase refers to (a) the capitalization of the first
letter of each word in a string and (b) the capitalization of each letter
after a nonletter character.  There is no judgment of the word's importance in
the string or whether the letter after a nonletter character is part of the
same word.  For example, "it's" in titlecase is "It'S".

{pmore}
A title-cased string is any string to which the above rules have been applied.
For example, if we used the {helpb strproper()} function with the book title
{it:Zen and the Art of Motorcycle Maintenance}, Stata would return the
title-cased string {cmd:Zen And The Art Of Motorcycle Maintenance}.

{pmore}
A Unicode title-cased string is a string that has had Unicode title-casing
rules applied to Unicode words.  This is almost, but not exactly, like
capitalizing the first letter of each Unicode word.  Like capitalization,
title-casing letters is locale-dependent, which means that the same letter
might have different titlecase forms in different locales.  For example, in
some locales, capital letters at the beginning of words are not supposed to
have accents on them, even if that capital letter by itself would have an
accent.

{pmore}
If you do not have characters beyond plain ASCII and your locale is English,
there is no distinction in results.  For example, {cmd:ustrtitle()} with an
English {help u_glossary##locale:locale} locale also would return the
title-cased string {cmd:Zen And The Art Of Motorcycle Maintenance}.

{pmore}
Use the {helpb ustrtitle()} function to apply the appropriate capitalization
rules for your language (locale).

{marker unicode}{...}
{phang}
{bf:Unicode}.
Unicode is a standard for {help u_glossary##encode:encoding}
and dealing with text written in almost any conceivable living or dead
language.  Unicode specifies a set of encoding systems that are designed to
hold (and, unlike extended ASCII, to keep separate) characters used in
different languages.  The Unicode standard defines not only the characters and
encodings for them, but also rules on how to perform various operations on
words in a given language (locale), such as capitalization and ordering.  The
most common Unicode encodings are mUTF-8, UTF-16, and
UTF-32.  Stata uses {help u_glossary##utf:UTF-8}.

{marker unichar}{...}
{phang}
{bf:Unicode character}.  Technically, a Unicode character is any character
with a Unicode {help u_glossary##encode:encoding}.
Colloquially, we use the term to refer to any character other than the
{help u_glossary##plainascii:plain ASCII}
characters.

{phang}
{bf:Unicode normalization}.
Unicode normalization allows us to use a common representation and therefore
compare Unicode strings that appear the same when displayed but could have
more than one way of being encoded.  This rarely arises in practice, but
because it is possible in theory, Stata provides the {helpb ustrnormalize()}
function for converting between different normalized forms of the same string.

{pmore}
For example, suppose we wish to search for "ñ" (the lowercase n with a
tilde over it from the Spanish alphabet).  This letter may have been
{help u_glossary##encode:encoded} with the single
{help u_glossary##codep:code point} U+00F1.  However, the
sequence U+006E (the Latin lowercase "n") followed by U+0303 (the tilde) is
defined by Unicode to be equivalent to U+00F1.  This type of visual
identicalness is called canonical equivalence.  The one-code-point form is
known as the canonical composited form, and the multiple-code-point form is
known as the canonical decomposed form.  Normalization modifies one or the
other string to the opposite canonical equivalent form so that the underlying
byte sequences match.  If we had strings in a mixture of forms, we would want
to use this normalization when sorting or when searching for strings or
substrings.

{pmore}
Another form of Unicode normalization allows characters that appear somewhat
different to be given the same meaning or interpretation.  For example, when
sorting or indexing, we may want the
{help u_glossary##codep:code point} U+FB00 (the typographic
ligature "f") to match the sequence of two Latin "f" letters
{help u_glossary##encode:encoded} as U+0066 U+0066.  This is
called compatible equivalence.

{phang}
{bf:Unicode title-cased string}.  See
{help u_glossary##titlecase:{it:titlecase, title-cased string, and Unicode title-cased string}}.

{marker utf}{...}
{phang}
{bf:UTF-8}.  UTF-8 stands for Universal character set + Transformation
Format -- 8-bit.  It is a type of
{help u_glossary##unicode:Unicode}
{help u_glossary##encode:encoding}
system that was designed for backward compatibility with
{help u_glossary##ascii:ASCII} and
is used by Stata 14.

{marker valuelabel}{...}
{phang}
{bf:value label}.  A value label defines a mapping between numeric data and
the words used to describe what those numeric values represent.  So, the
variable disease might have a value label status associated with it that maps
1 to positive and 0 to negative.  See {findalias frvallab}.

{marker varlist}{...}
{phang}
{bf:varlist}.  A varlist is a list of variables that observe certain
conventions:  variable names may be abbreviated; the asterisk notation
can be used as a shortcut to refer to groups of variables, such
as {cmd:income*} or {cmd:*1995} to refer to all variable names beginning with
{cmd:income} or all variable names ending in {cmd:1995}, respectively; and a
dash may be used to indicate all variables stored between the two listed
variables, for example, {cmd:mpg-weight}.  See {findalias frvarlists}.
{p_end}
