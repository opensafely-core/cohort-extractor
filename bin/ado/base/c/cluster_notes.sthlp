{smcl}
{* *! version 1.1.9  22mar2018}{...}
{viewerdialog "cluster notes" "dialog cluster_note"}{...}
{vieweralsosee "[MV] cluster notes" "mansection MV clusternotes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{vieweralsosee "[MV] cluster utility" "help cluster_utility"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "cluster notes##syntax"}{...}
{viewerjumpto "Menu" "cluster notes##menu"}{...}
{viewerjumpto "Description" "cluster notes##description"}{...}
{viewerjumpto "Links to PDF documentation" "cluster_notes##linkspdf"}{...}
{viewerjumpto "Examples" "cluster notes##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[MV] cluster notes} {hline 2}}Cluster analysis notes{p_end}
{p2col:}({mansection MV clusternotes:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

INCLUDE help cluster_notes_syntax


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
      {bf:Cluster analysis notes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cluster} {cmd:notes} is a set of commands to manage notes for a
previously run cluster analysis.  You can attach notes that become part of the
data and are saved when the data are saved and retrieved when the data are
used.  {cmd:cluster} {cmd:notes} may also be used to list notes for all
defined cluster analyses or for specific cluster analyses names.

{pstd}
{cmd:cluster notes drop} allows you to drop cluster notes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV clusternotesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. cluster notes myclus: Group 9 looks strange.  Examine it closer.}{p_end}
{phang}{cmd:. cluster notes ageclus: Consider removing the singleton groups.}{p_end}
{phang}{cmd:. cluster notes}{p_end}
{phang}{cmd:. cluster notes myclus}{p_end}
{phang}{cmd:. cluster notes drop clusxyz in 3 6/8}{p_end}
{phang}{cmd:. cluster notes drop ageclus}{p_end}
{phang}{cmd:. cluster notes}{p_end}
