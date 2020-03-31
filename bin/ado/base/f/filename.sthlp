{smcl}
{* *! version 1.2.2  15oct2018}{...}
{findalias asfrfilenames}{...}
{title:Title}

{p 4 13 2}
{findalias frfilenames}


{title:Description}

{pstd}
Some commands require that you specify a filename.  Filenames are
specified in the way natural for your operating system:

    Windows                  Unix                     Mac
    {hline 72}
{cmd}    mydata                   mydata                   mydata
    mydata.dta               mydata.dta               mydata.dta
    c:mydata.dta             ~friend/mydata.dta       ~friend/mydata.dta

    "my data"                "my data"                "my data"
    "my data.dta"            "my data.dta"            "my data.dta"

    myproj\mydata            myproj/mydata            myproj/mydata
    "my project\my data"     "my project/my data"     "my project/my data"

    C:\analysis\data\mydata  ~/analysis/data/mydata   ~/analysis/data/mydata
    "C:\my project\my data"  "~/my project/my data"   "~/my project/my data"

    ..\data\mydata           ../data/mydata           ../data/mydata
    "..\my project\my data"  "../my project/my data"  "../my project/my data"
{txt}

{pstd}
In most cases, where {it:filename} is a file that you are loading,
{it:filename} may also be a URL.  For instance, we might specify
{cmd:use https://www.stata-press.com/data/r16/nlswork}.

{pstd}
All operating systems allow blanks in filenames, and so does Stata.  However,
if the filename includes a blank, you must enclose the filename in double
quotes.  Typing

{phang2}
{cmd:. save "my data"}

{pstd}
would create the file {cmd:my} {cmd:data.dta}.  Typing 

{phang2}
{cmd:. save my data}

{pstd}
would be an error.

{pstd}
See {help extensions:file extensions} for details and types of filename
extensions.
{p_end}
