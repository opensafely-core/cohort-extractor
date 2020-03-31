{* *! version 1.0.7  09dec2014}{...}
{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opt k(#)}}perform cluster analysis resulting in # groups{p_end}
{synopt:{opth mea:sure(measure option:measure)}}similarity or dissimilarity
measure; default is {cmd:L2} (Euclidean){p_end}
{synopt:{opt n:ame(clname)}}name of resulting cluster analysis{p_end}

{syntab:Options}
{synopt:{cmdab:s:tart(}{it:{help cluster_kmeans##start():start_option}{cmd:)}}}obtain {it:k} initial group centers by using
{it:start_option}{p_end}
{synopt:{opt keep:centers}}append the {it:k} final group means or medians to
the data{p_end}

{syntab:Advanced}
{synopt:{opth gen:erate(varlist:groupvar)}}name of grouping variable{p_end}
{synopt:{opt iter:ate(#)}}maximum number of iterations; default is
{cmd:iterate(10000)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt k(#)} is required.{p_end}
