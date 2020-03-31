{* *! version 1.0.6  07apr2011}{...}
{synoptset 21 tabbed}{...}
{synopthdr:clustermat_options}
{synoptline}
{syntab:Main}
{synopt:{opth sh:ape(cluster_linkage##shape:shape)}}shape (storage method) of {it:matname}{p_end}
{synopt:{opt add}}add cluster information to data currently in memory{p_end}
{synopt:{opt clear}}replace data in memory with cluster information{p_end}
{synopt:{opth lab:elvar(varname)}}place dissimilarity matrix row names in
	{it:varname}{p_end}
{synopt:{opt n:ame(clname)}}name of resulting cluster analysis{p_end}

{syntab:Advanced}
{synopt:{opt force}}perform clustering after fixing {it:matname} problems{p_end}
{synopt:{opt gen:erate(stub)}}prefix for generated variables; default prefix is {it:clname}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 21}{...}
{marker shape}{...}
{synopt:{it:shape}}{it:matname} is stored as a{p_end}
{synoptline}
{synopt:{opt f:ull}}square symmetric matrix; the default{p_end}
{synopt:{opt l:ower}}vector of rowwise lower triangle (with diagonal){p_end}
{synopt:{opt ll:ower}}vector of rowwise strict lower triangle (no diagonal)
	{p_end}
{synopt:{opt u:pper}}vector of rowwise upper triangle (with diagonal){p_end}
{synopt:{opt uu:pper}}vector of rowwise strict upper triangle (no diagonal)
	{p_end}
{synoptline}
{p2colreset}{...}
