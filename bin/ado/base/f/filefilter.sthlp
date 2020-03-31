{smcl}
{* *! version 1.2.10  19oct2017}{...}
{vieweralsosee "[D] filefilter" "mansection D filefilter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] file" "help file"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] changeeol" "help changeeol"}{...}
{vieweralsosee "[D] hexdump" "help hexdump"}{...}
{viewerjumpto "Syntax" "filefilter##syntax"}{...}
{viewerjumpto "Description" "filefilter##description"}{...}
{viewerjumpto "Links to PDF documentation" "filefilter##linkspdf"}{...}
{viewerjumpto "Options" "filefilter##options"}{...}
{viewerjumpto "Technical note" "filefilter##technote"}{...}
{viewerjumpto "Examples" "filefilter##examples"}{...}
{viewerjumpto "Stored results" "filefilter##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] filefilter} {hline 2}}Convert ASCII or binary patterns in
a file{p_end}
{p2col:}({mansection D filefilter:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{opt filef:ilter}
{it:oldfile}
{it:newfile}
{cmd:,}{break}
{c -(}
{opt f:rom(oldpattern)}
{opt t:o(newpattern)}{break}
{space 2}|
{opt ascii2ebcdic}
|
{opt ebcdic2ascii}
{c )-}
[{it:{help filefilter##options_table:options}}]

{p 4 4 2}
where {it:oldpattern} and {it:newpattern} for ASCII characters are

{p 13 42 2}{cmd:"}{it:string}{cmd:"} or {cmd:}{it:string}{cmd:}

{p2colset 25 40 42 2}{...}
{p2col 14 40 42 2 :{it:string}{space 2}{cmd::=} {cmd:[}{it:char}{cmd:[}{it:char}{cmd:[}{it:char}{cmd:[}{it:...}{cmd:]]]]}}{p_end}
{p2col 14 40 42 2 :{it:char}{space 4}{cmd::=} {it:regchar}{cmd: | }{it:code}}{p_end}
{p2col 14 40 42 2 :{it:regchar} {cmd::=} ASCII 32-91, 93-127, or}{p_end}
{p2col :extended ASCII 128, 161-255; excludes '\'}{p_end}
{p2col 14 40 42 2 :{it:code}{space 4}{cmd::=} {cmd:\BS}}backslash{p_end}
{p2col :{cmd:\r}}carriage return{p_end}
{p2col :{cmd:\n}}newline{p_end}
{p2col :{cmd:\t}}tab{p_end}
{p2col :{cmd:\M}}Classic Mac EOL, or \r{p_end}
{p2col :{cmd:\W}}Windows EOL, or \r\n{p_end}
{p2col :{cmd:\U}}Unix or Mac EOL, or \n{p_end}
{p2col :{cmd:\LQ}}left single quote, `{p_end}
{p2col :{cmd:\RQ}}right single quote, '{p_end}
{p2col :{cmd:\Q}}double quote, "{p_end}
{p2col :{cmd:\$}}dollar sign, ${p_end}
{p2col :{cmd:\}{it:###}{cmd:d}}3-digit [0-9] decimal ASCII{p_end}
{p2col :{cmd:\}{it:##}{cmd:h}}2-digit [0-9,A-F] hexadecimal ASCII{p_end}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{p2coldent :* {opt f:rom(oldpattern)}}find {it:oldpattern} to be
replaced{p_end}
{p2coldent :* {opt t:o(newpattern)}}use {it:newpattern} to replace
occurrences of {opt from()}{p_end}
{p2coldent :* {opt ascii2ebcdic}}convert file from ASCII to EBCDIC{p_end}
{p2coldent :* {opt ebcdic2ascii}}convert file from EBCDIC to ASCII{p_end}
{synopt :{opt r:eplace}}replace {it:newfile} if it already exists{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Both {opt from(oldpattern)} and {opt to(newpattern)} are required,
or {opt ascii2ebcdic} or {opt ebcdic2ascii} is required.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{opt filefilter} reads an input file, searching for {it:oldpattern}.
Whenever a matching pattern is found, it is replaced with {it:newpattern}.
All resulting data, whether matching or nonmatching, are then written to the
new file.

{pstd}
Because of the buffering design of {opt filefilter}, arbitrarily large files
can be converted quickly.  {opt filefilter} is also useful when traditional
editors cannot edit a file, such as when unprintable ASCII characters
are involved.  In fact, converting end-of-line characters between Macintosh,
Windows, and Unix is convenient with the EOL codes.

{pstd}
Unicode is not directly supported, but UTF-8 encoded files can be
operated on by using byte-sequence methods in some cases.

{pstd}
Although it is not mandatory, you may want to use quotes to delimit a pattern,
protecting the pattern from Stata's parsing routines.
A pattern that contains blanks must be in quotes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D filefilterQuickstart:Quick start}

        {mansection D filefilterRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opt from(oldpattern)} specifies the pattern to be found and
replaced.  It is required unless {opt ascii2ebcdic} or {opt ebcdic2ascii} is
specified.

{phang}{opt to(newpattern)} specifies the pattern used to replace
occurrences of {opt from()}.  It is required unless {opt ascii2ebcdic}
or {opt ebcdic2ascii} is specified.

{phang}{opt ascii2ebcdic} specifies that characters in the file be
converted from ASCII coding to EBCDIC coding.  {opt from()}, {opt to()},
and {opt ebcdic2ascii} are not allowed with {opt ascii2ebcdic}.

{phang}{opt ebcdic2ascii} specifies that characters in the file be
converted from EBCDIC coding to ASCII coding.  {opt from()}, {opt to()},
and {opt ascii2ebcdic} are not allowed with {opt ebcdic2ascii}.

{phang}{opt replace} specifies that {it:newfile} be replaced if it
already exists.


{marker technote}{...}
{title:Technical note}

{pstd}
Unicode is not directly supported, but you can try to
operate on a UTF-8 encoded Unicode file by working on the byte sequence
representation of the UTF-8 encoded Unicode character.  For example, the
Unicode character {bf:é}, the Latin small letter "e" with an acute accent
(Unicode code point {bf:\u00e9}), has the byte sequence representation
(195,169).  You can obtain the byte sequence by using
{helpb f_tobytes:tobytes("é")}.  Although you may use 195 and 169 in
{it:regchar} and {it:code}, they will be treated as two separate bytes instead
of one character {bf:é} (195 followed by 169).  In short, this goes beyond the
original design of the command and is technically unsupported.  If you try 
to use {opt filefilter} in this way, you might encounter problems.


{marker examples}{...}
{title:Examples}

{pstd}Convert Classic Mac-style EOL characters to Windows-style{p_end}
{phang2}{cmd:. filefilter macfile.txt winfile.txt, from(\M) to(\W) replace}

{pstd}Convert left quote (`) characters to the string "left quote"{p_end}
{phang2}{cmd:. filefilter auto1.csv auto2.csv, from(\LQ) to("left quote")}

{pstd}Convert the character with hexidecimal code 60 to the string "left quote"
{p_end}
{phang2}{cmd:. filefilter auto1.csv auto2.csv, from(\60h) to("left quote")}

{pstd}Convert the character with decimal code 96 to the string "left quote"
{p_end}
{phang2}{cmd:. filefilter auto1.csv auto2.csv, from(\096d) to("left quote")}

{pstd}Convert strings beginning with hexidecimal code 6B followed by
"Text" followed by decimal character 100 followed by "Text" to
an empty string (remove them from the file){p_end}
{phang2}{cmd:. filefilter file1.txt file2.txt, from("\6BhText\100dText") to("")}

{pstd}Convert file from EBCDIC to ASCII encoding{p_end}
{phang2}{cmd:. filefilter ebcdicfile.txt asciifile.txt, ebcdic2ascii}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:filefilter} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(occurrences)}}number of {it:oldpattern} found{p_end}
{synopt:{cmd:r(bytes_from)}}# of bytes represented by {it:oldpattern}{p_end}
{synopt:{cmd:r(bytes_to)}}# of bytes represented by {it:newpattern}{p_end}
{p2colreset}{...}
