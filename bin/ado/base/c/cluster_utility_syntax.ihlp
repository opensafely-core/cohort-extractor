{* *! version 1.0.6  21mar2011}{...}
{pstd}
Directory-style listing of currently defined clusters

	{cmd:cluster} {cmd:dir}


{pstd}
Detailed listing of clusters

{p 8 21 2}{cmd:cluster} {cmd:list} [{it:clnamelist}]
     [{cmd:,} {help cluster_utility##list_options:{it:list_options}} ]


{pstd}
Drop cluster analyses

{p 8 21 2}{cmd:cluster} {cmd:drop} {c -(} {it:clnamelist} | {cmd:_all} {c )-}


{pstd}
Mark a cluster analysis as the most recent one

{p 8 21 2}{cmd:cluster} {cmd:use} {it:clname}


{pstd}
Rename a cluster

{p 8 21 2}{cmd:cluster} {cmd:rename} {it:oldclname} {it:newclname}


{pstd}
Rename variables attached to a cluster

{p 8 21 2}{cmd:cluster} {cmd:renamevar} {it:oldvarname} {newvar}
[{cmd:,} {opt n:ame(clname)} ]

{p 8 21 2}{cmd:cluster} {cmd:renamevar} {it:oldstub} {it:newstub} {cmd:,}
{opt p:refix} [ {opt n:ame(clname)} ]


{marker list_options}{...}
{synoptset 17 tabbed}{...}
{synopthdr:list_options}
{synoptline}
{syntab:Options}
{synopt:{opt n:otes}}list cluster notes{p_end}
{synopt:{opt t:ype}}list cluster analysis type{p_end}
{synopt:{opt m:ethod}}list cluster analysis method{p_end}
{synopt:{opt d:issimilarity}}list cluster analysis dissimilarity measure{p_end}
{synopt:{opt s:imilarity}}list cluster analysis similarity measure{p_end}
{synopt:{opt v:ars}}list variable names attached to the cluster analysis{p_end}
{synopt:{opt c:hars}}list any characteristics attached to the cluster
	analysis{p_end}
{synopt:{opt o:ther}}list any "other" information{p_end}

{synopt:{opt a:ll}}list all items and information attached to the
	cluster; the default{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:all} does not appear in the dialog box.
{p_end}
