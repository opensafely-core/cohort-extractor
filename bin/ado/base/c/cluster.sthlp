{smcl}
{* *! version 1.1.8  22mar2018}{...}
{vieweralsosee "[MV] cluster" "mansection MV cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster programming subroutines" "help cluster_subroutines"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{viewerjumpto "Syntax" "cluster##syntax"}{...}
{viewerjumpto "Description" "cluster##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster##linkspdf"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[MV] cluster} {hline 2}}Introduction to cluster-analysis commands{p_end}
{p2col:}({mansection MV cluster:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Cluster analysis of data

	{cmd:cluster} {it:subcommand} {it:...}

 
    Cluster analysis of a dissimilarity matrix

	{cmd:clustermat} {it:subcommand} {it:...}


{marker description}{...}
{title:Description}

{pstd}
Stata's cluster-analysis routines provide several hierarchical and
partition clustering methods, postclustering summarization methods, and
cluster-management tools.  This entry presents an overview of
the {cmd:cluster} and {cmd:clustermat} commands (also see
{manhelp clustermat MV}), as well as Stata's cluster-analysis management
tools.  The hierarchical clustering methods may be applied
to the data by using the {cmd:cluster} command or to a user-supplied
dissimilarity matrix by using the {cmd:clustermat} command.

{pstd}
The {cmd:cluster} command has the following {it:subcommands}, which
are detailed in their respective manual entries.

	Topic{col 44}{cmd:cluster} {it:subcommand}
	{hline 65}
	Partition-clustering methods for observations
	(see {manhelp cluster_kmeans MV:cluster kmeans and kmedians})
	    Kmeans{col 44}{cmd:cluster kmeans}
	    Kmedians{col 44}{cmd:cluster kmedians}

	Hierarchical clustering methods for observations
	(see {manhelp cluster_linkage MV:cluster linkage})
	    Single linkage{col 44}{cmd:cluster singlelinkage}
	    Average linkage{col 44}{cmd:cluster averagelinkage}
	    Complete linkage{col 44}{cmd:cluster completelinkage}
	    Weighted-average linkage{col 44}{cmd:cluster waveragelinkage}
	    Median linkage{col 44}{cmd:cluster medianlinkage}
	    Centroid linkage{col 44}{cmd:cluster centroidlinkage}
	    Ward's linkage{col 44}{cmd:cluster wardslinkage}

	Postclustering commands
	    Stopping rules{col 44}{helpb cluster stop}
 	    Dendrograms (cluster trees){col 44}{helpb cluster dendrogram}
		{col 44}(synonym: {cmd:cluster} {cmd:tree})
	    Generate grouping variables{col 44}{helpb cluster generate}

	User utilities
	    Cluster notes{col 44}{helpb cluster notes}
	    Other user utilities
	    (see {manhelp cluster_utility MV:cluster utility})
		{col 44}{cmd:cluster dir}
		{col 44}{cmd:cluster list}
		{col 44}{cmd:cluster drop}
		{col 44}{cmd:cluster use}
		{col 44}{cmd:cluster rename}
		{col 44}{cmd:cluster renamevar}

	Programmer utilities
	(see {manhelp cluster_programming MV:cluster programming utilities})
		{col 44}{cmd:cluster query}
		{col 44}{cmd:cluster set}
		{col 44}{cmd:cluster} {cmd:delete}
		{col 44}{cmd:cluster} {cmd:parsedistance}
		{col 44}{cmd:cluster measures}

	(Dis)similarity measures
	(see {manhelpi measure_option MV})
	{hline 65}

	{pstd}
	The {cmd:clustermat} command has the following {it:subcommands},
	which are detailed along with the related {cmd:cluster} command
	in the {helpb cluster linkage} help file.  Also see
	{manhelp clustermat MV}.

	Topic{col 44}{cmd:clustermat} {it:subcommand}
	{hline 65}
	Hierarchical clustering of a dissimilarity matrix
	(see {manhelp cluster_linkage MV:cluster linkage})
	    Single linkage{col 44}{cmd:clustermat singlelinkage}
	    Complete linkage{col 44}{cmd:clustermat completelinkage}
	    Average linkage{col 44}{cmd:clustermat averagelinkage}
	    Weighted average linkage{col 44}{cmd:clustermat waveragelinkage}
	    Median linkage{col 44}{cmd:clustermat medianlinkage}
	    Centroid linkage{col 44}{cmd:clustermat centroidlinkage}
	    Ward's linkage{col 44}{cmd:clustermat wardslinkage}
	{hline 65}

{pstd}
Also, the {cmd:clustermat stop} postclustering command has syntax similar
to that of the {cmd:cluster stop} command; see
{manhelp cluster_stop MV:cluster stop}.  For the remaining postclustering
commands and user utilities, you may specify either {cmd:cluster} or
{cmd:clustermat} -- it does not matter which.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusterRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


