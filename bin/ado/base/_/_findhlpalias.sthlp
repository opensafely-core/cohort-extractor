{smcl}
{* *! version 1.1.5  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "find_hlp_file##syntax"}{...}
{viewerjumpto "Description" "find_hlp_file##description"}{...}
{viewerjumpto "Remarks" "find_hlp_file##remarks"}{...}
{viewerjumpto "Stored results" "find_hlp_file##results"}{...}
{title:Title}

    {hi:[P] find_hlp_file} {hline 2} Find help file


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:find_hlp_file}
{it:commandname_or_abbreviation}

{p 8 16 2}
{cmd:_findhlpalias}
{it:commandname_or_abbreviation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:find_hlp_file} locates the help for
{it:commandname_or_abbreviation}.

{pstd}
{cmd:_findhlpalias}
assists in locating help files associated with
{it:commandname_or_abbreviation}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The help file associated with {it:commandname_or_abbreviation} might be in

	{it:commandname_or_abbreviation}{cmd:.sthlp}
    or
	{it:commandname_or_abbreviation}{cmd:.hlp}
    or
	{it:somethingelse}{cmd:.sthlp}
    or
	{it:somethingelse}{cmd:.hlp}

{pstd}
The system files {cmd:ahelp_alias.maint}, {cmd:bhelp_alias.maint}, ...
{cmd:zhelp_alias.maint} list the aliases.  The right way to find the
help file associated with {cmd:`name'} is

	{cmd:find_hlp_file `name'}

{pstd}
The base name of the help file -- the name without the {cmd:.sthlp}
or {cmd:.hlp} suffix -- 
will be returned in {cmd:r(result)}, or an error message will be displayed and
r(111) returned.

{pstd}
{cmd:find_hlp_file} is implemented in terms of {cmd:_findhlpalias}.
{cmd:_findhlpalias} searches the appropriate {cmd:.maint} file for
{it:commandname_or_abbreviation} and, if found, returns in {cmd:r(name)} the
aliased name.  If not found, no error message is displayed and returned is
r(111).

{pstd}
Thus, the code for {cmd:find_hlp_file} reads, roughly,

	{cmd}program find_hlp_file, rclass
		args name

		capture which `name'.sthlp
		if c(rc)==0 {
			return local result "`name'"
			exit
		}
		capture which `name'.hlp
		if c(rc)==0 {
			return local result "`name'"
			exit
		}
		capture _findhlpalias `name'
		if c(rc)==0 {
			local alias "`r(name)'"
			capture which `alias'.sthlp
			if c(rc)==0 {
				return local result "`alias'"
				exit
			}
			capture which `alias'.hlp
			if c(rc)==0 {
				return local result "`alias'"
				exit
			}
		}
		display as err "help for `name' not found"
		exit 111
	end{txt}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:find_hlp_file} returns in {cmd:r(result)} the base name of the help file
without the {cmd:.sthlp} or {cmd:.hlp} suffix.  If no help file exists for
{it:commandname_or_abbreviation}, an error is returned:  "help for ___ not
found"; r(111).

{pstd}
{cmd:_findhlpalias} returns in {cmd:r(name)} the alias (base name)
associated with
{it:commandname_or_abbreviation}.  If there is no alias associated with
{it:commandname_or_abbreviation}, no error message is displayed, but
returned is r(111).
{p_end}
