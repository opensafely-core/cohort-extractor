{smcl}
{* *! version 1.0.2  11feb2011}{...}
{title:Out-of-date command}

{pstd}
As of version 6.0 {cmd:eq} is now undocumented but continues to work.
In its place multiple-equation estimators now accept a new in-line equation
syntax or obtain the second equation as an option.  {cmd:heckman}, for
instance, does the latter; see {manhelp heckman R}.  {cmd:sureg}, for
instance, does the former; see {manhelp sureg R}.  In all cases, the old
syntax continues to work, but only if you first {cmd:set version 5.0}.
{p_end}
