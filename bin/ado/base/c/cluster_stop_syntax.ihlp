{* *! version 1.0.10  09dec2014}{...}
{pstd} 
Cluster analysis of data

{p 8 24 2}
	{cmd:cluster} {cmd:stop} [{it:clname}]
	[{cmd:,} {it:options}]


{pstd}
Cluster analysis of a dissimilarity matrix

{p 8 24 2}
	{cmd:clustermat} {cmd:stop} [{it:clname}]
	{cmd:,} {opth var:iables(varlist)}
	[{it:options}]


{phang}
where {it:clname} is the name of the cluster analysis.  The default
is the most recently performed cluster analysis, which can be reset using
the {cmd:cluster} {cmd:use} command; see
{helpb cluster utility:[MV] cluster utility}.


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:r:ule(}{cmdab:cal:inski)}}use Calinski-Harabasz pseudo-F index stopping rule; the default{p_end}
{synopt:{cmdab:r:ule(duda)}}use Duda-Hart Je(2)/Je(1) index stopping rule{p_end}
{synopt:{opt r:ule(rule_name)}}use {it:rule_name} stopping rule; see
  {it:{help cluster_stop##rule():Options}} for details{p_end}
{synopt:{opth gr:oups(numlist)}}compute stopping rule for specified 
groups{p_end}
{synopt:{opt mat:rix(matname)}}save the results in matrix {it:matname}{p_end}
{p2coldent :* {opth var:iables(varlist)}}compute the stopping rule using {it:varlist}{p_end}
{synoptline}
{p 4 6 2}* {opt variables(varlist)} is required with a {cmd:clustermat}
solution and optional with a {cmd:cluster} solution.{p_end}
{p 4 6 2}{opt rule(rule_name)} is not shown in the dialog box.  See
{manhelp cluster_subroutines MV:cluster programming subroutines} for
information on how to add stopping rules to the {cmd:cluster stop} command.
{p_end}
