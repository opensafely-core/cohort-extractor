{smcl}
{* *! version 1.1.12  01nov2018}{...}
{vieweralsosee "[R] netio" "mansection R netio"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "r(2)" "help r(2)"}{...}
{vieweralsosee "r(663)" "help r(663)"}{...}
{vieweralsosee "r(677)" "help r(677)"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "netio##syntax"}{...}
{viewerjumpto "Description" "netio##description"}{...}
{viewerjumpto "Links to PDF documentation" "netio##linkspdf"}{...}
{viewerjumpto "Options" "netio##options"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] netio} {hline 2}}Control Internet connections{p_end}
{p2col:}({mansection R netio:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Turn on or off the use of a proxy server

{p 8 26 2}{cmdab:se:t httpproxy} {c -(}{opt on}{c |}{opt off}{c )-} [{cmd:, init}]{p_end}


    Set proxy host name

{p 8 26 2}{cmdab:se:t httpproxyhost} [{cmd:"}]{it:name}[{cmd:"}]{p_end}


    Set the proxy port number

{p 8 26 2}{cmdab:se:t httpproxyport} {it:#}{p_end}


    Turn on or off proxy authorization

{p 8 26 2}{cmdab:se:t httpproxyauth} {c -(}{opt on}{c |}{opt off}{c )-}{p_end}


    Set proxy authorization user ID

{p 8 26 2}{cmdab:se:t httpproxyuser} [{cmd:"}]{it:name}[{cmd:"}]{p_end}


    Set proxy authorization password

{p 8 26 2}{cmdab:se:t httpproxypw} [{cmd:"}]{it:password}[{cmd:"}]{p_end}


    Set time limit for establishing initial connection

{p 8 26 2}{cmdab:se:t timeout1} {it:#seconds} [{cmd:,} {opt perm:anently} ]{p_end}


    Set time limit for data transfer

{p 8 26 2}{cmdab:se:t timeout2} {it:#seconds} [{cmd:,} {opt perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
Some commands (for example, {cmd:net} and {cmd:update})
are designed specifically for use over the Internet.  Many
other Stata commands that read a file (for example, {cmd:copy}, {cmd:type},
and {cmd:use}) can also read directly from a URL.  All of these commands will
usually work without your ever needing to concern yourself with the {cmd:set}
commands discussed here.  These {cmd:set} commands provide control over
network system parameters.

{pstd}
If you experience problems when using Stata's network features, ask your system
administrator if your site uses a proxy.  A proxy is a server between your
computer and the rest of the Internet, and your computer may need to
communicate with other computers on the Internet through this proxy.  If your
site uses a proxy, your system administrator can provide you with its host
name and the port your computer can use to communicate with it.  If your site's
proxy requires you to log in to it before it will respond, your system
administrator will provide you with a user ID and password.

{pstd}
{cmd:set httpproxyhost} sets the name of the host to be used as a proxy
server.  {cmd:set httpproxyport} sets the port number.  {cmd:set httpproxy}
turns on or off the use of a proxy server, leaving the proxy host name and
port intact, even when not in use.
See {help r(677)} for more information.

{pstd}
Under the Mac and Windows operating systems, when you
{cmd:set httpproxy on}, Stata will attempt to obtain the values of
{cmd:httpproxyhost} and {cmd:httpproxyport} from the operating system if they
have not been previously set.  {cmd:set httpproxy on, init} attempts to obtain
these values from the operating system, even if they have been previously set.

{pstd}
If the proxy requires authorization (user ID and password), set authorization
on via {cmd:set httpproxyauth on}.  The proxy user and proxy password must
also be set to the appropriate user ID and password by using 
{cmd:set httpproxyuser} and {cmd:set httpproxypw}.

{pstd}
Stata remembers the various proxy settings between sessions and
does not need a {opt permanently} option.

{pstd}
{cmd:set timeout1} changes the time limit in seconds that Stata imposes for
establishing the initial connection with a remote host.  The default value is
30.  {cmd:set timeout2} changes the time limit in seconds that Stata imposes
for subsequent data transfer with the host.  The default value is 180.  If
these time limits are exceeded, a "connection timed out" message and error code
2 are produced; see {help r(2)}.  You should seldom need to change these
settings.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R netioRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt init} specifies that {cmd:set httpproxy on} attempts to initialize
{cmd:httpproxyhost} and {cmd:httpproxyport} from the operating system
(Mac and Windows only).

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the {cmd:timeout1} and {cmd:timeout2} settings be remembered and become the
default setting when you invoke Stata.

{pmore}
The various {cmd:httpproxy} settings do not have a {opt permanently} option
because {opt permanently} is implied.  {p_end}
