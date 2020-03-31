{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "[R] netio" "help netio"}{...}
{vieweralsosee "r(677)" "help r(677)"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] news" "help news"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{title:Title}

    "remote connection to proxy failed" error, r(663)


{title:Description}

{pstd}
If you see

{p 14 14 2}{err:remote connection to proxy failed}{p_end}
	      {search r(663):r(663);}

{pstd}
then you have set a proxy server (see help {help r(677)}) but it is
not responding to Stata.  The likely problems are

{phang2}1.  you specified the wrong port,

{phang2}2.  you specified the wrong host, or

{phang2}3.  the proxy server is down.

{pstd}
Type {cmd:query} in Stata to determine the host and port you have set.
{p_end}
