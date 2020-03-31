{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee "[R] netio" "help netio"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] news" "help news"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{title:Title}

    "connection timed out" error, r(2)


{marker description}{...}
{title:Description}

{pstd}
If you see

		{err:connection timed out}
		{search r(2):r(2);}

{pstd}
then an Internet connection has timed out.  This can happen when

{phang2}
a.  the connection between you and the host is slow, or

{phang2}
b.  the connection between you and the host disappeared and so eventually
    "timed out".

{pstd}
For (b), wait a while (say 5 minutes) and try again (sometimes pieces of the
Internet can break for up to a day, but that is rare).  For (a), you can reset
the limits for what constitutes "timed out".  There are two numbers to set.


{marker timeout1}{...}
{title:timeout1:  the time to establish the initial connection}

{pstd}
By default, Stata waits 30 seconds before declaring a timeout.
You can change the limit:

		{cmd:. set timeout1} {it:#seconds}

{pstd}
You might try doubling the usual limit and specify 60.  {it:#seconds} must be
between 1 and 32,000.


{marker timeout2}{...}
{title:timeout2:  the time to retrieve data from an open connection}

{pstd}
By default, Stata waits 180 seconds (3 minutes) before declaring a timeout.
To change the limit, type

		{cmd:. set timeout2} {it:#seconds}

{pstd}
You might try doubling the usual limit and specify 360.
{it:#seconds} must be between 1 and 32,000.
{p_end}
