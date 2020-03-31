{smcl}
{* *! version 1.0.9  10aug2012}{...}
{* This is not the modern way to deal with making a command svyable}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{viewerjumpto "Syntax" "svyopts##syntax"}{...}
{viewerjumpto "Description" "svyopts##description"}{...}
{viewerjumpto "Some official Stata commands that use svyopts" "svyopts##official"}{...}
{viewerjumpto "Examples" "svyopts##examples"}{...}
{viewerjumpto "Stored results" "svyopts##results"}{...}
{title:Title}

    Parsing tool for survey commands


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:svyopts}
	{it:modopts}
	{it:diopts}
	[ {it:rest} ]
	[{cmd:,} {it:options}]


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:svyopts} is a parsing tool that was written to assist in syntax checking
and parsing of survey estimation commands that use {cmd:ml}.  The options
specified in {it:options} will be separated into groups and returned in local
macros specified by the caller.  The names of the local macros are identified
by {it:modopts}, {it:diopts} and {it:rest}.

{p 4 8 2}
{it:modopts} is required and will contain those options that the {cmd:ml}
command recognizes as {cmd:svy} options.
Options returned in {it:modopts} are

{p 8 8 2}
	{cmdab:nosvy:adjust}
	{cmdab:sc:ore:(}{it:newvarlist}|{it:stub}*{cmd:)}
	{cmdab:sub:pop:(}{it:subpop_spec}{cmd:)}
	{cmdab:srs:subpop}

{p 8 8 2}
For a description of the above options see {manhelp ml R}.

{p 4 8 2}
{it:diopts} is required and will contain options that affect the display of
output.
Options returned in {it:diopts} are

{p 8 8 2}
	{cmdab:l:evel:(}{it:#}{cmd:)}
	{cmd:deff}
	{cmd:deft}
	{cmd:meff}
	{cmd:meft}
	{cmdab:ef:orm}
	{cmdab:p:rob}
	{cmd:ci}
	{cmdab:noh:eader}

{p 8 8 2}
For a description of the above options see {manhelp ml R}.

{p 4 8 2}
{it:rest} is optional and, if specified, will contain all other options that
were not returned in {it:modopts} or {it:diopts}.  If {it:rest} is not
specified, then any extra options will cause an error.


{marker official}{...}
{title:Some official Stata commands that use {cmd:svyopts}}

{p 4 4 2}
The following commands use {cmd:svyopts}.  See help for

{p 8 8 2}
	{help svygnbreg},
	{help svyheckman},
	{help svyheckprob},
	{help svyintreg},
	{help svynbreg},
	{help svypoisson}


{marker examples}{...}
{title:Examples}

{p 4 4 2}
{cmd}. svyopts mlopts diopts , eform subpop(sub){text}

{p 4 4 2}
{cmd}. svyopts mlopts diopts , junk eform subpop(sub){text}{break}
{err}option junk not allowed{break}
{txt}{search r(198):r(198);}

{p 4 4 2}
{cmd}. svyopts mlopts diopts rest , junk eform subpop(sub){text}{break}


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:svyopts} stores the following in {cmd:s()}:

{p 4 4 2}
Macros:

        {cmd:s(meff)}     {cmd:meff}, {cmd:meft} or both if supplied
        {cmd:s(subpop)}   {it:varname} from {cmd:subpop()} option
