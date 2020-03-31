{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog list "dialog cluster_list"}{...}
{viewerdialog "drop" "dialog cluster_drop"}{...}
{viewerdialog "rename[var]" "dialog cluster_rename"}{...}
{vieweralsosee "[MV] cluster utility" "mansection MV clusterutility"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster notes" "help cluster_notes"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] char" "help char"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{viewerjumpto "Syntax" "cluster utility##syntax"}{...}
{viewerjumpto "Menu" "cluster utility##menu"}{...}
{viewerjumpto "Description" "cluster utility##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_utility##linkspdf"}{...}
{viewerjumpto "Options for cluster list" "cluster utility##options_list"}{...}
{viewerjumpto "Options for cluster renamevar" "cluster utility##options_renamevar"}{...}
{viewerjumpto "Examples" "cluster utility##examples"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[MV] cluster utility} {hline 2}}List, rename, use, and drop
cluster analyses{p_end}
{p2col:}({mansection MV clusterutility:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

INCLUDE help cluster_utility_syntax


{marker menu}{...}
{title:Menu}

    {title:cluster list}

{phang2}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
      {bf:Detailed listing of clusters} 

    {title:cluster drop}

{phang2}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
       {bf:Drop cluster analyses}

    {title:cluster rename}

{phang2}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
        {bf:Rename a cluster or cluster variables}


{marker description}{...}
{title:Description}

{pstd}
These cluster utility commands allow you to view and manipulate the cluster
objects that you have created.  See {manhelp cluster MV} for a list of the
available {cmd:cluster} commands.  If you want even more control over your
cluster objects, or if you are programming new {cmd:cluster} subprograms,
more {cmd:cluster} programmer utilities are available; see
{manhelp cluster_programming MV:cluster programming utilities} for details.

{pstd}
The {cmd:cluster dir} command provides a directory-style listing of all the
currently defined clusters.  {cmd:cluster list} provides a detailed listing
of the specified clusters or of all current clusters if no cluster names are
specified.  The default action is to list all the information attached to the
clusters.  You may limit the type of information listed by specifying
particular options.

{pstd}
The {cmd:cluster drop} command removes the named clusters.  The keyword
{cmd:_all} specifies that all current cluster analyses be dropped.

{pstd}
Stata cluster analyses are referred to by name.  Many of the {cmd:cluster}
commands default to using the most recently defined cluster analysis if no
cluster name is provided.  The {cmd:cluster use} command sets the specified
cluster analysis as the most recently executed cluster analysis, so that,
by default, this cluster analysis will be used if the cluster name is omitted
from many of the {cmd:cluster} commands.  You may use the
{cmd:*} and {cmd:?} name-matching characters to shorten the typing of cluster
names; see {findalias frabbrev}.

{pstd}
{cmd:cluster rename} allows you to rename a cluster analysis without
changing any of the variable names attached to the cluster analysis.
The {cmd:cluster renamevar} command, on the
other hand, allows you to rename the variables attached to a cluster analysis
and to update the cluster object with the new variable names.  Do not
use the {cmd:rename} command (see {manhelp rename D}) to rename
variables attached to a cluster analysis because this would invalidate the
cluster object.  Use the {cmd:cluster renamevar} command instead.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterutilityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_list}{...}
{title:Options for cluster list}

{dlgtab:Options}

{phang}
{cmd:notes} specifies that cluster notes be listed.

{phang}
{cmd:type} specifies that the type of cluster analysis be listed.

{phang}
{cmd:method} specifies that the cluster analysis method be listed.

{phang}
{cmd:dissimilarity} specifies that the dissimilarity measure be listed.

{phang}
{cmd:similarity} specifies that the similarity measure be listed.

{phang}
{cmd:vars} specifies that the variables attached to the clusters be
listed.

{phang}
{cmd:chars} specifies that any Stata characteristics attached to the clusters
be listed.

{phang}
{cmd:other} specifies that information attached to the clusters under the
heading "other" be listed.

{pstd}The following option is available with {cmd:cluster list} but is not
shown in the dialog box:

{phang}
{cmd:all}, the default, specifies that all items and information attached to
the cluster(s) be listed.  You may instead pick among the {cmd:notes},
{cmd:type}, {cmd:method}, {cmd:dissimilarity}, {cmd:similarity}, {cmd:vars},
{cmd:chars}, and {cmd:other} options to limit what is presented.


{marker options_renamevar}{...}
{title:Options for cluster renamevar}

{phang}
{cmd:name(}{it:clname}{cmd:)} indicates
the cluster analysis within which the variable renaming is to take place.  If
{cmd:name()} is not specified, the most recently performed cluster analysis
(or the one specified by {cmd:cluster use}) will be used.

{phang}
{cmd:prefix} specifies that all
variables attached to the cluster analysis that have {it:oldstub} as the
beginning of their name be renamed, with {it:newstub} replacing
{it:oldstub}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. cluster dir}

{phang}{cmd:. cluster list myclus}{p_end}
{phang}{cmd:. cluster list}{p_end}
{phang}{cmd:. cluster list a*, vars notes}

{phang}{cmd:. cluster renamevar a5kmeans g5km, name(a5kmeans)}{p_end}
{phang}{cmd:. cluster use xcls}{p_end}
{phang}{cmd:. cluster renamevar xcls_ wrk, prefix}{p_end}
{phang}{cmd:. cluster renamevar g grp, prefix name(a5kmeans)}

{phang}{cmd:. cluster rename xcls bob}{p_end}
{phang}{cmd:. cluster rename a5kmeans sam}

{phang}{cmd:. cluster drop sam myclus}{p_end}
{phang}{cmd:. cluster drop _all}{p_end}
