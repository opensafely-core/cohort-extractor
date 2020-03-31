{smcl}
{* *! version 1.2.14  15oct2018}{...}
{vieweralsosee "[R] sj" "mansection R sj"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] net search" "help net_search"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "stb" "help stb"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{findalias asfrstb}{...}
{viewerjumpto "Description" "sj##description"}{...}
{viewerjumpto "Links to PDF documentation" "sj##linkspdf"}{...}
{viewerjumpto "Obtaining community-contributed additions from the SJ" "sj##software"}{...}
{viewerjumpto "Subscribing to the SJ" "sj##subscribe"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] sj} {hline 2}}Stata Journal installation instructions{p_end}
{p2col:}({mansection R sj:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {bf:Stata Journal} (SJ) is a quarterly journal containing articles about
statistics, data analysis, teaching methods, and effective use of Stata's
language.  The SJ publishes reviewed papers together with shorter notes
and comments, regular columns, tips, book reviews, and other material of
interest to researchers applying statistics in a variety of disciplines.  You
can read all about the Stata Journal at
{browse "https://www.stata-journal.com"}.

{pstd}
The Stata Journal is a printed and electronic journal with corresponding
software.  If you want the journal, you must subscribe, but the software is
available for no charge from our website at
{browse "https://www.stata-journal.com"}.  PDF copies of SJ articles that are
older than three years are available for download for no charge at
{browse "https://www.stata-journal.com/archives.html"}.
More recent articles may be individually purchased.

{pstd}
The Stata Journal, Volume 1, Issue 1, began publication in the fourth quarter
of 2001.  The predecessor to the Stata Journal was the Stata Technical Bulletin
(STB); see {help stb}.  The STB began publication in May 1991 and was the
first publication of its kind for statistical software users.

{pstd}
To see the table of contents for the latest SJ (or any SJ), see
{browse "https://www.stata-journal.com/archives.html"}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R sjRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker software}{...}
{title:Obtaining community-contributed additions from the SJ}

{pstd}
The SJ community-contributed additions are easily obtained.
You can {net "from https://www.stata-journal.com/software":click here}

{p 4 15 2}Or {space 4} 1) Select {bf:Help > SJ and community-contributed commands}{p_end}
{p 12 15 2}2) Click on Stata Journal{p_end}

{pstd}
Or use the command line and type

	    {inp:. net from https://www.stata-journal.com/software}

{pstd}
See {manhelp net R}.  What to do next will be obvious.


{marker subscribe}{...}
{title:Subscribing to the SJ}

{pstd}
Subscriptions to and back issues of the Stata Journal are available from
StataCorp; see
{browse "https://www.stata.com/bookstore/subscribe-stata-journal/"}.
{p_end}
