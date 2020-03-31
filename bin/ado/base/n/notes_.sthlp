{smcl}
{* *! version 1.0.2  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{viewerjumpto "Syntax" "notes_##syntax"}{...}
{viewerjumpto "Description" "notes_##description"}{...}
{title:Title}

{p 4 30 2}
{bf:[P] notes_} {hline 2} Programmer's commands for use with notes


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:notes _dir}{bind:   }{it:macname}

{phang2}
{cmd:notes _count}
{it:macname} {cmd::} {it:name}

{phang2}
{cmd:notes _fetch}
{it:macname} {cmd::} {it:name} {it:#}


{marker description}{...}
{title:Description}

{pstd}
These additional {bf:{help notes:notes}} subcommands are for use by
programmers.  They are especially useful in certification scripts.

{pstd}
{cmd:notes _dir} {it:macname} 
returns in local macro {it:macname} the names that have notes associated with
them.  {cmd:_dta} is listed first, if it has notes, followed by variables that
have notes.  Variables are in alphabetical order.

{pstd}
{cmd:notes _count} {it:macname} {cmd::} {it:name} returns the number of 
notes associated with {it:name}.  {it:name} may be {cmd:_dta} or an
unabbreviated variable name.  The number of notes associated with {it:name}
are returned in local macro {it:macname}.  If {it:name} has no notes, 0 is
stored in {it:macname}.

{pstd}
{cmd:notes _fetch} {it:macname} {cmd::} {it:name} {it:#} returns the 
contents of the {it:#}th note associated with {it:name}, or returns 
"".  The returned result is stored in local macro {it:macname}. 

{pstd}
In the above commands with a colon, the colon must be surrounded by one or
more spaces.

{pstd}
Warning: Code {cmd:notes} and not {cmd:note} when using these commands.
If you code the singular, these commands will appear to work, but the returned
result will not be filled into the local macro.
{p_end}
