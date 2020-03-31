{smcl}
{* *!  version 1.0.1  23may2013}{...}
{* this sthlp file is called by sg__connections.dlg, sg__errvar.dlg, sg__variables.dlg}{...}
{vieweralsosee "[SEM] sem and gsem option constraints()" "help sem and gsem option constraints"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation##item11"}{...}
{title:Constraints}

{pstd}
Numeric constraints or symbolic constraints may be specified in the dialog
field.  Enter a number to constrain the parameter to that value.  A symbolic
constraint is specified by entering a name (1 to 32 characters in length).
Parameters that have the same symbolic constraint are constrained to be equal.

{pstd}
You may also enter a linear combination of symbolic constraints.  For instance,
entering {cmd:2*c1} would constrain the parameter to be twice that of another
parameter that was symbolically constrained to {cmd:c1}.  More complicated
linear combinations, such as {cmd:3*c1+10}, are also allowed.
{p_end}
