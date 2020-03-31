{smcl}
{* *! version 1.2.2  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "doublebuffer##syntax"}{...}
{viewerjumpto "Description" "doublebuffer##description"}{...}
{title:Title}

{phang}
Set the Results window scrollback buffer size{p_end}


{marker syntax}{...}
{title:Syntax}

	{cmd:set scrollbufsize} {it:#}

	{cmd:10000} <= {it:#} <= {cmd:2000000}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set scrollbufsize} sets the scrollback buffer size, in bytes, for the
Results window.  The default value of {cmd:scrollbufsize} is 200,000 and can
be set within the range from 10,000 to 2,000,000.

{pstd}
The {cmd:scrollbufsize} determines how far back you can scroll in the Results
window.

{pstd}
The change in buffer size does not occur in the current Stata session;
instead, the new buffer size takes effect the next time Stata is started.
{p_end}
