{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[MV] clustermat" "mansection MV clustermat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] cluster programming subroutines" "help cluster_subroutines"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{viewerjumpto "Syntax" "clustermat##syntax"}{...}
{viewerjumpto "Description" "clustermat##description"}{...}
{viewerjumpto "Links to PDF documentation" "clustermat##linkspdf"}{...}
{viewerjumpto "Examples" "clustermat##examples"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MV] clustermat} {hline 2}}Introduction to clustermat commands
{p_end}
{p2col:}({mansection MV clustermat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:clustermat} {it:linkage} {it:matname}  ...

INCLUDE help clus_linkage
    See {manhelp cluster_linkage MV:cluster linkage}.

{pstd}
{cmd:clustermat stop} has similar syntax to that of {cmd:cluster stop}; see
{manhelp cluster_stop MV:cluster stop}.  For the remaining postclustering
subcommands and user utilities, you may specify either {cmd:cluster} or
{cmd:clustermat} -- it does not matter which.


{marker description}{...}
{title:Description}

{pstd}
{cmd:clustermat} performs hierarchical cluster analysis on the dissimilarity
matrix {it:matname}.  {cmd:clustermat} is part of the {cmd:cluster} suite of
commands; see {manhelp cluster MV}.  All Stata hierarchical clustering
methods are allowed with {cmd:clustermat}.  The partition-clustering methods
({cmd:kmeans} and {cmd:kmedians}) are not allowed because they require the data.

{pstd}
See {manhelp cluster MV} for a listing of all the {cmd:cluster} and 
{cmd:clustermat} commands.  The {cmd:cluster dendrogram} command 
({manhelp cluster_dendrogram MV:cluster dendrogram}) will display the
resulting dendrogram, the {cmd:clustermat stop} command 
(see {manhelp clustermat_stop MV:clustermat stop}) will help in
determining the number of groups, and the {cmd:cluster generate} command
(see {manhelp cluster_generate MV:cluster generate}) will produce grouping
variables.  Other useful {cmd:cluster} subcommands include {cmd:notes},
{cmd:dir}, {cmd:list}, {cmd:drop}, {cmd:use}, {cmd:rename}, and
{cmd:renamevar}; see {manhelp cluster_notes MV:cluster notes} and
{manhelp cluster_utility MV:cluster utility}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clustermatRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wclub}{p_end}
{phang2}{cmd:. matrix dissimilarity clubD = , variables Jaccard}
          {cmd:dissim(oneminus)}

{pstd}Examine portion of dissimilarity matrix{p_end}
{phang2}{cmd:. matlist clubD[1..5, 1..5]}

{pstd}Perform single linkage hierarchical clustering, clearing dataset in memory
{p_end}
{phang2}{cmd:. clustermat singlelinkage clubD, name(singlink) clear}{p_end}
{phang2}{cmd:. cluster dendrogram singlink}

{pstd}Perform Ward's linkage hierarchical clustering, adding to results in
memory{p_end}
{phang2}{cmd:. clustermat wardslinkage clubD, name(wardslink) add}{p_end}
{phang2}{cmd:. cluster dendrogram wardslink}{p_end}
