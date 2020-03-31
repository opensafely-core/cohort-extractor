{smcl}
{* *! version 1.0.1  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{vieweralsosee "[D] rename group" "help rename group"}{...}
{viewerjumpto "Syntax" "_rename##syntax"}{...}
{viewerjumpto "Description" "_rename##description"}{...}
{title:Title}

    {bf:[D] _rename} {hline 2} Rename variable


{marker syntax}{...}
{title:Syntax}

{phang}
Rename variable

{p 8 16 2}
{opt _rename} {it:old_varname} {it:new_varname}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_rename} 
changes the name of an existing variable {it:old_varname} to
{it:new_varname}; the contents of the variable are unchanged.
Use {manhelp rename D} in preference to {cmd:_rename}.

{pstd}
As of Stata 12, code form {cmd:rename} was changed to ado/Mata from
internal C.  {cmd:_rename} is the old, built-in {cmd:rename} command.
It is used in testing Stata, and when you set {cmd:version} less 
than 12, {cmd:_rename} is the {cmd:rename} command.
{p_end}
