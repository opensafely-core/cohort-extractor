{smcl}
{* *! version 1.1.26  29jan2019}{...}
{vieweralsosee "[P] file" "mansection P file"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] filefilter" "help filefilter"}{...}
{vieweralsosee "[D] hexdump" "help hexdump"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] import delimited" "help import delimited"}{...}
{vieweralsosee "[D] infix" "help infix"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "file##syntax"}{...}
{viewerjumpto "Description" "file##description"}{...}
{viewerjumpto "Links to PDF documentation" "file##linkspdf"}{...}
{viewerjumpto "Options" "file##options"}{...}
{viewerjumpto "Text output specifications" "file##text_output"}{...}
{viewerjumpto "Remarks" "file##remarks"}{...}
{viewerjumpto "Stored results" "file##stored_results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[P] file} {hline 2}}Read and write text and binary files{p_end}
{p2col:}({mansection P file:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Open file

{p 8 19 2}
{cmd:file} {cmd:open}
{space 1}{it:handle}
{cmd:using} {it:{help filename}}{cmd:,}
{c -(}{cmdab:r:ead}|{cmdab:w:rite}|{cmdab:r:ead} {cmdab:w:rite}{c )-}
[
[{cmdab:t:ext}|{cmdab:b:inary}]
[{cmd:replace}|{cmd:append}]
{cmd:all}
]


    Read file

{p 8 19 2}
{cmd:file} {cmdab:r:ead} {space 1}{it:handle} [{it:specs}]


    Write to file

{p 8 19 2}
{cmd:file} {cmdab:w:rite} {it:handle} [{it:specs}]


    Change current location in file

{p 8 19 2}
{cmd:file} {cmd:seek} {space 1}{it:handle}
{c -(}{cmdab:q:uery}|{cmd:tof}|{cmd:eof}|{it:#}{c )-}


    Set byte order of binary file

{p 8 19 2}
{cmd:file} {cmd:set} {space 2}{it:handle}
{cmd:byteorder}
{c -(}{cmd:hilo}|{cmd:lohi}|{cmd:1}|{cmd:2}{c )-}


    Close file

{p 8 19 2}
{cmd:file} {cmd:close}
{c -(}{it:handle}|{cmd:_all}{c )-}


    List file type, status, and name of handle

{p 8 19 2}
{cmd:file} {cmdab:q:uery}


{pstd}
where {it:specs} for {cmd:text} output is

	{cmd:"}{it:string}{cmd:"} or {cmd:`"}{it:string}{cmd:"'}
	{cmd:(}{it:{help exp}}{cmd:)}{col 40}(parentheses are required)
	{help format:{bf:%}{it:fmt}} {cmd:(}{it:{help exp}}{cmd:)}{col 40}(see {manhelp format D} about {cmd:%}{it:fmt})
	{cmd:_skip(}{it:#}{cmd:)}
	{cmdab:_col:umn(}{it:#}{cmd:)}
	{cmdab:_n:ewline}[{cmd:(}{it:#}{cmd:)}]
	{cmd:_char(}{it:#}{cmd:)}{col 40}({cmd:0} {ul:<} {it:#} {ul:<} {cmd:255})
	{cmd:_tab}[{cmd:(}{it:#}{cmd:)}]
	{cmd:_page}[{cmd:(}{it:#}{cmd:)}]
	{cmd:_dup(}{it:#}{cmd:)}

{pstd}
{it:specs} for {cmd:text} input is {it:localmacroname},

{pstd}
{it:specs} for {cmd:binary} output is

	{cmd:%}{c -(}{cmd:8}|{cmd:4}{c )-}{cmd:z}        {cmd:(}{it:exp}{cmd:)}
	{cmd:%}{c -(}{cmd:4}|{cmd:2}|{cmd:1}{c )-}{cmd:b}[{cmd:s}|{cmd:u}] {cmd:(}{it:exp}{cmd:)}
	{cmd:%}{it:#}{cmd:s}            {cmd:"}{it:text}{cmd:"}{col 40}({cmd:1} {ul:<} {it:#} {ul:<} {cmd:max_macrolen})
	{cmd:%}{it:#}{cmd:s}            {cmd:`"}{it:text}{cmd:"'}
	{cmd:%}{it:#}{cmd:s}            {cmd:(}{it:exp}{cmd:)}

{pstd}
and {it:specs} for {cmd:binary} input is

	{cmd:%}{c -(}{cmd:8}|{cmd:4}{c )-}{cmd:z}        {it:scalarname}
	{cmd:%}{c -(}{cmd:4}|{cmd:2}|{cmd:1}{c )-}{cmd:b}[{cmd:s}|{cmd:u}] {it:scalarname}
	{cmd:%}{it:#}{cmd:s}            {it:localmacroname}{col 40}({cmd:1} {ul:<} {it:#} {ul:<} {cmd:max_macrolen})


{marker description}{...}
{title:Description}

{pstd}
{cmd:file} is a programmer's command and should not be confused with
{helpb import delimited}, {helpb infile}, and {helpb infix}, which are the
usual ways that data are brought into Stata.  {cmd:file} allows programmers to
read and write both text and binary files, so {cmd:file} could be used
to write a program to input data in some complicated situation, but that would
be an arduous undertaking.

{pstd}
Files are referred to by a file {it:handle}.  When you open a file, you
specify the file handle that you want to use; for example, in

	{cmd:. file open myfile using example.txt, write}

{pstd}
{cmd:myfile} is the file handle for the file named {cmd:example.txt}.  From
that point on, you refer to the file by its handle.  Thus

	{cmd:. file write myfile "this is a test" _n}

{pstd}
would write the line "this is a test" (without the quotes) followed by a
new line into the file, and

	{cmd:. file close myfile}

{pstd}
would then close the file.  You may have multiple files open at the same time,
and you may access them in any order.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P fileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:read}, {cmd:write}, or {cmd:read write} is required; they specify
    how the file is to be opened.  If the file is opened {cmd:read},
    you can later use {cmd:file} {cmd:read} but not {cmd:file}
    {cmd:write}; if the file is opened {cmd:write}, you can later use
    {cmd:file} {cmd:write} but not {cmd:file} {cmd:read}.  If the file
    is opened {cmd:read} {cmd:write}, you can then use both.

{pmore}
    {cmd:read} {cmd:write} is more flexible, but most programmers open
    files purely {cmd:read} or purely {cmd:write} because that is all that is
    necessary; it is safer and it is faster.

{pmore}
    When a file is opened {cmd:read}, the file must already exist, or an
    error message will be issued.  The file is positioned at the top
    (tof), so the first {cmd:file} {cmd:read} reads at the beginning of the
    file.  Both local files and files over the net may be opened for
    {cmd:read}.

{pmore}
    When a file is opened {cmd:write} and the {cmd:replace} or
    {cmd:append} option is not specified, the file must not exist, or an error
    message will be issued.  The file is positioned at the top (tof), so the
    first {cmd:file} {cmd:write} writes at the beginning of the file.  Net
    files may not be opened for {cmd:write}.

{pmore}
    When a file is opened {cmd:write} and the {cmd:replace} option is also
    specified, it does not matter whether the file already exists; the
    existing file, if any, is erased beforehand.

{pmore}
    When a file is opened {cmd:write} and the {cmd:append} option is also
    specified, it also does not matter whether the file already exists; the
    file will be reopened or created if necessary.  The file will be
    positioned at the append point, meaning that if the file existed, the
    first {cmd:file} {cmd:write} will write at the first byte past the end of
    the previous file; if there was no previous file, {cmd:file} {cmd:write}
    begins writing at the first byte in the file.  {cmd:file} {cmd:seek} may
    not be used with {cmd:write} {cmd:append} files.

{pmore}
    When a file is opened {cmd:read} {cmd:write}, it also does not matter
    whether the file exists.  If the file exists, it is reopened.  If the
    file does not exist, a new file is created.  Regardless, the file will be
    positioned at the top of the file.  You can use {cmd:file} {cmd:seek} to
    seek to the end of the file or wherever else you desire.  Net files may
    not be opened for {cmd:read} {cmd:write}.

{pmore}
    Before opening a file, you can determine whether it exists by using
    {cmd:confirm} {cmd:file}; see {manhelp confirm P}.

{phang}
{cmd:text} and {cmd:binary} determine how the file is to be treated once it is
    opened.  {cmd:text} is the default.  With {cmd:text}, files are
    assumed to be composed of lines of characters, with each line ending
    in a line-end character.  The character varies across operating systems,
    being line feed under Unix, carriage return under Mac, and carriage
    return/line feed under Windows.  {cmd:file} understands all the ways that
    lines might end when reading and assumes lines are to end in the usual way
    for the computer being used when writing.

{pmore}
    The alternative to {cmd:text} is {cmd:binary}, meaning that the file is
    to be viewed merely as a stream of bytes.  With {cmd:binary}, there is an
    issue of byte order; consider the number 1 written as a 2-byte integer.
    On some computers (called hilo), it is written as {bind:"00 01"}, and on
    other computers (called lohi), it is written as {bind:"01 00"} (with the
    least significant byte written first).  There are similar issues for 4-byte
    integers, 4-byte floats, and 8-byte floats.

{pmore}
    {cmd:file} assumes that the bytes are ordered in the way natural to the
    computer being used.  {cmd:file} {cmd:set} can be used to vary this
    assumption.  {cmd:file} {cmd:set} can be issued immediately after
    {cmd:file} {cmd:open}, or later, or repeatedly.

{phang}
    {cmd:replace} and {cmd:append} are allowed only when the file is opened for
    {cmd:write} (which does not include {cmd:read} {cmd:write}).  They
    determine what is to be done if the file already exists.  The default is
    to issue an error message and not open the file.  See the description of
    the options {cmd:read}, {cmd:write}, and {cmd:read} {cmd:write} above for
    more details.

{phang}
    {cmd:all} is allowed when the file is opened for {cmd:write} or for
    {cmd:read} {cmd:write}.  It specifies that, if the file needs to be
    created, the permissions on the file are to be set so that it is readable
    by everybody.


{marker text_output}{...}
{title:Text output specifications}

{phang}
{cmd:"}{it:string}{cmd:"} and {cmd:`"}{it:string}{cmd:"'} write {it:string}
    into the file, without the surrounding quotes.

{phang}
{cmd:(}{it:{help exp}}{cmd:)} evaluates the expression {it:exp} and writes the
result into the file.  If the result is numeric, it is written with a
{cmd:%10.0g} format, but with leading and trailing spaces removed.  If {it:exp}
evaluates to a string, the resulting string is written, with no extra leading
or trailing blanks.

{phang}
{cmd:%}{it:fmt} {cmd:(}{it:exp}{cmd:)} evaluates expression {it:exp} and
    writes the result with the specified {cmd:%}{it:fmt}.  If {it:exp}
    evaluates to a string, {cmd:%}{it:fmt} must be a string format, and,
    correspondingly, if {it:exp} evaluates to a real, a numeric format must be
    specified.  Do not confuse Stata's standard display formats with the
    binary formats {cmd:%b} and {cmd:%z} described elsewhere in this help
    file.  {cmd:file} {cmd:write} here allows Stata's display formats
    described in {manhelp format D} and allows the centering extensions (for
    example, {cmd:%~20s}) described in {manlink P display}.

{phang}
{cmd:_skip(}{it:#}{cmd:)} inserts {it:#} blanks into the file.  If
{it:#} {ul:<} {cmd:0}, nothing is written; {it:#} {ul:<} {cmd:0} is not
considered an error.

{phang}
{cmd:_column(}{it:#}{cmd:)} writes enough blanks to skip
    forward to column {it:#} of the line; if {it:#} refers to a prior
    column, nothing is displayed.  The first column of a line is numbered 1.
    Referring to a column less than 1 is not considered an error; nothing is
    displayed then.

{phang}
{cmd:_newline}[{cmd:(}{it:#}{cmd:)}], which may be abbreviated
    {cmd:_n}[{cmd:(}{it:#}{cmd:)}], outputs one end-of-line character if
    {it:#} is not specified or outputs the specified number of end-of-line
    characters.  The end-of-line character varies according to your operating
    system, being line feed under Unix, carriage return under Mac, and
    the two characters carriage return/line feed under Windows.  If
    {it:#} {ul:<} {cmd:0}, no end-of-line character is output.

{phang}
{cmd:_char(}{it:#}{cmd:)} outputs one ASCII character, being the one
    given by the ASCII code {it:#} specified.  {it:#} must be between 0 and
    255, inclusive.

{phang}
{cmd:_tab}[{cmd:(}{it:#}{cmd:)}] outputs one tab character if {it:#} is not
    specified or outputs the specified number of tab characters.  Coding
    {cmd:_tab} is equivalent to coding {cmd:_char(9)}.

{phang}
{cmd:_page}[{cmd:(}{it:#}{cmd:)}] outputs one page feed character if
    {it:#} is not specified or outputs the specified number of page feed
    characters.  Coding {cmd:_page} is equivalent to coding {cmd:_char(12)}.
    The page feed character is often called control-L.

{phang}
{cmd:_dup(}{it:#}{cmd:)} specified that the next directive is to be executed
    (duplicated) {it:#} times.  {it:#} must be greater than or equal to 0.
    If {it:#} is equal to zero, the next element is not displayed.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help file##1.1:Use of file}
	{help file##1.2:Use of file with tempfiles}
	{help file##2.1:Writing text files}
	{help file##2.2:Reading text files}
{phang2}{help file##2.3:Use of seek when reading and writing text files}{p_end}
	{help file##3.1:Reading and writing binary files}
	{help file##3.2:Writing binary files}
	{help file##3.3:Reading binary files}
{phang2}{help file##3.4:Use of seek when reading and writing binary files}{p_end}
{p 8 24 2}{help file##A1:Appendix A1:  Useful commands and functions for use with file}{p_end}
{p 8 24 2}{help file##A2:Appendix A2:  Actions of binary output formats with out-of-range values}


{marker 1.1}{...}
{title:Use of file}

{pstd}
{cmd:file} provides low-level access to file I/O.  You open the file, use
{cmd:file} {cmd:read} or {cmd:file} {cmd:write} repeatedly to read or write
the file, and then close the file with {cmd:file} {cmd:close}:

	{cmd:file open} ...
	...
	{cmd:file read}  or  {cmd:file write} ...
	...
	{cmd:file read}  or  {cmd:file write} ...
	...
	{cmd:file close} ...

{pstd}
Do not forget to close the file.  Open files tie up system resources.
Also, for files opened for write, the contents of the
file probably will not be fully written until you close the file.

{pstd}
Typing {cmd:file} {cmd:close} {cmd:_all} will close all open files, and the
{helpb clear:clear all} command closes all files as well.  These commands,
however, should not be included in programs that you write; they are included to
allow the user to reset Stata when programmers have been sloppy.

{pstd}
If you use file handles obtained from {helpb tempname}, the file will be
automatically closed when the ado-file terminates:

	{cmd:tempname myfile}
	{cmd:file open `myfile' using} ...

{pstd}
This is the only case when not closing the file is appropriate.  Use of
temporary names for file handles offers considerable advantages because
programs can be stopped because of errors or because the user presses 
{hi:Break}.


{marker 1.2}{...}
{title:Use of file with tempfiles}

{pstd}
In the rare event that you {cmd:file} {cmd:open} a {cmd:tempfile}, you must
obtain the handle from {cmd:tempname}; see {manhelp macro P}.  Temporary files
are automatically deleted when the ado- or do-file ends.  If the file is erased
before it is closed, significant problems are possible.  Using a tempname will
guarantee that the file is properly closed beforehand:

	{cmd:tempname myfile}
	{cmd:tempfile tfile}
	{cmd:file open `myfile' using "`tfile'"} ...


{marker 2.1}{...}
{title:Writing text files}

{pstd}
This is easy to do:

{phang2}{cmd:file open} {it:handle} {cmd:using} {it:filename}{cmd:, write text}
{p_end}
	{cmd:file write} {it:handle} ...
	...
	{cmd:file close} {it:handle}

{pstd}
The syntax of {cmd:file} {cmd:write} is similar to that of {cmd:display};
see {helpb display:[P] display}.  The significant difference is that
expressions must be bound in parentheses.  In {cmd:display}, you can code

	{cmd:display 2+2}

{pstd}
but using {cmd:file} {cmd:write}, you must code

	{cmd:file write} {it:handle} {cmd:(2+2)}

{pstd}
The other important difference between {cmd:file} {cmd:write} and
{cmd:display} is that {cmd:display} assumes you want the end-of-line
character output at the end of each {cmd:display} (and {cmd:display} provides
{cmd:_continue} for use when you do not want this), but {cmd:file} {cmd:write}
assumes you want an end-of-line character only when you specify it.  Thus
rather than coding "{cmd:file write} {it:handle} {cmd:(2+2)}", you probably
want to code

{phang2}{cmd:file write} {it:handle} {cmd:(2+2)} {cmd:_n}

{pstd}
Because Stata outputs end-of-line characters only where you specify, coding

{phang2}{cmd:file write} {it:handle} {cmd:"first part is " (2+2)} {cmd:_n}

{pstd}
has the same effect as coding

{phang2}{cmd:file write} {it:handle} {cmd:"first part is "}{p_end}
{phang2}{cmd:file write} {it:handle} {cmd:(2+2)} {cmd:_n}

{pstd}
or even

{phang2}{cmd:file write} {it:handle} {cmd:"first part is "}{p_end}
{phang2}{cmd:file write} {it:handle} {cmd:(2+2)}{p_end}
{phang2}{cmd:file write} {it:handle} {cmd:_n}

{pstd}
There is no limit to the line length that {cmd:file} {cmd:write} can write
because, as far as {cmd:file} {cmd:write} is concerned, {cmd:_n} is just
another character.  The {cmd:_col(}{it:#}{cmd:)} directive, however, will lose
count if you write lines of more than 2,147,483,646 characters
({cmd:_col(}{it:#}{cmd:)} skips forward to the specified column).  In general,
we recommend that you do not write lines longer than 165,199 characters because
reading lines longer than that is more difficult using {cmd:file} {cmd:read}.

{pstd}
We say that {cmd:_n} is just another character, but we should say character or
characters.  {cmd:_n} outputs the appropriate end-of-line character for your
operating system, meaning the two-character carriage return followed by
line feed under Windows, the one-character carriage return under Mac,
and the one-character line feed under Unix.


{marker 2.2}{...}
{title:Reading text files}

{pstd}
The commands for reading text files are similar to those for writing them:

{phang2}{cmd:file open} {it:handle} {cmd:using} {it:filename}{cmd:, read text}{p_end}
{phang2}{cmd:file read} {it:handle} {it:localmacroname}{p_end}
	...
	{cmd:file close} {it:handle}

{pstd}
The {cmd:file} {cmd:read} command has one syntax:

{phang2}{cmd:file read} {it:handle} {it:localmacroname}

{pstd}
One line is read from the file, and it is put in {it:localmacroname}.
For instance, to read a line from the file {cmd:myfile} and put it in the
local macro line, you code

	{cmd:file read myfile line}

{pstd}
Thereafter in your code, you can refer to {cmd:`line'} to obtain the contents
of the line just read.  The following program will do a reasonable job of
displaying the contents of the file, putting line numbers in front of the lines:

	{cmd:program ltype}
		{cmd:version {ccl stata_version}}
		{cmd:local 0 `"using `0'"'}
		{cmd:syntax using/}
		{cmd:tempname fh}
		{cmd:local linenum = 0}
		{cmd:file open `fh' using `"`using'"', read}
		{cmd:file read `fh' line}
		{cmd:while r(eof)==0 {c -(}}
			{cmd:local linenum = `linenum' + 1}
			{cmd:display %4.0f `linenum' _asis `"  `macval(line)'"'}
			{cmd:file read `fh' line}
		{cmd:{c )-}}
		{cmd:file close `fh'}
	{cmd:end}

{pstd}
In the program above, we used {cmd:tempname} to obtain a temporary
name for the file handle.  Doing that, we ensure that the file will be closed
even if the user presses {hi:Break} while our program is displaying lines, and
so never executes {cmd:file close `fh'}.  In fact, our {cmd:file close `fh'}
line is unnecessary.

{pstd}
We also used {cmd:r(eof)} to determine when the file ends.  {cmd:file}
{cmd:read} sets {cmd:r(eof)} to contain 0 before end of file and 1 once
end of file is encountered; see
{it:{help file##stored_results:Stored results}}.

{pstd}
We included {cmd:_asis} in the {cmd:display} in case the
file contained braces or SMCL commands.  These would be interpreted,
and we wanted to suppress that interpretation so that {cmd:ltype} would
display lines exactly as written in the file; see {manhelp smcl P}.  We also
used the {mansection P macroRemarksandexamplesmacval():{bf:macval()}} macro
function to obtain what was in {cmd:`line'} without recursively expanding the
contents of line.


{marker 2.3}{...}
{title:Use of seek when reading and writing text files}

{pstd}
You may use {cmd:file} {cmd:seek} when reading or writing text files, although,
in fact, it is seldom used, except with {cmd:read} {cmd:write} files and,
even then, it is seldom used with text files.

{pstd}
See {it:{help file##3.4:Use of seek when reading and writing binary files}}
below for a description of {cmd:file} {cmd:seek} -- {cmd:seek}
works the same way with both text and binary files -- and then bear the
following in mind:

{p 8 11 2}
o{space 2}The {it:#} in "{cmd:file} {cmd:seek} {it:handle} {it:#}" refers
 to byte position, not line number.  "{cmd:file} {cmd:seek} {it:handle}
 {cmd:5}" means to seek to the fifth byte of the file, not the fifth line.

{p 8 11 2}
o{space 2}When calculating byte offsets by hand, remember that the end-of-line
 character is 1 byte under Mac and Unix but is 2 bytes under Windows.

{p 8 11 2}
o{space 2}Rewriting a line of an text file works as expected only if
 the new and old lines are of the same length.


{marker 3.1}{...}
{title:Reading and writing binary files}

{pstd}
Consider whether you wish to read this section.  There are many potential
pitfalls associated with binary files, and, at least in theory, a poorly
written binary-I/O program can cause Stata to crash.

{pstd}
Binary files are made up of binary elements, of which Stata can understand
the following:

    Element                                          Corresponding format
    {hline 69}
    single- and multiple-character strings           {cmd:%1s} and {cmd:%}{it:#}{cmd:s}
    signed and unsigned 1-byte binary integers       {cmd:%1b}, {cmd:%1bs}, and {cmd:%1bu}
    signed and unsigned 2-byte binary integers       {cmd:%2b}, {cmd:%2bs}, and {cmd:%2bu}
    signed and unsigned 4-byte binary integers       {cmd:%4b}, {cmd:%4bs}, and {cmd:%4bu}
    4-byte IEEE floating-point numbers               {cmd:%4z}
    8-byte IEEE floating-point numbers               {cmd:%8z}
    {hline 69}

{pstd}
The differences between all of these types are only of interpretation.  For
instance, the decimal number 72, stored as a 1-byte binary integer, also
represents the character H.  If a file contained the 1-byte integer 72 and you
were to read the byte by using the format {cmd:%1s}, you would get back the
character "H", and if a file contained the character "H" and you were to read
the byte by using the format {cmd:%1bu}, you would get back the number 72; 72
and H are indistinguishable in that they represent the same bit pattern.
Whether that bit pattern represents 72 or H depends on the format you use,
which is to say, the interpretation you give to the field.

{pstd}
Similar equivalence relations hold between the other elements.
A binary file is nothing more than a sequence of unsigned 1-byte integers,
where those integers are sometimes given different interpretations or are
grouped and given an interpretation. In fact, all you need is the format
{cmd:%1bu} and you could read or write anything.  The other formats, however,
make programming more convenient.

                                                                    Missing
    Format  Length   Type               Minimum         Maximum     values?
    {hline 71}
    {cmd:%1bu}      1    unsigned byte              0             255       no
    {cmd:%1bs}      1    signed byte             -127             127       no
    {cmd:%1b}       1    Stata byte              -127             100       yes

    {cmd:%2bu}      2    unsigned short int         0          65,535       no
    {cmd:%2bs}      2    signed short int     -32,767          32,767       no
    {cmd:%2b}       2    Stata int            -32,767          32,740       yes

    {cmd:%4bu}      4    unsigned int             647   4,294,967,295       no
    {cmd:%4bs}      4    signed int    -2,147,483,647   2,147,483,647       no
    {cmd:%4b}       4    Stata long    -2,147,483,647   2,147,483,620       yes

    {cmd:%4z}       4    float                 -10^38           10^38       yes
    {cmd:%8z}       8    double               -10^307          10^307       yes
    {hline 71}

{pstd}
When you write a binary file, you must decide on the format you will use
for every element that you will write.  When you read a binary file, you must
know ahead of time the format that was used for each element.


{marker 3.2}{...}
{title:Writing binary files}

{pstd}
As with text files, you open the file, write repeatedly, and then close
the file:

{phang2}{cmd:file open} {it:handle} {cmd:using} {it:filename}{cmd:, write binary}{p_end}
	{cmd:file write} {it:handle} ...
	...
	{cmd:file close} {it:handle}

{pstd}
The {cmd:file} {cmd:write} command may include the following elements:

	{cmd:%}{c -(}{cmd:8}|{cmd:4}{c )-}{cmd:z}        {cmd:(}{it:exp}{cmd:)}
	{cmd:%}{c -(}{cmd:4}|{cmd:2}|{cmd:1}{c )-}{cmd:b}[{cmd:s}|{cmd:u}] {cmd:(}{it:exp}{cmd:)}
	{cmd:%}{it:#}{cmd:s}            {cmd:"}{it:text}{cmd:"}{col 40}(1 {ul:<} {it:#} {ul:<} {cmd:max_macrolen})
	{cmd:%}{it:#}{cmd:s}            {cmd:`"}{it:text}{cmd:"'}
	{cmd:%}{it:#}{cmd:s}            {cmd:(}{it:exp}{cmd:)}

{pstd}
For instance, to write "test file" followed by 2, 2+2, and 3*2 represented in
its various forms, you could code

{phang2}{cmd:. file write} {it:handle} {cmd:%9s "test file" %8z (2) %4b (2+2) %1bu (3*2)}

{pstd}
or

{phang2}{cmd:. file write} {it:handle} {cmd:%9s "test file"}{p_end}
{phang2}{cmd:. file write} {it:handle} {cmd:%8z (2) %4b (2+2) %1bu (3*2)}

{pstd}
or even

{phang2}{cmd:. file write} {it:handle} {cmd:%9s "test file" }{p_end}
{phang2}{cmd:. file write} {it:handle} {cmd:%8z (2) }{p_end}
{phang2}{cmd:. file write} {it:handle} {cmd:%4b (2+2) %1bu (3*2)}

{pstd}
etc.

{pstd}
You write strings with the {cmd:%}{it:#}{cmd:s} format and numbers with the
{cmd:%b} or {cmd:%z} formats.  Concerning strings, the {it:#} in
{cmd:%}{it:#}{cmd:s} should be greater than or equal to the length of the
string to be written in bytes.  If {it:#} is too small, only that many
characters of the string will be written.  Thus

{phang2}{cmd:. file write} {it:handle} {cmd:%4s "test file"}

{pstd}
would write "test" into the file and leave the file positioned at the fifth
byte.  There is nothing wrong with coding that (the "test" can be read back
easily enough), but this is probably not what you intended to write.

{pstd}
Also concerning strings, you can output string literals -- just enclose the
string in quotes -- or you can output the results of string expressions.
Expressions, as for using {cmd:file} {cmd:write} to output text
files, must be enclosed in parentheses:

{phang2}{cmd:. file write} {it:handle} {cmd:%4s (substr(a,2,6))}

{pstd}
The following program will output a user-specified matrix to a user-specified
file; the syntax of the command being implemented is

{phang2}{cmd:mymatout1} {it:matname} {cmd:using} {it:filename} [{cmd:, replace}]

{pstd}
and the code is

	{cmd:program mymatout1}
		{cmd:version {ccl stata_version}}
		{cmd:gettoken mname 0 : 0 }
		{cmd:syntax using/ [, replace]}

		{cmd:local r = rowsof(`mname')}
		{cmd:local c = colsof(`mname')}

		{cmd:tempname hdl}
		{cmd:file open `hdl' using `"`using'"', `replace' write binary}

		{cmd:file write `hdl' %2b (`r') %2b (`c')}
		{cmd:forvalues i=1(1)`r' {c -(}}
			{cmd:forvalues j=1(1)`c' {c -(}}
				{cmd:file write `hdl' %8z (`mname'[`i',`j'])}
			{cmd:{c )-}}
		{cmd:{c )-}}
		{cmd:file close `hdl'}
	{cmd:end}

{pstd}
A significant problem with {cmd:mymatout1} is that, if we wrote a matrix
on our Unix computer (an Intel-based computer) and copied the file to a
SPARC-based computer, we would discover that we could not read the file.  Intel
computers write multiple-byte numbers with the least-significant byte first;
SPARC-based computers write the most-significant byte first.  Who knows what
your computer does?  Thus even though there is general agreement across
computers on how numbers and characters are written, this byte-ordering
difference is enough to stop binary files.

{pstd}
{cmd:file} can handle this problem for you, but you have to insert a little
code.  The recommended procedure is this:  before writing any numbers
in the file, write a field saying which byte order this computer uses (see
{helpb byteorder()} function).
Later, when we write the command
to read the file, it will read the ordering that we recorded.  We will then tell
{cmd:file} which byte ordering the file is using, and {cmd:file} itself will
reorder the bytes if that is necessary.  There are other ways we could
handle this -- such as always writing in a known byte order -- but
the recommended procedure is better because it is, on average, faster.  Most
files are read on the same computer that wrote them, and thus the computer
wastes no time rearranging bytes then.

{pstd}
The improved version of {cmd:mymatout1} is

	program {cmd:mymatout2}
		version {ccl stata_version}
		gettoken mname 0 : 0
		syntax using/ [, replace]

		local r = rowsof(`mname')
		local c = colsof(`mname')

		tempname hdl
		file open `hdl' using `"`using'"', `replace' write binary

  /* new */     {cmd:file write `hdl' %1b (byteorder())}

		file write `hdl' %2b (`r') %2b (`c')
		forvalues i=1(1)`r' {c -(}
			forvalues j=1(1)`c' {c -(}
				file write `hdl' %8z (`mname'[`i',`j'])
			{c )-}
		{c )-}
		file close `hdl'
	end

{pstd}
{cmd:byteorder()} returns 1 if the machine is hilo and 2 if lohi, but all that
matters is that it is small enough to fit in a byte.  The important thing is
that we write this number using {cmd:%1b}, about which there is no
byte-ordering disagreement.  What we do with this number we will deal with
later.

{pstd}
The second significant problem with our program is that it does not write a
signature.  Binary files are difficult to tell apart: they all look like
binary junk.  It is important that we include some sort of marker at the top
saying who wrote this file and in what format it was written.  That is called
a signature.  The signature we will use is

			{cmd:mymatout 1.0.0}

{pstd}
We will write that 14-byte-long string first thing in the file so that
later, when we write {cmd:mymatin}, we can read the string and verify that it
contains what we expect.  Signature lines should always contain a generic
identity ({cmd:mymatout} here) along with a version number, which we
can change if we modify the output program to change the output format.  This
way, the wrong input program cannot be used with a more up-to-date file format.

{pstd}
Our improved program is

	program {cmd:mymatout3}
		version {ccl stata_version}
		gettoken mname 0 : 0
		syntax using/ [, replace]

		local r = rowsof(`mname')
		local c = colsof(`mname')

		tempname hdl
		file open `hdl' using `"`using'"', `replace' write binary

  /* new */     {cmd:file write `hdl' %14s "mymatout 1.0.0"}
		file write `hdl' %1b (byteorder())

		file write `hdl' %2b (`r') %2b (`c')
		forvalues i=1(1)`r' {c -(}
			forvalues j=1(1)`c' {c -(}
				file write `hdl' %8z (`mname'[`i',`j'])
			{c )-}
		{c )-}
		file close `hdl'
	end

{pstd}
This program works well.  After we wrote the corresponding
input routine (see {it:{help file##3.3:Reading binary files}} below),
however, we noticed that our restored matrices lacked their original row and
column names, which led to a final round of changes:

	program {cmd:mymatout4}
		version {ccl stata_version}
		gettoken mname 0 : 0
		syntax using/ [, replace]

		local r = rowsof(`mname')
		local c = colsof(`mname')

		tempname hdl
		file open `hdl' using `"`using'"', `replace' write binary

  /* changed */ file write `hdl' %14s "mymatout 1.0.{cmd:1}"
		file write `hdl' %1b (byteorder())
		file write `hdl' %2b (`r') %2b (`c')

  /* new */     {cmd:local names : rownames `mname'}
  /* new */     {cmd:local len : length local names}
  /* new */     {cmd:file write `hdl' %4b (`len') %`len's `"`names'"'}

  /* new */     {cmd:local names : colnames `mname'}
  /* new */     {cmd:local len : length local names}
  /* new */     {cmd:file write `hdl' %4b (`len') %`len's `"`names'"'}

		forvalues i=1(1)`r' {c -(}
			forvalues j=1(1)`c' {c -(}
				file write `hdl' %8z (`mname'[`i',`j'])
			{c )-}
		{c )-}
		file close `hdl'
	end

{pstd}
In this version, we added the lines necessary to write the row and column
names into the file.  We write the row names by coding

		{cmd:local names : rownames `mname'}
		{cmd:local len : length local names}
		{cmd:file write `hdl' %4b (`len') %`len's `"`names'"'}

{pstd}
and we similarly write the column names.  The interesting thing here is
that we need to write a string into our binary file for which the length
of the string varies.  One solution would be

		{cmd:file write `hdl' %165199s `"`mname'"'}

{pstd}
but that would be inefficient because, in general, the names are much shorter
than 165,199 bytes.  The solution is to obtain the length of the string
to be written and then write the length into the file.  In the above
code, macro {cmd:`len'} contains the length, we write {cmd:`len'} as a
4-byte integer, and then we write the string using a {cmd:%`len's} format.
Consider what happens when {cmd:`len'} is, say, 50.  We write 50 into the
file, and then we write the string using a {cmd:%50s} format.  Later, when
we read back the file, we can reverse this process, reading the length
and then using the appropriate format.

{pstd}
We also changed the signature from "mymatout
1.0.0" to "mymatout 1.0.1" because the file format changed.
Making that change ensures that an old read program does not attempt to read
a more modern format (and so produce incorrect results).

{hline}
{p 4 4 4}
    {it:Technical note:}
    You may write strings using {cmd:%}{it:#}{cmd:s} formats that are
    narrower than, equal to, or wider than the length of the string being
    written.  When the format is too narrow, only that many characters of
    the string are written.  When the format and string are of the same width,
    the entire string is written.  When the format is wider than the string,
    the entire string is written, and then the excess positions in the file
    are filled with binary zeros.

{p 4 4 4}
    Binary zeros are special in strings because binary denotes the end of the
    string.  Thus when you read back the string, even if it was written in a
    field that was too wide, it will appear exactly as it appeared originally.
{p_end}
{hline}


{marker 3.3}{...}
{title:Reading binary files}

{pstd}
You read binary files just as you wrote them,

{phang2}{cmd:file open} {it:handle} {cmd:using} {it:filename}{cmd:, read binary}{p_end}
	{cmd:file read} {it:handle} ...
	...
	{cmd:file close} {it:handle}

{pstd}
When reading them, you must be careful to specify the same formats as you did
when you wrote the file.

{pstd}
The program that will read the matrices written by {cmd:mymatout1}, presented
below, has the syntax

	{cmd:mymatin1} {it:matname} {it:filename}

{pstd}
and the code is

	{cmd:program mymatin1}
		{cmd:version {ccl stata_version}}
		{cmd:gettoken mname 0 : 0 }
		{cmd:syntax using/}

		{cmd:tempname hdl}
		{cmd:file open `hdl' using `"`using'"', read binary}

		{cmd:tempname val}
		{cmd:file read `hdl' %2b `val'}
		{cmd:local r = `val'}
		{cmd:file read `hdl' %2b `val'}
		{cmd:local c = `val'}

		{cmd:matrix `mname' = J(`r', `c', 0)}
		{cmd:forvalues i=1(1)`r' {c -(}}
			{cmd:forvalues j=1(1)`c' {c -(}}
				{cmd:file read `hdl' %8z `val'}
				{cmd:matrix `mname'[`i',`j'] = `val'}
			{cmd:{c )-}}
		{cmd:{c )-}}
		{cmd:file close `hdl'}
	{cmd:end}

{pstd}
When {cmd:file} {cmd:read} reads numeric values, they are always stored into
{cmd:scalar}s (see {helpb scalar:[P] scalar}), and you specify the name of the
scalar directly after the binary numeric format.  Here we are using the scalar
named {cmd:`val'}, where {cmd:`val'} is a name that we obtained from
{cmd:tempname}.  We could just as well have used a fixed name, say
{cmd:myscalar}, so the first {cmd:file} {cmd:read} would read

		{cmd:file read `hdl' %2b myscalar}

{pstd}
and we would similarly substitute {cmd:myscalar} everywhere {cmd:`val'}
appears, but that would make our program less elegant.  If the user had
previously stored a value under the name {cmd:myscalar}, our values would
replace it.

{pstd}
In the second version of {cmd:mymatout}, we included the byte order.  The
correspondingly improved version of {cmd:mymatin} is

	program {cmd:mymatin2}
		version {ccl stata_version}
		gettoken mname 0 : 0
		syntax using/

		tempname hdl
		file open `hdl' using `"`using'"', read binary

		tempname val
  /* new */     {cmd:file read `hdl' %1b `val'}
  /* new */     {cmd:local border = `val'}
  /* new */     {cmd:file set `hdl' byteorder `border'}

		file read `hdl' %2b `val'
		local r = `val'
		file read `hdl' %2b `val'
		local c = `val'

		matrix `mname' = J(`r', `c', 0)
		forvalues i=1(1)`r' {c -(}
			forvalues j=1(1)`c' {c -(}
				file read `hdl' %8z `val'
				matrix `mname'[`i',`j'] = `val'
			{c )-}
		{c )-}
		file close `hdl'
	end

{pstd}
We simply read back the value we recorded and then {cmd:file} {cmd:set} it.
We cannot directly {cmd:file} {cmd:set} {it:handle} {cmd:byteorder}
{cmd:`val'} because {cmd:`val'} is a scalar and the syntax for {cmd:file}
{cmd:set} {cmd:byteorder} is

{p 8 19 2}
{cmd:file} {cmd:set} {it:handle} {cmd:byteorder}
{c -(}{cmd:hilo}|{cmd:lohi}|{cmd:1}|{cmd:2}{c )-}

{pstd}
That is, {cmd:file} {cmd:set} is willing to see a number ({cmd:1} and
{cmd:hilo} mean the same thing, as do {cmd:2} and {cmd:lohi}), but that
number must be a literal (the character {cmd:1} or {cmd:2}), so we had to copy
{cmd:`val'} into a macro before we could use it.  Once we set the byte order,
however, we could from then on depend on {cmd:file} to reorder the bytes for
us should that be necessary.

{pstd}
In the third version of {cmd:mymatout}, we added a signature.  In the
modification below, we read the signature by using a {cmd:%14s} format.
Strings are copied into local macros, and we must specify the name of the local
macro following the format:

	program {cmd:mymatin3}
		version {ccl stata_version}
		gettoken mname 0 : 0
		syntax using/

		tempname hdl
		file open `hdl' using `"`using'"', read binary

  /* new */     {cmd:file read `hdl' %14s signature}
  /* new */     {cmd:if "`signature'" != "mymatout 1.0.0" {c -(}}
  /* new */             {cmd:disp as err "file not mymatout 1.0.0"}
  /* new */             {cmd:exit 610}
  /* new */     {cmd:{c )-}}

		tempname val
		file read `hdl' %1b `val'
		local border = `val'
		file set `hdl' byteorder `border'

		file read `hdl' %2b `val'
		local r = `val'
		file read `hdl' %2b `val'
		local c = `val'

		matrix `mname' = J(`r', `c', 0)
		forvalues i=1(1)`r' {c -(}
			forvalues j=1(1)`c' {c -(}
				file read `hdl' %8z `val'
				matrix `mname'[`i',`j'] = `val'
			{c )-}
		{c )-}
		file close `hdl'
	end

{pstd}
In the fourth and final version, we wrote the row and column names.  
We wrote the names by first preceding them by a 4-byte integer
recording their width:

	program {cmd:mymatin4}
		version {ccl stata_version}
		gettoken mname 0 : 0
		syntax using/

		tempname hdl
		file open `hdl' using `"`using'"', read binary

		file read `hdl' %14s signature
  /* changed */ if "`signature'" != "mymatout 1.0.{cmd:1}" {c -(}
  /* changed */         disp as err "file not mymatout 1.0.{cmd:1}"
			exit 610
		{c )-}

		tempname val
		file read `hdl' %1b `val'
		local border = `val'
		file set `hdl' byteorder `border'

		file read `hdl' %2b `val'
		local r = `val'
		file read `hdl' %2b `val'
		local c = `val'

		matrix `mname' = J(`r', `c', 0)

  /* new */     {cmd:file read `hdl' %4b `val'}
  /* new */     {cmd:local len = `val'}
  /* new */     {cmd:file read `hdl' %`len's names}
  /* new */     {cmd:matrix rownames `mname' = `names'}

  /* new */     {cmd:file read `hdl' %4b `val'}
  /* new */     {cmd:local len = `val'}
  /* new */     {cmd:file read `hdl' %`len's names}
  /* new */     {cmd:matrix colnames `mname' = `names'}

		forvalues i=1(1)`r' {c -(}
			forvalues j=1(1)`c' {c -(}
				file read `hdl' %8z `val'
				matrix `mname'[`i',`j'] = `val'
			{c )-}
		{c )-}
		file close `hdl'
	end


{marker 3.4}{...}
{title:Use of seek when reading and writing binary files}

{pstd}
Nearly all I/O programs are written without using {cmd:file} {cmd:seek}.
{cmd:file} {cmd:seek} changes your location in the file.  Ordinarily, you
start at the beginning of the file and proceed sequentially through the bytes.
{cmd:file} {cmd:seek} lets you back up or skip ahead.

{pstd}
{cmd:file} {cmd:seek} {it:handle} {cmd:query} actually does not change your
location in the file; it merely returns in scalar {cmd:r(loc)} the
current position, with the first byte in the file being numbered 0, the second
1, and so on.  In fact, all the {cmd:file} {cmd:seek} commands return
{cmd:r(loc)}, but {cmd:file} {cmd:seek} {cmd:query} is unique because that is
all it does.

{pstd}
{cmd:file} {cmd:seek} {it:handle} {cmd:tof} moves to the beginning (top) of
the file.  This is useful with {cmd:read} files when you want to read the file
again, but you can seek to tof even with {cmd:write} files and, of course,
with {cmd:read} {cmd:write} files.  (Concerning {cmd:read} files:
you can seek to top, or any point, before or after the
end-of-file condition is raised.)

{pstd}
{cmd:file} {cmd:seek} {it:handle} {cmd:eof} moves to the end of the file.
This is useful only with {cmd:write} files (or {cmd:read} {cmd:write} files)
but may be used with {cmd:read} files, too.

{pstd}
{cmd:file} {cmd:seek} {it:handle} {it:#} moves to the specified position.
{it:#} is measured in bytes from the beginning of the file and is in the
same units as reported in {cmd:r(loc)}.  {cmd:file} {cmd:seek} {it:handle}
{cmd:0} is equivalent to {cmd:file} {cmd:seek} {it:handle} {cmd:tof}.

{hline}
{p 4 4 4}
    {it:Technical note:}
    When a file is opened {cmd:write} {cmd:append}, you may not use
    {cmd:file} {cmd:seek}.  If you need to seek in the file, open the file
    {cmd:read} {cmd:write} instead.
{p_end}
{hline}


{marker A1}{...}
{title:Appendix A1:  Useful commands and functions for use with file}

{p 5 9 2}
    o   When opening a file {cmd:read write} or {cmd:write append},
	{cmd:file}'s actions differ depending upon whether the file
	already exists.  {cmd:confirm file} (see {helpb confirm:[P] confirm})
	can tell you whether a file exists; use it before opening the file.

{p 5 9 2}
    o   To obtain the length of strings when writing binary files, use the
	macro function {cmd:length}:

	    {cmd:local length : length local mystr}
	    {cmd:file write} {it:handle} {cmd:%`length's `"`mystr'"'}

{p 9 9 2}
	See {it:{help macro##parsing_desc:Macro functions for parsing}} in 
	{bf:[P] macro} for details.

{p 5 9 2}
    o   To write portable binary files, we recommend writing in natural
	byte order and recording the byte order in the file.  Then the
	file can be read by reading the byte order and setting it:

	    Writing:
		{cmd:file write handle %1b (byteorder())}

	    Reading:
		{cmd:tempname mysca}
		{cmd:file read handle %1b `mysca'}
		{cmd:local b_order = `mysca'}
		{cmd:file set handle byteorder `b_order'}

{p 9 9 2}
	The {helpb byteorder()} function returns 1 or 2 depending on
	whether the computer being used records data in hilo or lohi format.


{marker A2}{...}
{title:Appendix A2:  Actions of binary output formats with out-of-range values}

{pstd}
Say that you write the number 2,137 with a {cmd:%1b} format.  What value will
you later get back when you read the field with a {cmd:%1b} format? 
Here the answer is {bf:.}, Stata's missing
value, because the {cmd:%1b} format is a variation of {cmd:%1bs} that
supports Stata's missing value.  If you wrote 2,137 with {cmd:%1bs}, it would
read back as 127; if you wrote it with {cmd:%1bu}, it would read back as
255.

{pstd}
In general, in the Stata variation, missing values are supported, and numbers
outside the range are written as missing.  In the remaining formats, the
minimum or maximum is written as

                                            Value written when value ...
  Format        Min value       Max value        Too small       Too large
  {hline 72}
   {cmd:%1bu}                 0             255                0             255
   {cmd:%1bs}              -127             127             -127             127
   {cmd:%1b}               -127             100                {bf:.}               {bf:.}

   {cmd:%2bu}                 0          65,535                0          65,535
   {cmd:%2bs}           -32,767          32,767          -32,767          32,767
   {cmd:%2b}            -32,767          32,740                {bf:.}               {bf:.}

   {cmd:%4bu}                 0   4,294,967,295                0   4,294,967,295
   {cmd:%4bs}    -2,147,483,647   2,147,483,647   -2,147,483,647   2,147,483,647
   {cmd:%4b}     -2,147,483,647   2,147,483,620                {bf:.}               {bf:.}

   {cmd:%4z}             -10^38           10^38                {bf:.}               {bf:.}
   {cmd:%8z}            -10^307          10^307                {bf:.}               {bf:.}
  {hline 72}

{pstd}
In the above table, if you write {bf:.} (missing value), take that as writing
a value larger than the maximum allowed for the type.

{pstd}
If you write a noninteger value with an integer format, the result will be
truncated to an integer.  For example, writing 124.75 with a {cmd:%2b} format
is the same as writing 124.


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:file read} stores the following in {cmd:r()}: 

{synoptset 27 tabbed}{...}
{p2col 5 27 30 2: Scalars}{p_end}
{synopt:{cmd:r(eof)}}{cmd:1} on end of file, {cmd:0} otherwise{p_end}

{synoptset 27 tabbed}{...}
{p2col 5 27 30 2: Macros}{p_end}
{synopt:{cmd:r(status)} (if {cmd:text} file)}{cmd:win}{space 4}line read; line ended in
cr-lf{p_end}
{synopt:}{cmd:mac}{space 4}line read; line ended in cr{p_end}
{synopt:}{cmd:unix}{space 3}line read; line ended in lf{p_end}
{synopt:}{cmd:split}{space 2}line read; line was too long and so split{p_end}
{synopt:}{cmd:none}{space 3}line read; line was not terminated{p_end}
{synopt:}{cmd:eof}{space 4}line not read because of end of file{p_end}

{pstd}
{cmd:r(status)}={cmd:split} indicates that {cmd:c(macrolen)} - 1
(33{cmd:maxvar}+199 for Stata/MP and Stata/SE, 165,199 for Stata/IC)
characters of the line were returned and that the next {cmd:file}
{cmd:read} will pick up where the last read left off.

{pstd}
{cmd:r(status)}={cmd:none} indicates that the entire line was returned, that
no line-end character was found, and that the next {cmd:file} {cmd:read} will
return {cmd:r(status)}={cmd:eof}.

{pstd}
If {cmd:r(status)}={cmd:eof} ({cmd:r(eof)}=1), then the local macro into
which the line was read contains {cmd:""}.  The local macro containing
{cmd:""}, however, does not imply end of file because the line might simply
have been empty.

{pstd}
{cmd:file seek} stores the following in {cmd:r()}:

{synoptset 27 tabbed}{...}
{p2col 5 27 30 2: Scalars}{p_end}
{synopt:{cmd:r(loc)}}current position of the file{p_end}

{pstd}
{cmd:file query} stores the following in {cmd:r()}:

{synoptset 27 tabbed}{...}
{p2col 5 27 30 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of open files{p_end}
{p2colreset}{...}
