{smcl}
{* *! version 1.1.5  20apr2018}{...}
{vieweralsosee "[P] numlist" "mansection P numlist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11.1.8 numlist" "help numlist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "nlist##syntax"}{...}
{viewerjumpto "Description" "nlist##description"}{...}
{viewerjumpto "Links to PDF documentation" "nlist##linkspdf"}{...}
{viewerjumpto "Options" "nlist##options"}{...}
{viewerjumpto "Examples" "nlist##examples"}{...}
{viewerjumpto "Stored results" "nlist##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] numlist} {hline 2}}Parse numeric lists{p_end}
{p2col:}({mansection P numlist:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
     {cmd:numlist} {cmd:"}{it:numlist}{cmd:"} [{cmd:,} {cmdab:asc:ending}
       {cmdab:desc:ending} {cmdab:int:eger} {cmdab:miss:ingokay}
       {cmd:min(}{it:#}{cmd:)} {cmd:max(}{it:#}{cmd:)}
       {cmdab:r:ange:(}{it:operator#} [{it:operator#}]{cmd:)} {cmd:sort}]

{phang}where {it:numlist} consists of one or more
{it:{help numlist:numlist_elements}}

{phang}and where {it:operator} is    {cmd:<} | {cmd:<=} | {cmd:>} | {cmd:>=}

{pmore}There is no space between {it:operator} and {it:#}; for example, 

   		{cmd:range(>=0)}
		{cmd:range(>=0 <=20)}
		{cmd:range(>0 <=50)}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:numlist} command expands the numeric list supplied as a string
argument and performs error checking based on the options specified.  Any
numeric sequence operators in the {it:numlist} string are evaluated, and the
expanded list of numbers is returned in {hi:r(numlist)}.  See {help numlist}
for a discussion of numeric lists.  Also see {manhelp syntax P} for a more
comprehensive command that will also parse numeric lists.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P numlistRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{cmd:ascending} indicates that the user must give the numeric list in
ascending order without repeated values.  This is different from the {cmd:sort}
option.

{phang}{cmd:descending} indicates that the numeric list must be given in
descending order without repeated values.

{phang}{cmd:integer} specifies that the user may only give integer values in
the numeric list.

{phang}{cmd:missingokay} indicates that missing values are allowed in the
numeric list.  By default, missing values are not allowed.

{phang}{cmd:min(}{it:#}{cmd:)} specifies the minimum number of elements
allowed in the numeric list.  The default is {cmd:min(1)}.  If you want to
allow empty numeric lists, specify {cmd:min(0)}.

{phang}{cmd:max(}{it:#}{cmd:)} specifies the maximum number of elements
allowed in the numeric list.  The default is {cmd:max(1600)}, which is the
largest allowed maximum.

{phang}{cmd:range(}{it:operator#} [{it:operator#}]{cmd:)} specifies the
acceptable range for the values in the numeric list.  The {it:operators} are
{cmd:<} (less than), {cmd:<=} (less than or equal to), {cmd:>} (greater than),
and {cmd:>=} (greater than or equal to). No space is allowed
between the {it:operator} and the {it:#}.

{phang}{cmd:sort} specifies that the returned numeric list be sorted.
This is different from the {cmd:ascending} option, which places the
responsibility for providing a sorted list on the user who will not be allowed
to enter a nonsorted list.  {cmd:sort}, on the other hand, puts no restriction
on the user and takes care of sorting the list.  Repeated values are also
allowed with {cmd:sort}.


{marker examples}{...}
{title:Examples}

    {cmd:. numlist "5.3 1.0234 3 6:18 -2.0033 5.3/7.3"}
    {cmd:. display "`r(numlist)'"}

    {cmd:. numlist "5.3 1.0234 3 6:18 -2.0033 5.3/7.3", integer}
            (gives error message)

    {cmd:. numlist "1 5 8/12 15", integer descending} 
            (gives error message)

    {cmd:. numlist "1 5 8/12 15", integer ascending}
    {cmd:. display "`r(numlist)'"}

    {cmd:. numlist "100 1 5 8/12 15", integer ascending} 
            (gives error message)

    {cmd:. numlist "100 1 5 8/12 15", integer sort}
    {cmd:. display "`r(numlist)'"}

    {cmd:. numlist "3 5 . 28 -3(2)5"}
            (gives error message)

    {cmd:. numlist "3 5 . 28 -3(2)5", missingokay min(3) max(25)}
    {cmd:. display "`r(numlist)'"}

    {cmd:. numlist "28 36", min(3) max(6)}
            (gives error message)

    {cmd:. numlist "28 36 -3 5 2.8 7 32 -8", min(3) max(6)}
            (gives error message)

    {cmd:. numlist "3/6 -4 -1 to 5", range(>=1)}
            (gives error message)

    {cmd:. numlist "3/6", range(>=0 <30)}
    {cmd:. display "`r(numlist)'"}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:numlist} stores the following in {cmd:r()}:

    Macros
        {cmd:r(numlist)}    expanded numeric list
