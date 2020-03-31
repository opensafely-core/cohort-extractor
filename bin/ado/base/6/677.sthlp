{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee "[R] netio" "help netio"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] news" "help news"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{title:Title}

    "remote connection failed" error, r(677)


{title:Description}

{pstd}
If you see

{p 14 14 2}{err:remote connection failed}{break}
	      {search r(677):r(677);}

{pstd}
then you asked for something to be done over the web, Stata tried, but could
not contact the specified host.

{pstd}
Stata was able to talk over the network.  Stata was able to lookup the host
but was not able to establish a connection to that host.

{pstd}
Perhaps the host is down; try again later.

{pstd}
If 100% of your web accesses result in this message, then perhaps your
network connection is through a proxy server.  If it is, then you must tell
Stata.

{pstd}
Contact your system administrator.  Ask for the name and port of the "http
proxy server".  Say that you are told

{center:http proxy server:      jupiter.myuni.edu}
{center:port number:            8080             }

{pstd}
In Stata, type

{phang2}{cmd:. set httpproxyhost jupiter.myuni.edu}{p_end}
{phang2}{cmd:. set httpproxyport 8080}{p_end}
{phang2}{cmd:. set httpproxy on}

{pstd}
Your web accesses should then work.
{p_end}
