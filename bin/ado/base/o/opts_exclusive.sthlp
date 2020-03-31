{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] error" "help error"}{...}
{vieweralsosee "[P] exit" "help exit"}{...}
{viewerjumpto "Syntax" "opts_exclusive##syntax"}{...}
{viewerjumpto "Description" "opts_exclusive##description"}{...}
{viewerjumpto "Examples" "opts_exclusive##examples"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col:{hi:[P] opts_exclusive} {hline 2}}Programmer's utility for mutually
exclusive options{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmd:opts_exclusive} {cmd:"}{it:opts}{cmd:"}
[[{it:option_name}] {it:return_code}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:opts_exclusive} is a programmer's command for displaying an appropriate
message and return code when mutually exclusive options are encountered.
{it:opts} is the list of mutually exclusive options or suboptions.  If there
are fewer than two options listed in {it:opts}, {cmd:opts_exclusive} silently
exits with a 0 return code.  With more than two options in {it:opts}, an error
message is displayed and the return code set.  For suboptions,
{it:option_name} indicates the option name.  The default return code is 198.
{it:return_code} specifies a different return code.


{marker examples}{...}
{title:Examples}

    {cmd:. opts_exclusive "a b" myopt}
{p 4 4 2}
    {err:option myopt() invalid; only one of a or b is allowed}
{p_end}
    {search r(198):r(198);}

    {cmd:. opts_exclusive "this that other" xyz 274}
{p 4 4 2}
    {err:option xyz() invalid; only one of this, that, or other is allowed}
{p_end}
    {search r(274):r(274);}

    {cmd:. opts_exclusive "green yellow red blue"}
{p 4 4 2}
    {err:only one of green, yellow, red, or blue is allowed}
{p_end}
    {search r(198):r(198);}
