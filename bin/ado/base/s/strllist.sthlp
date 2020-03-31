{smcl}
{* *! version 1.0.2  22dec2016}{...}
{findalias asfrstrllist}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrdatatypes}{...}
{title:Title}

    {findalias frstrllist}


{marker description}{...}
{title:Description}

{pstd}
By default, the {cmd:list} command shows only the first part of long strings,
followed by two dots.  How much {cmd:list} shows is determined by the width of
your Results window.

{pstd}
{cmd:list} will show the first 2,045 bytes of long strings, whether
stored as {cmd:strL}s or {cmd:str}{it:#}s, if you add the {cmd:notrim}
option.

{phang2}{cmd:. list, notrim}{p_end}
{phang2}{cmd:. list mystr, notrim}{p_end}
{phang2}{cmd:. list mystr in 5, notrim}{p_end}

{pstd}
Another way to display long strings is to use the {cmd:display} command.  With
{cmd:display}, you can see the entire contents.  To display the fifth
observation of the variable {cmd:mystr}, you type

{phang2}{cmd:. display _asis mystr[5]}{p_end}

{pstd}
That one command can produce a lot of output if the string is long, even
hundreds of thousands of pages!  Remember that you can press {it:Break} to
stop the listing.

{pstd}
To see the first 5,000 characters of the string, you type

{phang2}{cmd:. display _asis usubstr(mystr[5], 1, 5000)}{p_end}

{pstd}
For detailed information about displaying Unicode characters beyond
plain ASCII characters, see {findalias frdiunicode}.

{pstd}
Very rarely, a string variable might contain SMCL output.  SMCL is
Stata's text markup language.  A variable might contain SMCL if you used
{cmd:fileread()} to read a Stata log file into it.  In that case, you can see
the text correctly formatted by typing

{phang2}{cmd:. display as txt mystr[1]}

{pstd}
To learn more about other features of {cmd:display}, see
{helpb display}.
{p_end}
