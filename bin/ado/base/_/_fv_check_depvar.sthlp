{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_fv_check_depvar##syntax"}{...}
{viewerjumpto "Description" "_fv_check_depvar##description"}{...}
{viewerjumpto "Option" "_fv_check_depvar##option"}{...}
{title:Title}

{p 4 30 2}
{hi:[P] _fv_check_depvar} {hline 2}
Check for factor variables in the list of dependent variables


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_fv_check_depvar} {it:{help varname:depvars}} [{cmd:,} {opt k(#)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_fv_check_depvar} checks for factor variables and interactions in
{it:depvars} and reports an error if any are found.


{marker option}{...}
{title:Option}

{phang}
{opt k(#)} specifies that only the first {it:#} variables be checked.  If
{it:#} is less than 1 or greater than the number of specified variables in
{it:{help varname:depvars}}, then all the terms are checked.  The default is to
check all variables in {it:depvars}.
{p_end}
