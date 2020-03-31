{smcl}
{* *! version 1.0.0  19jun2019}{...}
{vieweralsosee "[D] vl list" "mansection D vllist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] vl" "help vl"}{...}
{vieweralsosee "[D] vl create" "help vl create"}{...}
{vieweralsosee "[D] vl drop" "help vl drop"}{...}
{vieweralsosee "[D] vl rebuild" "help vl rebuild"}{...}
{vieweralsosee "[D] vl set" "help vl set"}{...}
{viewerjumpto "Syntax" "vl list##syntax"}{...}
{viewerjumpto "Description" "vl list##description"}{...}
{viewerjumpto "Links to PDF documentation" "vl list##linkspdf"}{...}
{viewerjumpto "Options" "vl list##options"}{...}
{viewerjumpto "Examples" "vl list##examples"}{...}
{viewerjumpto "Stored results" "vl list##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] vl list} {hline 2}}List contents of variable lists{p_end}
{p2col:}({mansection D vllist:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Show the contents of variable lists

{p 8 16 2}
{cmd:vl} {cmd:list} [{it:vlnamelist}] [{cmd:,} {it:options}]


{pstd}
Show the variable lists to which variables belong

{p 8 16 2}
{cmd:vl} {cmd:list} {cmd:(}{varlist}{cmd:)}
[{cmd:,} {it:options}]


{pstd}
Show names of all variable lists

{p 8 16 2}
{cmd:vl} {cmd:dir}[{cmd:,} {opt sys:tem} {cmd:user}]


{phang}
{it:vlnamelist} is a list of variable-list names.{p_end}
{phang}
{cmd:(_all)} or {cmd:(*)} can be used to specify all numeric variables in the
dataset.

{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt :{opt sys:tem}}show only system-defined variable lists{p_end}
{synopt :{opt user}}show only user-defined variable lists{p_end}
{synopt :{opt min:imum}}show minimum value of each variable{p_end}
{synopt :{opt max:imum}}show maximum value of each variable{p_end}
{synopt :{opt obs:ervations}}show number of nonmissing observations of each
variable{p_end}
{synopt :{opt sort}}order by variable list and then alphabetically by variable name when
{it:vlnamelist} is specified; order alphabetically by variable name and then
by variable list when {cmd:(}{varlist}{cmd:)} is specified{p_end}
{synopt :{opt strok}}allow string variables when {cmd:(}{varlist}{cmd:)} is
specified{p_end}
{synopt :{opt nolstretch}}do not stretch the width of the table to accommodate
long names{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vl} {cmd:list} shows the contents of variable lists when given
names of variable lists.  When given names of variables, it shows the
variable lists to which each variable belongs.

{pstd}
{cmd:vl} {cmd:dir} shows the names of all variable lists.

{pstd}
For an introduction to the {cmd:vl} commands, see
{manhelp vl D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D vllistQuickstart:Quick start}

        {mansection D vllistRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}


{marker options}{...}
{title:Options}

{phang}
{cmd:system} specifies that only system-defined variable lists be shown.  By
default, both system-defined and user-defined variable lists are shown.

{phang}
{cmd:user} specifies that only user-defined variable lists be shown.

{phang}
{cmd:minimum} specifies that the minimum value of each variable be displayed.

{phang}
{cmd:maximum} specifies that the minimum value of each variable be displayed.

{phang}
{cmd:observations} specifies that number of nonmissing observations of each
variable be displayed.

{phang}
{cmd:sort} specifies that the listing be sorted.  When {it:vlnamelist} is
specified, the listing is ordered by variable list and then alphabetically by
variable name.  By default in this case, variables are listed in the order in
which they were added to the variable list.

{pmore}
When {cmd:(}{varlist}{cmd:)} is specified, the listing is ordered
alphabetically by variable name and then by variable list.  By default in this
case, variables are listed in the order in which they appear in {it:varlist}.

{phang}
{cmd:strok} specifies that string variables be included in the listing when
{cmd:(}{varlist}{cmd:)} is specified.  By default, specifying string
variables in {it:varlist} gives an error message.  Specifying {cmd:strok}
prevents this error message and lists any string variables.

{phang}
{cmd:nolstretch} specifies that the width of the table not be automatically
widened to accommodate long variable and variable-list names.  When
{cmd:nolstretch} is specified, names are abbreviated to make the table width
no more than 79 characters.  The default, {cmd:lstretch}, is to automatically
widen the table up to the width of the Results window.  To change the default,
use {helpb lstretch:set lstretch off}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the system-defined variable lists{p_end}
{phang2}{cmd:. vl set}{p_end}

{pstd}List the contents of the variable lists{p_end}
{phang2}{cmd:. vl list}{p_end}

{pstd}Same as above, but list by variable name{p_end}
{phang2}{cmd:. vl list (*)}{p_end}

{pstd}Show names of variable lists{p_end}
{phang2}{cmd:. vl dir}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vl list} stores the following in {cmd:r()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of variables listed{p_end}
{synopt:{cmd:r(k_system)}}number of variables listed in system-defined
variable lists{p_end}
{synopt:{cmd:r(k_not_system)}}number of variables listed not in
system-defined variable lists{p_end}
{synopt:{cmd:r(k_vlcategorical)}}number of variables listed in {cmd:vlcategorical}{p_end}
{synopt:{cmd:r(k_vlcontinuous)}}number of variables listed in {cmd:vlcontinuous}{p_end}
{synopt:{cmd:r(k_vluncertain)}}number of variables listed in {cmd:vluncertain}{p_end}
{synopt:{cmd:r(k_vlother)}}number of variables listed in {cmd:vlother}{p_end}
{synopt:{cmd:r(k_vldummy)}}number of variables listed in {cmd:vldummy} when
defined{p_end}
{synopt:{cmd:r(k_user)}}number of variables listed in user-defined variable
lists{p_end}
{synopt:{cmd:r(k_not_user)}}number of variables listed not in user-defined
variable lists{p_end}
{synopt:{cmd:r(k_}{it:vlusername}{cmd:)}}number of variables listed in {it:vlusername}{p_end}
{synopt:{cmd:r(k_string)}}number of string variables listed when {cmd:strok}
specified{p_end}

{p2col 5 23 27 2: Macros}{p_end}
{synopt:{cmd:r(vlsysnames)}}names of all system-defined variable lists{p_end}
{synopt:{cmd:r(vlusernames)}}names of all user-defined variable lists{p_end}

{pstd}
{cmd:vl dir} stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k_system)}}number of variables in system-defined variable
lists{p_end}
{synopt:{cmd:r(k_vlcategorical)}}number of variables in {cmd:vlcategorical}{p_end}
{synopt:{cmd:r(k_vlcontinuous)}}number of variables in {cmd:vlcontinuous}{p_end}
{synopt:{cmd:r(k_vluncertain)}}number of variables in {cmd:vluncertain}{p_end}
{synopt:{cmd:r(k_vlother)}}number of variables in {cmd:vlother}{p_end}
{synopt:{cmd:r(k_vldummy)}}number of variables in {cmd:vldummy} when
defined{p_end}
{synopt:{cmd:r(k_user)}}number of variables in user-defined variable
lists{p_end}
{synopt:{cmd:r(k_}{it:vlusername}{cmd:)}}number of variables in {it:vlusername}{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(vlsysnames)}}names of system-defined variable lists{p_end}
{synopt:{cmd:r(vlusernames)}}names of user-defined variable lists{p_end}
{p2colreset}{...}
