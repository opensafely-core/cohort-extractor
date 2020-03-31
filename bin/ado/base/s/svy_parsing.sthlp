{smcl}
{* *! version 1.1.3  09aug2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program properties" "help program_properties"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy_bootstrap"}{...}
{vieweralsosee "[SVY] svy brr" "help svy_brr"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{vieweralsosee "[SVY] svy sdr" "help svy_sdr"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{viewerjumpto "Remarks" "svy_parsing##remarks"}{...}
{viewerjumpto "Example" "svy_parsing##example"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] svy parsing} {hline 2} Check options for community-contributed commands
used with the svy prefix


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:svy} fits statistical models for complex survey data and can be used with
community-contributed estimation commands that meet its programming properties;
see {help program properties}.  Not all options of a given estimation command
may be allowed with the {cmd:svy} prefix, so {cmd:svy} provides a way for
estimation command programmers to check for these disallowed options.
{cmd:svy} does this by looking for a program with a specific name to help
validate the options specified on the prefixed command.  The name of the
syntax validation command is a function of the prefixed estimation as follows:

{pmore}
{cmd:. svy:} {it:cmdname} ... , {it:options}

{pstd}
The above command causes {cmd:svy} to look for a command named
{it:cmdname}{cmd:_svy_check} and then to make the call

{pmore}
{cmd:.} {it:cmdname}{cmd:_svy_check}, {opt vce(vcetype)} {it:options}

{pstd}
if {it:cmdname}{cmd:_svy_check} exists.  {it:vcetype} is empty by default but
will contain the replication method, even if {helpb svyset}, using the
{opt vce()} option.


{marker example}{...}
{title:Example}

{pstd}
Suppose that we developed an estimation command and added support for
{cmd:svy}.  Let's assume our command is called {cmd:myest} and that there is
an option called {opt lrstats} that is not allowed with the {cmd:svy} prefix.
When {cmd:svy} is used with {cmd:myest}, {cmd:svy} will look for a program
named {cmd:myest_svy_check}.  If {cmd:myest_svy_check} exists, {cmd:svy} will
call it with the options specified in the call to {cmd:myest}, along with the
{opt vce()} option containing the VCE method that will be used.  For example,

{pmore}
{cmd:. svy:} {cmd:myest} {it:varlist}

{pstd}
will make the call

{pmore}
{cmd:. myest_svy_check, vce(linearized)}

{pstd}
if {cmd:myest_svy_check} exists.

{pstd}
We mentioned that {cmd:myest} has option {opt lrstats} that is not allowed
with {cmd:svy}, so our {cmd:myest_svy_check} has the following definition:

	{cmd}program myest_svy_check
		syntax [, vce(string) lrstats *]
		if "`lrstats'" != "" {c -(}
			di as err "option lrstats not allowed with svy `vce'"
			exit 198
		{c )-}
	end{txt}

{pstd}
{cmd:myest_svy_check} specifically parses options {opt vce()} and
{opt lrstats}, ignoring all other options.  If {opt lrstats} is specified,
then {cmd:myest_svy_check} reports an error explaining that {opt lrstats} is
not allowed with {cmd:svy}.

{pstd}
The default VCE is {cmd:vce(linearized)}, but {cmd:svy} will pass an empty
{opt vce()} option if the default is not changed and {cmd:svy}
{cmd:linearized} is not explicitly specified.  {cmd:svy} will always pass the
replication method being used in the {opt vce()} option, so we can disallow
options based on the VCE method if possible.
{p_end}
