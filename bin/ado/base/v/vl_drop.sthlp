{smcl}
{* *! version 1.0.0  12jun2019}{...}
{vieweralsosee "[D] vl drop" "mansection D vldrop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] vl" "help vl"}{...}
{vieweralsosee "[D] vl create" "help vl create"}{...}
{vieweralsosee "[D] vl list" "help vl list"}{...}
{vieweralsosee "[D] vl rebuild" "help vl rebuild"}{...}
{vieweralsosee "[D] vl set" "help vl set"}{...}
{viewerjumpto "Syntax" "vl drop##syntax"}{...}
{viewerjumpto "Description" "vl drop##description"}{...}
{viewerjumpto "Links to PDF documentation" "vl drop##linkspdf"}{...}
{viewerjumpto "Options" "vl drop##options"}{...}
{viewerjumpto "Examples" "vl drop##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] vl drop} {hline 2}}Drop variable lists or variables from variable lists
{p_end}
{p2col:}({mansection D vldrop:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Drop variable lists

{p 8 16 2}
{cmd:vl drop} {it:vlnamelist}
[{cmd:,} {opt sys:tem} {cmd:user}]


{pstd}
Drop variables from variable lists

{p 8 16 2}
{cmd:vl drop} {cmd:(}{varlist}{cmd:)}
[{cmd:,} {opt sys:tem} {cmd:user}]


{pstd}
Clear all variable lists

{p 8 16 2}
{cmd:vl clear}
[{cmd:,} {opt sys:tem} {cmd:user}]


{phang}
{it:vlnamelist} is a list of variable-list names.{p_end}
{phang}
{cmd:(_all)} or {cmd:(*)} can be used to specify all numeric variables in the
dataset.


{marker description}{...}
{title:Description}

{pstd}
{cmd:vl} {cmd:drop} {it:vlusername} deletes user-defined variable lists.

{pstd}
{cmd:vl} {cmd:drop} {it:vlsysname} zeros system-defined variable
lists.  They still exist but are empty.

{pstd}
{cmd:vl} {cmd:drop} {cmd:(}{varlist}{cmd:)} removes variables from
all variable lists.

{pstd}
{cmd:vl} {cmd:clear} deletes all variable lists and removes all traces of the
{cmd:vl} system.

{pstd}
For an introduction to the {cmd:vl} commands, see
{manhelp vl D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D vldropQuickstart:Quick start}

        {mansection D vldropRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}


{marker options}{...}
{title:Options}

{phang}
{cmd:system} when specified with {cmd:vl} {cmd:drop} {cmd:(}{varlist}{cmd:)},
drops the variables in {it:varlist} only from system-defined variable lists.
By default, variables are dropped from all variable lists, both system-defined
and user-defined.

{pmore}
When specified with {cmd:vl} {cmd:clear}, only the system-defined variable
lists are deleted.  By default, both the system-defined and user-defined
variable lists are deleted, and all traces of the {cmd:vl} system are gone.

{phang}
{cmd:user} when specified with {cmd:vl} {cmd:drop} {cmd:(}{varlist}{cmd:)},
drops the variables in {it:varlist} only from user-defined variable lists.

{pmore}
When specified with {cmd:vl} {cmd:clear}, only the user-defined variable lists
are deleted.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the system-defined variable lists{p_end}
{phang2}{cmd:. vl set}{p_end}

{pstd}Create the variable lists {cmd:myvars} and {cmd:myvars2}{p_end}
{phang2}{cmd:. vl create myvars = (price-weight)}{p_end}
{phang2}{cmd:. vl create myvars2 = (turn foreign)}{p_end}

{pstd}Delete variable {cmd:price} from the user-defined variable list
{cmd:myvars}{p_end}
{phang2}{cmd:. vl drop (price), user}{p_end}

{pstd}Delete the user-defined variable list {cmd:myvars}{p_end}
{phang2}{cmd:. vl drop myvars}{p_end}

{pstd}Delete all system-defined variable lists{p_end}
{phang2}{cmd:. vl clear, system}{p_end}

    {hline}
{pstd}Create the system-defined variable lists{p_end}
{phang2}{cmd:. vl set}{p_end}

{pstd}Delete all variable lists and all traces of the {cmd:vl} system{p_end}
{phang2}{cmd:. vl clear}{p_end}

    {hline}
