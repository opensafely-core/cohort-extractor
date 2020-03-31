{smcl}
{* *! version 1.1.2  29jan2019}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "reventries##syntax"}{...}
{viewerjumpto "Description" "reventries##description"}{...}
{viewerjumpto "Option" "reventries##option"}{...}
{title:Title}

{phang}
Set the number of commands stored by the History window{p_end}


{marker syntax}{...}
{title:Syntax}

	{cmd:set} {cmd:reventries} {it:#} [{cmd:,} {cmdab:perm:anently}]

	5 <= {it:#} <= 32000; default is 5,000


{marker description}{...}
{title:Description}

{pstd}
{cmd:set reventries} sets the maximum number of commands stored by
the History window.  The History window will remember the last {it:#}
interactive commands during a Stata session.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
