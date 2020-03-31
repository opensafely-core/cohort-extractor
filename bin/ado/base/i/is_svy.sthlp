{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{viewerjumpto "Syntax" "is_svy##syntax"}{...}
{viewerjumpto "Description" "is_svy##description"}{...}
{viewerjumpto "Option" "is_svy##option"}{...}
{title:Title}

{p 4 22 2}
{hi:[SVY] is_svy} {hline 2} Determine if the last estimation command belongs
to the svy class


{marker syntax}{...}
{title:Syntax}

	{cmd:is_svy} [{cmd:,} {cmdab:r:egression}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:is_svy} returns in {cmd:r(is_svy)} whether (1) or not (0) the last
estimation command belongs to the class of {hi:svy} commands.  Note that
{hi:svy} treats both "summary commands" such as {cmd:svymean} and
regression type commands such as {cmd:svyregress} as estimation commands.


{marker option}{...}
{title:Option}

{phang}
{cmd:regression} specifies that {cmd:r(is_svy)} indicates
whether or not the last estimation command is a {hi:svy} regression
command.
{p_end}
