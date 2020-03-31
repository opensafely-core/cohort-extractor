{smcl}
{* *! version 1.2.12  22mar2018}{...}
{viewerdialog "infile (fixed format)" "dialog infile_dict"}{...}
{vieweralsosee "[D] infile (fixed format)" "mansection D infile(fixedformat)"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] infile (free format)" "help infile1"}{...}
{vieweralsosee "[D] infix (fixed forma)" "help infix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "infile2##syntax"}{...}
{viewerjumpto "Menu" "infile2##menu"}{...}
{viewerjumpto "Description" "infile2##description"}{...}
{viewerjumpto "Links to PDF documentation" "infile2##linkspdf"}{...}
{viewerjumpto "Options" "infile2##options"}{...}
{viewerjumpto "Dictionary directives" "infile2##dict_dir"}{...}
{viewerjumpto "Examples" "infile2##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[D] infile (fixed format)} {hline 2}}Import text data in fixed
format with a dictionary{p_end}
{p2col:}({mansection D infile(fixedformat):View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{opt inf:ile} {helpb using} {it:dfilename} {ifin} [{cmd:,} {it:options}]

{phang}
If {it:dfilename} is specified without an extension, {cmd:.dct} is assumed.
If {it:dfilename} contains embedded spaces, remember to enclose it in double
quotes.

{synoptset 19 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opth u:sing(infile2##filename:filename)}}text dataset filename{p_end}
{synopt :{opt clear}}replace data in memory{p_end}

{syntab :Options}
{synopt :{opt a:utomatic}}create value labels from nonnumeric data{p_end}
{synopt :{opt ebcdic}}treat text dataset as EBCDIC{p_end}
{synoptline}
{p2colreset}{...}


{pstd}
A dictionary is a text file that is created with the Do-file Editor or an
editor outside Stata.  This file specifies how Stata should read fixed-format
data from a text file.  The syntax for a dictionary is

	{hline 38} begin dictionary file {hline 4}
	[{cmd:infile}] {cmd:dictionary} [{cmd:using} {it:filename}] {cmd:{c -(}}
		{cmd:* comments may be included freely}
		{cmd:_lrecl(}{it:#}{cmd:)}
		{cmd:_firstlineoffile(}{it:#}{cmd:)}
		{cmd:_lines(}{it:#}{cmd:)}

		{cmd:_line(}{it:#}{cmd:)}
		{cmd:_newline}[{cmd:(}{it:#}{cmd:)}]

		{cmd:_column(}{it:#}{cmd:)}
		{cmd:_skip}[{cmd:(}{it:#}{cmd:)}]

		[{it:type}] {it:varname} [{cmd::}{it:lblname}] [{cmd:%}{it:infmt}] [{cmd:"}{it:variable label}{cmd:"}]
	{cmd:{c )-}}
	{it:(your data might appear here)}
	{hline 38} end dictionary file {hline 6}

{p 4 6 2}
where {cmd:%infmt} is {c -(} {cmd:%}[{opt #}[{opt .#}]]
{c -(}{opt f}|{opt g}|{opt e}{c )-} | {cmd:%}[{opt #}]{opt s}
             | {cmd:%}[{opt #}]{opt S}{c )-}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Text data in fixed format with a dictionary}


{marker description}{...}
{title:Description}

{pstd}
{opt infile using} reads a dataset that is stored in text form.
{opt infile using} does this by first reading {it:dfilename} -- a "dictionary"
that describes the format of the data file -- and then reads the file
containing the data.  The dictionary is a file you create with the Do-file
Editor or an editor outside Stata.

{pstd} 
Strings containing plain ASCII or UTF-8 are imported correctly.  Strings
containing extended ASCII will not be imported (that is, displayed) correctly;
you can use Stata's {helpb replace} command with the
{helpb f_ustrfrom:ustrfrom()} function to convert extended ASCII to UTF-8.  If
{opt ebcdic} is specified, the data will be converted from EBCDIC to ASCII as
they are imported.  The dictionary in all cases must be ASCII.

{pstd}
If {opt using} {it:{help filename}} is not specified, the data are assumed to
begin on the line following the closing brace.  If {opt using} {it:filename} is
specified, the data are assumed to be located in {it:filename}.

{pstd}
The data may be in the same file as the dictionary or in another file.
{cmd:infile} with a dictionary can import both numeric and
string data.  Individual strings may be up to 100,000 bytes long.
Strings longer than 2,045 bytes are imported as {cmd:strL}s (see
{findalias frstrl}).

{pstd}
Another variation on {opt infile} omits the intermediate dictionary; see
{help infile1}.  This variation is easier to use but will not read
fixed-format files.  On the other hand, although {opt infile} with a dictionary
will read free-format files, {opt infile} without a dictionary is even better
at it.

{pstd}
An alternative to {opt infile using} for reading fixed-format files is
{opt infix}; see {manhelp infix D:infix (fixed format)}.  {opt infix} provides
fewer features than {opt infile using} but is easier to use.

{pstd}
Stata has other commands for reading data.  If you are not certain that
{opt infile using} will do what you are looking for, see
{manhelp import D} and {findalias frdatain}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D infile(fixedformat)Quickstart:Quick start}

        {mansection D infile(fixedformat)Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker filename}{...}
{phang}{opth using(filename)} specifies the name of a file containing the data.
If {opt using()} is not specified, the data are assumed to follow the
dictionary in {it:dfilename}, or if the dictionary specifies the name of some
other file, that file is assumed to contain the data.  If
{opt using(filename)} is specified, {it:filename} is used to obtain the data,
even if the dictionary says otherwise.  If {it:filename} is specified without
an extension, {cmd:.raw} is assumed.

{pmore}
If {it:filename} contains embedded spaces, remember to enclose it in double
quotes.

{phang}{opt clear} specifies that it is okay for the new data to replace what
is currently in memory.
To ensure that you do not lose something important, {opt infile using} will
refuse to read new data if other data are already in memory.  {opt clear}
allows {opt infile using} to replace the data in memory.  You can also drop
the data yourself by typing {cmd:drop _all} before reading new data.

{dlgtab:Options}

{phang}{opt automatic} causes Stata to create value labels from the nonnumeric
data it reads.
It also automatically widens the display format to fit the longest label.

{phang}{opt ebcdic} specifies that the data be stored using EBCDIC character
encoding rather than the default ASCII encoding and that the data be converted
from EBCDIC to ASCII as they are imported.


{marker dict_dir}{...}
{title:Dictionary directives}

{phang}
{cmd:*} marks comment lines.  Wherever you wish to place a comment, begin the
    line with a {cmd:*}.  Comments can appear many times in the same dictionary.

{phang}
{opt _lrecl(#)} is used only for reading datasets that do not have
end-of-line delimiters (carriage return, line feed, or some combination of
these).  Such files are often produced by mainframe computers and are either
coded in EBCDIC or have been translated from EBCDIC into ASCII.
{cmd:_lrecl()} specifies the logical record length.  {cmd:_lrecl()}
requests that {cmd:infile} act as if a line ends every {it:#} bytes.

{pmore}
    {cmd:_lrecl()} appears only once, and typically not at all, in a
    dictionary.

{phang}
{opt _firstlineoffile(#)} (abbreviation {cmd:_first()}) is also rarely
    specified.  It states the line of the file where the data begin.
    You do not need to specify {cmd:_first()} when the data follow the
    dictionary; Stata can figure that out for itself.  However, you might
    specify {cmd:_first()} when reading data from another file in which the
    first line does not contain data because of headers or other markers.

{pmore}
    {cmd:_first()} appears only once, and typically not at all, in a
    dictionary.

{phang} 
{opt _lines(#)} states the number of lines per observation in the
    file.  Simple datasets typically have {cmd:_lines(1)}.  Large datasets
    often have many lines (sometimes called records) per observation.
    {cmd:_lines()} is optional, even when there is more than one line per
    observation because {cmd:infile} can sometimes figure it out for itself.
    Still, if {cmd:_lines(1)} is not right for your data, it is best to specify
    the correct number through {opt _lines(#)}.

{pmore}
    {cmd:_lines()} appears only once in a dictionary.

{phang}
{opt _line(#)} tells {cmd:infile} to jump to line {it:#} of the
    observation.  {cmd:_line()} is not the same as {cmd:_lines()}. Consider a
    file with {cmd:_lines(4)}, meaning four lines per observation.
    {cmd:_line(2)} says to jump to the second line of the observation.
    {cmd:_line(4)} says to jump to the fourth line of the observation.  You may
    jump forward or backward. {cmd:infile} does not care, and there is no
    inefficiency in going forward to {cmd:_line(3)}, reading a few variables,
    jumping back to {cmd:_line(1)}, reading another variable, and jumping
    forward again to {cmd:_line(3)}.

{pmore}
    You need not ensure that, at the end of your dictionary, you are on the
    last line of the observation.  {cmd:infile} knows how to get to the next
    observation because it knows where you are and it knows {cmd:_lines()},
    the total number of lines per observation.

{pmore}
    {cmd:_line()} may appear many times in a dictionary.

{phang}
{cmd:_newline}[{cmd:(}{it:#}{cmd:)}] is an alternative to {cmd:_line()}.
    {cmd:_newline(1)}, which may be abbreviated {cmd:_newline}, goes 
    forward one line.  {cmd:_newline(2)} goes forward two lines.  We do
    not recommend using {cmd:_newline()} because {cmd:_line()} is better.
    If you are currently on line 2 of an observation and want to get to line
    6, you could type {cmd:_newline(4)}, but your meaning is clearer if you
    type {cmd:_line(6)}.  

{pmore}
    {cmd:_newline()} may appear many times in a dictionary.

{phang}
{opt _column(#)} jumps to column {it:#} (in bytes) of the current line.  You
    may jump forward or backward within a line.
    {cmd:_column()} may appear many times in a dictionary.

{phang}
{cmd:_skip}[{cmd:(}{it:#}{cmd:)}] jumps forward {it:#} columns on the current
    line.  {cmd:_skip()} is just an alternative to {cmd:_column()}.
    {cmd:_skip()} may appear many times in a dictionary.

{phang}
[{it:type}] {it:varname} [{cmd::}{it:lblname}}] [{cmd:%}{it:infmt}]
 [{cmd:"}{it:variable label}{cmd:"}]
    instructs {cmd:infile} to read a variable.  The simplest form of this
    instruction is the variable name itself:  {it:varname}.

{pmore}
    At all times, {cmd:infile} is on some column of some line of an
    observation.  {cmd:infile} starts on column 1 of line 1, so pretend that
    is where we are.  Given the simplest directive, `{it:varname}', 
    {cmd:infile} goes through the following logic:

{pmore}
    If the current column is blank, it skips forward until there is a nonblank
    column (or until the end of the line).  If it just skipped all the way to
    the end of the line, it stores a missing value in {it:varname}.  If it
    skipped to a nonblank column, it begins collecting what is there until it
    comes to a blank column or the end of the line.  These are the data for
    {it:varname}.  Then it sets the current column to wherever it is.

{pmore}
    The logic is a bit more complicated.  For instance, when skipping forward
    to find the data, {cmd:infile} might encounter a quote.  If so, it then
    collects the characters for the data by skipping forward until it finds
    the matching quote.  If you specify a {cmd:%}{it:infmt}, then {cmd:infile}
    skips the skipping-forward step and simply collects the specified number
    of bytes.  If  you specify a {cmd:%S}{it:infmt}, then {cmd:infile}
    does not skip leading or trailing blanks.  Nevertheless, the general logic
    is (optionally) skip, collect, and reset.


{marker examples}{...}
{title:Examples:  reading data with a dictionary}

{p 4 8 2}{cmd:. infile using mydict}{p_end}
{p 4 8 2}{cmd:. infile using mydict, using(mydata)}{p_end}
{p 4 8 2}{cmd:. infile using mydict if b==1}{p_end}
{p 4 8 2}{cmd:. infile using mydict if runiform()<=.1}


{title:Example:  reading EBCDIC data with a dictionary}

{p 4 8 2}{cmd:. infile using mydict, using(myebcdicdata) ebcdic}{p_end}


{title:Examples:  sample dictionaries}

    {hline 21} begin xmpl1.dct {hline 4}
    {cmd:dictionary {c -(}}
	    {cmd:a}
	    {cmd:b}
    {cmd:{c )-}}
    {cmd:1 2}
    {cmd:3 4}
    {hline 21} end xmpl1.dct {hline 6}


    {hline 21} begin xmpl2.dct {hline 4}
    {cmd:dictionary {c -(}}
	    {cmd:int    t        "day of year"}
	    {cmd:double amt      "amount"}
    {cmd:{c )-}}
    {cmd:1 2.2}
    {cmd:2 3.3}
    {hline 21} end xmpl2.dct {hline 6}


    {hline 21} begin xmpl3.dct {hline 4}
    {cmd:dictionary {c -(}}
    {cmd:_lines(2)}
    {cmd:_line(1)}
	    {cmd:int   a}
	    {cmd:float b}
    {cmd:_line(2)}
	    {cmd:float c}
    {cmd:{c )-}}
    {cmd:1 2.2}
    {cmd:3.2}
    {cmd:2 3.2}
    {cmd:4.2}
    {hline 21} end xmpl3.dct {hline 6}


    {hline 31} begin xmpl4.dct {hline 4}
    {cmd:dictionary {c -(}}
	    {cmd:long  idnumb    "Identification number"}
	    {cmd:str6  sex       "Sex"}
	    {cmd:byte  age       "Age"}
    {cmd:{c )-}}
    {cmd:472921002 male 32}
    {cmd:329193100 male 45}
    {cmd:399938271 female 30}
    {cmd:484873982 "female" 33}
    {hline 31} end xmpl4.dct {hline 6}


    {hline 43} begin xmpl5.dct {hline 4}
    {cmd:dictionary {c -(}}
	    {cmd:_column(5) }
		       {cmd:long  idnumb %9f "Identification number"}
		       {cmd:str6  sex    %6s "Sex"}
		       {cmd:int   age    %2f "Age"}
	    {cmd:_column(27)}
		       {cmd:float income %6f "Income"}
    {cmd:{c )-}}
	{cmd:329193402male  32      42000}
	{cmd:472921002male  32      50000}
	{cmd:329193100male  45}
	{cmd:399938271female30      43000}
	{cmd:484873982female33      48000}
    {hline 43} end xmpl5.dct {hline 6}


{title:Example:  dictionary and data in separate files}

    {hline 43} begin persons.dct {hline 4}
    {cmd:dictionary using persons.raw {c -(}}
	    {cmd:_column(5) }
		       {cmd:long  idnumb %9f "Identification number"}
		       {cmd:str6  sex    %6s "Sex"}
		       {cmd:int   age    %2f "Age"}
	    {cmd:_column(27)}
		       {cmd:float income %6f "Income"}
    {cmd:{c )-}}
    {hline 43} end persons.dct {hline 6}


    {hline 16} begin persons.raw {hline 4}
        {cmd:329193402male  32      42000}
        {cmd:472921002male  32      50000}
        {cmd:329193100male  45}
        {cmd:399938271female30      43000}
        {cmd:484873982female33      48000}
    {hline 16} end persons.raw {hline 6}
