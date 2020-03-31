{smcl}
{* *! version 1.0.3  19oct2017}{...}
{vieweralsosee "[MV] cluster programming subroutines" "mansection MV clusterprogrammingsubroutines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{viewerjumpto "Description" "cluster subroutines##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_subroutines##linkspdf"}{...}
{viewerjumpto "Remarks" "cluster subroutines##remarks"}{...}
{p2colset 1 41 43 2}{...}
{p2col:{bf:[MV] cluster programming subroutines} {hline 2}}Add cluster-analysis routines{p_end}
{p2col:}({mansection MV clusterprogrammingsubroutines:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry describes how to extend Stata's {cmd:cluster} command; see
{manhelp cluster MV}.  Programmers can add subcommands to {cmd:cluster}, add
functions to {cmd:cluster} {cmd:generate} (see
{manhelp cluster_generate MV:cluster generate}), add
stopping rules to {cmd:cluster} {cmd:stop} (see
{manhelp cluster_stop MV:cluster stop}), and
set up an alternative command to be executed when {cmd:cluster} {cmd:dendrogram}
is called (see {manhelp cluster_dendrogram MV:cluster dendrogram}).

{pstd}
The {cmd:cluster} command also provides utilities for programmers; see
{manhelp cluster_programming MV:cluster programming utilities} to learn more.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterprogrammingsubroutinesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
You add a cluster by creating a Stata program with the name
{hi:cluster_}{it:subcmdname}.  For example, if I wanted to add the subcommand
{cmd:xyz} to {cmd:cluster}, I would create {cmd:cluster_xyz.ado}.  Users could
then execute my {cmd:xyz} subcommand with

{p 8 12 2}{cmd:cluster xyz} {it:...}.

{p 4 4 2}
Everything entered on the command line following {bind:{cmd:cluster xyz}}
is passed to {cmd:cluster_xyz}.

{p 4 4 2}
Programmers can add functions to the {bind:{cmd:cluster generate}} command.
This is accomplished by creating a command called {cmd:clusgen_}{it:name}.
For example, if I wanted to add a function called {cmd:abc()} to
{bind:{cmd:cluster generate}} I would create {cmd:clusgen_abc.ado}.  Users
could then execute

{p 8 12 2}{cmd:cluster generate} {it:varname} {cmd:= abc(}{it:...}{cmd:)} {it:...}

{p 4 4 2}
Everything entered on the command line following {bind:{cmd:cluster gen}}
is passed to {cmd:clusgen_abc}.

{p 4 4 2}
New stopping rules can be added to the {bind:{cmd:cluster stop}} command.
You do this by creating a command called {cmd:clstop_}{it:name}.  For example,
if I created {cmd:clstop_xyz.ado}, the {bind:{cmd:cluster stop}} command would
gain the option {cmd:rule(xyz)}

{p 8 12 2}{cmd:cluster stop} [{it:clname}] {cmd:, rule(xyz)} {it:...}

{p 4 4 2}
{cmd:clstop_xyz} is passed the cluster name ({it:clname}) as entered by the
user (or the name of the current cluster result if not specified) followed by
a comma and all the options entered by the user except for the {cmd:rule(xyz)}
option.

{p 4 4 2}
Programmers can change the behavior of the {bind:{cmd:cluster dendrogram}}
command (alias {bind:{cmd:cluster tree}}).  This is accomplished with using
the {cmd:other()} option of the {bind:{cmd:cluster set}} command with a
{it:tag} of {cmd:treeprogram} and {it:text} giving the name of the command to
be used in place of the standard Stata program for
{bind:{cmd:cluster dendrogram}}.  For example, if I had created a new
hierarchical cluster analysis method for Stata that needed a different
algorithm for producing dendrograms, I would use the command

{p 8 12 2}{cmd:cluster set} {it:clname} {cmd:, other(treeprogram} {it:progname}{cmd:)}

{p 4 4 2}
to set {it:progname} as the program to be executed when
{bind:{cmd:cluster dendrogram}} is called.
{p_end}
