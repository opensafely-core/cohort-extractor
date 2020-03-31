{smcl}
{* *! version 1.0.0  21jun2019}{...}
{vieweralsosee "[D] vl rebuild" "mansection D vlrebuild"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] vl" "help vl"}{...}
{vieweralsosee "[D] vl create" "help vl create"}{...}
{vieweralsosee "[D] vl drop" "help vl drop"}{...}
{vieweralsosee "[D] vl list" "help vl list"}{...}
{vieweralsosee "[D] vl set" "help vl set"}{...}
{viewerjumpto "Syntax" "vl rebuild##syntax"}{...}
{viewerjumpto "Description" "vl rebuild##description"}{...}
{viewerjumpto "Links to PDF documentation" "vl rebuild##linkspdf"}{...}
{viewerjumpto "Example" "vl rebuild##example"}{...}
{viewerjumpto "Stored results" "vl rebuild##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] vl rebuild} {hline 2}}Rebuild variable lists{p_end}
{p2col:}({mansection D vlrebuild:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:vl} {cmd:rebuild}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vl} {cmd:rebuild} restores system-defined and user-defined variable
lists.  After loading a dataset with {helpb use}, run {cmd:vl} {cmd:rebuild}.

{pstd}
After using {helpb merge} or {helpb append}, run {cmd:vl} {cmd:rebuild} to
merge variable lists.  You only need to run {cmd:vl} {cmd:rebuild} when the
using dataset has variable lists.

{pstd}
After dropping variables with {helpb drop}, run {cmd:vl} {cmd:rebuild} to
remove the dropped variables from all variable lists.

{pstd}
After modifying variable lists with {cmd:vl} {cmd:modify} or {cmd:vl}
{cmd:move}, run {cmd:vl} {cmd:rebuild} to update variable lists created by
{cmd:vl} {cmd:substitute}.

{pstd}
And if you are confused, know that it never hurts to run {cmd:vl}
{cmd:rebuild}.

{pstd}
For an introduction to the {cmd:vl} commands, see
{manhelp vl D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D vlrebuildQuickstart:Quick start}

        {mansection D vlrebuildRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the system-defined variable lists{p_end}
{phang2}{cmd:. vl set}{p_end}

{pstd}Save the dataset to the current working directory{p_end}
{phang2}{cmd:. save auto}{p_end}

{pstd}Later, load the data from the current working directory{p_end}
{phang2}{cmd:. use auto}{p_end}

{pstd}Restore the system-defined variable lists{p_end}
{phang2}{cmd:. vl rebuild}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vl rebuild} stores the following in {cmd:r()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Scalars}{p_end}
{synopt:{cmd:r(k_system)}}number of variables in system-defined variable lists{p_end}
{synopt:{cmd:r(k_vlcategorical)}}number of variables in {cmd:vlcategorical}{p_end}
{synopt:{cmd:r(k_vlcontinuous)}}number of variables in {cmd:vlcontinuous}{p_end}
{synopt:{cmd:r(k_vluncertain)}}number of variables in {cmd:vluncertain}{p_end}
{synopt:{cmd:r(k_vlother)}}number of variables in {cmd:vlother}{p_end}
{synopt:{cmd:r(k_vldummy)}}number of variables in {cmd:vldummy} when defined{p_end}
{synopt:{cmd:r(k_user)}}number of variables in user-defined variable lists{p_end}
{synopt:{cmd:r(k_}{it:vlusername}{cmd:)}}number of variables in {it:vlusername}{p_end}

{p2col 5 23 27 2: Macros}{p_end}
{synopt:{cmd:r(vlsysnames)}}names of system-defined variable lists{p_end}
{synopt:{cmd:r(vlusernames)}}names of user-defined variable lists{p_end}
{p2colreset}
