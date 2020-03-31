{smcl}
{* *! version 1.0.4  08mar2015}{...}
{findalias asfrstr}{...}
{title:Title}

{p 4 13 2}
{findalias frstr}


{title:Description}

{pstd}
A string is a sequence of characters and is typically enclosed in double
quotes.  The quotes are not considered a part of the string but delimit the
beginning and end of the string.  The following are examples of valid strings:

{cmd}        "Hello, world"
        "String"
        "string"
        " string"
        "string "
        ""
        "x/y+3"
        "1.2"{txt}

{pstd}
All the strings above are distinct.  Capitalization matters. Leading and
trailing spaces matter.  Also note that {cmd:"1.2"} is a string and not a
number because it is enclosed in quotes.

{pstd}
There is never a circumstance in which a string cannot be delimited with
quotes, but there are instances where strings do not have to be delimited by
quotes, such as when inputting data. In those cases, nondelimited strings are
stripped of their leading and trailing blanks.  Delimited strings are always
accepted as is.

{pstd}
The special string {cmd:""}, often called null string, is considered by Stata
to be a missing.  No special meaning is given to the string containing one
period, {cmd:"."}.

{pstd}
In addition to double quotes for enclosing strings, Stata also allows compound
double quotes:  {cmd:`"} and {cmd:"'}.  You can type {cmd:"}{it:string}{cmd:"}
or you can type {cmd:`"}{it:string}{cmd:"'}, although users seldom type
{cmd:`"}{it:string}{cmd:"'}.  Compound double quotes are of special interest to
programmers because they nest and provide a way for a quoted string to itself
contain double quotes (either simple or compound).  See {findalias frdoubleq}.

{pstd}
Stata provides two types of strings: {cmd:str}{it:#}s and {cmd:strL}s.
{cmd:str}{it:#}s are fixed-length string storage types.  A
{cmd:str36} string can hold 36 characters.  Stata allows {cmd:str1},
{cmd:str2}, {cmd:str3}, ..., {cmd:str2045}.  {cmd:strL}s are Stata's long
strings, which can be up to 2-billion characters long.  {cmd:strL}s can hold
binary strings, whereas {cmd:str}{it:#}s can only hold text characters.  See
{findalias frstrs} and {findalias frstrl} for more information.  If your
strings contain Unicode characters, see {findalias frunicode}.
{p_end}
