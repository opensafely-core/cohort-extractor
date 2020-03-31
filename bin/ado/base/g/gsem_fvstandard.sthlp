{smcl}
{* *! version 1.0.0  15mar2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Syntax" "gsem_fvstandard##syntax"}{...}
{viewerjumpto "Description" "gsem_fvstandard##description"}{...}
{viewerjumpto "Option" "gsem_fvstandard##option"}{...}
{title:Title}

{p2colset 5 31 33 2}{...}
{p2col:{hi:[SEM] gsem, fvstandard} {hline 2}}Keep track of levels for factor
variables{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} ... [{cmd:,} {opt fvstand:ard} ...]


{marker description}{...}
{title:Description}

{pstd}
{cmd:gsem, fvstandard}, when
{helpb set fvtrack:set fvtrack factor} is in effect, changes how {cmd:gsem}
keeps track of factor-variable levels within interaction terms.


{marker option}{...}
{title:Option}

{phang}
{cmd:fvstandard}
specifies that all factor variables automatically be assigned a base
level among the specified or implied levels and that implied yet unspecified
elements of interaction terms be left in the model specification.

{pmore}
This option is ignored unless {helpb set fvtrack:set fvtrack factor} is
in effect.
{p_end}
