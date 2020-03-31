{* *! version 1.0.5  13may2013}{...}
{pstd}
Generate grouping variables for specified numbers of clusters

{p 8 15 2}{cmd:cluster} {cmdab:gen:erate}
		{c -(} {newvar} | {it:stub} {c )-} {cmd:=}
		{opth gr:oups(numlist)} [{cmd:,} {it:options} ]


{pstd}
Generate grouping variable by cutting the dendrogram

{p 8 15 2}{cmd:cluster} {cmdab:gen:erate} {newvar} {cmd:=}
		{cmd:cut(}{it:#}{cmd:)}
	[{cmd:,} {cmdab:n:ame:(}{it:clname}{cmd:)} ]


{synoptset 14}{...}
{synopthdr}
{synoptline}
{synopt :{opt n:ame(clname)}}name of cluster analysis to use in producing new
variables{p_end}
{synopt :{cmdab:t:ies(}{cmdab:e:rror}{cmd:)}}produce error message for
ties; default{p_end}
{synopt :{cmdab:t:ies(}{cmdab:s:kip}{cmd:)}}ignore requests that result
in ties{p_end}
{synopt :{cmdab:t:ies(}{cmdab:f:ewer}{cmd:)}}produce results for largest
number of groups smaller than your request{p_end}
{synopt :{cmdab:t:ies(}{cmdab:m:ore}{cmd:)}}produce results for smallest number
of groups larger than your request{p_end}
{synoptline}
{p2colreset}{...}
