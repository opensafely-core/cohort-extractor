{smcl}
{* *! version 1.0.0  25mar2015}{...}
{vieweralsosee "[U] 12.4.2.3 Encodings" "mansection U 12.4.2.3Encodings"}{...}
{vieweralsosee "[D] unicode encoding" "mansection D unicodeencoding"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "[D] unicode translate" "help unicode translate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 12.4.2 Handling Unicode strings" "mansection U 12.4.2HandlingUnicodestrings"}{...}
{viewerjumpto "Description" "encodings##description"}{...}
{viewerjumpto "Encodings" "encodings##encodings"}{...}
{title:Title}

{pstd}
Advice on choosing an encoding
{p_end}


{marker description}{...}
{title:Description}

{pstd}
You are here because you need to choose the encoding with which your
Extended ASCII data were recorded.

{pstd}
Choosing the right encoding can be daunting.  There are roughly 230
encodings with over 1,000 aliases.  We have advice.

{pstd}
If you have characters commonly used in the Latin alphabet, it is
likely that they are either {cmd:ISO-8859-1}, also known as {cmd:Latin1}, or
{cmd:Windows-1252}.  {cmd:Windows-1252} is nearly the same as
{cmd:ISO-8859-1}.  If your data came from a Windows computer, they are
likely {cmd:Windows-1252}.  If they came from the Internet, they are likely
{cmd:ISO-8859-1}.

{pstd}
If you have Japanese Extended ASCII characters, they are probably
{cmd:Shift_JIS} or {cmd:Windows-932}, or (less likely) {cmd:EUC-JP}.

{pstd}
Try each.  Look at the result in Stata's Data Editor; use
{cmd:describe}, {cmd:codebook}, and {cmd:tabulate} on the variables to
see if you are happy with the result.  If not, try another.

{pstd}
If you do not have Latin or Japanese characters, or if one of the
above encodings did not work, choose another encoding.

{pstd}
There are two ways to search.  The first is within this help file.
Use the Viewer's Edit > Find capability to search for text within this
help file.  Search based on what you know about your characters.  Are
they Cyrillic?  Search for "Cyrillic" in this file.  Do they contain
Japanese?  Search for "Japan".  Make your search simple: search for
"Japan", not "Japanese characters".

{pstd}
The second way is with the
{helpb unicode_encoding:unicode encoding list} command.  Start by
searching the Internet for advice on encodings that your data might
contain.  Wikipedia's
{browse "http://en.wikipedia.org/wiki/Character_encoding#Common_character_encodings":common character encodings} list is a good place to start.

{pstd}
Say that your data contain Greek characters.  You find
that {cmd:ISO 8859-7} and {cmd:Windows-1253} are commonly used for
Greek.  How do you specify those encodings in Stata?
Search Stata's encodings and their aliases with
{cmd:unicode} {cmd:encoding} {cmd:list}.  Specify
the smallest unique part of the encoding you wish to search for.
Rather than searching for "{cmd:Windows-1253}", simply
search for "{cmd:1253}":

{p 8 8 2}
{cmd:. unicode encoding list *1253*}

{pstd}
You find that there are two encodings that
have "{cmd:windows-1253}" as an alias.  You can use either of
these encoding names, or any of their aliases, in any Stata
function that takes an encoding as an argument or with
{helpb unicode_translate:unicode encoding set}.

{pstd}
Repeat a similar search for {cmd:ISO 8859-7}:

{p 8 8 2}
{cmd:. unicode encoding list *8859-7*}


{marker encodings}{...}
{title:Encodings}

INCLUDE help enc_list

